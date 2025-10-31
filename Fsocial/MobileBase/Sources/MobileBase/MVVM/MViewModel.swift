//
//  File.swift
//  
//
//  Created by Tran Hieu on 07/08/2024.
//

import Foundation

open class MViewModel: NSObject {
    
    public override init() {
        super.init()
        #if DEBUG
        print("❇️\(type(of: self)) init")
        #endif
    }
    
    open func viewModelDidReady() { }
    
    open func viewModelWillActive() { }
    
    open func viewModelDidActive() { }
    
    open func viewModelWillInactive() { }
    
    open func viewModelDidInactive() { }
    
    deinit {
        #if DEBUG
        print("✅\(type(of: self)) deinit")
        #endif
    }
}
