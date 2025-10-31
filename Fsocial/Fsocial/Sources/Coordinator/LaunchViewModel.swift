//
//  File.swift
//  Fsocial
//
//  Created by Huy Tran on 14/8/24.
//

import Foundation

class LaunchViewModel: NSObject {
    
    let router: WeakRouter<LaunchRoute>
    
    init(with router: WeakRouter<LaunchRoute>) {
        self.router = router
    }
}
