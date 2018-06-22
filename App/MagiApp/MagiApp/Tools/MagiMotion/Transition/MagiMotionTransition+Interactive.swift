//
//  MagiMotionTransition+Interactive.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

extension MagiMotionTransition {
    /**
     Updates the elapsed time for the interactive transition.
     - Parameter progress t: the current progress, must be between -1...1.
     */
    func update(_ percentageComplete: TimeInterval) {
        guard .animating == state else {
            startingProgress = percentageComplete
            return
        }
        
        progressRunner.stop()
        progress = Double(CGFloat(percentageComplete).clamp(0, 1))
    }
    
    /**
     Finish the interactive transition.
     Will stop the interactive transition and animate from the
     current state to the **end** state.
     - Parameter isAnimated: A Boolean.
     */
    func finish(isAnimated: Bool = true) {
        guard .animating == state || .notified == state || .starting == state else {
            return
        }
        
        guard isAnimated else {
            complete(isFinishing: true)
            return
        }
        
        var d: TimeInterval = 0
        
        for a in animators {
            d = max(d, a.resume(at: progress * totalDuration, isReversed: false))
        }
        
        complete(after: d, isFinishing: true)
    }
    
    /**
     Cancel the interactive transition.
     Will stop the interactive transition and animate from the
     current state to the **begining** state
     - Parameter isAnimated: A boolean indicating if the completion is animated.
     */
    func cancel(isAnimated: Bool = true) {
        guard .animating == state || .notified == state || .starting == state else {
            return
        }
        
        guard isAnimated else {
            complete(isFinishing: false)
            return
        }
        
        var d: TimeInterval = 0
        
        for a in animators {
            var t = progress
            if t < 0 {
                t = -t
            }
            
            d = max(d, a.resume(at: t * totalDuration, isReversed: true))
        }
        
        complete(after: d, isFinishing: false)
    }
    
    /**
     Override transition animations during an interactive animation.
     
     For example:
     
     Motion.shared.apply([.position(x:50, y:50)], to: view)
     
     will set the view's position to 50, 50
     - Parameter modifiers: An Array of MotionModifier.
     - Parameter to view: A UIView.
     */
    func apply(modifiers: [MagiMotionModifier], to view: UIView) {
        guard .animating == state else {
            return
        }
        
        let targetState = MagiMotionTargetState(modifiers: modifiers)
        if let otherView = context.pairedView(for: view) {
            for animator in animators {
                animator.apply(state: targetState, to: otherView)
            }
        }
        
        for animator in self.animators {
            animator.apply(state: targetState, to: view)
        }
    }
}
