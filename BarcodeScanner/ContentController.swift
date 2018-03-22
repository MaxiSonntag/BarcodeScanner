//
//  ContentController.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 31.05.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit

class ContentController: NSObject {
    
    var model : ProductModel!
    var originalElements : [ProductEntry]!
    
    override init() {
        model = ProductModel()
        
    }
    
    //Laden des gespeicherten Models
    func loadSavedData(){
        let savedProducts = PersistencyManager().loadProductModel().getAllElements()
        model.overwriteProducts(savedProducts: savedProducts)
        originalElements = savedProducts
    }
    
    //Speichern des aktuellen Models
    func saveData(){
        PersistencyManager().saveProductModel(model)
    }
    
    func getProductEntry(forEAN ean : String)->ProductEntry{
        let entry = model.getElement(forEAN: ean)
        return entry
    }

}
