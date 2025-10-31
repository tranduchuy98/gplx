//
//  LaunchCoordinator.swift
//  iStudy
//
//  Created by Huy Duc on 2022/11/11.®
//

import Foundation

enum LaunchRoute: Route {
    case login
    case redirectTabbar
}

class LaunchCoordinator: ViewCoordinator<LaunchRoute> {
    
    init() {
        let viewController = Storyboard.load(.main, type: MainRootViewController.self)
        super.init(rootViewController: viewController)
        viewController.viewModel = LaunchViewModel(with: weakRouter)
    }
//    
//    fileprivate func createSelectLanguageCoordinator() -> AppCoordinator {
//        let coordinator = AppCoordinator(initialRoute: .selectLanguage)
//        coordinator.rootViewController.modalPresentationStyle = .fullScreen
//        return coordinator
//    }
//    
//    fileprivate func createWelcomeCoordinator() -> AppCoordinator {
//        let coordinator = AppCoordinator(initialRoute: .welcome)
//        coordinator.rootViewController.modalPresentationStyle = .fullScreen
//        return coordinator
//    }
//    
    fileprivate func createSignInCoordinator() -> AppCoordinator {
        let coordinator = AppCoordinator(initialRoute: .login)
        coordinator.rootViewController.modalPresentationStyle = .fullScreen
        return coordinator
    }
    
    open override func prepareTransition(for route: RouteType) -> TransitionType {
        switch route {
        case .redirectTabbar:
            let coordinator = RootTabBarCoordinator()
            coordinator.rootViewController.modalPresentationStyle = .fullScreen
            AppDelegate.shared?.rootCoordinator = coordinator
            return .presentOnRoot(coordinator, animation: .push)
        case .login:
            let coordinator = createSignInCoordinator()
            AppDelegate.shared?.appCoordinator = coordinator
            return .presentOnRoot(coordinator, animation: .push)
        }
    }
}
