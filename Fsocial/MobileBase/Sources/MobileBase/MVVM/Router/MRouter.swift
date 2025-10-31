//
//  Router.swift
//  MVVMCore
//
//  Created by Tran Hieu on 05/08/2024.
//

import UIKit

open class MRouter: NSObject, MPresentable, UINavigationControllerDelegate {
    
    private var completions: [UIViewController : () -> Void]
    
    private let navigationController: UINavigationController
    
    public init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        self.completions = [:]
        super.init()
        self.navigationController.delegate = self
    }
    
    // MARK: Presentable
    
    open func toPresentable() -> UIViewController {
        return navigationController
    }
    
    deinit {
        if let presented = navigationController.presentedViewController {
            dismiss(presented)
        }
    }
    
    public func present(_ presentable: MPresentable, animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.present(presentable.toPresentable(), animated: animated, completion: completion)
    }
    
    public func dismiss(_ presentable: MPresentable, animated: Bool = true, completion: (() -> Void)? = nil) {
        if navigationController.presentedViewController == presentable.toPresentable() {
            navigationController.dismiss(animated: animated, completion: completion)
        }
    }
    
    public func dismiss(coordinator: MCoordinator, animated: Bool = true, completion: (() -> Void)? = nil) {
        dismiss(coordinator.toPresentable())
    }
    
    public func removeLatestSameTypeAndPush(_ presentable: MPresentable, animated: Bool = true) {
        let controller = presentable.toPresentable()
        
        if let index = navigationController.viewControllers.lastIndex(where: { type(of: $0) === type(of: controller) }) {
            navigationController.viewControllers.remove(at: index)
        }
        navigationController.pushViewController(controller, animated: animated)
    }
    
    public func replace(_ presentable: MPresentable, animated: Bool = true) {
        let controller = presentable.toPresentable()
        let total = navigationController.viewControllers.count
        
        if (total > 0) {
            navigationController.viewControllers.remove(at: total - 1)
        }
        push(controller, animated: animated)
    }
    
    /// Remove some view controller (not last controller) - disable go back some screen when have an action success
    public func remove(_ viewControllerTypes: [UIViewController.Type]) {
        navigationController.viewControllers.removeAll(where: { (vc) -> Bool in
            if viewControllerTypes.contains(where: { type(of: vc) === $0 }) {
                return true
            } else {
                return false
            }
        })
    }
    
    public func push(_ presentable: MPresentable, animated: Bool = true, completion: (() -> Void)? = nil) {
        
        let controller = presentable.toPresentable()
        
        guard controller is UINavigationController == false else {
            return
        }
        
        if let completion = completion {
            completions[controller] = completion
        }
        
        navigationController.pushViewController(controller, animated: animated)
    }
    
    public func pop(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let completion = completion {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            if let controller = navigationController.popViewController(animated: animated) {
                runCompletion(for: controller)
            }
            return CATransaction.commit()
        }
        if let controller = navigationController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    public func setRoot(_ presentable: MPresentable, hideBar: Bool = false, completion: (() -> Void)? = nil) {
        // Call all completions so all coordinators can be deallocated
        for controller in navigationController.viewControllers {
            runCompletion(for: controller)
        }
        
        let controller = presentable.toPresentable()
        
        if let viewController = controller as? UINavigationController {
            navigationController.setViewControllers(viewController.viewControllers, animated: false)
            if let completion = completion {
                viewController.viewControllers.forEach { completions[$0] = completion }
            }
        } else {
            navigationController.setViewControllers([controller], animated: false)
            if let completion = completion {
                completions[controller] = completion
            }
        }
        navigationController.isNavigationBarHidden = hideBar
    }
    
    public func popToRoot(animated: Bool, completion: (() -> Void)? = nil) {
        if let completion = completion {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            if let controllers = navigationController.popToRootViewController(animated: animated) {
                controllers.forEach { runCompletion(for: $0) }
            }
            return CATransaction.commit()
        }
        if let controllers = navigationController.popToRootViewController(animated: animated) {
            controllers.forEach { runCompletion(for: $0) }
        }
    }
    
    public func popTo(_ presentable: MPresentable, animated: Bool = true) {
        if let controllers = navigationController.popToViewController(presentable.toPresentable(), animated: animated) {
            controllers.forEach { runCompletion(for: $0) }
        }
    }
    
    public func popTo(viewControllerType: UIViewController.Type, completion: (() -> Void)? = nil) {
        if let completion = completion {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            if let viewController = navigationController
                .viewControllers
                .first(where: { viewControllerType === type(of: $0) }) {
                if let vcs = navigationController.popToViewController(viewController, animated: true) {
                    vcs.forEach { runCompletion(for: $0) }
                }
            }
            return CATransaction.commit()
        }
        if let viewController = navigationController
            .viewControllers
            .first(where: { viewControllerType === type(of: $0) }) {
            if let vcs = navigationController.popToViewController(viewController, animated: true) {
                vcs.forEach { runCompletion(for: $0) }
            }
        }
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
    
    // MARK: UINavigationControllerDelegate
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Ensure the view controller is popping
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(poppedViewController) else {
            return
        }
        
        runCompletion(for: poppedViewController)
    }
}
