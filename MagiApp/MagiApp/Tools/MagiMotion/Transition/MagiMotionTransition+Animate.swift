//
//  MagiMotionTransition+Animate.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

extension MagiMotionTransition {
    /// Starts the transition animation.
    func animate() {
        guard .starting == state else {
            return
        }
        
        state = .animating
        
        if let tv = toView {
            context.unhide(view: tv)
        }
        
        for v in animatingFromViews {
            context.hide(view: v)
        }
        
        for v in animatingToViews {
            context.hide(view: v)
        }
        
        var t: TimeInterval = 0
        var animatorWantsInteractive = false
        
        if context.insertToViewFirst {
            for v in animatingToViews {
                context.snapshotView(for: v)
            }
            
            for v in animatingFromViews {
                context.snapshotView(for: v)
            }
            
        } else {
            for v in animatingFromViews {
                context.snapshotView(for: v)
            }
            
            for v in animatingToViews {
                context.snapshotView(for: v)
            }
        }
        
        // UIKit appears to set fromView setNeedLayout to be true.
        // We don't want fromView to layout after our animation starts.
        // Therefore we kick off the layout beforehand
        fromView?.layoutIfNeeded()
        for animator in animators {
            let duration = animator.animate(fromViews: animatingFromViews.filter {
                return animator.canAnimate(view: $0, isAppearing: false)
                }, toViews: animatingToViews.filter {
                    return animator.canAnimate(view: $0, isAppearing: true)
            })
            
            if .infinity == duration {
                animatorWantsInteractive = true
            } else {
                t = max(t, duration)
            }
        }
        
        totalDuration = t
        
        if let forceFinishing = forceFinishing {
            complete(isFinishing: forceFinishing)
        } else if let startingProgress = startingProgress {
            update(startingProgress)
        } else if animatorWantsInteractive {
            update(0)
        } else {
            complete(after: totalDuration, isFinishing: true)
        }
        
        fullScreenSnapshot?.removeFromSuperview()
    }
}


