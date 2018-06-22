//
//  MagiMagiMotionModifier.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

public final class MagiMotionModifier {
    /// A reference to the callback that applies the MagiMotionModifier.
    internal let apply: (inout MagiMotionTargetState) -> Void
    
    /**
     An initializer that accepts a given callback.
     - Parameter applyFunction: A given callback.
     */
    public init(applyFunction: @escaping (inout MagiMotionTargetState) -> Void) {
        apply = applyFunction
    }
}

public extension MagiMotionModifier {
    /**
     Animates the view with a matching motion identifier.
     - Parameter _ motionIdentifier: A String.
     - Returns: A MagiMotionModifier.
     */
    static func source(_ motionIdentifier: String) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.motionIdentifier = motionIdentifier
        }
    }
    
    /**
     Animates the view's current masksToBounds to the
     given masksToBounds.
     - Parameter masksToBounds: A boolean value indicating the
     masksToBounds state.
     - Returns: A MagiMotionModifier.
     */
    static func masksToBounds(_ masksToBounds: Bool) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.masksToBounds = masksToBounds
        }
    }
    
    /**
     Animates the view's current background color to the
     given color.
     - Parameter color: A UIColor.
     - Returns: A MagiMotionModifier.
     */
    static func background(color: UIColor) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.backgroundColor = color.cgColor
        }
    }
    
    /**
     Animates the view's current border color to the
     given color.
     - Parameter color: A UIColor.
     - Returns: A MagiMotionModifier.
     */
    static func border(color: UIColor) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.borderColor = color.cgColor
        }
    }
    
    /**
     Animates the view's current border width to the
     given width.
     - Parameter width: A CGFloat.
     - Returns: A MagiMotionModifier.
     */
    static func border(width: CGFloat) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.borderWidth = width
        }
    }
    
    /**
     Animates the view's current corner radius to the
     given radius.
     - Parameter radius: A CGFloat.
     - Returns: A MagiMotionModifier.
     */
    static func corner(radius: CGFloat) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.cornerRadius = radius
        }
    }
    
    /**
     Animates the view's current transform (perspective, scale, rotate)
     to the given one.
     - Parameter _ transform: A CATransform3D.
     - Returns: A MagiMotionModifier.
     */
    static func transform(_ transform: CATransform3D) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.transform = transform
        }
    }
    
    /**
     Animates the view's current perspective to the given one through
     a CATransform3D object.
     - Parameter _ perspective: A CGFloat.
     - Returns: A MagiMotionModifier.
     */
    static func perspective(_ perspective: CGFloat) -> MagiMotionModifier {
        return MagiMotionModifier {
            var t = $0.transform ?? CATransform3DIdentity
            t.m34 = 1 / -perspective
            $0.transform = t
        }
    }
    
    /**
     Animates the view's current rotate to the given x, y,
     and z values.
     - Parameter x: A CGFloat.
     - Parameter y: A CGFloat.
     - Parameter z: A CGFloat.
     - Returns: A MagiMotionModifier.
     */
    static func rotate(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.transform = CATransform3DRotate($0.transform ?? CATransform3DIdentity, x, 1, 0, 0)
            $0.transform = CATransform3DRotate($0.transform!, y, 0, 1, 0)
            $0.transform = CATransform3DRotate($0.transform!, z, 0, 0, 1)
        }
    }
    
    /**
     Animates the view's current rotate to the given point.
     - Parameter _ point: A CGPoint.
     - Parameter z: A CGFloat, default is 0.
     - Returns: A MagiMotionModifier.
     */
    static func rotate(_ point: CGPoint, z: CGFloat = 0) -> MagiMotionModifier {
        return .rotate(x: point.x, y: point.y, z: z)
    }
    
    /**
     Rotate 2d.
     - Parameter _ z: A CGFloat.
     - Returns: A MagiMotionModifier.
     */
    static func rotate(_ z: CGFloat) -> MagiMotionModifier {
        return .rotate(z: z)
    }
    
    /**
     Animates the view's current scale to the given x, y, z scale values.
     - Parameter x: A CGFloat.
     - Parameter y: A CGFloat.
     - Parameter z: A CGFloat.
     - Returns: A MagiMotionModifier.
     */
    static func scale(x: CGFloat = 1, y: CGFloat = 1, z: CGFloat = 1) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.transform = CATransform3DScale($0.transform ?? CATransform3DIdentity, x, y, z)
        }
    }
    
    /**
     Animates the view's current x & y scale to the given scale value.
     - Parameter _ xy: A CGFloat.
     - Returns: A MagiMotionModifier.
     */
    static func scale(_ xy: CGFloat) -> MagiMotionModifier {
        return .scale(x: xy, y: xy)
    }
    
    /**
     Animates the view's current translation to the given
     x, y, and z values.
     - Parameter x: A CGFloat.
     - Parameter y: A CGFloat.
     - Parameter z: A CGFloat.
     - Returns: A MagiMotionModifier.
     */
    static func translate(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.transform = CATransform3DTranslate($0.transform ?? CATransform3DIdentity, x, y, z)
        }
    }
    
    /**
     Animates the view's current translation to the given
     point value (x & y), and a z value.
     - Parameter _ point: A CGPoint.
     - Parameter z: A CGFloat, default is 0.
     - Returns: A MagiMotionModifier.
     */
    static func translate(_ point: CGPoint, z: CGFloat = 0) -> MagiMotionModifier {
        return .translate(x: point.x, y: point.y, z: z)
    }
    
    /**
     Animates the view's current position to the given point.
     - Parameter _ point: A CGPoint.
     - Returns: A MagiMotionModifier.
     */
    static func position(_ point: CGPoint) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.position = point
        }
    }
    
    /**
     Animates a view's current position to the given x and y values.
     - Parameter x: A CGloat.
     - Parameter y: A CGloat.
     - Returns: A MagiMotionModifier.
     */
    static func position(x: CGFloat, y: CGFloat) -> MagiMotionModifier {
        return .position(CGPoint(x: x, y: y))
    }
    
    /// Forces the view to not fade during a transition.
    static var forceNonFade = MagiMotionModifier {
        $0.nonFade = true
    }
    
    /// Fades the view in during a transition.
    static var fadeIn = MagiMotionModifier.fade(1)
    
    /// Fades the view out during a transition.
    static var fadeOut = MagiMotionModifier.fade(0)
    
    /**
     Animates the view's current opacity to the given one.
     - Parameter to opacity: A Double.
     - Returns: A MagiMotionModifier.
     */
    static func fade(_ opacity: Double) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.opacity = opacity
        }
    }
    
    /**
     Animates the view's current opacity to the given one.
     - Parameter _ opacity: A Double.
     - Returns: A MagiMotionModifier.
     */
    static func opacity(_ opacity: Double) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.opacity = opacity
        }
    }
    
    /**
     Animates the view's current zPosition to the given position.
     - Parameter _ position: An Int.
     - Returns: A MagiMotionModifier.
     */
    static func zPosition(_ position: CGFloat) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.zPosition = position
        }
    }
    
    /**
     Animates the view's current size to the given one.
     - Parameter _ size: A CGSize.
     - Returns: A MagiMotionModifier.
     */
    static func size(_ size: CGSize) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.size = size
        }
    }
    
    /**
     Animates the view's current size to the given width and height.
     - Parameter width: A CGFloat.
     - Parameter height: A CGFloat.
     - Returns: A MagiMotionModifier.
     */
    static func size(width: CGFloat, height: CGFloat) -> MagiMotionModifier {
        return .size(CGSize(width: width, height: height))
    }
    
    /**
     Animates the view's current shadow path to the given one.
     - Parameter path: A CGPath.
     - Returns: A MagiMotionModifier.
     */
    static func shadow(path: CGPath) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.shadowPath = path
        }
    }
    
    /**
     Animates the view's current shadow color to the given one.
     - Parameter color: A UIColor.
     - Returns: A MagiMotionModifier.
     */
    static func shadow(color: UIColor) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.shadowColor = color.cgColor
        }
    }
    
    /**
     Animates the view's current shadow offset to the given one.
     - Parameter offset: A CGSize.
     - Returns: A MagiMotionModifier.
     */
    static func shadow(offset: CGSize) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.shadowOffset = offset
        }
    }
    
    /**
     Animates the view's current shadow opacity to the given one.
     - Parameter opacity: A Float.
     - Returns: A MagiMotionModifier.
     */
    static func shadow(opacity: Float) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.shadowOpacity = opacity
        }
    }
    
    /**
     Animates the view's current shadow radius to the given one.
     - Parameter radius: A CGFloat.
     - Returns: A MagiMotionModifier.
     */
    static func shadow(radius: CGFloat) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.shadowRadius = radius
        }
    }
    
    /**
     Animates the view's contents rect to the given one.
     - Parameter rect: A CGRect.
     - Returns: A MagiMotionModifier.
     */
    static func contents(rect: CGRect) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.contentsRect = rect
        }
    }
    
    /**
     Animates the view's contents scale to the given one.
     - Parameter scale: A CGFloat.
     - Returns: A MagiMotionModifier.
     */
    static func contents(scale: CGFloat) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.contentsScale = scale
        }
    }
    
    /**
     The duration of the view's animation.
     - Parameter _ duration: A TimeInterval.
     - Returns: A MagiMotionModifier.
     */
    static func duration(_ duration: TimeInterval) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.duration = duration
        }
    }
    
    /**
     Sets the view's animation duration to the longest
     running animation within a transition.
     */
    static var durationMatchLongest = MagiMotionModifier {
        $0.duration = .infinity
    }
    
    /**
     Delays the animation of a given view.
     - Parameter _ time: TimeInterval.
     - Returns: A MagiMotionModifier.
     */
    static func delay(_ time: TimeInterval) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.delay = time
        }
    }
    
    /**
     Sets the view's timing function for the transition.
     - Parameter _ timingFunction: A CAMediaTimingFunction.
     - Returns: A MagiMotionModifier.
     */
    static func timingFunction(_ timingFunction: CAMediaTimingFunction) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.timingFunction = timingFunction
        }
    }
    
    /**
     Available in iOS 9+, animates a view using the spring API,
     given a stiffness and damping.
     - Parameter stiffness: A CGFlloat.
     - Parameter damping: A CGFloat.
     - Returns: A MagiMotionModifier.
     */
    @available(iOS 9, *)
    static func spring(stiffness: CGFloat, damping: CGFloat) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.spring = (stiffness, damping)
        }
    }
    
    /**
     Animates the natural curve of a view. A value of 1 represents
     a curve in a downward direction, and a value of -1
     represents a curve in an upward direction.
     - Parameter intensity: A CGFloat.
     - Returns: A MagiMotionModifier.
     */
    static func arc(intensity: CGFloat = 1) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.arc = intensity
        }
    }
    
    /**
     Animates subviews with an increasing delay between each animation.
     - Parameter delta: A TimeInterval.
     - Parameter direction: A CascadeDirection.
     - Parameter animationDelayedUntilMatchedViews: A boolean indicating whether
     or not to delay the subview animation until all have started.
     - Returns: A MagiMotionModifier.
     */
    static func cascade(delta: TimeInterval = 0.02, direction: CascadeDirection = .topToBottom, animationDelayedUntilMatchedViews: Bool = false) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.cascade = (delta, direction, animationDelayedUntilMatchedViews)
        }
    }
    
    /**
     Creates an overlay on the animating view with a given color and opacity.
     - Parameter color: A UIColor.
     - Parameter opacity: A CGFloat.
     - Returns: A MagiMotionModifier.
     */
    static func overlay(color: UIColor, opacity: CGFloat) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.overlay = (color.cgColor, opacity)
        }
    }
}

