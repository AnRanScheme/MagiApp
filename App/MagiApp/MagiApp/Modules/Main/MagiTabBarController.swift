//
//  MagiTabBarController.swift
//  MagicApp
//
//  Created by 安然 on 2017/11/3.
//  Copyright © 2017年 MacBook. All rights reserved.
//

import UIKit

class MagiTabBarController: UITabBarController {
    
    
    // MARK: - 系统方法

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocationData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 自定义方法
    
    private func loadLocationData() {
        
        guard let jsonPath = Bundle.main.path(forResource: "tapMenu.json",
                                              ofType: nil)
            else { return }
      
        guard let jsonData = NSData(contentsOfFile: jsonPath)
            else { return }
        
        guard let json = try? JSONSerialization.jsonObject(with: jsonData as Data,
                                                           options: .mutableContainers)
            else { return }
        
        let anyObject = json as AnyObject
        
        guard let dict = anyObject as? [String: Any] else { return }
        
        guard let dictArray = dict["tabbar_items"] as? [[String : Any]] else { return }
        
        for dict in dictArray {
            
            guard let vcName = dict["page"] as? String else { continue }
            guard let title = dict["title"] as? String else { continue }
            guard let imageName = dict["normal_icon"] as? String else { continue }
            
            addChildVIewController(vcName: vcName,
                                   title: title,
                                   imageName: imageName)
            
        }
    }
    
    private func addChildVIewController(vcName: String, title: String, imageName: String) {
        
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        
        let clsName = namespace + "." + vcName
        
        let cls = NSClassFromString(clsName) as! UIViewController.Type
        
        let vc = cls.init()

        if vcName == "CenterViewController" {
            
            let navVC = MagiNavigationController(rootViewController: vc)
            
            let menuVC = SideMenuViewController()
            menuVC.centerViewController = vc as? CenterViewController
            let containerVC = ContainerViewController(sideMenu: menuVC,
                                                      center: navVC)
            containerVC.title = title
            
            containerVC.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.black],
                                                 for: .normal)
            
            containerVC.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.orange],
                                                 for: .selected)
            
            containerVC.tabBarItem.image = UIImage(named: imageName)
            
            containerVC.tabBarItem.selectedImage = UIImage(named: "\(imageName)_selected")?.withRenderingMode(.alwaysOriginal)
            addChildViewController(containerVC)
        }
        
        else {
            vc.title = title
            
            vc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.black],
                                                 for: .normal)
            
            vc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.orange],
                                                 for: .selected)
            
            vc.tabBarItem.image = UIImage(named: imageName)
            
            vc.tabBarItem.selectedImage = UIImage(named: "\(imageName)_selected")?.withRenderingMode(.alwaysOriginal)

            let navVC = MagiNavigationController(rootViewController: vc)
            
            addChildViewController(navVC)
        }

    }

}
