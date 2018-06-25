//
//  MagiScreen.swift
//  MagiApp
//
//  Created by 安然 on 2018/6/25.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

public struct MagiScreen {
    /// Retrieves the device bounds.
    public static var bounds: CGRect {
        return UIScreen.main.bounds
    }
    
    /// Retrieves the device width.
    public static var width: CGFloat {
        return bounds.width
    }
    
    /// Retrieves the device height.
    public static var height: CGFloat {
        return bounds.height
    }
    
    /// Retrieves the device scale.
    public static var scale: CGFloat {
        return UIScreen.main.scale
    }
}