// conditional modifiers
public extension MagiMotionModifier {
    /**
     Apply modifiers when the condition is true.
     - Parameter _ condition: A MotionConditionalContext.
     - Returns: A Boolean.
     */
    static func when(_ condition: @escaping (MagiMotionConditionalContext) -> Bool, _ modifiers: [MagiMotionModifier]) -> MagiMotionModifier {
        
        return MagiMotionModifier {
            if nil == $0.conditionalModifiers {
                $0.conditionalModifiers = []
            }
            
            $0.conditionalModifiers!.append((condition, modifiers))
        }
    }
    
    static func when(_ condition: @escaping (MagiMotionConditionalContext) -> Bool, _ modifiers: MagiMotionModifier...) -> MagiMotionModifier {
        return .when(condition, modifiers)
    }
    
    /**
     Apply modifiers when matched.
     - Parameter _ modifiers: A list of modifiers.
     - Returns: A MagiMotionModifier.
     */
    static func whenMatched(_ modifiers: MagiMotionModifier...) -> MagiMotionModifier {
        return .when({ $0.isMatched }, modifiers)
    }
    
    /**
     Apply modifiers when presenting.
     - Parameter _ modifiers: A list of modifiers.
     - Returns: A MagiMotionModifier.
     */
    static func whenPresenting(_ modifiers: MagiMotionModifier...) -> MagiMotionModifier {
        return .when({ $0.isPresenting }, modifiers)
    }
    
