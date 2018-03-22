//
//  ProductModel.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 24.05.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit

class ProductModel: NSObject, NSCoding {
    
    fileprivate var model = ProductDataSingleton.sharedInstance
    fileprivate let modelKey = "model"
    
    override init(){
        super.init()
    }
    
    func numberOfEntries()->Int{
        return model.products.count
    }
    
    func append(element: ProductEntry){
        model.products.append(element)
    }
    
    func getElement(at position: Int)->ProductEntry{
        return model.products[position]
    }
    
    func set(element: ProductEntry, at: Int){
        model.products[at] = element
    }
    
    func remove(at i: Int){
        model.products.remove(at: i)
    }
    
    func getAllElements()->[ProductEntry]{
        return model.products
    }
    
    func overwriteProducts(savedProducts : [ProductEntry]){
        model.products = savedProducts
    }

    func removeElement(withCode code:String){
        
        let element = getElement(forEAN: code)
        if let index = model.products.index(of: element){
            model.products.remove(at: index)
        }
    }
    
    func getElement(forEAN ean : String) -> ProductEntry{
        let element = model.products.first(where: { $0.mReceivedCode == ean})!
        return element
    }
    
    func addBarcodeImage(toProduct ean : String, image : UIImage){
        let element = getElement(forEAN: ean)
        element.mBarcode = image
    }
    
    func overwriteElement(forEAN ean : String, element: ProductEntry){
        let oldProduct = getElement(forEAN: ean)
        var newBarcode : UIImage?
        if let barcode = oldProduct.mBarcode{
            newBarcode = barcode
        }
        removeElement(withCode: ean)
        append(element: element)
        addBarcodeImage(toProduct: ean, image: newBarcode!)
    }
    
    
    
    //Persistenz - Hier eigentlich unnötig, genügt [ProductEntry] abzuspeichern
    required init?(coder aDecoder: NSCoder) {
        super.init()
        doDecoding(aDecoder)
    }
    
    fileprivate func doDecoding(_ aDecoder : NSCoder){
        model = aDecoder.decodeObject(forKey: modelKey) as! ProductDataSingleton
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(model, forKey: modelKey)
    }

}

fileprivate class ProductDataSingleton: NSObject, NSCoding{
    
    fileprivate let productsKey = "products"
    static let sharedInstance = ProductDataSingleton()
    fileprivate var products : [ProductEntry] = [ProductEntry.init(aCompany: "Testhersteller", aShortDescription: "Testbeschreibung", aType: "Test-Typ", aPrice: "999", aCode: "1234567", aDescription: "Testbeschreibung", aBarcode: nil)]
    
    override init(){
        super.init()
    }
    
    //Persistenz
    required init?(coder aDecoder: NSCoder) {
        super.init()
        doDecoding(aDecoder)
    }
    
    fileprivate func doDecoding(_ aDecoder : NSCoder){
        products = aDecoder.decodeObject(forKey: productsKey) as! [ProductEntry]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(products, forKey: productsKey)
    }
}

class ProductEntry: NSObject, NSCoding{
    
    var mCompany : String = ""
    var mShortDescription : String = ""
    var mDescription : String?
    var mType : String = ""
    var mPrice : String = ""
    var mReceivedCode : String = ""
    var mBarcode : UIImage?
    
    fileprivate let companyKey = "companyKey"
    fileprivate let shortDescKey = "shortDescKey"
    fileprivate let descKey = "descKey"
    fileprivate let typeKey = "typeKey"
    fileprivate let priceKey = "priceKey"
    fileprivate let codeKey = "codeKey"
    fileprivate let imageKey = "imageKey"
    
    
    init(aCompany : String, aShortDescription : String, aType : String, aPrice : String, aCode : String, aDescription : String?, aBarcode : UIImage?) {
        mCompany = aCompany
        mShortDescription = aShortDescription
        mType = aType
        mPrice = aPrice
        mReceivedCode = aCode
        mDescription = aDescription
        mBarcode = aBarcode
    }
    
