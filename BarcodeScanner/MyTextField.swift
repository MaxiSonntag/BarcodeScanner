//
//  MyTextField.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 04.07.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit

@IBDesignable
class MyTextField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = UIColor(white: 231/255, alpha: 1).cgColor
        self.layer.borderWidth = 1
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 7)
    }
   
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
