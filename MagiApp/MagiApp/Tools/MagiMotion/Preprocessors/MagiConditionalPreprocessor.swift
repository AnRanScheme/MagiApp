//
//  MagiConditionalPreprocessor.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

public struct MagiMotionConditionalContext {
    
    internal weak var motion: MagiMotionTransition!
    public weak var view: UIView!
    
    public private(set) var isAppearing: Bool
    
    public var isPresenting: Bool {
        return motion.isPresenting
    }
    
    public var isTabBarController: Bool {
        return motion.isTabBarController
    }
    
    public var isNavigationController: Bool {
        return motion.isNavigationController
    }
    
    public var isMatched: Bool {
        return nil != matchedView
    }
    
    public var isAncestorViewMatched: Bool {
        return nil != matchedAncestorView
    }
    
    public var matchedView: UIView? {
        return motion.context.pairedView(for: view)
    }
    
    public var matchedAncestorView: (UIView, UIView)? {
        var current = view.superview
        
        while let ancestor = current, ancestor != motion.context.container {
            if let pairedView = motion.context.pairedView(for: ancestor) {
                return (ancestor, pairedView)
            }
            
            current = ancestor.superview
        }
        
        return nil
    }
    
    public var fromViewController: UIViewController {
        return motion.fromViewController!
    }
    
    public var toViewController: UIViewController {
        return motion.toViewController!
    }
    
    public var currentViewController: UIViewController {
        return isAppearing ? toViewController : fromViewController
    }
    
    public var otherViewController: UIViewController {
        return isAppearing ? fromViewController : toViewController
    }
}

class MagiConditionalPreprocessor: MagiMotionCorePreprocessor {
    override func process(fromViews: [UIView], toViews: [UIView]) {
        process(views: fromViews, isAppearing: false)
        process(views: toViews, isAppearing: true)
    }
    
    func process(views: [UIView], isAppearing: Bool) {
        for v in views {
            guard let conditionalModifiers = context[v]?.conditionalModifiers else {
                continue
            }
            
            for (condition, modifiers) in conditionalModifiers {
                if condition(MagiMotionConditionalContext(motion: motion, view: v, isAppearing: isAppearing)) {
                    context[v]!.append(contentsOf: modifiers)
                }
            }
        }
    }
}


