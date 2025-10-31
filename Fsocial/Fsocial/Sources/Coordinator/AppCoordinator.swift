//
//  AppCoordinator.swift
//  iStudy
//
//  Created by Huy Duc on 2022/11/11.
//

import Foundation
import SwiftUI

// swiftlint:disable type_body_length
class AppCoordinator: NavigationCoordinator<AppRoute> {
    override init(rootViewController: NavigationCoordinator<RouteType>.RootViewController = .init(), initialRoute: RouteType? = nil) {
        super.init(rootViewController: rootViewController, initialRoute: initialRoute)
    }
    // swiftlint:disable cyclomatic_complexity function_body_length
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        if rootViewController.isNavigationBarHidden {
            rootViewController.setNavigationBarHidden(false, animated: false)
        }
        switch route {
        case .pop:
            return .pop()
        case .dismiss: return .dismiss()
        case .login:
            let viewModel = LoginViewModel(with: weakRouter)
            let viewController = LoginViewController.newInstance(with: viewModel)
            return .push(viewController)
        case .tabbar:
            let coordinator = RootTabBarCoordinator()
            coordinator.rootViewController.modalPresentationStyle = .fullScreen
            AppDelegate.shared?.rootCoordinator = coordinator
            return .presentOnRoot(coordinator, animation: .push)
        case .news:
            let viewModel = NewsViewModel(with: weakRouter)
            let viewController = NewsViewController.newInstance(with: viewModel)
            return .push(viewController)
        case .wallet:
            let viewModel = WalletViewModel(with: weakRouter)
            let viewController = WalletViewController.newInstance(with: viewModel)
            return .push(viewController)
        case .more:
            let viewModel = MoreViewModel(with: weakRouter)
            let viewController = MoreViewController.newInstance(with: viewModel)
            return .push(viewController)
        case .message:
            let viewModel = MessageViewModel(with: weakRouter)
            let viewController = MessageViewController.newInstance(with: viewModel)
            return .push(viewController)
        case .questionView:
            let viewModel = QuestionViewViewModel(with: weakRouter)
            let viewController = QuestionViewViewController.newInstance(with: viewModel)
            return .push(viewController)
        }
    }
}
