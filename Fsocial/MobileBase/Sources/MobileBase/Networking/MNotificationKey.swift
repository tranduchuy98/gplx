//
//  NotificationKey.swift
//  Networking
//
//  Created by ChungTV on 22/02/2022.
//

import Foundation

public extension Notification.Name {
    static let httpClientDidResponseUnauthorizedError = Notification.Name(MConstants.HTTP_CLIENT_DID_RESPONSE_UNAUTHORIZED_ERROR)
    static let httpClientDidReceiveErrorResponse = Notification.Name(MConstants.HTTP_CLIENT_DID_RECEIVE_ERROR_RESPONSE)
}
