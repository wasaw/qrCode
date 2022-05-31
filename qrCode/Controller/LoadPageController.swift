//
//  LoadPageController.swift
//  qrCode
//
//  Created by Александр Меренков on 06.05.2022.
//

import UIKit
import WebKit
import simd

class LoadPageController: UIViewController {
    
//    MARK: - Properties
    
    private let urlString: String
    private let webView = WKWebView()
    
//    MARK: - Lifecycle
    
    init(url: String) {
        self.urlString = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        tabBarController?.tabBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(handleBackButton))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        guard let url = URL(string: urlString) else { return }
        webView.frame = view.bounds
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
        
        view.backgroundColor = .white
    }
    
//    MARK: - Selectors
    
    @objc private func handleBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
}

//  MARK: - Extensions

extension LoadPageController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.evaluateJavaScript("document.title") { (result, error) -> Void in
            self.navigationItem.title = result as? String
        }
    }
}
