//
//  Animation+Modal.swift
//  iStudy
//

import UIKit

extension Animation {
    static let modal = Animation(presentation: InteractiveTransitionAnimation.modalPresentation,
                                 dismissal: InteractiveTransitionAnimation.modalDismissal)
}

extension InteractiveTransitionAnimation {
    fileprivate static let modalPresentation = InteractiveTransitionAnimation(duration: duration) { context in
        let toView: UIView = context.view(forKey: .to)!
        let fromView: UIView = context.view(forKey: .from)!

        var startToFrame = fromView.frame
        startToFrame.origin.y += startToFrame.height
        context.containerView.addSubview(toView)
        context.containerView.bringSubviewToFront(toView)
        toView.frame = startToFrame

        UIView.animate(withDuration: duration, animations: {
            toView.frame = fromView.frame
        }, completion: { _ in
            context.completeTransition(!context.transitionWasCancelled)
        })
    }

    fileprivate static let modalDismissal = InteractiveTransitionAnimation(duration: duration) { context in
        let toView: UIView = context.view(forKey: .to)!
        let fromView: UIView = context.view(forKey: .from)!

        context.containerView.addSubview(toView)
        context.containerView.sendSubviewToBack(toView)
        var newFromFrame = toView.frame
        newFromFrame.origin.y += toView.frame.height

        UIView.animate(withDuration: duration, animations: {
            fromView.frame = newFromFrame
        }, completion: { _ in
            context.completeTransition(!context.transitionWasCancelled)
        })
    }
}
