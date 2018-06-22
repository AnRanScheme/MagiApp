//
//  MagiMotionAnimator.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

public protocol MagiMotionAnimator: class {
    /// A reference to Motion.
    var motion: MagiMotionTransition! { get set }
    
    /// Cleans the contexts.
    func clean()
    
    /**
     A function that determines if a view can be animated.
     - Parameter view: A UIView.
     - Parameter isAppearing: A boolean that determines whether the
     view is appearing.
     */
    func canAnimate(view: UIView, isAppearing: Bool) -> Bool
    
    /**
     Animates the fromViews to the toViews.
     - Parameter fromViews: An Array of UIViews.
     - Parameter toViews: An Array of UIViews.
     - Returns: A TimeInterval.
     */
    func animate(fromViews: [UIView], toViews: [UIView]) -> TimeInterval
    
    /**
     Moves the view's animation to the given elapsed time.
     - Parameter to progress: A TimeInterval.
     */
    func seek(to progress: TimeInterval)
    
    /**
     Resumes the animation with a given elapsed time and
     optional reversed boolean.
     - Parameter at progress: A TimeInterval.
     - Parameter isReversed: A boolean to reverse the animation
     or not.
     */
    func resume(at progress: TimeInterval, isReversed: Bool) -> TimeInterval
    
    /**
     Applies the given state to the given view.
     - Parameter state: A MotionModifier.
     - Parameter to view: A UIView.
     */
    func apply(state: MagiMotionTargetState, to view: UIView)
}

