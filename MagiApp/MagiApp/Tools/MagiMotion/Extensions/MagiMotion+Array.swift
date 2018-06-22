//
//  MagiMotion+Array.swift
//  MagicApp
//
//  Created by 安然 on 2018/5/31.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

internal extension Array {
    /**
     Retrieves the element at the given index if it exists.
     - Parameter _ index: An Int.
     - Returns: An optional Element value.
     */
    func get(_ index: Int) -> Element? {
        if index < count {
            return self[index]
        }
        return nil
    }
}

