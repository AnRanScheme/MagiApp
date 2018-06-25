//
//  URLSessionViewController.swift
//  MagiApp
//
//  Created by 安然 on 2018/6/25.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit
import SnapKit

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
        
        let clearBtn = Button()
        clearBtn.setImage(Icon.clear, for: .normal)
        clearBtn.frame.size = CGSize(width: 40, height: 40)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: clearBtn)
        
        view.addSubview(urlEncodeBtn)
        view.addSubview(getBtn)
        view.addSubview(postBtn)
        view.addSubview(logTextView)
        
        urlEncodeBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview()
            make.height.equalTo(44)
        }

        getBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(urlEncodeBtn.snp.right)
            make.width.equalTo(urlEncodeBtn.snp.width)
            make.height.equalTo(44)
        }
        
        postBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview()
            make.left.equalTo(getBtn.snp.right)
            make.width.equalTo(getBtn.snp.width)
            make.height.equalTo(44)
        }
        
        logTextView.snp.makeConstraints { (make) in
            make.top.equalTo(getBtn.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-8)
        }

    }
    
    fileprivate func sessionDataTaskRequest(_ method: String, parameters: [String: AnyObject]) {
        //1.创建会话用的URL
        var hostString = "http://jsonplaceholder.typicode.com/posts"
        //对参数进行URL编码
        let escapeQueryString = query(parameters)
        
        if method == "GET" {
            hostString += "?" + escapeQueryString
        }
        let url: URL = URL.init(string: hostString)!
        
        //2.创建Request
        var request = URLRequest(url: url)
        request.httpMethod = method //指定请求方式
        if method == "POST" {
            request.httpBody = escapeQueryString.data(using: String.Encoding.utf8)
        }
        
        //3.获取Session单例，创建SessionDataTask
        let session = URLSession.shared
        let sessionTask = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                self.showLog(error! as AnyObject)
                return
            }
            
            if data != nil {    //对Data进行Json解析
                let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                self.showLog(json! as AnyObject)
            }
        }
        sessionTask.resume()
    }
    
    fileprivate func showLog(_ info: AnyObject) {
        let log = "\(info)"
        print(log)
        
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 1)
        
        DispatchQueue.main.async {
            
            semaphore.wait()
            
            let logs = self.logTextView.text
            
            let newlogs = String((logs! + "\n"+log)).replacingOccurrences(of: "\\n", with: "\n")

            self.logTextView.text = newlogs
            
            self.logTextView.layoutManager.allowsNonContiguousLayout = false
            
            self.logTextView.scrollRectToVisible(CGRect(x: 0,
                                                        y: self.logTextView.contentSize.height - 15,
                                                        width: self.logTextView.contentSize.width,
                                                        height: 10),
                                                 animated: true)
            
            semaphore.signal()
        }
        
    }
    
    // - MARK - Alamofire中的三个方法该方法将字典转换成URL编码的字符
    func query(_ parameters: [String: AnyObject]) -> String {
        
        var components: [(String, String)] = []     //存有元组的数组，元组由ULR中的(key, value)组成
        
        for key in parameters.keys.sorted(by: <) {        //遍历参数字典
            let value = parameters[key]!
            components += queryComponents(key, value)
        }
        
        return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
    }
    
    
    func queryComponents(_ key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        
        
        if let dictionary = value as? [String: AnyObject] {         //value为字典的情况, 递归调用
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        }
            
        else if let array = value as? [AnyObject] {               //value为数组的情况, 递归调用
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        }
            
        else {  //vlalue为字符串的情况，进行转义，上面两种情况最终会递归到此情况而结束
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    /**
     
     - parameter string: 要转义的字符串
     
     - returns: 转义后的字符串
     */
    func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        //==========================================================================================================
        //
        //  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
        //  hundred Chinese characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
        //  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead. For more
        //  info, please refer to:
        //
        //      - https://github.com/Alamofire/Alamofire/issues/206
        //
        //==========================================================================================================
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = string.substring(with: range)
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring
                
                index = endIndex
            }
        }
        
        return escaped
    }
    
    /**
     清理缓存文件
     */
    func clearCacheFile() {
        //获取缓存文件路径
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        
        //获取BoundleID
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return
        }
        
        //拼接当前工程所创建的缓存文件路径
        let projectCashPath = "\(cachePath)/\(bundleIdentifier)/"
        
        //创建FileManager
        let fileManager: FileManager = FileManager.default
        
        //获取缓存文件列表
        guard let cacheFileList = try?fileManager.contentsOfDirectory(atPath: projectCashPath) else {
            return
        }
        
        //遍历文件列表，移除所有缓存文件
        for fileName in cacheFileList {
            let willRemoveFilePath = projectCashPath + fileName
            
            if fileManager.fileExists(atPath: willRemoveFilePath) {
                try!fileManager.removeItem(atPath: willRemoveFilePath)
            }
        }
    }
    
    // MARK: - 属性
    
    fileprivate var downloadTask: URLSessionDownloadTask? = nil
    
    fileprivate var downloadSession: Foundation.URLSession? = nil
    
    fileprivate var etag: String? = nil
    
    // MARK: - 控件
    
    fileprivate lazy var getBtn: UIButton = {
        let _getBtn = UIButton()
        _getBtn.setTitle("data_task_get", for: .normal)
        _getBtn.setTitleColor(Color.blue.lighten3,
                              for: .normal)
        _getBtn.layer.borderColor = Color.blue.lighten3.cgColor
        _getBtn.layer.borderWidth = 1.0
        _getBtn.addTarget(self,
                          action: #selector(getBtnAction(_:)),
                          for: .touchUpInside)
        return _getBtn
    }()
    
    fileprivate lazy var urlEncodeBtn: UIButton = {
        let _getBtn = UIButton()
        _getBtn.setTitle("URL_编码", for: .normal)
        _getBtn.setTitleColor(Color.blue.lighten3,
                              for: .normal)
        _getBtn.layer.borderColor = Color.blue.lighten3.cgColor
        _getBtn.layer.borderWidth = 1.0
        _getBtn.addTarget(self,
                           action: #selector(urlEncodeAction(_:)),
                           for: .touchUpInside)
        return _getBtn
    }()
    
    fileprivate lazy var postBtn: UIButton = {
        let _postBtn = UIButton()
        _postBtn.setTitle("data_task_post", for: .normal)
        _postBtn.setTitleColor(Color.blue.lighten3,
                              for: .normal)
        _postBtn.layer.borderColor = Color.blue.lighten3.cgColor
        _postBtn.layer.borderWidth = 1.0
        _postBtn.addTarget(self,
                           action: #selector(postBtnAction(_:)),
                           for: .touchUpInside)
        return _postBtn
    }()
    
    fileprivate lazy var logTextView: UITextView = {
        let _logTextView = UITextView()
        _logTextView.backgroundColor = UIColor.black
        _logTextView.textColor = UIColor.white
        return _logTextView
    }()

}

