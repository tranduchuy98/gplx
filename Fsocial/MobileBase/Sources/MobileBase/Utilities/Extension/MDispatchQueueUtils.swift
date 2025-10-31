//
//  DispatchQueueUtils.swift
// Example
//
//  Created by ChungTV on 14/02/2022.
//

import Foundation

extension DispatchQueue {
    private static let backgroundQueue = DispatchQueue(label: MConstants.DISPATCH_QUEUE_DEFAULT_BACKGROUND,
                                                       target: .global())
    
    static func runInBackground<T>(_ runInBackground: @escaping () -> T?,
                                   complete: @escaping (T?) -> Void) {
        backgroundQueue.async {
            let result = runInBackground()

            DispatchQueue.main.async {
                complete(result)
            }
        }
    }
    
    static func runInBackground(_ runInBackground: @escaping () -> Void) {
        backgroundQueue.async {
            runInBackground()
        }
    }
    
    /// Run block after a duration relative to `DispatchTime.now()`
    ///
    func async(after duration: DispatchTimeInterval, execute work: @escaping () -> Void) {
        asyncAfter(deadline: .now() + duration, execute: work)
    }
}
