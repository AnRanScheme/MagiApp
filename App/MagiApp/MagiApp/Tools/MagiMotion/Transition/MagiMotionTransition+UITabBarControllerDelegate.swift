//
//  MagiMotionTransition+UITabBarControllerDelegate.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

extension MagiMotionTransition: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if isTransitioning {
            cancel(isAnimated: false)
        }
        
        return true
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioning
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard !isTransitioning else {
            return nil
        }
        
        state = .notified
        
        let fromVCIndex = tabBarController.childViewControllers.index(of: fromVC)!
        let toVCIndex = tabBarController.childViewControllers.index(of: toVC)!
        
        isPresenting = toVCIndex > fromVCIndex
        fromViewController = fromViewController ?? fromVC
        toViewController = toViewController ?? toVC
        isTabBarController = true
        
        return self
    }
}


