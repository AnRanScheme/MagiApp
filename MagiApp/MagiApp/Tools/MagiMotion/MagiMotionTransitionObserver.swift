//
//  MagiMotionTransitionObserver.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import Foundation

public protocol MagiMotionTargetStateObserver {

    /// Executed when the elapsed time changes during a transition.
    ///
    /// - Parameters:
    ///   - transitionObserver: A MotionTargetStateObserver.
    ///   - progress: A TimeInterval.
    func motion(transitionObserver: MagiMotionTargetStateObserver, didUpdateWith progress: TimeInterval)
}
