//
//  APIService.swift
//  Networking
//
//  Created by ChungTV on 22/02/2022.
//

import Foundation

open class MAPIService<H: MHTTPClient> {
    
    public let client: H
    
    public required init(client: H) {
        self.client = client
    }
    
    @discardableResult
    public func dataTask<D: Decodable>(
                                       method: MHTTPMethod,
                                       path: String,
                                       headers: [String: String]? = nil,
                                       params: MParametersType? = nil,
                                       decoding: MHTTPDecoding.Factory? = nil,
                                       completion: ((Result<D, Error>) -> Void)?,
                                       completionWithResponse: ((Result<D, Error>, URLResponse?) -> Void)? = nil) -> MIDataTask? {
        
        guard let endpoint = getEndpoint() else {
            completion?(.failure(MHTTPRequestException.urlNil))
            return nil
        }
        let urlRequestBuilder = MURLRequestBuilder(endpoint: endpoint)
            .httpMethod(method)
            .path(path)
            .httpHeaders(getDefaultHeaders().joined(headers ?? [:]))
            .parameters(getDefaultParams().joined(params ?? [:]))
        return client.dataTask(request: urlRequestBuilder.build(),
                               decodeFactory: decoding ?? getDefaultDecoding(),
                               completion: completion,
                               completionWithResponse: completionWithResponse)
    }
    
    @discardableResult
    public func dataTask<R: Encodable, D: Decodable>(method: MHTTPMethod,
                                                     path: String,
                                                     headers: [String: String]? = nil,
                                                     params: MParametersType? = nil,
                                                     sendingData: R?,
                                                     encoding: HTTPEncoding.Factory? = nil,
                                                     decoding: MHTTPDecoding.Factory? = nil,
                                                     completion: ((Result<D, Error>) -> Void)?,
                                                     completionWithResponse: ((Result<D, Error>, URLResponse?) -> Void)? = nil) -> MIDataTask? {
        guard let endpoint = getEndpoint() else {
            completion?(.failure(MHTTPRequestException.urlNil))
            return nil
        }
        let urlRequestBuilder = MURLRequestBuilder(endpoint: endpoint)
            .httpMethod(method)
            .path(path)
            .httpHeaders(getDefaultHeaders().joined(headers ?? [:]))
            .parameters(getDefaultParams().joined(params ?? [:]))
            .sendingData(sendingData, encoding ?? getDefaultEncoding())
        return client.dataTask(request: urlRequestBuilder.build(),
                               decodeFactory: decoding ?? getDefaultDecoding(),
                               completion: completion,
                               completionWithResponse: completionWithResponse)
    }
    
    @discardableResult
    public func multipartDataTask<R: Decodable>(method: MHTTPMethod,
                                                path: String,
                                                headers: [String: String]? = nil,
                                                params: MParametersType? = nil,
                                                multiparts: [MMultipartFormDataType]?,
                                                decoding: MHTTPDecoding.Factory? = nil,
                                                completion: ((Result<R, Error>) -> Void)?,
                                                completionWithResponse: ((Result<R, Error>, URLResponse?) -> Void)? = nil) -> MIDataTask? {
        guard let endpoint = getEndpoint() else {
            completion?(.failure(MHTTPRequestException.urlNil))
            return nil
        }
        let urlRequestBuilder = MURLRequestBuilder(endpoint: endpoint)
            .httpMethod(method)
            .path(path)
            .httpHeaders(getDefaultHeaders().joined(headers ?? [:]))
            .parameters(getDefaultParams().joined(params ?? [:]))
        if let forms = multiparts, !forms.isEmpty {
            let multipartBuilder = MultipartFormDataBuilder()
            forms.forEach { multipartBuilder.append($0) }
            urlRequestBuilder.multipartDataBuilder(multipartBuilder)
        }
        return client.dataTask(request: urlRequestBuilder.build(),
                               decodeFactory: decoding ?? getDefaultDecoding(),
                               completion: completion,
                               completionWithResponse: completionWithResponse)
    }
    
    @discardableResult
    public func urlEncodeDataTask<R: Decodable>(method: MHTTPMethod,
                                                path: String,
                                                headers: [String: String]? = nil,
                                                params: MParametersType? = nil,
                                                builder: MURLEncodedDataBuilder,
                                                decoding: MHTTPDecoding.Factory? = nil,
                                                completion: ((Result<R, Error>) -> Void)?,
                                                completionWithResponse: ((Result<R, Error>, URLResponse?) -> Void)? = nil) -> MIDataTask? {
        guard let endpoint = getEndpoint() else {
            completion?(.failure(MHTTPRequestException.urlNil))
            return nil
        }
        let urlRequestBuilder = MURLRequestBuilder(endpoint: endpoint)
            .httpMethod(method)
            .path(path)
            .httpHeaders(getDefaultHeaders().joined(headers ?? [:]))
            .parameters(getDefaultParams().joined(params ?? [:]))
            .urlEncodeDataBuilder(builder)
        return client.dataTask(request: urlRequestBuilder.build(),
                               decodeFactory: decoding ?? getDefaultDecoding(),
                               completion: completion,
                               completionWithResponse: completionWithResponse)
    }
    
    open func getEndpoint() -> MAPIEndpoint? {
        return nil
    }
    
    open func getDefaultHeaders() -> [String: String] {
        return [:]
    }
    
    open func getDefaultParams() -> MParametersType {
        return [:]
    }
    
    open func getDefaultDecoding() -> MHTTPDecoding.Factory {
        return MHTTPDecoding.Factory()
    }
    
    open func getDefaultEncoding() -> HTTPEncoding.Factory {
        return HTTPEncoding.Factory()
    }
}
