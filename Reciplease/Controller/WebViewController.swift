//
//  WebViewController.swift
//  Reciplease
//
//  Created by Gregory De knyf on 30/01/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var url: URL!
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Url request
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        //Controller title
        title = "How to make recipe"
        
        //Refresh button
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
    }
}
