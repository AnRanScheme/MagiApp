//
//  MagiMotionSnapshotType.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/5.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

public enum MagiMotionSnapshotType {
    /**
     This setting will optimize for different types of views.
     For custom views or views with masking, .optimizedDefault might
     create snapshots that appear differently than the actual view.
     In that case, use .normal or .slowRender to disable the optimization.
     */
    case optimized
    
    /// snapshotView(afterScreenUpdates:)
    case normal
    
    /// layer.render(in: currentContext)
    case layerRender
    
    /**
     This setting will not create a snapshot. It will animate the view directly.
     This will mess up the view hierarchy, therefore, view controllers have to rebuild
     their view structure after the transition finishes.
     */
    case noSnapshot
}

