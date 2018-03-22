//
//  PersistencyManager.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 31.05.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit

class PersistencyManager: NSObject {
    
    fileprivate let fileName = "ProductModel.plist"
    fileprivate let dataKey = "ProductObject"
    
    func loadProductModel()->ProductModel{
        var item : ProductModel!
        let file = dataFileForName(name: fileName)
        
        if !FileManager.default.fileExists(atPath: file){
            return ProductModel()
        }
        
        if let data = try? Data(contentsOf: URL(fileURLWithPath: file)){
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            item = unarchiver.decodeObject(forKey: dataKey) as! ProductModel!
            unarchiver.finishDecoding()
        }
        return item
    }
    
    func saveProductModel(_ items : ProductModel){
        let file = dataFileForName(name: fileName)
        let data = NSMutableData()
        
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: dataKey)
        archiver.finishEncoding()
        data.write(toFile: file, atomically: true)
    }
    
    func dataFileForName(name: String)->String{
        return (documentPath() as NSString).appendingPathComponent(fileName)
    }
    
    func documentPath()->String{
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return allPaths[0]
    }

}
