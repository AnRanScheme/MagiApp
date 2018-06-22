//
//  MagiMotionPlugin.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

class MagiMotionPlugin: MagiMotionCorePreprocessor, MagiMotionAnimator {
    /**
     Determines whether or not to receive `seekTo` callback on every frame.
     
     Default is false.
     
     When **requirePerFrameCallback** is **false**, the plugin needs to start its own animations inside `animate` & `resume`
     The `seekTo` method is only being called during an interactive transition.
     
     When **requirePerFrameCallback** is **true**, the plugin will receive `seekTo` callback on every animation frame. Hence it is possible for the plugin to do per-frame animations without implementing `animate` & `resume`
     */
    open var requirePerFrameCallback = false
    
    public override required init() {}
    
    /**
     Called before any animation.
     Override this method when you want to preprocess transitions for views
     - Parameters:
     - context: object holding all parsed and changed transitions,
     - fromViews: A flattened list of all views from source ViewController
     - toViews: A flattened list of all views from destination ViewController
     
     To check a view's transitions:
     
     context[view]
     context[view, "transitionName"]
     
     To set a view's transitions:
     
     context[view] = [("transition1", ["parameter1"]), ("transition2", [])]
     context[view, "transition1"] = ["parameter1", "parameter2"]
     
     */
    open override func process(fromViews: [UIView], toViews: [UIView]) {}
    
    /**
     - Returns: return true if the plugin can handle animating the view.
     - Parameters:
     - context: object holding all parsed and changed transitions,
     - view: the view to check whether or not the plugin can handle the animation
     - isAppearing: true if the view is isAppearing(i.e. a view in destination ViewController)
     If return true, Motion won't animate and won't let any other plugins animate this view.
     The view will also be hidden automatically during the animation.
     */
    open func canAnimate(view: UIView, isAppearing: Bool) -> Bool { return false }
    
    /**
     Perform the animation.
     
     Note: views in `fromViews` & `toViews` are hidden already. Unhide then if you need to take snapshots.
     - Parameters:
     - context: object holding all parsed and changed transitions,
     - fromViews: A flattened list of all views from source ViewController (filtered by `canAnimate`)
     - toViews: A flattened list of all views from destination ViewController (filtered by `canAnimate`)
     - Returns: The duration needed to complete the animation
     */
    
    open func animate(fromViews: [UIView], toViews: [UIView]) -> TimeInterval { return 0 }
    
    /**
     Called when all animations are completed.
     
     Should perform cleanup and release any reference
     */
    open func clean() {}
    
    /**
     For supporting interactive animation only.
     
     This method is called when an interactive animation is in place
     The plugin should pause the animation, and seek to the given progress
     - Parameters:
     - progress: time of the animation to seek to.
     */
    open func seek(to progress: TimeInterval) {}
    
    /**
     For supporting interactive animation only.
     
     This method is called when an interactive animation is ended
     The plugin should resume the animation.
     - Parameters:
     - progress: will be the same value since last `seekTo`
     - reverse: a boolean value indicating whether or not the animation should reverse
     */
    open func resume(at progress: TimeInterval, isReversed: Bool) -> TimeInterval { return 0 }
    
    /**
     For supporting interactive animation only.
     
     This method is called when user wants to override animation transitions during an interactive animation
     
     - Parameters:
     - state: the target state to override
     - view: the view to override
     */
    open func apply(state: MagiMotionTargetState, to view: UIView) {}
}

// methods for enable/disable the current plugin
extension MagiMotionPlugin {
    /// A boolean indicating whether plugins are available.
    public static var isEnabled: Bool {
        get {
            return MagiMotionTransition.isEnabled(plugin: self)
        }
        set(value) {
            if value {
                enable()
            } else {
                disable()
            }
        }
    }
    
    /// Enable plugins.
    public static func enable() {
        MagiMotionTransition.enable(plugin: self)
    }
    
    /// Disable plugins.
    public static func disable() {
        MagiMotionTransition.disable(plugin: self)
    }
}

