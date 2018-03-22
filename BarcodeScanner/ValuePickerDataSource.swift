//
//  ValuePickerDataSource.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 31.05.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit

class ValuePickerDataSource: NSObject, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 3{
            return 1
        }else{
            return 10
        }
        
    }
    
    func getData(for component : Int, in row : Int)->String{
        if component == 3{
            return ","
        }else{
            return "\(row)"
        }
    }

}
