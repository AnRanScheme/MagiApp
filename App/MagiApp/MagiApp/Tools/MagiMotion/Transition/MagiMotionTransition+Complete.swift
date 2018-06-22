//
//  MagiMotionTransition+Complete.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

extension MagiMotionTransition {
    /**
     Complete the transition.
     - Parameter isFinishing: A Boolean indicating if the transition
     has completed.
     */
    @objc
    func complete(isFinishing: Bool) {
        if state == .notified {
            forceFinishing = isFinishing
        }
        
        guard .animating == state || .starting == state else {
            return
        }
        
        defer {
            transitionContext = nil
            fromViewController = nil
            toViewController = nil
            isNavigationController = false
            isTabBarController = false
            forceNonInteractive = false
            animatingToViews.removeAll()
            animatingFromViews.removeAll()
            transitionObservers = nil
            transitionContainer = nil
            completionCallback = nil
            forceFinishing = nil
            container = nil
            startingProgress = nil
            preprocessors.removeAll()
            animators.removeAll()
            plugins.removeAll()
            context = nil
            progress = 0
            totalDuration = 0
            state = .possible
        }
        
        state = .completing
        
        progressRunner.stop()
        context.clean()
        
        if let tv = toView, let fv = fromView {
            if isFinishing && isPresenting && toOverFullScreen {
                // finished presenting a overFullScreen view controller.
                context.unhide(rootView: tv)
                context.removeSnapshots(rootView: tv)
                context.storeViewAlpha(rootView: fv)
                
                fromViewController!.motionStoredSnapshot = container
                fv.removeFromSuperview()
                fv.addSubview(container)
                
            } else if !isFinishing && !isPresenting && fromOverFullScreen {
                // Cancelled dismissing a overFullScreen view controller.
                context.unhide(rootView: fv)
                context.removeSnapshots(rootView: fv)
                context.storeViewAlpha(rootView: tv)
                
                toViewController!.motionStoredSnapshot = container
                container.superview?.addSubview(tv)
                tv.addSubview(container)
                
            } else {
                context.unhideAll()
                context.removeAllSnapshots()
            }
            
            // Move fromView & toView back from our container back to the one supplied by UIKit.
            if (toOverFullScreen && isFinishing) || (fromOverFullScreen && !isFinishing) {
                transitionContainer?.addSubview(isFinishing ? fv : tv)
            }
            
            transitionContainer?.addSubview(isFinishing ? tv : fv)
            
            if isPresenting != isFinishing, !isContainerController {
                // Only happens when present a .overFullScreen view controller.
                // bug: http://openradar.appspot.com/radar?id=5320103646199808
                UIApplication.shared.keyWindow?.addSubview(isPresenting ? fv : tv)
            }
        }
        
        if container.superview == transitionContainer {
            container.removeFromSuperview()
        }
        
        for a in animators {
            a.clean()
        }
        
        transitionContainer?.isUserInteractionEnabled = true
        
        completionCallback?(isFinishing)
        
        if isFinishing {
            toViewController?.tabBarController?.tabBar.layer.removeAllAnimations()
        } else {
            fromViewController?.tabBarController?.tabBar.layer.removeAllAnimations()
        }
        
        let tContext = transitionContext
        let fvc = fromViewController
        let tvc = toViewController
        
        if isFinishing {
            processEndTransitionDelegation(transitionContext: tContext, fromViewController: fvc, toViewController: tvc)
        } else {
            processCancelTransitionDelegation(transitionContext: tContext, fromViewController: fvc, toViewController: tvc)
            tContext?.cancelInteractiveTransition()
        }
        
        tContext?.completeTransition(isFinishing)
    }
}

