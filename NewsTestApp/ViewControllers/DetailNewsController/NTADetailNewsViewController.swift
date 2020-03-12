//
//  NTADetailNewsViewController.swift
//  NewsTestApp
//
//  Created by Вячеслав on 08/03/2020.
//  Copyright © 2020 PaRaDoX. All rights reserved.
//

import UIKit
import WebKit

class NTADetailNewsViewController: UIViewController, WKNavigationDelegate {
  
    @IBOutlet var webView: WKWebView!
    
    var viewModel: NTANewsDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.navigationDelegate = self
        let request = URLRequest.init(url: self.viewModel.newsURL!)
        self.webView.load(request)
        self.title = self.viewModel.newsTitle
        
        // Do any additional setup after loading the view.
    }

//MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let requestString: String = navigationAction.request.url!.absoluteString
        let newsURLString: String = self.viewModel.newsURL!.absoluteString
         
        if (requestString.elementsEqual(newsURLString)) {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
        }
    }

}
