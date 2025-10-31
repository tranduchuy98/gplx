//
//  MURLEncodedDataBuilder.swift
//  Networking
//
//  Created by ChungTV on 22/02/2022.
//

import Foundation

public final class MURLEncodedDataBuilder {
    
    public init() {
        
    }
    
    private var queryItems: [URLQueryItem] = []
    
    @discardableResult
    public func append(name: String, value: String?) -> MURLEncodedDataBuilder {
        let item = URLQueryItem(name: name, value: value)
        queryItems.append(item)
        return self
    }
    
    public func build() -> Data? {
        var components = URLComponents()
        components.queryItems = queryItems
        return components.query?.data(using: .utf8)
    }
}
