//
//  MagiTransitionPreprocessor.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

public enum MagiMotionTransitionAnimationType {
    
    public enum Direction {
        case left
        case right
        case up
        case down
    }
    
    case none
    case auto
    case push(direction: Direction)
    case pull(direction: Direction)
    case cover(direction: Direction)
    case uncover(direction: Direction)
    case slide(direction: Direction)
    case zoomSlide(direction: Direction)
    case pageIn(direction: Direction)
    case pageOut(direction: Direction)
    case fade
    case zoom
    case zoomOut
    
    /// 递归枚举 在枚举里面使用枚举值   作用确定枚举的具体数值
    indirect case selectBy(presenting: MagiMotionTransitionAnimationType, dismissing: MagiMotionTransitionAnimationType)
    
    ///  Sets the presenting and dismissing modifiers.
    ///
    /// - Parameter presenting: A MagiMotionTransitionAnimationType.
    /// - Returns: A MagiMotionTransitionAnimationType.
    public static func autoReverse(presenting: MagiMotionTransitionAnimationType) -> MagiMotionTransitionAnimationType {
        return .selectBy(presenting: presenting, dismissing: presenting.reversed())
    }
    
    /// Returns a reversal transition.
    func reversed() -> MagiMotionTransitionAnimationType {
        switch self {
        case .push(direction: .up):
            return .pull(direction: .down)
            
        case .push(direction: .right):
            return .pull(direction: .left)
            
        case .push(direction: .down):
            return .pull(direction: .up)
            
        case .push(direction: .left):
            return .pull(direction: .right)
            
        case .pull(direction: .up):
            return .push(direction: .down)
            
        case .pull(direction: .right):
            return .push(direction: .left)
            
        case .pull(direction: .down):
            return .push(direction: .up)
            
        case .pull(direction: .left):
            return .push(direction: .right)
            
        case .cover(direction: .up):
            return .uncover(direction: .down)
            
        case .cover(direction: .right):
            return .uncover(direction: .left)
            
        case .cover(direction: .down):
            return .uncover(direction: .up)
            
        case .cover(direction: .left):
            return .uncover(direction: .right)
            
        case .uncover(direction: .up):
            return .cover(direction: .down)
            
        case .uncover(direction: .right):
            return .cover(direction: .left)
            
        case .uncover(direction: .down):
            return .cover(direction: .up)
            
        case .uncover(direction: .left):
            return .cover(direction: .right)
            
        case .slide(direction: .up):
            return .slide(direction: .down)
            
        case .slide(direction: .down):
            return .slide(direction: .up)
            
        case .slide(direction: .left):
            return .slide(direction: .right)
            
        case .slide(direction: .right):
            return .slide(direction: .left)
            
        case .zoomSlide(direction: .up):
            return .zoomSlide(direction: .down)
            
        case .zoomSlide(direction: .down):
            return .zoomSlide(direction: .up)
            
        case .zoomSlide(direction: .left):
            return .zoomSlide(direction: .right)
            
        case .zoomSlide(direction: .right):
            return .zoomSlide(direction: .left)
            
        case .pageIn(direction: .up):
            return .pageOut(direction: .down)
            
        case .pageIn(direction: .right):
            return .pageOut(direction: .left)
            
        case .pageIn(direction: .down):
            return .pageOut(direction: .up)
            
        case .pageIn(direction: .left):
            return .pageOut(direction: .right)
            
        case .pageOut(direction: .up):
            return .pageIn(direction: .down)
            
        case .pageOut(direction: .right):
            return .pageIn(direction: .left)
            
        case .pageOut(direction: .down):
            return .pageIn(direction: .up)
            
        case .pageOut(direction: .left):
            return .pageIn(direction: .right)
            
        case .zoom:
            return .zoomOut
            
        case .zoomOut:
            return .zoom
            
        default:
            return self
        }
    }

}

