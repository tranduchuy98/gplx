//
//  NewsViewController.swift
//  Fsocial
//
//  Created by Huy Tran on 14/8/24.
//  Copyright (c) 2024 huyduc.dev. All rights reserved.


import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwiftUI
import SnapKit

class NewsViewController: BaseViewController<NewsViewModel> {

    override var setting: NavigationSetting {
        NavigationSetting(isHiddenNavigation: true)
    }
    
    @objc func backButtonClicked() {
        viewModel.back()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
    }
    
    func setupContentView() {
        let swiftUIView = NewsContentView() {
            self.viewModel.router.trigger(.questionView)
        }
        let hosting = UIHostingController(rootView: swiftUIView)
        self.addChild(hosting)
        self.view.addSubview(hosting.view)
        hosting.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        hosting.didMove(toParent: self)
    }

}
