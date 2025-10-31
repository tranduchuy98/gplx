//
//  CollectionUtils.swift
// Example
//
//  Created by ChungTV on 14/02/2022.
//

import Foundation

extension Optional where Wrapped: Collection {
    
    var isNilOrEmpty: Bool {
        guard let list = self else {
            return true
        }
        return list.isEmpty
    }
    
    var isNotNilOrEmpty: Bool {
        guard let list = self else {
            return false
        }
        return !list.isEmpty
    }
}

extension Collection {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
}

extension Array {
    func getItem(at index: Int) -> Element? {
        guard index >= 0 && index < count else {
            return nil
        }
        return self[index]
    }
}
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
//
//extension Dictionary {
//    
//    mutating func join(_ other: [Key: Value?]) {
//        other.compactMapValues({ $0 }).forEach({ self[$0.key] = $0.value })
//    }
//    
//    func joined(_ other: [Key: Value?]) -> [Key: Value] {
//        var dict = self
//        dict.join(other)
//        return dict
//    }
//}
