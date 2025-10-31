//
//  WalletViewModel.swift
//  Fsocial
//
//  Created by Huy Tran on 14/8/24.
//  Copyright (c) 2024 Ftech AI. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

class WalletViewModel : BaseViewModel {
    required public init(with router: WeakRouter<AppRoute>) {
        super.init(with: router)
    }
}
