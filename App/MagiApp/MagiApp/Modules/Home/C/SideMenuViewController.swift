//
//  SideMenuViewController.swift
//  MagicApp
//
//  Created by 安然 on 2018/1/18.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    // MARK: - 系统方法

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 属性
    
    var centerViewController: CenterViewController?
    
    fileprivate static let identifier = "CellID"
    
    // MARK: - 控件
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = self.view.bounds
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: SideMenuViewController.identifier)
        return tableView
    }()

}

// MARK: - UITableViewDataSource
extension SideMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItem.sharedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuViewController.identifier,
                                                 for:indexPath)
        
        let menuItem = MenuItem.sharedItems[indexPath.row]
        cell.textLabel?.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 36)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = menuItem.symbol
        cell.contentView.backgroundColor = menuItem.color
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SideMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        centerViewController?.menuItem = MenuItem.sharedItems[indexPath.row]
        
        let containerVC = parent as! ContainerViewController
        containerVC.toggleSideMenu()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
}
