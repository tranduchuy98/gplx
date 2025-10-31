//
//  URLRequestBuilder.swift
//  Networking
//
//  Created by ChungTV on 22/02/2022.
//

import Foundation

public final class MURLRequestBuilder {
    
    let endpoint: MAPIEndpoint
    
    
    public init(endpoint: MAPIEndpoint) {
        self.endpoint = endpoint
    }
    
    private var method: MHTTPMethod = .get
    
    private var path: String = ""
    private var timeoutInterval: TimeInterval = 30
    private var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    private var httpHeader: [String: String]?
    private var parameters: MParametersType?
    private var sendingData: Encodable?
    private var encodingFactory: HTTPEncoding.Factory?
    private var multipartDataBuilder: MultipartFormDataBuilderType?
    private var urlencodeDataBuilder: MURLEncodedDataBuilder?
    
    final public func build() -> URLRequest {
        let url = generateUrlComponent(path: path, parameters: parameters)
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = timeoutInterval
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = httpHeader
        urlRequest.cachePolicy = cachePolicy
        if let multipartBuilder = multipartDataBuilder {
            let body = multipartBuilder.build()
            urlRequest.httpBody = body
            urlRequest.setValue("multipart/form-data; boundary=\(multipartBuilder.boundary)", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        } else if urlencodeDataBuilder != nil {
            urlRequest.httpBody = urlencodeDataBuilder?.build()
            urlRequest.allHTTPHeaderFields?[MAPIConsts.contentTypeHeaderKey] = MAPIConsts.contentTypeUrlencoded
        } else if sendingData != nil {
            urlRequest.httpBody = sendingData?.toData(using: encodingFactory?.create())
        } else {
            urlRequest.httpBody = nil
        }
        return urlRequest
    }
    
    @discardableResult
    public func path(_ path: String) -> MURLRequestBuilder {
        self.path = path
        return self
    }
    
    @discardableResult
    public func cachePolicy(_ policy: URLRequest.CachePolicy) -> MURLRequestBuilder {
        self.cachePolicy = policy
        return self
    }
    
    @discardableResult
    public func httpMethod(_ method: MHTTPMethod) -> MURLRequestBuilder {
        self.method = method
        return self
    }
    
    @discardableResult
    public func httpHeaders(_ headers: [String: String]?) -> MURLRequestBuilder {
        self.httpHeader = headers
        return self
    }
    
    @discardableResult
    public func parameters(_ params: MParametersType?) -> MURLRequestBuilder {
        self.parameters = params
        return self
    }
    
    @discardableResult
    public func sendingData(_ data: Encodable? = nil,
                     _ encodingFactory: HTTPEncoding.Factory = HTTPEncoding.Factory()) -> MURLRequestBuilder {
        self.sendingData = data
        if data != nil {
            self.encodingFactory = encodingFactory
        } else {
            self.encodingFactory = nil
        }
        return self
    }
    
    @discardableResult
    public func multipartDataBuilder(_ multipartData: MultipartFormDataBuilderType) -> MURLRequestBuilder {
        self.multipartDataBuilder = multipartData
        return self
    }
    
    @discardableResult
    public func urlEncodeDataBuilder(_ builder: MURLEncodedDataBuilder) -> MURLRequestBuilder {
        self.urlencodeDataBuilder = builder
        return self
    }
    
    @discardableResult
    public func timeout(_ time: TimeInterval) -> MURLRequestBuilder {
        self.timeoutInterval = time
        return self
    }
    
    private func generateUrlComponent(path: String, parameters: MParametersType?) -> URL {
        var components = URLComponents()
        
        let (host, basePath) = endpoint.components
        components.scheme = endpoint.scheme
        components.host = host
        components.port = endpoint.port
        components.path = basePath + path
        
        components.queryItems = parameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)")}
        
        // Fix "+" sign is not encoded in query, so it becomes a space character
        components.percentEncodedQuery = components.percentEncodedQuery?
            .replacingOccurrences(of: "+", with: "%2B")
        
        return components.url!
    }
}


private extension Encodable {
    func toData(using encoder: JSONEncoder?) -> Data? {
        try? encoder?.encode(self)
    }
}
