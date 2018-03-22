//
//  ProductTableViewCell.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 24.05.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var hersteller: UILabel!
    @IBOutlet weak var typ: UILabel!
    @IBOutlet weak var kurzbeschreibung: UILabel!
    @IBOutlet weak var wert: UILabel!
    @IBOutlet weak var code: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
