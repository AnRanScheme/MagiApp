//
//  MagiMotionCoreAnimator.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

internal class MagiMotionCoreAnimator<T: MagiMotionAnimatorViewContext>: MagiMotionAnimator {
    weak public var motion: MagiMotionTransition!
    
    /// A reference to the MotionContext.
    public var context: MagiMotionContext! {
        return motion.context
    }
    
    /// An index of views to their corresponding animator context.
    var viewToContexts = [UIView: T]()
    
    /// Cleans the contexts.
    func clean() {
        for v in viewToContexts.values {
            v.clean()
        }
        
        viewToContexts.removeAll()
    }
    
    /**
     A function that determines if a view can be animated.
     - Parameter view: A UIView.
     - Parameter isAppearing: A boolean that determines whether the
     view is appearing.
     */
    func canAnimate(view: UIView, isAppearing: Bool) -> Bool {
        guard let state = context[view] else {
            return false
        }
        
        return T.canAnimate(view: view, state: state, isAppearing: isAppearing)
    }
    
    /**
     Animates the fromViews to the toViews.
     - Parameter fromViews: An Array of UIViews.
     - Parameter toViews: An Array of UIViews.
     - Returns: A TimeInterval.
     */
    func animate(fromViews: [UIView], toViews: [UIView]) -> TimeInterval {
        var d: TimeInterval = 0
        
        for v in fromViews {
            createViewContext(view: v, isAppearing: false)
        }
        
        for v in toViews {
            createViewContext(view: v, isAppearing: true)
        }
        
        for v in viewToContexts.values {
            if let duration = v.targetState.duration, .infinity != duration {
                v.duration = duration
                d = max(d, duration)
                
            } else {
                let duration = v.snapshot.optimizedDuration(targetState: v.targetState)
                
                if nil == v.targetState.duration {
                    v.duration = duration
                }
                
                d = max(d, duration)
            }
        }
        
        for v in viewToContexts.values {
            if .infinity == v.targetState.duration {
                v.duration = d
            }
            
            d = max(d, v.startAnimations())
        }
        
        return d
    }
    
    /**
     Moves the view's animation to the given elapsed time.
     - Parameter to progress: A TimeInterval.
     */
    func seek(to progress: TimeInterval) {
        for v in viewToContexts.values {
            v.seek(to: progress)
        }
    }
    
    /**
     Resumes the animation with a given elapsed time and
     optional reversed boolean.
     - Parameter at progress: A TimeInterval.
     - Parameter isReversed: A boolean to reverse the animation
     or not.
     */
    func resume(at progress: TimeInterval, isReversed: Bool) -> TimeInterval {
        var duration: TimeInterval = 0
        
        for (_, v) in viewToContexts {
            if nil == v.targetState.duration {
                v.duration = max(v.duration, v.snapshot.optimizedDuration(targetState: v.targetState) + progress)
            }
            
            duration = max(duration, v.resume(at: progress, isReversed: isReversed))
        }
        
        return duration
    }
    
    /**
     Applies the given state to the given view.
     - Parameter state: A MotionModifier.
     - Parameter to view: A UIView.
     */
    func apply(state: MagiMotionTargetState, to view: UIView) {
        guard let v = viewToContexts[view] else {
            return
        }
        
        v.apply(state: state)
    }
}

fileprivate extension MagiMotionCoreAnimator {
    /**
     Creates a view context for a given view.
     - Parameter view: A UIView.
     - Parameter isAppearing: A boolean that determines whether the
     view is appearing.
     */
    func createViewContext(view: UIView, isAppearing: Bool) {
        viewToContexts[view] = T(animator: self, snapshot: context.snapshotView(for: view), targetState: context[view]!, isAppearing: isAppearing)
    }
}