    /**
     Apply modifiers when dismissing.
     - Parameter _ modifiers: A list of modifiers.
     - Returns: A MagiMotionModifier.
     */
    static func whenDismissing(_ modifiers: MagiMotionModifier...) -> MagiMotionModifier {
        return .when({ !$0.isPresenting }, modifiers)
    }
    
    /**
     Apply modifiers when appearingg.
     - Parameter _ modifiers: A list of modifiers.
     - Returns: A MagiMotionModifier.
     */
    static func whenAppearing(_ modifiers: MagiMotionModifier...) -> MagiMotionModifier {
        return .when({ $0.isAppearing }, modifiers)
    }
    
    /**
     Apply modifiers when disappearing.
     - Parameter _ modifiers: A list of modifiers.
     - Returns: A MagiMotionModifier.
     */
    static func whenDisappearing(_ modifiers: MagiMotionModifier...) -> MagiMotionModifier {
        return .when({ !$0.isAppearing }, modifiers)
    }
}

public extension MagiMotionModifier {
    /**
     Apply transitions directly to the view at the start of the transition.
     The transitions supplied here won't be animated.
     For source views, transitions are set directly at the begining of the animation.
     For destination views, they replace the target state (final appearance).
     */
    static func beginWith(_ modifiers: [MagiMotionModifier]) -> MagiMotionModifier {
        return MagiMotionModifier {
            if nil == $0.beginState {
                $0.beginState = []
            }
            
            $0.beginState?.append(contentsOf: modifiers)
        }
    }
    
