//
//  MagiSourcePreprocessor.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

class MagiSourcePreprocessor: MagiMotionCorePreprocessor {
    /**
     Processes the transitionary views.
     - Parameter fromViews: An Array of UIViews.
     - Parameter toViews: An Array of UIViews.
     */
    override func process(fromViews: [UIView], toViews: [UIView]) {
        for fv in fromViews {
            guard let motionIdentifier = context[fv]?.motionIdentifier, let tv = context.destinationView(for: motionIdentifier) else {
                continue
            }
            
            prepare(view: fv, for: tv)
        }
        
        for tv in toViews {
            guard let motionIdentifier = context[tv]?.motionIdentifier, let fv = context.sourceView(for: motionIdentifier) else {
                continue
            }
            
            prepare(view: tv, for: fv)
        }
    }
}

fileprivate extension MagiSourcePreprocessor {
    /**
     Prepares a given view for a target view.
     - Parameter view: A UIView.
     - Parameter for targetView: A UIView.
     */
    func prepare(view: UIView, for targetView: UIView) {
        let targetPos = context.container.convert(targetView.layer.position, from: targetView.superview!)
        let targetTransform = context.container.layer.flatTransformTo(layer: targetView.layer)
        
        var state = context[view]!
        
        /**
         Use global coordinate space since over target position is
         converted from the global container
         */
        state.coordinateSpace = .global
        
        state.position = targetPos
        state.transform = targetTransform
        
        // Remove incompatible options.
        state.size = nil
        
        if view.bounds.size != targetView.bounds.size {
            state.size = targetView.bounds.size
        }
        
        if view.layer.cornerRadius != targetView.layer.cornerRadius {
            state.cornerRadius = targetView.layer.cornerRadius
        }
        
        if view.layer.shadowColor != targetView.layer.shadowColor {
            state.shadowColor = targetView.layer.shadowColor
        }
        
        if view.layer.shadowOpacity != targetView.layer.shadowOpacity {
            state.shadowOpacity = targetView.layer.shadowOpacity
        }
        
        if view.layer.shadowOffset != targetView.layer.shadowOffset {
            state.shadowOffset = targetView.layer.shadowOffset
        }
        
        if view.layer.shadowRadius != targetView.layer.shadowRadius {
            state.shadowRadius = targetView.layer.shadowRadius
        }
        
        if view.layer.shadowPath != targetView.layer.shadowPath {
            state.shadowPath = targetView.layer.shadowPath
        }
        
        if view.layer.contentsRect != targetView.layer.contentsRect {
            state.contentsRect = targetView.layer.contentsRect
        }
        
        if view.layer.contentsScale != targetView.layer.contentsScale {
            state.contentsScale = targetView.layer.contentsScale
        }
        
        context[view] = state
    }
}
