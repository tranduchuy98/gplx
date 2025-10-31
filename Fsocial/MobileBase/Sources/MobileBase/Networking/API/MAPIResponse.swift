//
//  APIResponse.swift
//  AppNetworking
//
//  Created by ChungTV on 23/05/2022.
//

import Foundation

public protocol MAPIResponse: Decodable {
    func isSuccessfull() throws -> Bool
}
