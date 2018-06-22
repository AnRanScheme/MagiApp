//
//  MagiMotionTransition+UINavigationControllerDelegate.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

extension MagiMotionTransition: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard !isTransitioning else {
            return nil
        }
        
        state = .notified
        isPresenting = .push == operation
        fromViewController = fromViewController ?? fromVC
        toViewController = toViewController ?? toVC
        isNavigationController = true
        
        return self 
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioning
    }
}

