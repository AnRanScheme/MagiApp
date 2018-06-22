//
//  MagiMotionProgressRunner.swift
//  MagicApp
//
//  Created by 安然 on 2018/6/4.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

protocol MagiMotionProgressRunnerDelegate: class {
    func update(progress: TimeInterval)
    func complete(isFinishing: Bool)
}

class MagiMotionProgressRunner {
    
    weak var delegate: MagiMotionProgressRunnerDelegate?
    
    var isRunning: Bool {
        return displayLink != nil
    }
    
    internal var progress: TimeInterval = 0
    internal var duration: TimeInterval = 0
    internal var displayLink: CADisplayLink?
    internal var isReversed: Bool = false
    
    @objc
    func displayUpdate(_ link: CADisplayLink) {
        progress += isReversed ? -link.duration : link.duration
        
        if isReversed, progress <= 1.0/120.0 {
            delegate?.complete(isFinishing: false)
            stop()
            return
        }
        
        if !isReversed, progress > duration - 1.0/120.0 {
            delegate?.complete(isFinishing: true)
            stop()
            return
        }
        
        delegate?.update(progress: progress / duration)
    }
    
    func start(progress: TimeInterval, duration: TimeInterval, isReversed: Bool) {
        stop()
        self.progress = progress
        self.duration = duration
        self.isReversed = isReversed
        
        displayLink = CADisplayLink(target: self,
                                    selector: #selector(displayUpdate(_:)))
        
        displayLink?.add(to: RunLoop.main,
                         forMode: RunLoopMode(rawValue: RunLoopMode.commonModes.rawValue))
        
    }
    
    func stop() {
        displayLink?.isPaused = true
        displayLink?.remove(from: RunLoop.main,
                            forMode: RunLoopMode(rawValue: RunLoopMode.commonModes.rawValue))
        displayLink?.invalidate()
        displayLink = nil
    }
    
    
}
