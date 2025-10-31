//
//  HTTPRequestException.swift
//  Networking
//
//  Created by ChungTV on 21/02/2022.
//

import Foundation

public enum MHTTPRequestException: Int, Error {
    case urlNil
    case httpBodyNil
    case indexOutOfBounce
}