    static func beginWith(modifiers: [MagiMotionModifier]) -> MagiMotionModifier {
        return .beginWith(modifiers)
    }
    
    static func beginWith(_ modifiers: MagiMotionModifier...) -> MagiMotionModifier {
        return .beginWith(modifiers)
    }
    
    /**
     Use global coordinate space.
     
     When using global coordinate space. The view becomes an independent view that is not
     a subview of any view. It won't move when its parent view moves, and won't be affected
     by parent view attributes.
     
     When a view is matched, this is automatically enabled.
     The `source` transition will also enable this.
     */
    static var useGlobalCoordinateSpace = MagiMotionModifier {
        $0.coordinateSpace = .global
    }
    
    /// Ignore all motion transition attributes for a view's direct subviews.
    static var ignoreSubviewTransitions: MagiMotionModifier = .ignoreSubviewTransitions()
    
    /**
     Ignore all motion transition attributes for a view's subviews.
     - Parameter recursive: If false, will only ignore direct subviews' transitions.
     default false.
     */
    static func ignoreSubviewTransitions(recursive: Bool = false) -> MagiMotionModifier {
        return MagiMotionModifier {
            $0.ignoreSubviewTransitions = recursive
        }
    }
    
    /**
     This will create a snapshot optimized for different view types.
     For custom views or views with masking, useOptimizedSnapshot might create snapshots
     that appear differently than the actual view.
     In that case, use .useNormalSnapshot or .useSlowRenderSnapshot to disable the optimization.
     
     This transition actually does nothing by itself since .useOptimizedSnapshot is the default.
     */
    static var useOptimizedSnapshot = MagiMotionModifier {
        $0.snapshotType = .optimized
    }
    
    /// Create a snapshot using snapshotView(afterScreenUpdates:).
    static var useNormalSnapshot = MagiMotionModifier {
        $0.snapshotType = .normal
    }
    
    /**
     Create a snapshot using layer.render(in: currentContext).
     This is slower than .useNormalSnapshot but gives more accurate snapshots for some views
     (eg. UIStackView).
     */
    static var useLayerRenderSnapshot = MagiMotionModifier {
        $0.snapshotType = .layerRender
    }
    
    /**
     Force Motion to not create any snapshots when animating this view.
     This will mess up the view hierarchy, therefore, view controllers have to rebuild
     their view structure after the transition finishes.
     */
    static var useNoSnapshot = MagiMotionModifier {
        $0.snapshotType = .noSnapshot
    }
    
    /**
     Force the view to animate (Motion will create animation contexts & snapshots for them, so
     that they can be interactive).
     */
    static var forceAnimate = MagiMotionModifier {
        $0.forceAnimate = true
    }
    
    /**
     Force Motion to use scale based size animation. This will convert all .size transitions into
     a .scale transition. This is to help Motion animate layers that doesn't support bounds animations.
     This also gives better performance.
     */
    static var useScaleBasedSizeChange = MagiMotionModifier {
        $0.useScaleBasedSizeChange = true
    }
}

