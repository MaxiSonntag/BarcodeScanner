//
//  ShowBarcodeViewController.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 24.06.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit

class ShowBarcodeViewController: UIViewController {
    
    var image : UIImage?
    @IBOutlet weak var barcodeImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barcodeImageView.image = image
    }
    
}
