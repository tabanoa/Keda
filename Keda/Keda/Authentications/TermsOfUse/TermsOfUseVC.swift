//
//  TermsOfUseVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class TermsOfUseVC: UIViewController {
    
    //MARK: - Properties
    private let webView = UIWebView()
    private let backBtn = ShowMoreBtn()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        guard let url = Bundle.main.url(forResource: "termsOfUse.html", withExtension: nil),
            let data = try? Data(contentsOf: url) else { return }
        
        let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
        webView.load(data, mimeType: "text/html", textEncodingName: "URF-8", baseURL: baseURL)
    }
}

//MARK: - Configures

extension TermsOfUseVC {
    
    func updateUI() {
        //TODO: - BackBtn
        backBtn.setImage(UIImage(named: "icon-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.tintColor = .black
        backBtn.addTarget(self, action: #selector(backDidTap), for: .touchUpInside)
        view.addSubview(backBtn)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - WebView
        webView.backgroundColor = .white
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let widthBtn: CGFloat = 45.0
        NSLayoutConstraint.activate([
            backBtn.widthAnchor.constraint(equalToConstant: widthBtn),
            backBtn.heightAnchor.constraint(equalToConstant: widthBtn),
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2.0),
            
            webView.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 30.0),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc func backDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
