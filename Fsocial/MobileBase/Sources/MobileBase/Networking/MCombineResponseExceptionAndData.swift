//
//  MCombineResponseExceptionAndData.swift
//  Networking
//
//  Created by ChungTV on 21/02/2022.
//

import Foundation

public struct MCombineResponseExceptionAndData: Error {
    public var dataError: Data?
    public var responseError: MHTTPResponseException?
}
