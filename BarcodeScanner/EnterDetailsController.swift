//
//  EnterDetailsController.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 31.05.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit

class EnterDetailsController: NSObject {
    
    private var model : ProductModel!
    private var persistenceManager : PersistencyManager
    
    override init() {
        model = ProductModel()
        persistenceManager = PersistencyManager()
    }
    
    //If EditMode active -> Overwrite existing Product
    //If EditMode inactive -> Append new Product
    func saveDetails(aCompany : String, aShortDescription : String, aDescription : String?, aType : String, aValue : String, aCode : String, aBarcode : UIImage?, editMode : Bool){
        let newEntry = ProductEntry.init(aCompany: aCompany, aShortDescription: aShortDescription, aType: aType, aPrice: aValue, aCode: aCode, aDescription: aDescription, aBarcode: aBarcode)
        
        if editMode{
            model.overwriteElement(forEAN: aCode, element: newEntry)
        }else{
            model.append(element: newEntry)
        }
        
        persistenceManager.saveProductModel(model)
    }
    
    //Converts Price as String to [Character]
    //Makes it easier to access single numbers
    func getPriceArray(value : String, editMode : Bool)->[Character]{
        var aValue = ""
        if !editMode{
            aValue = value.substring(to: value.index(value.endIndex, offsetBy: -2))
        }else{
            aValue = value
        }
        var list = Array<Character>()
        
        
        let cents = aValue.remove(at: aValue.index(before: aValue.endIndex))
        list.append(cents)
        
        
        let centTens = aValue.remove(at: aValue.index(aValue.endIndex, offsetBy: -1))
        list.append(centTens)
        //print("aValue after centsTens: \(aValue)")
        
        let ones = aValue.remove(at: aValue.index(aValue.endIndex, offsetBy: -2))
        list.append(ones)
        //print("aValue after ones: \(aValue)")
        
        if aValue.characters.count > 1{
            //print("tens")
            let tens = aValue.remove(at: aValue.index(aValue.endIndex, offsetBy: -2))
            list.append(tens)
            //print("aValue after tens: \(aValue)")
            if aValue.characters.count > 1{
                let hundrets = aValue.remove(at: aValue.index(aValue.endIndex, offsetBy: -2))
                list.append(hundrets)
            }
        }
        
        return list
    }
    
}
