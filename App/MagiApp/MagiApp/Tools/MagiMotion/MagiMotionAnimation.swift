//
//  MagiMagiMotionAnimation.swift
//  MagicApp
//
//  Created by 安然 on 2018/5/31.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

public class MagiMotionAnimation {
    /// A reference to the callback that applies the MagiMotionAnimationState.
    internal let apply: (inout MagiMotionAnimationState) -> Void
    
    /**
     An initializer that accepts a given callback.
     - Parameter applyFunction: A given callback.
     */
    init(applyFunction: @escaping (inout MagiMotionAnimationState) -> Void) {
        apply = applyFunction
    }
}

public extension MagiMotionAnimation {
    /**
     Animates a view's current background color to the
     given color.
     - Parameter color: A UIColor.
     - Returns: A MagiMotionAnimation.
     */
    static func background(color: UIColor) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.backgroundColor = color.cgColor
        }
    }
    
    /**
     Animates a view's current border color to the
     given color.
     - Parameter color: A UIColor.
     - Returns: A MagiMotionAnimation.
     */
    static func border(color: UIColor) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.borderColor = color.cgColor
        }
    }
    
    /**
     Animates a view's current border width to the
     given width.
     - Parameter width: A CGFloat.
     - Returns: A MagiMotionAnimation.
     */
    static func border(width: CGFloat) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.borderWidth = width
        }
    }
    
    /**
     Animates a view's current corner radius to the
     given radius.
     - Parameter radius: A CGFloat.
     - Returns: A MagiMotionAnimation.
     */
    static func corner(radius: CGFloat) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.cornerRadius = radius
        }
    }
    
    /**
     Animates a view's current transform (perspective, scale, rotate)
     to the given one.
     - Parameter _ transform: A CATransform3D.
     - Returns: A MagiMotionAnimation.
     */
    static func transform(_ transform: CATransform3D) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.transform = transform
        }
    }
    
    /**
     Animates a view's current rotation to the given x, y,
     and z values.
     - Parameter x: A CGFloat.
     - Parameter y: A CGFloat.
     - Parameter z: A CGFloat.
     - Returns: A MagiMotionAnimation.
     */
    static func rotate(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            var t = $0.transform ?? CATransform3DIdentity
            t = CATransform3DRotate(t, CGFloat(Double.pi) * x / 180, 1, 0, 0)
            t = CATransform3DRotate(t, CGFloat(Double.pi) * y / 180, 0, 1, 0)
            $0.transform = CATransform3DRotate(t, CGFloat(Double.pi) * z / 180, 0, 0, 1)
        }
    }
    
    /**
     Animates a view's current rotation to the given point.
     - Parameter _ point: A CGPoint.
     - Parameter z: A CGFloat.
     - Returns: A MagiMotionAnimation.
     */
    static func rotate(_ point: CGPoint, z: CGFloat = 0) -> MagiMotionAnimation {
        return .rotate(x: point.x, y: point.y, z: z)
    }
    
    /**
     Rotate 2d.
     - Parameter _ z: A CGFloat.
     - Returns: A MagiMotionAnimation.
     */
    static func rotate(_ z: CGFloat) -> MagiMotionAnimation {
        return .rotate(z: z)
    }
    
    /**
     Animates a view's current spin to the given x, y,
     and z values.
     - Parameter x: A CGFloat.
     - Parameter y: A CGFloat.
     - Parameter z: A CGFloat.
     - Returns: A MagiMotionAnimation.
     */
    static func spin(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.spin = (x, y, z)
        }
    }
    
    /**
     Animates a view's current spin to the given point.
     - Parameter _ point: A CGPoint.
     - Parameter z: A CGFloat.
     - Returns: A MagiMotionAnimation.
     */
    static func spin(_ point: CGPoint, z: CGFloat = 0) -> MagiMotionAnimation {
        return .spin(x: point.x, y: point.y, z: z)
    }
    
    /**
     Spin 2d.
     - Parameter _ z: A CGFloat.
     - Returns: A MagiMotionAnimation.
     */
    static func spin(_ z: CGFloat) -> MagiMotionAnimation {
        return .spin(z: z)
    }
    
    /**
     Animates the view's current scale to the given x, y, and z scale values.
     - Parameter x: A CGFloat.
     - Parameter y: A CGFloat.
     - Parameter z: A CGFloat.
     - Returns: A MagiMotionAnimation.
     */
    static func scale(x: CGFloat = 1, y: CGFloat = 1, z: CGFloat = 1) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.transform = CATransform3DScale($0.transform ?? CATransform3DIdentity, x, y, z)
        }
    }
    
    /**
     Animates the view's current x & y scale to the given scale value.
     - Parameter _ xy: A CGFloat.
     - Returns: A MagiMotionAnimation.
     */
    static func scale(_ xy: CGFloat) -> MagiMotionAnimation {
        return .scale(x: xy, y: xy)
    }
    
    /**
     Animates a view equal to the distance given by the x, y, and z values.
     - Parameter x: A CGFloat.
     - Parameter y: A CGFloat.
     - Parameter z: A CGFloat.
     - Returns: A MagiMotionAnimation.
     */
    static func translate(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.transform = CATransform3DTranslate($0.transform ?? CATransform3DIdentity, x, y, z)
        }
    }
    
    /**
     Animates a view equal to the distance given by a point and z value.
     - Parameter _ point: A CGPoint.
     - Parameter z: A CGFloat.
     - Returns: A MagiMotionAnimation.
     */
    static func translate(_ point: CGPoint, z: CGFloat = 0) -> MagiMotionAnimation {
        return .translate(x: point.x, y: point.y, z: z)
    }
    
    /**
     Animates a view's current position to the given point.
     - Parameter _ point: A CGPoint.
     - Returns: A MagiMotionAnimation.
     */
    static func position(_ point: CGPoint) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.position = point
        }
    }
    
    /**
     Animates a view's current position to the given x and y values.
     - Parameter x: A CGloat.
     - Parameter y: A CGloat.
     - Returns: A MagiMotionAnimation.
     */
    static func position(x: CGFloat, y: CGFloat) -> MagiMotionAnimation {
        return .position(CGPoint(x: x, y: y))
    }
    
    /// Fades the view in during an animation.
    static var fadeIn = MagiMotionAnimation.fade(1)
    
    /// Fades the view out during an animation.
    static var fadeOut = MagiMotionAnimation.fade(0)
    
    /**
     Animates a view's current opacity to the given one.
     - Parameter _ opacity: A Double.
     - Returns: A MagiMotionAnimation.
     */
    static func fade(_ opacity: Double) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.opacity = opacity
        }
    }
    
    /**
     Animates a view's current zPosition to the given position.
     - Parameter _ position: An Int.
     - Returns: A MagiMotionAnimation.
     */
    static func zPosition(_ position: CGFloat) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.zPosition = position
        }
    }
    
    /**
     Animates a view's current size to the given one.
     - Parameter _ size: A CGSize.
     - Returns: A MagiMotionAnimation.
     */
    static func size(_ size: CGSize) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.size = size
        }
    }
    
    /**
     Animates the view's current size to the given width and height.
     - Parameter width: A CGFloat.
     - Parameter height: A CGFloat.
     - Returns: A MagiMotionAnimation.
     */
    static func size(width: CGFloat, height: CGFloat) -> MagiMotionAnimation {
        return .size(CGSize(width: width, height: height))
    }
    
    /**
     Animates a view's current shadow path to the given one.
     - Parameter path: A CGPath.
     - Returns: A MagiMotionAnimation.
     */
    static func shadow(path: CGPath) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.shadowPath = path
        }
    }
    
    /**
     Animates a view's current shadow color to the given one.
     - Parameter color: A UIColor.
     - Returns: A MagiMotionAnimation.
     */
    static func shadow(color: UIColor) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.shadowColor = color.cgColor
        }
    }
    
    /**
     Animates a view's current shadow offset to the given one.
     - Parameter offset: A CGSize.
     - Returns: A MagiMotionAnimation.
     */
    static func shadow(offset: CGSize) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.shadowOffset = offset
        }
    }
    
    /**
     Animates a view's current shadow opacity to the given one.
     - Parameter opacity: A Float.
     - Returns: A MagiMotionAnimation.
     */
    static func shadow(opacity: Float) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.shadowOpacity = opacity
        }
    }
    
    /**
     Animates a view's current shadow radius to the given one.
     - Parameter radius: A CGFloat.
     - Returns: A MagiMotionAnimation.
     */
    static func shadow(radius: CGFloat) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.shadowRadius = radius
        }
    }
    
    /**
     Animates the views shadow offset, opacity, and radius.
     - Parameter offset: A CGSize.
     - Parameter opacity: A Float.
     - Parameter radius: A CGFloat.
     */
    static func depth(offset: CGSize, opacity: Float, radius: CGFloat) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.shadowOffset = offset
            $0.shadowOpacity = opacity
            $0.shadowRadius = radius
        }
    }
    
    /**
     Animates the views shadow offset, opacity, and radius.
     - Parameter _ depth: A tuple (CGSize, FLoat, CGFloat).
     */
    static func depth(_ depth: (CGSize, Float, CGFloat)) -> MagiMotionAnimation {
        return .depth(offset: depth.0, opacity: depth.1, radius: depth.2)
    }
    
    /**
     Available in iOS 9+, animates a view using the spring API,
     given a stiffness and damping.
     - Parameter stiffness: A CGFlloat.
     - Parameter damping: A CGFloat.
     - Returns: A MagiMotionAnimation.
     */
    @available(iOS 9, *)
    static func spring(stiffness: CGFloat, damping: CGFloat) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.spring = (stiffness, damping)
        }
    }
    
    /**
     The duration of the view's animation. If a duration of 0 is used,
     the value will be converted to 0.01, to give a close to zero value.
     - Parameter _ duration: A TimeInterval.
     - Returns: A MagiMotionAnimation.
     */
    static func duration(_ duration: TimeInterval) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.duration = duration
        }
    }
    
    /**
     Delays the animation of a given view.
     - Parameter _ time: TimeInterval.
     - Returns: A MagiMotionAnimation.
     */
    static func delay(_ time: TimeInterval) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.delay = time
        }
    }
    
    /**
     Sets the view's timing function for the animation.
     - Parameter _ timingFunction: A CAMediaTimingFunction.
     - Returns: A MagiMotionAnimation.
     */
    static func timingFunction(_ timingFunction: CAMediaTimingFunction) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.timingFunction = timingFunction
        }
    }
    
    /**
     Creates a completion block handler that is executed once the animation
     is done.
     - Parameter _ execute: A callback to execute once completed.
     */
    static func completion(_ execute: @escaping () -> Void) -> MagiMotionAnimation {
        return MagiMotionAnimation {
            $0.completion = execute
        }
    }
}
