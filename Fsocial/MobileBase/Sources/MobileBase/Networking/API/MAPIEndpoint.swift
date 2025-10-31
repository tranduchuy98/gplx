//
//  APIEndpoint.swift
//  Networking
//
//  Created by ChungTV on 21/02/2022.
//

import Foundation

public protocol MAPIEndpoint {
    var scheme: String { get }
    var components: (host: String, basePath: String) { get }
    var port: Int? { get }
}
