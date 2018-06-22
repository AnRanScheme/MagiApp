//
//  MagiMotionTransition+UIViewControllerTransitioningDelegate.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

extension MagiMotionTransition: UIViewControllerTransitioningDelegate {
    /// A reference to the interactive transitioning instance.
    var interactiveTransitioning: UIViewControllerInteractiveTransitioning? {
        return forceNonInteractive ? nil : self
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard !isTransitioning else {
            return nil
        }
        
        state = .notified
        isPresenting = true
        fromViewController = fromViewController ?? presenting
        toViewController = toViewController ?? presented
        
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard !isTransitioning else {
            return nil
        }
        
        state = .notified
        isPresenting = false
        fromViewController = fromViewController ?? dismissed
        return self
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioning
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioning
    }
}

extension MagiMotionTransition: UIViewControllerAnimatedTransitioning {
    /**
     The animation method that is used to coordinate the transition.
     - Parameter using transitionContext: A UIViewControllerContextTransitioning.
     */
    public func animateTransition(using context: UIViewControllerContextTransitioning) {
        transitionContext = context
        fromViewController = fromViewController ?? context.viewController(forKey: .from)
        toViewController = toViewController ?? context.viewController(forKey: .to)
        transitionContainer = context.containerView
        
        start()
    }
    
    /**
     Returns the transition duration time interval.
     - Parameter using transitionContext: An optional UIViewControllerContextTransitioning.
     - Returns: A TimeInterval that is the total animation time including delays.
     */
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0 // Time will be updated dynamically.
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        state = .possible
    }
}

extension MagiMotionTransition: UIViewControllerInteractiveTransitioning {
    public var wantsInteractiveStart: Bool {
        return true
    }
    
    public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        animateTransition(using: transitionContext)
    }
}

