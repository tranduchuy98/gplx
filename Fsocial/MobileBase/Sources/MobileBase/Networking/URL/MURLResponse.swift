//
//  URLResponse.swift
//  Networking
//
//  Created by ChungTV on 21/02/2022.
//

import Foundation

extension HTTPURLResponse {

    var status: MHTTPStatusCode? {
        return MHTTPStatusCode(rawValue: statusCode)
    }
    var responseException: MHTTPResponseException? {
        return MHTTPResponseException(rawValue: statusCode)
    }

}

extension URLResponse {
    var statusCode: MHTTPStatusCode? {
        return (self as? HTTPURLResponse)?.status
    }

    var exception: MHTTPResponseException? {
        return (self as? HTTPURLResponse)?.responseException
    }

}
