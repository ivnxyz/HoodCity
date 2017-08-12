//
//  PDFController.swift
//  HoodCity
//
//  Created by Iván Martínez on 11/08/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit

class PDFController: UIViewController {
    
    let request: URLRequest
    let controllerTitle: String
    
    //MARK: - UI elements
    
    lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.delegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(#imageLiteral(resourceName: "cancel-button"), for: .normal)
        button.addTarget(self, action: #selector(PDFController.cancel), for: .touchUpInside)
        
        let tabBarButtonItem = UIBarButtonItem(customView: button)
        
        return tabBarButtonItem
    }()
    
    lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        return loadingView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = cancelButton
        guard let navigationBarHeight = navigationController?.navigationBar.frame.size.height else { return }
        
        view.backgroundColor = .white
        title = controllerTitle
        
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        webView.loadRequest(request)
    }
    
    init(request: URLRequest, title: String) {
        self.request = request
        self.controllerTitle = title
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Loading View
    
    func startLoadingView() {
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 80),
            loadingView.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        loadingView.start()
    }
    
    func stopLoadingView() {
        loadingView.stop()
    }
}

extension PDFController: UIWebViewDelegate {
    
    //MARK: - UIWebViewDelegate
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        startLoadingView()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        stopLoadingView()
    }
}
