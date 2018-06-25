//
//  MagiApplication.swift
//  MagiApp
//
//  Created by 安然 on 2018/6/25.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

public struct MagiApplication {
    
    public static var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    public static var rootViewController: UIViewController? {
        return keyWindow?.rootViewController
    }
    
    public static var isLandscape: Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape
    }
    
    public static var isPortrait: Bool {
        return !isLandscape
    }
    
    public static var orientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
    
    /// Retrieves the device status bar style.
    public static var statusBarStyle: UIStatusBarStyle {
        get {
            return UIApplication.shared.statusBarStyle
        }
        set(value) {
            UIApplication.shared.statusBarStyle = value
        }
    }
    
    /// Retrieves the device status bar hidden state.
    public static var isStatusBarHidden: Bool {
        get {
            return UIApplication.shared.isStatusBarHidden
        }
        set(value) {
            UIApplication.shared.isStatusBarHidden = value
        }
    }
    
    /**
     A boolean that indicates based on iPhone rules if the
     status bar should be shown.
     */
    public static var shouldStatusBarBeHidden: Bool {
        return isLandscape && .phone == Device.userInterfaceIdiom
    }
    
    /// A reference to the user interface layout direction.
    public static var userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        return UIApplication.shared.userInterfaceLayoutDirection
    }
    

}


