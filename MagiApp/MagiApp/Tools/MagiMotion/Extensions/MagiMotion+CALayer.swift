//
//  MagiMotion+CALayer.swift
//  MagicApp
//
//  Created by 安然 on 2018/5/31.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

@available(iOS 10, *)
extension CALayer: CAAnimationDelegate {}

internal extension CALayer {
    /// Swizzle the `add(_:forKey:) selector.
    /// 置换方法
    internal static var motionAddedAnimations: [(CALayer, String, CAAnimation)]? = {
        let swizzling: (AnyClass, Selector, Selector) -> Void = { forClass, originalSelector, swizzledSelector in
            if let originalMethod = class_getInstanceMethod(forClass, originalSelector),
               let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector) {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }

        swizzling(CALayer.self,
                  #selector(add(_:forKey:)),
                  #selector(motionAdd(anim:forKey:)))
        
        return nil
    }()
    
    @objc
    dynamic func motionAdd(anim: CAAnimation, forKey: String?) {
        if nil == CALayer.motionAddedAnimations {
            motionAdd(anim: anim, forKey: forKey)
        } else {
            let copiedAnim = anim.copy() as! CAAnimation
            copiedAnim.delegate = nil // having delegate resulted some weird animation behavior
            CALayer.motionAddedAnimations?.append((self, forKey!, copiedAnim))
        }
    }
    
    /// Retrieves all currently running animations for the layer.
    var animations: [(String, CAAnimation)] {
        guard let keys = animationKeys() else {
            return []
        }
        
        return keys.map {
            return ($0, self.animation(forKey: $0)!.copy() as! CAAnimation)
        }
    }
    
    /**
     Concats transforms and returns the result.
     - Parameters layer: A CALayer.
     - Returns: A CATransform3D.
     */
    func flatTransformTo(layer: CALayer) -> CATransform3D {
        var l = layer
        var t = l.transform
        
        while let sl = l.superlayer, self != sl {
            t = CATransform3DConcat(sl.transform, t)
            l = sl
        }
        
        return t
    }
    
    /// Removes all Motion animations.
    func removeAllMotionAnimations() {
        guard let keys = animationKeys() else {
            return
        }
        
        for animationKey in keys where animationKey.hasPrefix("motion.") {
            removeAnimation(forKey: animationKey)
        }
    }
}

public extension CALayer {
    /**
     A function that accepts CAAnimation objects and executes them on the
     view's backing layer.
     - Parameter animation: A CAAnimation instance.
     */
    func animate(_ animations: CAAnimation...) {
        animate(animations)
    }
    
    /**
     A function that accepts CAAnimation objects and executes them on the
     view's backing layer.
     - Parameter animation: A CAAnimation instance.
     */
    func animate(_ animations: [CAAnimation]) {
        for animation in animations {
            if nil == animation.delegate {
                animation.delegate = self
            }
            
            if let a = animation as? CABasicAnimation {
                a.fromValue = (presentation() ?? self).value(forKeyPath: a.keyPath!)
            }
            
            if let a = animation as? CAPropertyAnimation {
                add(a, forKey: a.keyPath!)
            } else if let a = animation as? CAAnimationGroup {
                add(a, forKey: nil)
            } else if let a = animation as? CATransition {
                add(a, forKey: kCATransition)
            }
        }
    }
    
    /**
     Executed when an animation has started.
     - Parameter _ anim: A CAAnimation.
     */
    func animationDidStart(_ anim: CAAnimation) {}
    
    /**
     A delegation function that is executed when the backing layer stops
     running an animation.
     - Parameter animation: The CAAnimation instance that stopped running.
     - Parameter flag: A boolean that indicates if the animation stopped
     because it was completed or interrupted. True if completed, false
     if interrupted.
     */
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let a = anim as? CAPropertyAnimation else {
            if let a = (anim as? CAAnimationGroup)?.animations {
                for x in a {
                    animationDidStop(x, finished: true)
                }
            }
            return
        }
        
        guard let b = a as? CABasicAnimation else {
            return
        }
        
        guard let v = b.toValue else {
            return
        }
        
        guard let k = b.keyPath else {
            return
        }
        
        setValue(v, forKeyPath: k)
        removeAnimation(forKey: k)
    }
    
    /**
     A function that accepts a list of MotionAnimation values and executes them.
     - Parameter animations: A list of MotionAnimation values.
     */
    func animate(_ animations: MagiMotionAnimation...) {
        animate(animations)
    }
    
    /**
     A function that accepts an Array of MotionAnimation values and executes them.
     - Parameter animations: An Array of MotionAnimation values.
     - Parameter completion: An optional completion block.
     */
    func animate(_ animations: [MagiMotionAnimation], completion: (() -> Void)? = nil) {
        startAnimations(animations, completion: completion)
    }
}

