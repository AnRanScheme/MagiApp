//
//  MagiMotionPreprocessor.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

public protocol MagiMotionPreprocessor: class {
    
    /// A reference to Motion.
    var motion: MagiMotionTransition! { get set }
    
    /// Processes the transitionary views.
    ///
    /// - Parameters:
    ///   - fromViews: An Array of UIViews.
    ///   - toViews: An Array of UIViews.
    func process(fromViews: [UIView], toViews: [UIView])
    
}

