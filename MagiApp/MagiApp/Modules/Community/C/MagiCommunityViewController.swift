//
//  MagiCommunityViewController.swift
//  MagiApp
//
//  Created by 安然 on 2018/6/22.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

class MagiCommunityViewController: MagiBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 属性
    
    fileprivate static let identifier = "CellReuseIdentifier"
    
    fileprivate var data: Array<String> = ["URLSession学习",
                                           "URLSession学习",
                                           "URLSession学习"]
    
    // MARK: - 控件
    
    fileprivate lazy var tableView: UITableView = {
        let _tableView = UITableView()
        _tableView.frame = self.view.bounds
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.contentInset = UIEdgeInsets.zero
        _tableView.contentScaleFactor = MagiScreen.scale
        _tableView.separatorColor = Color.cyan.lighten1
        _tableView.separatorInset = UIEdgeInsets.zero
        _tableView.tableFooterView = UIView()
        _tableView.register(UITableViewCell.self,
                            forCellReuseIdentifier: MagiCommunityViewController.identifier)
        
        return _tableView
    }()

}

// MARK: - UITableViewDataSource
extension MagiCommunityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MagiCommunityViewController.identifier,
                                                 for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textColor = Color.pink.lighten1
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension MagiCommunityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}
