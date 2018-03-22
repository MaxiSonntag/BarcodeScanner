//
//  Error.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 28.06.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit

class ErrorReaction: NSObject {
    
    static let sharedErrorInstance = ErrorReaction()
    
    dynamic var errorHappened = false
    
    var errorType : ErrorTypes!{
        didSet{
            errorHappened = !errorHappened
        }
    }
    
    func showError(inView : UIBarButtonItem, completion: @escaping () -> Void)->UIAlertController{
        
        let actionSheetCtrl = UIAlertController(title: "An Error Occured", message: "", preferredStyle: .actionSheet)
        
        switch errorType! {
            
        case .networkingError:
            actionSheetCtrl.message = "A Netowrk Error occured\nPlease check your connection"
            let okayAction = UIAlertAction(title: "Okay", style: .default){ action -> Void in
                actionSheetCtrl.dismiss(animated: true, completion: nil)
                completion()
            }
            actionSheetCtrl.addAction(okayAction)
            
        case .permissionError:
            actionSheetCtrl.message = "We need your permission to access the camera\nPlease grant access to use barcode scanning"
            let grantAction = UIAlertAction(title: "Allow", style: .default){action -> Void in
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            }
            actionSheetCtrl.addAction(grantAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ action -> Void in
                actionSheetCtrl.dismiss(animated: true, completion: nil)
                completion()
            }
            actionSheetCtrl.addAction(cancelAction)
            
        default:
            actionSheetCtrl.message = "An unknown Error occured\nI'm sorry"
        }
        
        
        let popover = actionSheetCtrl.popoverPresentationController
        popover?.barButtonItem = inView
        
        return actionSheetCtrl
    }
    
    
    
    
}

enum ErrorTypes : String{
    case networkingError = "Network Error"
    case permissionError = "Permission Error"
    case noError = "No Error"
}
