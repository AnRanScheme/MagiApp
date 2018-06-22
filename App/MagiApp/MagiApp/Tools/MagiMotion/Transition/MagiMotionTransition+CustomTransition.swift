//
//  MagiMotionTransition+CustomTransition.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

extension MagiMotionTransition {
    /**
     A helper transition function.
     - Parameter from: A UIViewController.
     - Parameter to: A UIViewController.
     - Parameter in view: A UIView.
     - Parameter completion: An optional completion handler.
     */
    public func transition(from: UIViewController, to: UIViewController, in view: UIView, completion: ((Bool) -> Void)? = nil) {
        guard !isTransitioning else {
            return
        }
        
        state = .notified
        isPresenting = true
        transitionContainer = view
        fromViewController = from
        toViewController = to
        
        completionCallback = { [weak self] in
            guard let `self` = self else {
                return
            }
            
            completion?($0)
            
            self.state = .possible
        }
        
        start()
    }
}

