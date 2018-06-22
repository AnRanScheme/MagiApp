//
//  MagiMotionTargetState.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

/// 储存各种信息
public struct MagiMotionTargetState {
    /// The identifier value to match source and destination views.
    public var motionIdentifier: String?
    
    /// The initial state that the transition will start at.
    internal var beginState: [MagiMotionModifier]?
    
    public var conditionalModifiers: [((MagiMotionConditionalContext) -> Bool, [MagiMotionModifier])]?
    
    /// A reference to the position.
    public var position: CGPoint?
    
    /// A reference to the size.
    public var size: CGSize?
    
    /// A reference to the transform.
    public var transform: CATransform3D?
    
    /// A reference to the opacity.
    public var opacity: Double?
    
    /// A reference to the cornerRadius.
    public var cornerRadius: CGFloat?
    
    /// A reference to the backgroundColor.
    public var backgroundColor: CGColor?
    
    /// A reference to the zPosition.
    public var zPosition: CGFloat?
    
    /// A reference to the contentsRect.
    public var contentsRect: CGRect?
    
    /// A reference to the contentsScale.
    public var contentsScale: CGFloat?
    
    /// A reference to the borderWidth.
    public var borderWidth: CGFloat?
    
    /// A reference to the borderColor.
    public var borderColor: CGColor?
    
    /// A reference to the shadowColor.
    public var shadowColor: CGColor?
    
    /// A reference to the shadowOpacity.
    public var shadowOpacity: Float?
    
    /// A reference to the shadowOffset.
    public var shadowOffset: CGSize?
    
    /// A reference to the shadowRadius.
    public var shadowRadius: CGFloat?
    
    /// A reference to the shadowPath.
    public var shadowPath: CGPath?
    
    /// A boolean for the masksToBounds state.
    public var masksToBounds: Bool?
    
    /// A boolean indicating whether to display a shadow or not.
    public var displayShadow = true
    
    /// A reference to the overlay settings.
    public var overlay: (color: CGColor, opacity: CGFloat)?
    
    /// A reference to the spring animation settings.
    public var spring: (CGFloat, CGFloat)?
    
    /// A time delay on starting the animation.
    public var delay: TimeInterval = 0
    
    /// The duration of the animation.
    public var duration: TimeInterval?
    
    /// The timing function value of the animation.
    public var timingFunction: CAMediaTimingFunction?
    
    /// The arc curve value.
    public var arc: CGFloat?
    
    /// The cascading animation settings.
    public var cascade: (TimeInterval, CascadeDirection, Bool)?
    
    /**
     A boolean indicating whether to ignore the subview transition
     animations or not.
     */
    public var ignoreSubviewTransitions: Bool?
    
    /// The coordinate space to transition views within.
    public var coordinateSpace: MagiMotionCoordinateSpace?
    
    /// Change the size of a view based on a scale factor.
    public var useScaleBasedSizeChange: Bool?
    
    /// The type of snapshot to use.
    public var snapshotType: MagiMotionSnapshotType?
    
    /// Do not fade the view when transitioning.
    public var nonFade = false
    
    /// Force an animation.
    public var forceAnimate = false
    
    /// Custom target states.
    public var custom: [String: Any]?
    
    /**
     An initializer that accepts an Array of MotionTargetStates.
     - Parameter transitions: An Array of MotionTargetStates.
     */
    init(modifiers: [MagiMotionModifier]) {
        append(contentsOf: modifiers)
    }
}

extension MagiMotionTargetState {
    /**
     Adds a MotionTargetState to the current state.
     - Parameter _ modifier: A MotionTargetState.
     */
    public mutating func append(_ modifier: MagiMotionModifier) {
        modifier.apply(&self)
    }
    
    /**
     Adds an Array of MotionTargetStates to the current state.
     - Parameter contentsOf modifiers: An Array of MotionTargetStates.
     */
    public mutating func append(contentsOf modifiers: [MagiMotionModifier]) {
        for v in modifiers {
            v.apply(&self)
        }
    }
    
    /**
     A subscript that returns a custom value for a specified key.
     - Parameter key: A String.
     - Returns: An optional Any value.
     */
    public subscript(key: String) -> Any? {
        get {
            return custom?[key]
        }
        set(value) {
            if nil == custom {
                custom = [:]
            }
            
            custom![key] = value
        }
    }
}

extension MagiMotionTargetState: ExpressibleByArrayLiteral {
    /**
     An initializer implementing the ExpressibleByArrayLiteral protocol.
     - Parameter arrayLiteral elements: A list of MotionTargetStates.
     */
    public init(arrayLiteral elements: MagiMotionModifier...) {
        append(contentsOf: elements)
    }
}

