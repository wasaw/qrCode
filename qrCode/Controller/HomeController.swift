//
//  HomeController.swift
//  qrCode
//
//  Created by Александр Меренков on 29.04.2022.
//

import UIKit

class HomeController: UIViewController {
    
//    MARK: - Properties
    
    private let qrButton = QrButton()
    
//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qrButton.delegate = self

        configureButton()
        
        view.backgroundColor = .lightGray
    }
    
//    MARK: - Helpers
    
    func configureButton() {
        view.addSubview(qrButton)
        
        qrButton.translatesAutoresizingMaskIntoConstraints = false
        qrButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        qrButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        qrButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        qrButton.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        qrButton.layer.borderWidth = 1
    }
}

//  MARK: - Extensions

extension HomeController: LaunchScanerDelegate {
    func launchScaner() {
        let vc = ScaneController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
