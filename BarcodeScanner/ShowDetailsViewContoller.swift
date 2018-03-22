//
//  ShowDetailsViewContoller.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 01.06.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit

class ShowDetailsViewContoller: UIViewController, DownloadedImageProtocol, EnterDetailProtocol {
    
    var item : ProductEntry!
    
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var shortDescLabel: UILabel!
    @IBOutlet weak var fullDescLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var codeLabel: UITextView!
    @IBOutlet weak var barcodeImage: UIImageView!
    @IBOutlet weak var generateBarcodeButton: UIButton!
    @IBOutlet weak var editButton: UIBarButtonItem!

    
    let imageDownloadCtrl = BarcodeImageLoader()
    var loadingIndicatorCtrl : LoadingIndicatorController!
    var persistencyManager : PersistencyManager!
    let errors = ErrorReaction.sharedErrorInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errors.addObserver(self, forKeyPath: "errorHappened", options: NSKeyValueObservingOptions(), context: nil)
        
        companyLabel.text = item.mCompany
        shortDescLabel.text = item.mShortDescription
        fullDescLabel.text = item.mDescription
        valueLabel.text = item.mPrice
        codeLabel.text = item.mReceivedCode
        
        
        
        print("Barcode: \(item.mBarcode?.size.height)")
        if item.mBarcode != nil{
            barcodeImage.image = item.mBarcode
            generateBarcodeButton.isEnabled = false
            
        }else{
            barcodeImage.image = UIImage(named: "nothingtodisplay")
            
        }
        
        let tapListener = UITapGestureRecognizer(target: self, action: #selector(openImageView))
        barcodeImage.addGestureRecognizer(tapListener)
        barcodeImage.isUserInteractionEnabled = true
        
    }
    
    func openImageView(){
        
        if barcodeImage.image != #imageLiteral(resourceName: "nothingtodisplay"){
            let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BarcodeViewController") as! ShowBarcodeViewController
            
            destVC.image = barcodeImage.image
            
            self.navigationController?.pushViewController(destVC, animated: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func generateBarcode(_ sender: UIButton) {
        imageDownloadCtrl.downloadedImageReceiver = self
        
        loadingIndicatorCtrl = LoadingIndicatorController(view)
        loadingIndicatorCtrl.startLoadingIndicator()
        
        if item.mType != "Link"{
            imageDownloadCtrl.fetchImage(forCode: item.mReceivedCode)
        }else{
            let qrCode = imageDownloadCtrl.generateQRCode(forLink: item.mReceivedCode, inView: view)
            barcodeImage.image = qrCode
            addImageToItem(image: qrCode)
            loadingIndicatorCtrl.stopLoadingIndicator()
            generateBarcodeButton.isEnabled = false
        }
    }
    
    func receiveImage(image: UIImage?) {
        if let image = image{
            barcodeImage.image = image
            addImageToItem(image: image)
            generateBarcodeButton.isEnabled = false
        }else{
            print("receivedImage nil")
        }
        
        loadingIndicatorCtrl.stopLoadingIndicator()
    }
    
    func addImageToItem(image:UIImage){
        
        persistencyManager = PersistencyManager()
        let model = ProductModel()
        model.addBarcodeImage(toProduct: item.mReceivedCode, image: image)
        persistencyManager.saveProductModel(model)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show2Edit"{
            let destVC = segue.destination as! EnterDetailsViewController
            destVC.downloadedProduct = item
            destVC.editMode = true
            destVC.delegate = self
        }
    }
    
    func detailsAccepted(ctrl: EnterDetailsViewController) {
        ctrl.navigationController!.popViewController(animated: true)
        self.navigationController!.popViewController(animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "errorHappened"{
            self.loadingIndicatorCtrl.stopLoadingIndicator()
            let alert = errors.showError(inView: editButton, completion: {() -> Void in
                //self.loadingIndicatorCtrl.stopLoadingIndicator()
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
