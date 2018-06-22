//
//  MagiMotionAnimatorViewContext.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

internal class MagiMotionAnimatorViewContext {
    /// An optional reference to a MotionAnimator.
    var animator: MagiMotionAnimator?
    
    /// A reference to the snapshot UIView.
    var snapshot: UIView
    
    /// The animation target state.
    var targetState: MagiMotionTargetState
    
    /// A boolean indicating if the view is appearing.
    var isAppearing: Bool
    
    /// Animation duration time.
    var duration: TimeInterval = 0
    
    /// The computed current time of the snapshot layer.
    var currentTime: TimeInterval {
        return snapshot.layer.convertTime(CACurrentMediaTime(), from: nil)
    }
    
    /// A container view for the transition.
    var container: UIView? {
        return animator?.motion.context.container
    }
    
    /**
     An initializer.
     - Parameter animator: A MotionAnimator.
     - Parameter snapshot: A UIView.
     - Parameter targetState: A MotionModifier.
     - Parameter isAppearing: A Boolean.
     */
    required init(animator: MagiMotionAnimator, snapshot: UIView, targetState: MagiMotionTargetState, isAppearing: Bool) {
        self.animator = animator
        self.snapshot = snapshot
        self.targetState = targetState
        self.isAppearing = isAppearing
    }
    
    /// Cleans the context.
    func clean() {
        animator = nil
    }
    
    /**
     A class function that determines if a view can be animated
     to a given state.
     - Parameter view: A UIView.
     - Parameter state: A MotionModifier.
     - Parameter isAppearing: A boolean that determines whether the
     view is appearing.
     */
    class func canAnimate(view: UIView, state: MagiMotionTargetState, isAppearing: Bool) -> Bool {
        return false
    }
    
    /**
     Resumes the animation with a given elapsed time and
     optional reversed boolean.
     - Parameter at progress: A TimeInterval.
     - Parameter isReversed: A boolean to reverse the animation
     or not.
     - Returns: A TimeInterval.
     */
    @discardableResult
    func resume(at progress: TimeInterval, isReversed: Bool) -> TimeInterval {
        return 0
    }
    
    /**
     Moves the animation to the given elapsed time.
     - Parameter to progress: A TimeInterval.
     */
    func seek(to progress: TimeInterval) {}
    
    /**
     Applies the given state to the target state.
     - Parameter state: A MotionModifier.
     */
    func apply(state: MagiMotionTargetState) {}
    
    /**
     Starts the animations with an appearing boolean flag.
     - Parameter isAppearing: A boolean value whether the view
     is appearing or not.
     */
    @discardableResult
    func startAnimations() -> TimeInterval {
        return 0
    }
}