fileprivate extension CALayer {
    /**
     A function that executes an Array of MotionAnimation values.
     - Parameter _ animations: An Array of MotionAnimations.
     - Parameter completion: An optional completion block.
     */
    func startAnimations(_ animations: [MagiMotionAnimation], completion: (() -> Void)? = nil) {
        let ts = MagiMotionAnimationState(animations: animations)
        
        MagiMotion.delay(ts.delay) { [weak self,
            ts = ts,
            completion = completion] in
            
            guard let `self` = self else {
                return
            }
            
            var anims = [CABasicAnimation]()
            var duration = 0 == ts.duration ? 0.01 : ts.duration
            
            if let v = ts.backgroundColor {
                let a = MagiMotionCAAnimation.background(color: UIColor(cgColor: v))
                a.fromValue = self.backgroundColor
                anims.append(a)
            }
            
            if let v = ts.borderColor {
                let a = MagiMotionCAAnimation.border(color: UIColor(cgColor: v))
                a.fromValue = self.borderColor
                anims.append(a)
            }
            
            if let v = ts.borderWidth {
                let a = MagiMotionCAAnimation.border(width: v)
                a.fromValue = NSNumber(floatLiteral: Double(self.borderWidth))
                anims.append(a)
            }
            
            if let v = ts.cornerRadius {
                let a = MagiMotionCAAnimation.corner(radius: v)
                a.fromValue = NSNumber(floatLiteral: Double(self.cornerRadius))
                anims.append(a)
            }
            
            if let v = ts.transform {
                let a = MagiMotionCAAnimation.transform(v)
                a.fromValue = NSValue(caTransform3D: self.transform)
                anims.append(a)
            }
            
            if let v = ts.spin {
                var a = MagiMotionCAAnimation.spin(x: v.x)
                a.fromValue = NSNumber(floatLiteral: 0)
                anims.append(a)
                
                a = MagiMotionCAAnimation.spin(y: v.y)
                a.fromValue = NSNumber(floatLiteral: 0)
                anims.append(a)
                
                a = MagiMotionCAAnimation.spin(z: v.z)
                a.fromValue = NSNumber(floatLiteral: 0)
                anims.append(a)
            }
            
            if let v = ts.position {
                let a = MagiMotionCAAnimation.position(v)
                a.fromValue = NSValue(cgPoint: self.position)
                anims.append(a)
            }
            
            if let v = ts.opacity {
                let a = MagiMotionCAAnimation.fade(v)
                a.fromValue = self.value(forKeyPath: MagiMotionAnimationKeyPath.opacity.rawValue) ?? NSNumber(floatLiteral: 1)
                anims.append(a)
            }
            
            if let v = ts.zPosition {
                let a = MagiMotionCAAnimation.zPosition(v)
                a.fromValue = self.value(forKeyPath: MagiMotionAnimationKeyPath.zPosition.rawValue) ?? NSNumber(floatLiteral: 0)
                anims.append(a)
            }
            
            if let v = ts.size {
                let a = MagiMotionCAAnimation.size(v)
                a.fromValue = NSValue(cgSize: self.bounds.size)
                anims.append(a)
            }
            
            if let v = ts.shadowPath {
                let a = MagiMotionCAAnimation.shadow(path: v)
                a.fromValue = self.shadowPath
                anims.append(a)
            }
            
            if let v = ts.shadowColor {
                let a = MagiMotionCAAnimation.shadow(color: UIColor(cgColor: v))
                a.fromValue = self.shadowColor
                anims.append(a)
            }
            
            if let v = ts.shadowOffset {
                let a = MagiMotionCAAnimation.shadow(offset: v)
                a.fromValue = NSValue(cgSize: self.shadowOffset)
                anims.append(a)
            }
            
            if let v = ts.shadowOpacity {
                let a = MagiMotionCAAnimation.shadow(opacity: v)
                a.fromValue = NSNumber(floatLiteral: Double(self.shadowOpacity))
                anims.append(a)
            }
            
            if let v = ts.shadowRadius {
                let a = MagiMotionCAAnimation.shadow(radius: v)
                a.fromValue = NSNumber(floatLiteral: Double(self.shadowRadius))
                anims.append(a)
            }
            
            if #available(iOS 9.0, *), let (stiffness, damping) = ts.spring {
                for i in 0..<anims.count where nil != anims[i].keyPath {
                    let v = anims[i]
                    
                    guard "cornerRadius" != v.keyPath else {
                        continue
                    }
                    
                    let a = MagiMotionCAAnimation.convert(animation: v, stiffness: stiffness, damping: damping)
                    anims[i] = a
                    
                    if a.settlingDuration > duration {
                        duration = a.settlingDuration
                    }
                }
            }
            
            let g = MagiMotion.animate(group: anims, duration: duration)
            g.fillMode = MagiMotionAnimationFillModeToValue(mode: .both)
            g.isRemovedOnCompletion = false
            g.timingFunction = ts.timingFunction
            
            self.animate(g)
            
            if let v = ts.completion {
                MagiMotion.delay(duration, execute: v)
            }
            
            if let v = completion {
                MagiMotion.delay(duration, execute: v)
            }
        }
    }
}
