//
//  QrButton.swift
//  qrCode
//
//  Created by Александр Меренков on 29.04.2022.
//

import UIKit

protocol LaunchScanerDelegate: AnyObject {
    func launchScaner()
}

class QrButton: UIButton {
    
//    MARK: - Properties
    
    weak var delegate: LaunchScanerDelegate?
    
//    MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        setTitle("Сканировать код", for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        
        backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Selectors
    
    @objc private func handleButton() {
        delegate?.launchScaner()
    }
}
