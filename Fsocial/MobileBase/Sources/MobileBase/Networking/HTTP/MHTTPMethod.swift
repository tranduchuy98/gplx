//
//  HTTPMethod.swift
//  Networking
//
//  Created by ChungTV on 21/02/2022.
//

import Foundation

public enum MHTTPMethod: String {
    case get        = "GET"
    case put        = "PUT"
    case post       = "POST"
    case patch      = "PATCH"
    case delete     = "DELETE"
    case head       = "HEAD"
    case options    = "OPTIONS"
    case trace      = "TRACE"
    case connect    = "CONNECT"
}
