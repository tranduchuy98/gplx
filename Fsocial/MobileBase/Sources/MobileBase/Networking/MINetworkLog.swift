//
//  INetworkLog.swift
//  Networking
//
//  Created by ChungTV on 21/02/2022.
//

import Foundation

public protocol MINetworkLog {
    var isEnabled: Bool { get set }
    func d(_ items: Any...)
    func i(_ items: Any...)
    func w(_ items: Any...)
    func e(_ items: Any...)
}
