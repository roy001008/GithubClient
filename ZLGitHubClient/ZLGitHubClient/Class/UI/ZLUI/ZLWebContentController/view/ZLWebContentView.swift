//
//  ZLWebContentView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/28.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import WebKit

enum ZLWebContentProgress : Float {
    case sendRequest = 0.1
    case getResponse = 0.5
    case startLoad = 0.7
    case endLoad = 1.0
}

class ZLWebContentView: ZLBaseView {

    @objc @IBOutlet private weak var topViewHeightConstraint: NSLayoutConstraint!
    
    @objc @IBOutlet private weak var titleLabel: UILabel!
    
    @objc @IBOutlet private weak var progressView: UIProgressView!
    
    @IBOutlet weak var collectionView: UIView!
    
    @IBOutlet private weak var toolBar: UIToolbar!           // 工具栏
    
    @objc var webView : WKWebView?
    

    // toolbarbutton
    private var backBarButtonItem : UIBarButtonItem?
    private var forwardBarButtonItem : UIBarButtonItem?
    private var reloadOrStoploadBarButtonItem : UIBarButtonItem?
    
    
    private(set) var isLoading : Bool = false               // 是否在加载请求
    
    
    
    deinit {
        self.webView?.removeObserver(self, forKeyPath: "title", context: nil)
        self.webView?.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
        self.webView?.removeObserver(self, forKeyPath: "isLoading", context: nil)
        self.webView?.removeObserver(self, forKeyPath: "canGoBack", context: nil)
        self.webView?.removeObserver(self, forKeyPath: "canGoForward", context: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.topViewHeightConstraint.constant = self.topViewHeightConstraint.constant + ZLStatusBarHeight
        
        let webViewConfig = WKWebViewConfiguration.init()
        let webView : WKWebView = WKWebView.init(frame: self.collectionView.bounds,configuration: webViewConfig)
        webView.autoresizingMask = UIViewAutoresizing.init(rawValue: UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue)
        self.collectionView.insertSubview(webView, belowSubview: self.toolBar)
        self.webView = webView
        self.webView?.uiDelegate = self
        self.webView?.navigationDelegate = self
        
        self.setUpToolBar()
        
        self.webView?.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
        self.webView?.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        self.webView?.addObserver(self, forKeyPath: "isLoading", options: NSKeyValueObservingOptions.new, context: nil)
        self.webView?.addObserver(self, forKeyPath: "canGoBack", options: NSKeyValueObservingOptions.new, context: nil)
        self.webView?.addObserver(self, forKeyPath: "canGoForward", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    
    func setUpToolBar()
    {
        let backBarButtonItem : UIBarButtonItem = UIBarButtonItem.init(title: "上一页", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBackButtonClicked))
        self.backBarButtonItem?.isEnabled = false
        self.backBarButtonItem = backBarButtonItem
        
        let forwardBarButtonItem : UIBarButtonItem = UIBarButtonItem.init(title: "下一页", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onForwardButtonClicked))
        forwardBarButtonItem.isEnabled = false
        self.forwardBarButtonItem = forwardBarButtonItem
        
        let reloadOrStoploadBarButtonItem : UIBarButtonItem = UIBarButtonItem.init(title: "停止加载", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onReloadOrStopLoadButtonCicked))
        self.reloadOrStoploadBarButtonItem = reloadOrStoploadBarButtonItem
        
        let barButtonItems = [backBarButtonItem,forwardBarButtonItem,reloadOrStoploadBarButtonItem]
        
        self.toolBar.setItems(barButtonItems, animated: false)
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if("title" == keyPath)
        {
            let newTitle = change?[NSKeyValueChangeKey.newKey] as? String
            self.titleLabel.text = newTitle
        }
        else if "canGoBack" == keyPath
        {
            guard let value : Bool = change?[NSKeyValueChangeKey.newKey] as? Bool else
            {
                return
            }
            
            if value
            {
                self.backBarButtonItem?.isEnabled = true
            }
            else
            {
                self.backBarButtonItem?.isEnabled = false
            }
        }
        else if "canGoForward" == keyPath
        {
            guard let value : Bool = change?[NSKeyValueChangeKey.newKey] as? Bool else
            {
                return
            }
            
            if value
            {
                self.forwardBarButtonItem?.isEnabled = true
            }
            else
            {
                self.forwardBarButtonItem?.isEnabled = false
            }
        }
        
    }
    
}


// MARK: ZLWebContentProgress
extension ZLWebContentView
{
    func setSendRequestStatus()
    {
        self.progressView.isHidden = false
        self.progressView.progress = ZLWebContentProgress.sendRequest.rawValue
        self.reloadOrStoploadBarButtonItem?.title = "停止加载"
        self.isLoading = true
    }
    
    func setGetResponseStatus()
    {
        self.progressView.isHidden = false
        self.progressView.progress = ZLWebContentProgress.getResponse.rawValue
        self.reloadOrStoploadBarButtonItem?.title = "重新加载"
        self.isLoading = false
    }
    
    func setFaildRequestStatus()
    {
        self.progressView.isHidden = true
        self.progressView.progress = ZLWebContentProgress.getResponse.rawValue
        self.reloadOrStoploadBarButtonItem?.title = "重新加载"
        self.isLoading = false
    }
    
    func setStarLoadStatus()
    {
        self.progressView.isHidden = false
        self.progressView.progress = ZLWebContentProgress.startLoad.rawValue
    }
    
    func setEndLoadStatus()
    {
        self.progressView.isHidden = true
        self.progressView.progress = ZLWebContentProgress.endLoad.rawValue
        self.isLoading = false
    }
}

// MARK: UIToolBar
extension ZLWebContentView
{
    @objc func onBackButtonClicked()
    {
        if self.webView?.canGoBack ?? false
        {
            self.webView?.goBack()
        }
    }
    
    @objc func onForwardButtonClicked()
    {
        if self.webView?.canGoForward ?? false
        {
            self.webView?.goForward()
        }
    }
    
    @objc func onReloadOrStopLoadButtonCicked()
    {
        if self.isLoading
        {
            self.webView?.stopLoading()
        }
        else
        {
            self.webView?.reload()
        }
        
    }
}

// MARK: WKUIDelegate,WKNavigationDelegate
extension ZLWebContentView : WKUIDelegate,WKNavigationDelegate
{
    func webViewDidClose(_ webView: WKWebView) {
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        ZLLog_Debug("ZLWebContentView: webView:decidePolicyForNavigationAction: type[\(navigationAction.navigationType)] request[\(navigationAction.request)]]")
        decisionHandler(.allow)
        
        self.setSendRequestStatus()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        ZLLog_Debug("ZLWebContentView: webView:decidePolicyForNavigationResponse: response[\(navigationResponse.response)]")
        decisionHandler(.allow)
        
        self.setGetResponseStatus()
    }
    
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        ZLLog_Debug("ZLWebContentView: webView:didReceiveServerRedirectForProvisionalNavigation navigation[\(String(describing: navigation))]")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ZLLog_Debug("ZLWebContentView: webView:didStartProvisionalNavigation navigation[\(String(describing: navigation))]")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        ZLLog_Debug("ZLWebContentView: webView:didFailProvisionalNavigation navigation[\(String(describing: navigation))] error[\(error.localizedDescription)]")
        
        self.setFaildRequestStatus()
    }
    

    /**
     * 收到请求的响应，开始刷新界面
     *
     **/
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        self.setStarLoadStatus()
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        self.setEndLoadStatus()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       
        self.setEndLoadStatus()
    }
}
