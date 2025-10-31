//
//  RootTabBarCoordinator.swift
//  iStudy
//

import Foundation
import UIKit

enum TabRoute: Int, Route {
    case news       = 0
    case message = 1
    case wallet     = 2
    case more  = 3
}

class RootTabBarCoordinator: TabBarCoordinator<TabRoute> {
    var tabbarDelegate: TabbarDelegate?
    
    private let newsCoordinator: AppCoordinator
    private let messageCoordinator: AppCoordinator
    private let walletoordinator: AppCoordinator
    private let moreCoordinator: AppCoordinator
    
    var currentCoordinator: AppCoordinator? {
        let route = TabRoute(rawValue: rootViewController.selectedIndex)
        switch route {
        case .news: return newsCoordinator
        case .message: return messageCoordinator
        case .wallet: return walletoordinator
        default: break
        }
        return nil
    }
    
    init() {
        self.newsCoordinator                                = AppCoordinator(initialRoute: .news)
        newsCoordinator.rootViewController.tabBarItem       = UITabBarItem(title: L10n.Tabbar.news,
                                                                           image: #imageLiteral(resourceName: "ic-news"), tag: 0)
        
        self.messageCoordinator                          = AppCoordinator(initialRoute: .message)
        messageCoordinator.rootViewController.tabBarItem = UITabBarItem(title: L10n.Tabbar.message,
                                                                           image: #imageLiteral(resourceName: "ic-comment"), tag: 1)
        
        self.walletoordinator                              = AppCoordinator(initialRoute: .wallet)
        walletoordinator.rootViewController.tabBarItem     = UITabBarItem(title: L10n.Tabbar.wallet,
                                                                           image: #imageLiteral(resourceName: "ic-wallet"), tag: 2)
        
        self.moreCoordinator                           = AppCoordinator(initialRoute: .more)
        moreCoordinator.rootViewController.tabBarItem  = UITabBarItem(title: L10n.Tabbar.more,
                                                                           image: #imageLiteral(resourceName: "ic-more"), tag: 3)
        
        let controllers                                     = [newsCoordinator.rootViewController,
                                                               messageCoordinator.rootViewController,
                                                               walletoordinator.rootViewController,
                                                               moreCoordinator.rootViewController]
        
        super.init(tabs: [newsCoordinator, messageCoordinator, walletoordinator, moreCoordinator], select: newsCoordinator)
        self.tabbarDelegate = TabbarDelegate(router: weakRouter)
        rootViewController.delegate = self.tabbarDelegate
    }
    
    override func prepareTransition(for route: TabRoute) -> TabBarTransition {
        switch route {
        case .news:
            return .select(newsCoordinator.strongRouter)
        case .message:
            return .select(messageCoordinator.strongRouter)
        case .wallet:
            return .select(walletoordinator.strongRouter)
        case .more:
            return .select(moreCoordinator.strongRouter)
        }
    }
}

class TabbarDelegate: NSObject, UITabBarControllerDelegate {
    
    var router: WeakRouter<TabRoute>
    
    init(router: WeakRouter<TabRoute>) {
        self.router = router
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let baseVC = (viewController as? BaseViewController<BaseViewModel>) {
            tabBarController.tabBar.isHidden = baseVC.setting.isHiddenTabbar
        }
    }
}
