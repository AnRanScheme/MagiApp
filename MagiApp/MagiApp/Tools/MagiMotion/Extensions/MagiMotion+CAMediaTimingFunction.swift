//
//  MagiMotion+CAMediaTimingFunction.swift
//  MagicApp
//
//  Created by 安然 on 2018/5/31.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

public extension CAMediaTimingFunction {
    //  Default
    static let linear = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    static let easeIn = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    static let easeOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    static let easeInOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    
    //  Material
    static let standard = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
    static let deceleration = CAMediaTimingFunction(controlPoints: 0.0, 0.0, 0.2, 1)
    static let acceleration = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 1, 1)
    static let sharp = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.6, 1)
    
    // Easing.net
    
    
}
