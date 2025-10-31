//
//  HTTPClient.swift
//  Networking
//
//  Created by ChungTV on 21/02/2022.
//

import Foundation

internal let TAG = "[HTTPClient]"
internal let responseTimeWarningThreshold: Double = 1500 // ms

open class MHTTPClient {
    
    public let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public var enableGETLogs: Bool = false
    
    internal var logger: MINetworkLog?
    
    private lazy var errorNotifyQueue = DispatchQueue(label: MConstants.ERROR_NOTIFY_QUEUE,
                                                      qos: .utility)
    
    public func invokeLog(_ log: MINetworkLog) {
        self.logger = log
    }
    
    /// Create a dataTask for URLRequest
    /// This function will respect `request.httpBody`, if request has its own body then the parameter `body` will not be set.
    /// - Parameters: request
    /// - Parameters: body
    ///
    @discardableResult
    public func dataTask<R>(request: URLRequest,
                     decodeFactory: MHTTPDecoding.Factory,
                     completion: ((Result<R, Error>) -> Void)?,
                     completionWithResponse: ((Result<R, Error>, URLResponse?) -> Void)? = nil,
                     function: String = #function) -> MIDataTask where R: Decodable {
        let requestUrl = request.url?.absoluteString ?? ""
        
        logger?.d(TAG, "Method:", request.httpMethod ?? "UNKNOWN", "-", requestUrl)
        logger?.d(TAG, "Headers:", request.allHTTPHeaderFields ?? [:])
        
        if let body = request.httpBody {
            logger?.d(TAG, "Body:", String(data: body, encoding: .utf8) ?? "")
        }
        
        let startTime: DispatchTime? = (logger?.isEnabled ?? false) ? .now() : nil
        
        let task = session.dataTask(with: request) { (data, response, error) in
            self.handleDataTask(request: request,
                                method: MHTTPMethod(rawValue: request.httpMethod ?? ""),
                                decodeFactory: decodeFactory,
                                data: data,
                                response: response,
                                error: error,
                                completion: completion,
                                completionWithResponse: completionWithResponse,
                                function: function,
                                startTime: startTime)
        }
        return task
    }
    
    internal func handleUnauthorizedError(response: URLResponse?, data: Data) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .httpClientDidResponseUnauthorizedError,
                                            object: nil,
                                            userInfo: [
                                                "response": response as Any,
                                                "data": data
                                            ])
        }
    }
    
    internal func logError(error: Error, data: Data?, request: URLRequest) {
        
        func errorDescription() -> Any {
            guard let e = error as? MHTTPResponseException else {
                return error
            }
            
            return e.errorDescription ?? e
        }
        
        errorNotifyQueue.async {
            NotificationCenter.default.post(name: .httpClientDidReceiveErrorResponse,
                                            object: self,
                                            userInfo: [
                                                "error": error,
                                                "data": data as Any,
                                                "request": request
                                            ])
        }
        let requestUrl = request.url?.absoluteString ?? ""
        
        guard let errorData = data, errorData.count > 0 else {
            logger?.e(TAG, requestUrl, "-", errorDescription())
            return
        }
        
        guard let errorObject = try? JSONSerialization.jsonObject(with: errorData, options: .init()) else {
            if let errorString = String(data: errorData, encoding: .utf8) {
                logger?.e(TAG, requestUrl, "-", errorDescription(), "\n", errorString)
            } else {
                logger?.e(TAG, requestUrl, "-", errorDescription())
            }
            return
        }
        
        if let errorDict = errorObject as? [String: Any] {
            logger?.e(TAG, requestUrl, "-", errorDescription(), "\n", errorDict.toJson(beautify: true) ?? "")
        } else {
            logger?.e(TAG, requestUrl, "-", errorDescription(), "\n", errorObject)
        }
    }
    
    internal func logResponseTime(for requestUrl: String, with startTime: DispatchTime?) {
        if let start = startTime {
            let duration = Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000
            logger?.d(TAG, "Response time:", duration > responseTimeWarningThreshold ? "⚠️" : "",
                      "\(round(duration)) ms", "-", requestUrl)
        }
    }
    
    private func handleDataTask<R>(request: URLRequest,
                                   method: MHTTPMethod?,
                                   decodeFactory: MHTTPDecoding.Factory,
                                   data: Data?,
                                   response: URLResponse?,
                                   error: Error?,
                                   completion: ((Result<R, Error>) -> Void)?,
                                   completionWithResponse: ((Result<R, Error>, URLResponse?) -> Void)?,
                                   function: String = #function,
                                   startTime: DispatchTime? = nil) where R: Decodable {
        
        func onComplete(_ result: Result<R, Error>) {
            DispatchQueue.main.async {
                if let compl = completion {
                    compl(result)
                } else if let compl = completionWithResponse {
                    compl(result, response)
                }
            }
        }
        
        let requestUrl = request.url?.absoluteString ?? ""
        logResponseTime(for: requestUrl, with: startTime)
        
        if let error = error {
            if let nsError = error as NSError?, nsError.code == URLError.Code.cancelled.rawValue {
                logger?.d(TAG, "Cancelled: ", requestUrl)
                return
            }
            
            onComplete(.failure(error))
            logger?.e(TAG, requestUrl, error)
            return
        }
        
        guard let statusCode = (response as? HTTPURLResponse)?.status else {
            let errorResponse = MCombineResponseExceptionAndData(dataError: data,
                                                                responseError: MHTTPResponseException.noStatusCode)
            onComplete(.failure(errorResponse))
            logger?.e(TAG, requestUrl, String(describing: response))
            return
        }
        
        guard let receivedData = data else {
            let errorResponse = MCombineResponseExceptionAndData(dataError: data,
                                                                responseError: MHTTPResponseException.noReturnData)
            onComplete(.failure(errorResponse))
            logger?.e(TAG, requestUrl, "- noReturnData")
            return
        }
        
        if method != .get || enableGETLogs, let responseBody = String(data: receivedData, encoding: .utf8) {
            logger?.d(TAG, "Response body:", responseBody)
        }
        
        func handleTextPlainResponse() -> Bool {
            guard let response = response as? HTTPURLResponse else {
                return false
            }
            
            guard let contentType = response.allHeaderFields[MAPIConsts.contentTypeHeaderKey] as? String,
                  contentType.starts(with: MAPIConsts.contentTypeTextPlain) else {
                return false
            }
            
            if let string = String(data: receivedData, encoding: .utf8) as? R {
                onComplete(.success(string))
                return true
            }
            
            return false
        }
        
        switch statusCode.responseType {
        case .informational:
            break
            
        case .success:
            do {
                let parsedObject = try decodeFactory.create().decode(R.self, from: receivedData)
                onComplete(.success(parsedObject))
            } catch let error {
                if handleTextPlainResponse() {
                    return
                }
                let errorResponse = MCombineResponseExceptionAndData(dataError: receivedData,
                                                                    responseError: MHTTPResponseException.decodeReceivedDataFail)
                onComplete(.failure(errorResponse))
                logger?.e(TAG, requestUrl, "- decodeReceivedDataFail: ", error)
            }
            
        default:
            let error = response?.exception ?? MHTTPResponseException.undefine
            let errorResponse = MCombineResponseExceptionAndData(dataError: receivedData, responseError: error)
            onComplete(.failure(errorResponse))
            self.logError(error: error,
                          data: receivedData,
                          request: request)
            
            if statusCode == .unauthorized {
                handleUnauthorizedError(response: response, data: receivedData)
            }
        }
    }
    
}
