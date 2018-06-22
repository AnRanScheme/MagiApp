//
//  MagiIgnoreSubviewModifiersPreprocessor.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

class MagiIgnoreSubviewTransitionsPreprocessor: MagiMotionCorePreprocessor {
    /**
     Processes the transitionary views.
     - Parameter fromViews: An Array of UIViews.
     - Parameter toViews: An Array of UIViews.
     */
    override func process(fromViews: [UIView], toViews: [UIView]) {
        process(views: fromViews)
        process(views: toViews)
    }
    
    /**
     Process an Array of views for the cascade animation.
     - Parameter views: An Array of UIViews.
     */
    func process(views: [UIView]) {
        for v in views {
            guard let recursive = context[v]?.ignoreSubviewTransitions else {
                continue
            }
            
            var parentView = v
            
            if v is UITableView, let wrapperView = v.subviews.get(0) {
                parentView = wrapperView
            }
            
            guard recursive else {
                for subview in parentView.subviews {
                    context[subview] = nil
                }
                
                continue
            }
            
            cleanSubviewModifiers(for: parentView)
        }
    }
}

fileprivate extension MagiIgnoreSubviewTransitionsPreprocessor {
    /**
     Clears the modifiers for a given view's subviews.
     - Parameter for view: A UIView.
     */
    func cleanSubviewModifiers(for view: UIView) {
        for v in view.subviews {
            context[v] = nil
            cleanSubviewModifiers(for: v)
        }
    }
}
