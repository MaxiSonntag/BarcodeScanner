//
//  ProductTableViewDelegate.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 24.05.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit

class ProductTableViewDelegate: NSObject, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

}
