//
//  NetworkController.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 22.06.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit

class NetworkController: NSObject {
    
    let errorInstance = ErrorReaction.sharedErrorInstance
    
    func getData(from urlString : String, storeAt : DataElement){
        let url = URL(string: urlString)!
        let session = URLSession.shared
        let task = session.dataTask(with: url){
            data, response, error in
            DispatchQueue.main.async {
                print("Networking")
                
                if error != nil{
                    self.errorInstance.errorType = ErrorTypes.networkingError
                    return
                }
                if let data = data{
                    storeAt.data = data
                }
                
            }
            
        }
        task.resume()
        
    }
}
