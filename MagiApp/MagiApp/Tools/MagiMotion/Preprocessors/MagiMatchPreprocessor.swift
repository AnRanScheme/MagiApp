//
//  MagiMatchPreprocessor.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

class MagiMatchPreprocessor: MagiMotionCorePreprocessor {
    /**
     Processes the transitionary views.
     - Parameter fromViews: An Array of UIViews.
     - Parameter toViews: An Array of UIViews.
     */
    override func process(fromViews: [UIView], toViews: [UIView]) {
        for tv in toViews {
            guard let motionIdentifier = tv.motionIdentifier, let fv = context.sourceView(for: motionIdentifier) else {
                continue
            }
            
            var tvState = context[tv] ?? MagiMotionTargetState()
            var fvState = context[fv] ?? MagiMotionTargetState()
            
            // match is just a two-way source effect
            tvState.motionIdentifier = motionIdentifier
            fvState.motionIdentifier = motionIdentifier
            
            fvState.arc = tvState.arc
            fvState.duration = tvState.duration
            fvState.timingFunction = tvState.timingFunction
            fvState.delay = tvState.delay
            fvState.spring = tvState.spring
            
            let forceNonFade = tvState.nonFade || fvState.nonFade
            let isNonOpaque = !fv.isOpaque || fv.alpha < 1 || !tv.isOpaque || tv.alpha < 1
            
            if context.insertToViewFirst {
                fvState.opacity = 0
                
                if !forceNonFade && isNonOpaque {
                    tvState.opacity = 0
                    
                } else {
                    tvState.opacity = nil
                    
                    if !tv.layer.masksToBounds && tvState.displayShadow {
                        fvState.displayShadow = false
                    }
                }
                
            } else {
                tvState.opacity = 0
                
                if !forceNonFade && isNonOpaque {
                    // cross fade if from/toViews are not opaque
                    fvState.opacity = 0
                } else {
                    // no cross fade in this case, fromView is always displayed during the transition.
                    fvState.opacity = nil
                    
                    // we dont want two shadows showing up. Therefore we disable toView's shadow when fromView is able to display its shadow
                    if !fv.layer.masksToBounds && fvState.displayShadow {
                        tvState.displayShadow = false
                    }
                }
            }
            
            context[tv] = tvState
            context[fv] = fvState
        }
    }
}

