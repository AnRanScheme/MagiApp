//
//  MenuButton.swift
//  MagicApp
//
//  Created by 安然 on 2018/1/18.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

class MenuButton: UIView {
    
    // MARK: - 系统方法
    
    init(_ Array: [String]) {
        self.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        frame = CGRect(x: 0.0,
                       y: 0.0,
                       width: 20.0,
                       height: 20.0)
        addSubview(imageView)
    }
    
    @objc private func didTap() {
        tapHandler?()
    }
    
    // MARK: - 属性
    
    var tapHandler: (()->())?
    
    // MARK: - 控件
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image:UIImage(named:"menu.png"))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(MenuButton.didTap)))
        return imageView
    }()

}
