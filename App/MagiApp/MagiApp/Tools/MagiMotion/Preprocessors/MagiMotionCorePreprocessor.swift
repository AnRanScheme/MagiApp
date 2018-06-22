//
//  MagiMotionCorePreprocessor.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

class MagiMotionCorePreprocessor: MagiMotionPreprocessor {
    weak public var motion: MagiMotionTransition!
    
    /// A reference to the MotionContext.
    public var context: MagiMotionContext! {
        return motion!.context
    }
    
    func process(fromViews: [UIView], toViews: [UIView]) {}
}

