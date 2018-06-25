//
//  URLSessionViewController.swift
//  MagiApp
//
//  Created by 安然 on 2018/6/25.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

let kFileResumeData = "ResumeData"                  // 存储resumeData的Key
let keyBackgroundDownload = "backgroundDownload"    //BackgroundSession的标示

class URLSessionViewController: MagiBaseViewController {
    
    // MARK: - 系统方法

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 自定义方法
    
    private func setupUI() {
        
        view.addSubview(getBtn)
        view.addSubview(postBtn)


        
    }
    
    // MARK: - 属性
    
    fileprivate var downloadTask: URLSessionDownloadTask? = nil
    
    fileprivate var downloadSession: Foundation.URLSession? = nil
    
    fileprivate var etag: String? = nil
    
    // MARK: - 控件
    
    fileprivate lazy var getBtn: UIButton = {
        let _getBtn = UIButton()
        _getBtn.addTarget(self,
                           action: #selector(getBtnAction(_:)),
                           for: .touchUpInside)
        return _getBtn
    }()
    
    fileprivate lazy var postBtn: UIButton = {
        let _postBtn = UIButton()
        _postBtn.addTarget(self,
                           action: #selector(postBtnAction(_:)),
                           for: .touchUpInside)
        return _postBtn
    }()

}

extension URLSessionViewController {
    
    @objc
    fileprivate func getBtnAction(_ sender: UIButton) {
        
    }
    
    @objc
    fileprivate func postBtnAction(_ sender: UIButton) {
        
    }
    
}
