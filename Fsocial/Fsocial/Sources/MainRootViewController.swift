//
//  ViewController.swift
//  Fsocial
//
//  Created by Huy Tran on 13/8/24.
//

import UIKit


class MainRootViewController: UIViewController {
    var viewModel: LaunchViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.viewModel.router.trigger(.redirectTabbar)
        }
    }
}

