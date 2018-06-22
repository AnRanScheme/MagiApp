//
//  MagiMotionAnimationState.swift
//  MagicApp
//
//  Created by 安然 on 2018/5/31.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

public struct MagiMotionAnimationState {
    
    /// A reference to the position.
    public var position: CGPoint?
    
    /// A reference to the size.
    public var size: CGSize?
    
    /// A reference to the transform.
    public var transform: CATransform3D?
    
    /// A reference to the spin tuple.
    public var spin: (x: CGFloat, y: CGFloat, z: CGFloat)?
    
    /// A reference to the opacity.
    public var opacity: Double?
    
    /// A reference to the cornerRadius.
    public var cornerRadius: CGFloat?
    
    /// A reference to the backgroundColor.
    public var backgroundColor: CGColor?
    
    /// A reference to the zPosition.
    public var zPosition: CGFloat?
    
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
    
    /// A reference to the spring animation settings.
    public var spring: (CGFloat, CGFloat)?
    
    /// A time delay on starting the animation.
    public var delay: TimeInterval = 0
    
    /// The duration of the animation.
    public var duration: TimeInterval = 0.35
    
    /// The timing function value of the animation.
    public var timingFunction = CAMediaTimingFunction.easeInOut
    
    /// Custom target states.
    public var custom: [String: Any]?
    
    /// Completion block.
    public var completion: (() -> Void)?
    
    /// An initializer that accepts an Array of MagiMotionAnimations.
    ///
    /// - Parameter animations: An Array of MagiMotionAnimations.
    init(animations: [MagiMotionAnimation]) {
        append(contentsOf: animations)
    }
}

extension MagiMotionAnimationState {

    /// Adds a MotionAnimation to the current state.
    ///
    /// - Parameter element: A MagiMotionAnimation.
    public mutating func append(_ element: MagiMotionAnimation) {
        element.apply(&self)
    }

    /// Adds an Array of MotionAnimations to the current state.
    ///
    /// - Parameter elements: An Array of MotionAnimations.
    public mutating func append(contentsOf elements: [MagiMotionAnimation]) {
        for v in elements {
            v.apply(&self)
        }
    }
    
    /// A subscript that returns a custom value for a specified key.
    ///
    /// - Parameter key: A String.
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

extension MagiMotionAnimationState: ExpressibleByArrayLiteral {
    
    /// An initializer implementing the ExpressibleByArrayLiteral protocol.
    ///
    /// - Parameter elements: A list of MotionAnimations.
    public init(arrayLiteral elements: MagiMotionAnimation...) {
        append(contentsOf: elements)
    }
    
}

