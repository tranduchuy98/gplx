//
//  Animation+Scale.swift
//  iStudy
//
import UIKit
 

extension Animation {
    static let scale = Animation(
        presentation: InteractiveTransitionAnimation.scalePresentation,
        dismissal: InteractiveTransitionAnimation.scaleDismissal
    )
}

extension InteractiveTransitionAnimation {
    fileprivate static let scalePresentation = InteractiveTransitionAnimation(duration: duration) { transitionContext in
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!

        containerView.backgroundColor = .white
        toView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        toView.alpha = 0

        containerView.addSubview(toView)
        containerView.bringSubviewToFront(toView)

        UIView.animate(withDuration: duration, animations: {
            toView.transform = .identity

            toView.alpha = 1
            fromView.alpha = 0
        }, completion: { _ in
            fromView.alpha = 1
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    fileprivate static let scaleDismissal = InteractiveTransitionAnimation(duration: duration) { transitionContext in
        let containerView: UIView = transitionContext.containerView
        let toView: UIView = transitionContext.view(forKey: .to)!
        let fromView: UIView = transitionContext.view(forKey: .from)!

        containerView.backgroundColor = .white
        containerView.addSubview(toView)
        containerView.sendSubviewToBack(toView)

        toView.alpha = 0
        fromView.layer.masksToBounds = true
        let cornerRadius = max(fromView.frame.height, fromView.frame.width)

        UIView.animate(withDuration: duration, animations: {
            fromView.transform.scaledBy(x: 0.1, y: 0.1)

            toView.alpha = 1
            fromView.alpha = 0
        }, completion: { _ in
            if !transitionContext.transitionWasCancelled {
                fromView.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
