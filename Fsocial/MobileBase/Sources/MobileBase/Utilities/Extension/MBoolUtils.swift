//
//  BoolUtils.swift
// Example
//
//  Created by Admin on 01/11/2022.
//  Copyright © 2022 FTech AI. All rights reserved.
//

import Foundation

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}

extension Int {
    var boolenValue: Bool {
        return self == 1
    }
}
