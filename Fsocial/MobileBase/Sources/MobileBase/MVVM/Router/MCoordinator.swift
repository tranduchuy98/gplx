//
//  Coordinator.swift
//  MVVMCore
//
//  Created by Tran Hieu on 05/08/2024.
//

import UIKit

open class MCoordinator: NSObject {
    
    public enum NavigationType {
        case currentFlow // push
        case newFlow(hideBar: Bool) // present, set root
    }
    
    public let router: MRouter

    public private(set) var childCoordinators: [MCoordinator] = []
    public let navigationType: NavigationType

    open weak var root: MPresentable? {
        fatalError("need root view presentable")
    }
    
    public init(router: MRouter, navigationType: NavigationType) {
        self.router = router
        self.navigationType = navigationType
        
        super.init()

        if case .newFlow(let hideBar) = navigationType, let root = root {
            router.setRoot(root, hideBar: hideBar)
        }
    }

    public func addChild(_ coordinator: MCoordinator) {
        childCoordinators.append(coordinator)
    }

    private func removeChild(_ coordinator: MCoordinator) {
        if let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
        }
    }

    public func setRootChild(coordinator: MCoordinator, hideBar: Bool) {
        addChild(coordinator)
        router.setRoot(coordinator, hideBar: hideBar) { [weak self, weak coordinator] in
            guard let coord = coordinator else { return }
            self?.removeChild(coord)
        }
    }

    public func pushChild(coordinator: MCoordinator, animated: Bool, onRemove: (() -> Void)? = nil) {
        addChild(coordinator)

        router.push(coordinator, animated: animated) { [weak self, weak coordinator] in
            guard let self = self, let coordinator = coordinator else { return }
            onRemove?()
            self.removeChild(coordinator)
        }
    }
    
    // make sure to always call dismissChild after
    public func presentChild(coordinator: MCoordinator, animated: Bool) {
        addChild(coordinator)
        router.present(coordinator, animated: animated)
    }

    public func dismissChild(_ coordinator: MCoordinator, animated: Bool) {
        coordinator.toPresentable().presentingViewController?.dismiss(animated: animated, completion: nil)
        removeChild(coordinator)
    }
    
    public func popChild(_ coordinator: MCoordinator, animated: Bool) {
        coordinator.toPresentable().navigationController?.popViewController(animated: animated)
        removeChild(coordinator)
    }
}

extension MCoordinator: MPresentable {
    public func toPresentable() -> UIViewController {
        switch navigationType {
        case .currentFlow:
            if let root = root {
                return root.toPresentable()
            } else {
                fatalError("need root view presentable")
            }
        case .newFlow:
            return router.toPresentable()
        }
    }
}
