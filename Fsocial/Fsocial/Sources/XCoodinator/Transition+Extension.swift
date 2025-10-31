//
//  Transition+Extension.swift
//  iStudy
//

import UIKit

extension UIViewController {
    private var topPresentedViewController: UIViewController {
        presentedViewController?.topPresentedViewController ?? self
    }
    
    func present(onRoot: Bool,
                 _ viewController: UIViewController,
                 with options: TransitionOptions,
                 animation: Animation?,
                 completion: PresentationHandler?) {

        if let animation = animation {
            viewController.transitioningDelegate = animation
        }
        let presentingViewController = onRoot
            ? self
            : topPresentedViewController
        presentingViewController.present(viewController, animated: options.animated, completion: completion)
    }
}

extension Transition {
    public static func presentPopup(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        presentable.viewController.modalTransitionStyle = .crossDissolve
        presentable.viewController.modalPresentationStyle = .overFullScreen
        return Transition(presentables: [presentable],
                   animationInUse: animation?.presentationAnimation
        ) { rootViewController, options, completion in
            rootViewController.present(onRoot: false,
                                       presentable.viewController,
                                       with: options,
                                       animation: animation
            ) {
                presentable.presented(from: rootViewController)
                completion?()
            }
        }
    }
}
