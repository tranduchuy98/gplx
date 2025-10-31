//
//  LoginViewController.swift
//  Fsocial
//
//  Created by Huy Tran on 14/8/24.
//  Copyright (c) 2024 huyduc.dev. All rights reserved.


import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class LoginViewController: BaseViewController<LoginViewModel> {

    override var setting: NavigationSetting {
        NavigationSetting(isHiddenNavigation: true)
    }
    
    @objc func backButtonClicked() {
        viewModel.back()
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func a(_ sender: Any) {
        self.viewModel.router.trigger(.tabbar)
    }
}