    //ProductEntry aus JSON-String
    init?(withJson : [String:Any], withCode: String){
        
        guard let product = withJson["product"] as? [String : Any],
        let attributes = product["attributes"] as? [String: Any],
        let companyInfos = withJson["company"] as? [String: Any],
        let desc = attributes["long_desc"] as? String,
        let companyName = companyInfos["name"] as? String,
        let productName = attributes["product"] as? String
        else{
            return nil
        }
        
        let price = attributes["price_new"] as? String
        
        if let price = price{
            mPrice = price
        }else{
            mPrice = "0.0000"
        }
 
        mCompany = companyName
        mShortDescription = productName
        mDescription = desc
        //mPrice = price
        mReceivedCode = withCode
        mType = "UserChoice"
        mBarcode = nil
        
    }
    
    override init(){
        super.init()
    }
    
    
    //Persistenz
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.doDecoding(aDecoder)
    }
    
    
    fileprivate func doDecoding(_ aDecoder : NSCoder){
        mCompany = aDecoder.decodeObject(forKey: companyKey) as! String
        mShortDescription = aDecoder.decodeObject(forKey: shortDescKey) as! String
        mDescription = aDecoder.decodeObject(forKey: descKey) as! String?
        mType = aDecoder.decodeObject(forKey: typeKey) as! String
        mPrice = aDecoder.decodeObject(forKey: priceKey) as! String
        mReceivedCode = aDecoder.decodeObject(forKey: codeKey) as! String
        mBarcode = aDecoder.decodeObject(forKey: imageKey) as! UIImage?
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(mCompany, forKey: companyKey)
        aCoder.encode(mShortDescription, forKey: shortDescKey)
        aCoder.encode(mDescription, forKey: descKey)
        aCoder.encode(mType, forKey: typeKey)
        aCoder.encode(mPrice, forKey: priceKey)
        aCoder.encode(mReceivedCode, forKey: codeKey)
        aCoder.encode(mBarcode, forKey: imageKey)
        
    }
 
    
}



/* FÜR STRUCT NOTWENDIG -> mit Swift 4 hinfällig
extension ProductEntry{
    class HelperClass: NSObject, NSCoding{
        
        fileprivate let companyKey = "companyKey"
        fileprivate let shortDescKey = "shortDescKey"
        fileprivate let descKey = "descKey"
        fileprivate let typeKey = "typeKey"
        fileprivate let priceKey = "priceKey"
        fileprivate let codeKey = "codeKey"
        fileprivate let imageKey = "imageKey"
        
        var productEntry : ProductEntry?
        
        init(entry: ProductEntry) {
            super.init()
            self.productEntry = entry
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
            self.doDecoding(aDecoder)
        }
        
        func doDecoding(_ aDecoder : NSCoder){
            let aCompany = aDecoder.decodeObject(forKey: companyKey) as! String
            let aShortDescription = aDecoder.decodeObject(forKey: shortDescKey) as! String
            let aDescription = aDecoder.decodeObject(forKey: descKey) as! String?
            let aType = aDecoder.decodeObject(forKey: typeKey) as! String
            let aPrice = aDecoder.decodeObject(forKey: priceKey) as! String
            let aReceivedCode = aDecoder.decodeObject(forKey: codeKey) as! String
            let aBarcode = aDecoder.decodeObject(forKey: imageKey) as! UIImage?
            
            productEntry = ProductEntry(aCompany: aCompany, aShortDescription: aShortDescription, aType: aType, aPrice: aPrice, aCode: aReceivedCode, aDescription: aDescription, aBarcode: aBarcode)
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(productEntry!.mCompany, forKey: companyKey)
            aCoder.encode(productEntry!.mShortDescription, forKey: shortDescKey)
            aCoder.encode(productEntry!.mDescription, forKey: descKey)
            aCoder.encode(productEntry!.mType, forKey: typeKey)
            aCoder.encode(productEntry!.mPrice, forKey: priceKey)
            aCoder.encode(productEntry!.mReceivedCode, forKey: codeKey)
            aCoder.encode(productEntry!.mBarcode, forKey: imageKey)
        }
        
    }
 
}
 */
