//
//  MagiNavigationController.swift
//  MagicApp
//
//  Created by 安然 on 2017/11/3.
//  Copyright © 2017年 MacBook. All rights reserved.
//

import UIKit

class MagiNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        var title : String?
        
        if childViewControllers.count > 0 {
            title = "返回"
            if childViewControllers.count == 1 {
                title = childViewControllers.first?.title
            }
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(setHighlightedImg:"navigationbar_back_withtext",
                                                                              title: title,
                                                                              target: self,
                                                                              action: #selector(popVC))
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc fileprivate func popVC() {
        popViewController(animated:true)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return childViewControllers.count != 1
    }

}