// MARK: - action
extension URLSessionViewController {
    
    @objc
    fileprivate func clearBtnAction(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: kFileResumeData)
        logTextView.text = ""
        clearCacheFile()
    }
    
    @objc
    fileprivate func urlEncodeAction(_ sender: UIButton) {
        showLog("URL编码测试" as AnyObject)
        let parameters = [
            "post": "value01",
            "arr": ["元素1", "元素2"],
            "dic": ["key1": "value1",
                    "key2":"value2"]
            ] as [String : Any]
        showLog(query(parameters as [String : AnyObject]) as AnyObject)
    }
    
    @objc
    fileprivate func getBtnAction(_ sender: UIButton) {
        let parameters = ["userId": "1"]
        showLog("正在GET请求数据" as AnyObject)
        sessionDataTaskRequest("GET",
                               parameters: parameters as [String : AnyObject])
    }
    
    @objc
    fileprivate func postBtnAction(_ sender: UIButton) {
        showLog("正在POST请求数据" as AnyObject)
        let parameters = ["userId": "1"]
        sessionDataTaskRequest("POST",
                               parameters: parameters as [String : AnyObject])
    }
    
}

extension URLSessionViewController {
    
}

extension URLSessionViewController {
    
}

extension URLSessionViewController {
    
}

extension URLSessionViewController {
    
}

extension URLSessionViewController {
    
}

extension URLSessionViewController {
    
}
