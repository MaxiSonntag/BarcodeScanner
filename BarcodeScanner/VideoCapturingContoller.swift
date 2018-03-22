//
//  VideoCapturingContoller.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 21.06.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCapturingContoller: NSObject, CaptureMetadataSize {
    
    var supportedTypes = [AVMetadataObjectTypeQRCode,
                          AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeCode128Code]
    
    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var qrFrameView: UIView?
    var mainView : UIView?
    
    var captureDelegate = MetadataOutputObjectsDelegate()
    let errors = ErrorReaction.sharedErrorInstance

    
    func startCapturing(){
        
        //Errorhandling - Permission for Camera
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if authStatus == .notDetermined || authStatus == .denied{
            print("Error Set Permission")
            errors.errorType = ErrorTypes.permissionError
            return
        }
        
        
        captureDelegate.frameCallback = self
        
        //Physical device
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        
        do{
            //Represents input of camera
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            
            captureSession = AVCaptureSession()
            
            captureSession?.addInput(input)
            
            //Represents output of session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            //Translation of output into readable data through delegate
            captureMetadataOutput.setMetadataObjectsDelegate(captureDelegate, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedTypes
            captureDelegate.supportedTypes = supportedTypes
            
            //Displays videoCapturing on screen
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = (mainView?.layer.bounds)!
            mainView?.layer.addSublayer(videoPreviewLayer!)
            
            
            captureSession?.startRunning()
            
            
            //Green box around detected code
            qrFrameView = UIView()
            if let qrFrameView = qrFrameView{
                qrFrameView.layer.borderColor = UIColor.green.cgColor
                qrFrameView.layer.borderWidth = 2
                mainView?.addSubview(qrFrameView)
                mainView?.bringSubview(toFront: qrFrameView)
            }
            
            
        }catch{
            print(error)
            return
        }

    }
    
    //Green box - default size = zero, when barcode detected size = size of detected object
    func setFrameView(_ data: AVMetadataMachineReadableCodeObject) {
        let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: data)
        if barCodeObject?.bounds != nil{
            qrFrameView?.frame = barCodeObject!.bounds
        }else{
            qrFrameView?.frame = CGRect.zero
        }
    }

}
