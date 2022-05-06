//
//  ScaneController.swift
//  qrCode
//
//  Created by Александр Меренков on 05.05.2022.
//

import Foundation
import AVFoundation
import UIKit

class ScaneController: UIViewController {
    
//    MARK: - Preperties
    
    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var qrCodeFrameView: UIView?
    private var qrCodeUrlButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.layer.borderColor = UIColor.green.cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(handleUrl), for: .touchUpInside)
        return btn
    }()
    
//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("DEBUG: Failed to get the camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            guard let videoPreviewLayer = videoPreviewLayer else { return }
            view.layer.addSublayer(videoPreviewLayer)
            
            captureSession.startRunning()
            
            qrCodeFrameView = UIView()
            
            view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(leftSwipe)))
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
                
                view.addSubview(qrCodeUrlButton)
                
                qrCodeUrlButton.translatesAutoresizingMaskIntoConstraints = false
                qrCodeUrlButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
                qrCodeUrlButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                qrCodeUrlButton.centerXAnchor.constraint(equalTo: qrCodeFrameView.centerXAnchor).isActive = true
                qrCodeUrlButton.topAnchor.constraint(equalTo: qrCodeFrameView.bottomAnchor, constant: 15).isActive = true
                qrCodeUrlButton.isHidden = true
            }
        } catch {
            print(error)
            return
        }
    }
    
//    MARK: - Selectors
    
    @objc private func handleUrl() {
        print("DEBUG: tap")
    }
    
    @objc private func leftSwipe(sender: UIPanGestureRecognizer) {
        if sender.state == .ended {
            if sender.velocity(in: self.view).x < 0 {
                dismiss(animated: true)
            }
        }
    }
}

//  MARK: - Extensions

extension ScaneController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            qrCodeUrlButton.isHidden = true
            print("DEBUG: No detected code")
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                let metaString = metadataObj.stringValue ?? ""
                qrCodeUrlButton.setTitle(metaString, for: .normal)
                qrCodeUrlButton.isHidden = false
            }
        }
    }
}
