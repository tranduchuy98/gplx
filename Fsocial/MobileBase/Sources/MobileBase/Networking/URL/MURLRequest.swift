//
//  URLRequest.swift
//  Networking
//
//  Created by ChungTV on 21/02/2022.
//

import Foundation

public extension URLRequest {
    
    var method: MHTTPMethod? {
        get {
            guard let httpMethod = self.httpMethod else { return nil }
            return MHTTPMethod(rawValue: httpMethod)
        }
        set {
            httpMethod = newValue?.rawValue
        }
    }
}
