//
//  HTTPClient+Combine.swift
//  AppNetworking
//
//  Created by ChungTV on 23/05/2022.
//

import Foundation
import Combine

extension MHTTPClient {
    @available(iOS 13, *)
    public func dataTaskPublisher<R>(request: URLRequest,
                                     decodeFactory: MHTTPDecoding.Factory,
                                     function: String = #function) -> AnyPublisher<R, Error> where R: MAPIResponse {
        let requestUrl = request.url?.absoluteString ?? ""
        
        logger?.d(TAG, "Method:", request.httpMethod ?? "UNKNOWN", "-", requestUrl)
        logger?.d(TAG, "Headers:", request.allHTTPHeaderFields ?? [:])
        
        if let body = request.httpBody {
            logger?.d(TAG, "Body:", String(data: body, encoding: .utf8) ?? "")
        }
        
        let startTime: DispatchTime? = (logger?.isEnabled ?? false) ? .now() : nil
        return session
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { data, res -> R in
                let requestUrl = request.url?.absoluteString ?? ""
                self.logResponseTime(for: requestUrl, with: startTime)
                guard let response = res as? HTTPURLResponse,
                      let statusCode = response.status else {
                    self.logger?.e(TAG, requestUrl, String(describing: res))
                    throw MCombineResponseExceptionAndData(dataError: data,
                                                          responseError: MHTTPResponseException.noStatusCode)
                }
                let method = MHTTPMethod(rawValue: request.httpMethod ?? "")
                if method != .get || self.enableGETLogs, let responseBody = String(data: data, encoding: .utf8) {
                    self.logger?.d(TAG, "Response body:", responseBody)
                }
                switch statusCode.responseType {
                case .success:
                    do {
                        let parsedObject = try decodeFactory.create().decode(R.self, from: data)
                        return parsedObject
                    } catch let error {
                        guard let contentType = response.allHeaderFields[MAPIConsts.contentTypeHeaderKey] as? String,
                              contentType.starts(with: MAPIConsts.contentTypeTextPlain),
                              let string = String(data: data, encoding: .utf8) as? R else {
                            self.logger?.e(TAG, requestUrl, "- decodeReceivedDataFail: ", error)
                            throw MCombineResponseExceptionAndData(dataError: data,
                                                                  responseError: MHTTPResponseException.decodeReceivedDataFail)
                        }
                        return string
                    }
                default:
                    let error = response.exception ?? MHTTPResponseException.undefine
                    self.logError(error: error,
                                  data: data,
                                  request: request)
                    if statusCode == .unauthorized {
                        self.handleUnauthorizedError(response: response, data: data)
                    }
                    let errorResponse = MCombineResponseExceptionAndData(dataError: data, responseError: error)
                    throw errorResponse
                }
            }.eraseToAnyPublisher()
    }
}


