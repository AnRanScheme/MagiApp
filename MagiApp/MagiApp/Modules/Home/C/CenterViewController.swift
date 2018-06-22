//
//  CenterViewController.swift
//  MagicApp
//
//  Created by 安然 on 2018/1/18.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

class CenterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        menuItem = MenuItem.sharedItems.first!
        view.addSubview(symbol)
        symbol.center = view.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func popAlert(_ tapges: UITapGestureRecognizer) {
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 属性
    
    lazy var alert: UIAlertController = {
        
        let alert = UIAlertController(title: "你好",
                                      message: "你好",
                                      preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
        })
        let action = UIAlertAction(title: "确定",
                                   style: .default,
                                   handler: { (action) in
        })
        let action1 = UIAlertAction(title: "取消",
                                    style: .cancel,
                                    handler: { (action) in
        })
        alert.addAction(action)
        alert.addAction(action1)
        return alert
    }()

    var menuItem: MenuItem = MenuItem.sharedItems.first! {
        didSet {
            title = menuItem.title
            view.backgroundColor = menuItem.color
            symbol.text = menuItem.symbol
        }
    }
    
    // MARK: - 控件
    
    lazy var menuButton: MenuButton = {
        let menuButton = MenuButton()
        menuButton.tapHandler = {
            if let containerVC = self.navigationController?.parent as? ContainerViewController {
                containerVC.toggleSideMenu()
            }
        }
        return menuButton
    }()
    
    fileprivate lazy var symbol: UILabel = {
        let symbol = UILabel()
        symbol.text = "☎︎"
        symbol.textColor = UIColor.white
        symbol.font = UIFont.systemFont(ofSize: 48)
        symbol.isUserInteractionEnabled = true
        symbol.sizeToFit()
        let tapGes = UITapGestureRecognizer(target: self,
                                            action: #selector(popAlert(_:)))
        symbol.addGestureRecognizer(tapGes)
        return symbol
    }()

}
