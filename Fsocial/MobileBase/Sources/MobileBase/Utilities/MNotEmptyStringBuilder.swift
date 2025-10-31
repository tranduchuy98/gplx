//
//  NotEmptyStringBuilder.swift
// Example
//
//  Created by ChungTV on 14/02/2022.
//

import Foundation

public class MNotEmptyStringBuilder {

    public let split: String
    private var result: String?

    public init(split: String) {
        self.split = split
    }
    
    @discardableResult
    public func append(_ str: String?) -> MNotEmptyStringBuilder {
        guard let strNeedBuild = str, strNeedBuild.count > 0 else {
            return self
        }

        if result == nil {
            result = strNeedBuild
        } else {
            result! += split + strNeedBuild
        }

        return self
    }

    public func build() -> String? {
        return result
    }
}
