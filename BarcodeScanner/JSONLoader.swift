//
//  JSONLoader.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 22.06.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit
import Foundation

class JSONLoader: NSObject {
    
    var scannedCode = ""
    var networkCtrl = NetworkController()
    var networkData = DataElement()
    var downloadedProductReceiver : DownloadedProductProtocol!
    
    
    
    func fetchData(forCode : String){
        var urlString = createBaseUrl()
        let ean = URLQueryItem(name: "find", value: forCode)
        var newQueryItems = urlString.queryItems
        newQueryItems?.append(ean)
        urlString.queryItems = newQueryItems
        
        let url = urlString.url!
        
        
        scannedCode = forCode
        networkData.addObserver(self, forKeyPath: "data", options: NSKeyValueObservingOptions(), context: nil)
        networkCtrl.getData(from: url.absoluteString, storeAt: networkData)
    }
    
    
    fileprivate func createBaseUrl() -> URLComponents
    {
        var uc = URLComponents()
        uc.scheme = "http"
        uc.host = "eandata.com"
        uc.path = "/feed/"
        
        let version = URLQueryItem(name: "v", value: "3")
        let keycode = URLQueryItem(name: "keycode", value: "8351016C592EC934")
        let mode = URLQueryItem(name: "mode", value: "json")
        
        uc.queryItems = [version, keycode, mode]
        print("\(uc)")
        return uc
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("Observed networkData")
        extractJson(withCode: scannedCode)
        scannedCode = ""
    }
    
    func extractJson(withCode : String){
        guard let json = try? JSONSerialization.jsonObject(with: networkData.data, options: []) as? [String: Any] else {return}
        
        //print("JSON-Object: \(json)")
        
        let newEntry = ProductEntry(withJson: json!, withCode: withCode)
        
        if let newEntry = newEntry{
            downloadedProductReceiver.receiveProduct(product: newEntry)
        }else{
            downloadedProductReceiver.receiveProduct(product: ProductEntry())
        }
        
        networkData.removeObserver(self, forKeyPath: "data")
        
    }
}

class DataElement: NSObject {
    dynamic var data = Data()
}


