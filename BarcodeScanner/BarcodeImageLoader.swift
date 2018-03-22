//
//  BarcodeImageLoader.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 25.06.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit

class BarcodeImageLoader: NSObject {
    
    var networkCtrl = NetworkController()
    var networkData = DataElement()
    var downloadedImageReceiver : DownloadedImageProtocol!
    var notifyStr : String = ""
    
    func fetchImage(forCode: String){
        
        let urlString = createURL(forCode: forCode)
        let url = urlString.url!
        networkData.addObserver(self, forKeyPath: "data", options: NSKeyValueObservingOptions(), context: nil)
        networkCtrl.getData(from: url.absoluteString, storeAt: networkData)
    }
    
    
    func createURL(forCode : String)->URLComponents{
        var uc = URLComponents()
        uc.scheme = "http"
        uc.host = "eandata.com"
        uc.path = "/image/\(forCode).png"
        print("ImagePath: \(uc)")
        return uc
    }
    
    func extractImage(){
        let image = UIImage(data: networkData.data)
        let resizedImage = resizeBarcode(image: image!)
        if resizedImage != nil{
            print("ExtractedImage")
            downloadedImageReceiver.receiveImage(image: resizedImage)
        }else{
            print("Image is nil")
            downloadedImageReceiver.receiveImage(image: nil)
        }
    }
    
    func resizeBarcode(image: UIImage)->UIImage?{
        let newSize = CGSize(width: image.size.width * 2, height: image.size.height * 2)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        extractImage()
    }
    
    func generateQRCode(forLink link:String, inView: UIView)->UIImage{
        let data = link.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        let ciImage = filter?.outputImage
        
        return fixBlur(forImage: ciImage!, inView: inView)
        
    }
    
    func fixBlur(forImage image: CIImage, inView : UIView)->UIImage{
        let scaleX = (inView.frame.size.width / 3) / image.extent.size.width
        let scaleY = (inView.frame.size.width / 3) / image.extent.size.height
        
        
        let transformedImage = image.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        let uiImage = UIImage(ciImage: transformedImage)
        
        UIGraphicsBeginImageContext(uiImage.size)
        uiImage.draw(at: CGPoint.zero)
        
        let redraw = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        let pngRep = UIImagePNGRepresentation(redraw!)
        
        let resultImage = UIImage(data: pngRep!)
        
        return resultImage!
    }
    
    
}