class MagiTransitionPreprocessor: MagiMotionCorePreprocessor {
    /**
     Processes the transitionary views.
     - Parameter fromViews: An Array of UIViews.
     - Parameter toViews: An Array of UIViews.
     */
    override func process(fromViews: [UIView], toViews: [UIView]) {
        guard let m = motion else {
            return
        }
        
        guard let tv = m.toView else {
            return
        }
        
        guard let fv = m.fromView else {
            return
        }
        
        var defaultAnimation = m.defaultAnimation
        let isNavigationController = m.isNavigationController
        let isTabBarController = m.isTabBarController
        let toViewController = m.toViewController
        let fromViewController = m.fromViewController
        let isPresenting = m.isPresenting
        let fromOverFullScreen = m.fromOverFullScreen
        let toOverFullScreen = m.toOverFullScreen
        let animators = m.animators
        
        if case .auto = defaultAnimation {
            if isNavigationController, let navAnim = toViewController?.navigationController?.motionNavigationTransitionType {
                defaultAnimation = navAnim
                
            } else if isTabBarController, let tabAnim = toViewController?.tabBarController?.motionTabBarTransitionType {
                defaultAnimation = tabAnim
                
            } else if let modalAnim = (isPresenting ? toViewController : fromViewController)?.motionTransitionType {
                defaultAnimation = modalAnim
            }
        }
        
        if case .selectBy(let presentAnim, let dismissAnim) = defaultAnimation {
            defaultAnimation = isPresenting ? presentAnim : dismissAnim
        }
        
        if case .auto = defaultAnimation {
            if animators.contains(where: {
                $0.canAnimate(view: tv, isAppearing: true) || $0.canAnimate(view: fv, isAppearing: false)
            }) {
                defaultAnimation = .none
                
            } else if isNavigationController {
                defaultAnimation = isPresenting ? .push(direction: .left) : .pull(direction: .right)
                
            } else if isTabBarController {
                defaultAnimation = isPresenting ? .slide(direction: .left) : .slide(direction: .right)
                
            } else {
                defaultAnimation = .fade
            }
        }
        
        if case .none = defaultAnimation {
            return
        }
        
        context[fv] = [.timingFunction(.standard), .duration(0.35)]
        context[tv] = [.timingFunction(.standard), .duration(0.35)]
        
        let shadowState: [MagiMotionModifier] = [.shadow(opacity: 0.5),
                                             .shadow(color: .black),
                                             .shadow(radius: 5),
                                             .shadow(offset: .zero),
                                             .masksToBounds(false)]
        
        switch defaultAnimation {
        case .push(let direction):
            context.insertToViewFirst = false
            
            context[tv]!.append(contentsOf: [.translate(shift(direction: direction, isAppearing: true)),
                                             .shadow(opacity: 0),
                                             .beginWith(modifiers: shadowState),
                                             .timingFunction(.deceleration)])
            
            context[fv]!.append(contentsOf: [.translate(shift(direction: direction, isAppearing: false) / 3),
                                             .overlay(color: .black, opacity: 0.1),
                                             .timingFunction(.deceleration)])
            
        case .pull(let direction):
            context.insertToViewFirst = true
            
            context[fv]!.append(contentsOf: [.translate(shift(direction: direction, isAppearing: false)),
                                             .shadow(opacity: 0),
                                             .beginWith(modifiers: shadowState)])
            
            context[tv]!.append(contentsOf: [.translate(shift(direction: direction, isAppearing: true) / 3),
                                             .overlay(color: .black, opacity: 0.1)])
            
        case .slide(let direction):
            context[fv]!.append(contentsOf: [.translate(shift(direction: direction, isAppearing: false))])
            
            context[tv]!.append(contentsOf: [.translate(shift(direction: direction, isAppearing: true))])
            
        case .zoomSlide(let direction):
            context[fv]!.append(contentsOf: [.translate(shift(direction: direction, isAppearing: false)), .scale(0.8)])
            
            context[tv]!.append(contentsOf: [.translate(shift(direction: direction, isAppearing: true)), .scale(0.8)])
            
        case .cover(let direction):
            context.insertToViewFirst = false
            
            context[tv]!.append(contentsOf: [.translate(shift(direction: direction, isAppearing: true)),
                                             .shadow(opacity: 0),
                                             .beginWith(modifiers: shadowState),
                                             .timingFunction(.deceleration)])
            
            context[fv]!.append(contentsOf: [.overlay(color: .black, opacity: 0.1),
                                             .timingFunction(.deceleration)])
            
        case .uncover(let direction):
            context.insertToViewFirst = true
            
            context[fv]!.append(contentsOf: [.translate(shift(direction: direction, isAppearing: false)),
                                             .shadow(opacity: 0),
                                             .beginWith(modifiers: shadowState)])
            
            context[tv]!.append(contentsOf: [.overlay(color: .black, opacity: 0.1)])
            
        case .pageIn(let direction):
            context.insertToViewFirst = false
            
            context[tv]!.append(contentsOf: [.translate(shift(direction: direction, isAppearing: true)),
                                             .shadow(opacity: 0),
                                             .beginWith(modifiers: shadowState),
                                             .timingFunction(.deceleration)])
            
            context[fv]!.append(contentsOf: [.scale(0.7),
                                             .overlay(color: .black, opacity: 0.1),
                                             .timingFunction(.deceleration)])
            
        case .pageOut(let direction):
            context.insertToViewFirst = true
            
            context[fv]!.append(contentsOf: [.translate(shift(direction: direction, isAppearing: false)),
                                             .shadow(opacity: 0),
                                             .beginWith(modifiers: shadowState)])
            
            context[tv]!.append(contentsOf: [.scale(0.7),
                                             .overlay(color: .black, opacity: 0.1)])
            
        case .fade:
            // TODO: clean up this. overFullScreen logic shouldn't be here
            if !(fromOverFullScreen && !isPresenting) {
                context[tv] = [.fadeOut]
            }
            
            #if os(tvOS)
            context[fromView] = [.fade]
            #else
            if (!isPresenting && toOverFullScreen) || !fv.isOpaque || (fv.backgroundColor?.alphaComponent ?? 1) < 1 {
                context[fv] = [.fadeOut]
            }
            #endif
            
            context[tv]!.append(.durationMatchLongest)
            context[fv]!.append(.durationMatchLongest)
            
        case .zoom:
            context.insertToViewFirst = true
            
            context[fv]!.append(contentsOf: [.scale(1.3), .fadeOut])
            context[tv]!.append(contentsOf: [.scale(0.7)])
            
        case .zoomOut:
            context.insertToViewFirst = false
            
            context[tv]!.append(contentsOf: [.scale(1.3), .fadeOut])
            context[fv]!.append(contentsOf: [.scale(0.7)])
            
        default:
            fatalError("Not implemented")
        }
    }
    
    /**
     Shifts the transition by a given size.
     - Parameter direction: A MotionTransitionAnimationType.Direction.
     - Parameter isAppearing: A boolean indicating whether it is appearing
     or not.
     - Parameter size: An optional CGSize.
     - Parameter transpose: A boolean indicating to change the `x` point for `y`
     and `y` point for `x`.
     - Returns: A CGPoint.
     */
    func shift(direction: MagiMotionTransitionAnimationType.Direction, isAppearing: Bool, size: CGSize? = nil, transpose: Bool = false) -> CGPoint {
        let size = size ?? context.container.bounds.size
        let point: CGPoint
        
        switch direction {
        case .left, .right:
            point = CGPoint(x: (.right == direction) == isAppearing ? -size.width : size.width, y: 0)
            
        case .up, .down:
            point = CGPoint(x: 0, y: (.down == direction) == isAppearing ? -size.height : size.height)
        }
        
        if transpose {
            return CGPoint(x: point.y, y: point.x)
        }
        
        return point
    }
}
