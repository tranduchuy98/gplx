//
//  Animation+Push.swift
//  iStudy
//

import UIKit


extension Animation {
    static let push = Animation(presentation: InteractiveTransitionAnimation.push,
                                      dismissal: InteractiveTransitionAnimation.pop)
}

extension InteractiveTransitionAnimation {
    fileprivate static let push = InteractiveTransitionAnimation(duration: duration) { context in
        let toView = context.view(forKey: .to)!
        let fromView = context.view(forKey: .from)!

        let middleFrame = fromView.frame

        var leftFrame = middleFrame
        leftFrame.origin.x -= middleFrame.width * 0.3

        var rightFrame = middleFrame
        rightFrame.origin.x += middleFrame.width

        context.containerView.addSubview(toView)
        context.containerView.bringSubviewToFront(toView)
        toView.frame = rightFrame

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            fromView.frame = leftFrame
            toView.frame = middleFrame
        }, completion: { _ in
            context.completeTransition(!context.transitionWasCancelled)
        })
    }

    fileprivate static let pop = InteractiveTransitionAnimation(duration: duration) { context in
        let toView = context.view(forKey: .to)!
        let fromView = context.view(forKey: .from)!

        let middleFrame = fromView.frame

        var leftFrame = middleFrame
        leftFrame.origin.x -= middleFrame.width * 0.3

        var rightFrame = middleFrame
        rightFrame.origin.x += middleFrame.width

        context.containerView.addSubview(toView)
        context.containerView.sendSubviewToBack(toView)
        toView.frame = leftFrame

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            fromView.frame = rightFrame
            toView.frame = middleFrame
        }, completion: { _ in
            context.completeTransition(!context.transitionWasCancelled)
        })
    }
}
