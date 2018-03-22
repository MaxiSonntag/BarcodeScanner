//
//  LoadingIndicatorController.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 24.06.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit

class LoadingIndicatorController: NSObject {
    
    var relevantView : UIView!
    let loadingIndicator = UIActivityIndicatorView()
    var overlayView : UIView!
    
    init(_ view : UIView) {
        relevantView = view
    }
    
    func startLoadingIndicator(){
        //Overlay View
        overlayView = UIView(frame: (relevantView.frame))
        overlayView.center = (relevantView?.center)!
        overlayView.alpha = 0
        overlayView.backgroundColor = UIColor.black
        
        
        relevantView.addSubview(overlayView)
        relevantView.bringSubview(toFront: overlayView)
        
        //Animation
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        overlayView.alpha = overlayView.alpha > CGFloat(0) ? CGFloat(0.0) : CGFloat(0.5)
        UIView.commitAnimations()
        
        
        //Loading Indicator
        loadingIndicator.activityIndicatorViewStyle = .whiteLarge
        loadingIndicator.center = overlayView.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        
        //Add Loading Indicator to Overlay
        overlayView.addSubview(loadingIndicator)
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        
    }
    
    func stopLoadingIndicator(){
        loadingIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        overlayView.removeFromSuperview()
    }

}
