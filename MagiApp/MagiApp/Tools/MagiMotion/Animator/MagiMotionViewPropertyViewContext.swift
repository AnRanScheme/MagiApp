//
//  MagiMotionViewPropertyViewContext.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

@available(iOS 10, tvOS 10, *)
internal class MagiMotionViewPropertyViewContext: MagiMotionAnimatorViewContext {
    /// A reference to the UIViewPropertyAnimator.
    fileprivate var viewPropertyAnimator: UIViewPropertyAnimator!
    
    /// Ending effect.
    fileprivate var endEffect: UIVisualEffect?
    
    /// Starting effect.
    fileprivate var startEffect: UIVisualEffect?
    
    override class func canAnimate(view: UIView, state: MagiMotionTargetState, isAppearing: Bool) -> Bool {
        return view is UIVisualEffectView && nil != state.opacity
    }
    
    override func resume(at progress: TimeInterval, isReversed: Bool) -> TimeInterval {
        guard let visualEffectView = snapshot as? UIVisualEffectView else {
            return 0
        }
        
        if isReversed {
            viewPropertyAnimator?.stopAnimation(false)
            viewPropertyAnimator?.finishAnimation(at: .current)
            viewPropertyAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
                guard let `self` = self else {
                    return
                }
                
                visualEffectView.effect = isReversed ? self.startEffect : self.endEffect
            }
        }
        
        viewPropertyAnimator.startAnimation()
        
        return duration
    }
    
    override func seek(to progress: TimeInterval) {
        viewPropertyAnimator?.pauseAnimation()
        viewPropertyAnimator?.fractionComplete = CGFloat(progress / duration)
    }
    
    override func clean() {
        super.clean()
        viewPropertyAnimator?.stopAnimation(false)
        viewPropertyAnimator?.finishAnimation(at: .current)
        viewPropertyAnimator = nil
    }
    
    override func startAnimations() -> TimeInterval {
        guard let visualEffectView = snapshot as? UIVisualEffectView else {
            return 0
        }
        
        let appearedEffect = visualEffectView.effect
        let disappearedEffect = 0 == targetState.opacity ? nil : visualEffectView.effect
        
        startEffect = isAppearing ? disappearedEffect : appearedEffect
        endEffect = isAppearing ? appearedEffect : disappearedEffect
        
        visualEffectView.effect = startEffect
        
        viewPropertyAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
            guard let `self` = self else {
                return
            }
            
            visualEffectView.effect = self.endEffect
        }
        
        viewPropertyAnimator.startAnimation()
        
        return duration
    }
}

