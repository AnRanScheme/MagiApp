//
//  MagiMotion+UIKit.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

fileprivate let parameterRegex = "(?:\\-?\\d+(\\.?\\d+)?)|\\w+"
fileprivate let transitionsRegex = "(\\w+)(?:\\(([^\\)]*)\\))?"

internal extension NSObject {
    /// Copies an object using NSKeyedArchiver.
    func copyWithArchiver() -> Any? {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self))!
    }
}

internal extension UIColor {
    /// A tuple of the rgba components.
    var components: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return (r, g, b, a)
    }
    
    /// The alpha component value.
    var alphaComponent: CGFloat {
        return components.a
    }
}

