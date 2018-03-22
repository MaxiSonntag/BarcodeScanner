//
//  MetadataOutputObjectsDelegate.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 14.06.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit
import AVFoundation

class MetadataOutputObjectsDelegate: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    

    var callback : CaptureMetadataCallback?
    var frameCallback : CaptureMetadataSize?
    var supportedTypes : [String] = []
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        //No metadata detected
        if metadataObjects == nil || metadataObjects.count == 0{
            frameCallback?.setFrameView(AVMetadataMachineReadableCodeObject())
            return
        }
        
        //
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        //Check if captured metadata is supported
        if supportedTypes.contains(metadataObj.type){
            
            //Set size of green box in VideoCapturingContoller
            frameCallback?.setFrameView(metadataObj)
            
            if metadataObj.stringValue != nil{  
                callback?.setEANField(text: metadataObj.stringValue)
            }
        }
    }

}
