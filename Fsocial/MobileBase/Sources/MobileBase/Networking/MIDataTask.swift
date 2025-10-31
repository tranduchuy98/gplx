//
//  MIDataTask.swift
//  Networking
//
//  Created by ChungTV on 21/02/2022.
//

import Foundation

public protocol MIDataTask {
    func cancel()
    func resume()
}

extension URLSessionTask: MIDataTask {}
extension DispatchWorkItem: MIDataTask {
    public func resume() {
        perform()
    }
}
