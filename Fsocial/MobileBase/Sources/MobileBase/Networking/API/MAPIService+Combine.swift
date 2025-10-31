//
//  APIService+Combine.swift
//  AppNetworking
//
//  Created by ChungTV on 23/05/2022.
//

import Foundation
import Combine

@available(iOS 13, *)
extension MAPIService {
    
    public func dataTaskPublisher<D: MAPIResponse>(method: MHTTPMethod,
                                                path: String,
                                                headers: [String: String]? = nil,
                                                params: MParametersType? = nil,
                                                decoding: MHTTPDecoding.Factory = MHTTPDecoding.Factory()) -> AnyPublisher<D, Error> {
        
        guard let endpoint = getEndpoint() else {
            return Fail(error: MHTTPRequestException.urlNil).eraseToAnyPublisher()
        }
        let urlRequestBuilder = MURLRequestBuilder(endpoint: endpoint)
            .httpMethod(method)
            .path(path)
            .httpHeaders(getDefaultHeaders().joined(headers ?? [:]))
            .parameters(getDefaultParams().joined(params ?? [:]))
        return client.dataTaskPublisher(request: urlRequestBuilder.build(), decodeFactory: decoding)
    }
    
    public func dataTaskPublisher<R: Encodable, D: MAPIResponse>(method: MHTTPMethod,
                                                              path: String,
                                                              headers: [String: String]? = nil,
                                                              params: MParametersType? = nil,
                                                              sendingData: R?,
                                                              encoding: HTTPEncoding.Factory = HTTPEncoding.Factory(),
                                                              decoding: MHTTPDecoding.Factory = MHTTPDecoding.Factory()) -> AnyPublisher<D, Error> {
        guard let endpoint = getEndpoint() else {
            return Fail(error: MHTTPRequestException.urlNil).eraseToAnyPublisher()
        }
        let urlRequestBuilder = MURLRequestBuilder(endpoint: endpoint)
            .httpMethod(method)
            .path(path)
            .httpHeaders(getDefaultHeaders().joined(headers ?? [:]))
            .parameters(getDefaultParams().joined(params ?? [:]))
            .sendingData(sendingData, encoding)
        return client.dataTaskPublisher(request: urlRequestBuilder.build(), decodeFactory: decoding)
    }
    
    public func multipartDataTaskPublisher<R: MAPIResponse>(method: MHTTPMethod,
                                                         path: String,
                                                         headers: [String: String]? = nil,
                                                         params: MParametersType? = nil,
                                                         multiparts: [MMultipartFormDataType]?,
                                                         decoding: MHTTPDecoding.Factory = MHTTPDecoding.Factory()) -> AnyPublisher<R, Error> {
        guard let endpoint = getEndpoint() else {
            return Fail(error: MHTTPRequestException.urlNil).eraseToAnyPublisher()
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
        return client.dataTaskPublisher(request: urlRequestBuilder.build(), decodeFactory: decoding)
    }
}
