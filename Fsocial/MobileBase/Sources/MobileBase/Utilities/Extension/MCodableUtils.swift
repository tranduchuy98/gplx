//
//  DataUtils.swift
// Example
//
//  Created by ChungTV on 26/10/2022.
//  Copyright © 2022 FTech AI. All rights reserved.
//

import Foundation

public extension Encodable {
    func toJSON(_ encoder: JSONEncoder) -> [String: Any]? {
        if let data = try? encoder.encode(self),
           let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            return json as? [String: Any]
        }
        return nil
    }
    
    func toJsonString(_ encoder: JSONEncoder) -> String? {
        if let data = try? encoder.encode(self) {
            return String(data: data, encoding: .utf8)!
        }
        return nil
    }
}

public extension Encodable {
    var dictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        return dict ?? [:]
    }
}



