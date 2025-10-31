//
//  JSONCodable.swift
//  Networking
//
//  Created by ChungTV on 21/02/2022.
//

import Foundation

open class MHTTPDecoding {
    open class Factory {
        public init() {
            
        }
        open func create() -> JSONDecoder {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }
    }
}

open class HTTPEncoding {
    open class Factory {
        public init() {
            
        }
        open func create() -> JSONEncoder {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return encoder
        }
    }
}
