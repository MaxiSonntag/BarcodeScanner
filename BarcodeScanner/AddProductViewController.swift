//
//  AddProductViewController.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 31.05.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit
import AVFoundation

class AddProductViewController: UIViewController, EnterDetailProtocol, CaptureMetadataCallback, DownloadedProductProtocol {
    
    
    @IBOutlet weak var eanField: UITextField!
    @IBOutlet weak var typeSelection: UISegmentedControl!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var delegate : AddNewProductProtocol!
    
    let capturingCtrl = VideoCapturingContoller()
    let jsonCtrl = JSONLoader()
    var loadingIndicatorCtrl : LoadingIndicatorController!
    
    
    var downloadedProduct : ProductEntry?
    var downloadedInformation = false
    
    
    let errors = ErrorReaction.sharedErrorInstance
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errors.addObserver(self, forKeyPath: "errorHappened", options: NSKeyValueObservingOptions(), context: nil)
        
        // Do any additional setup after loading the view.
        capturingCtrl.captureDelegate.callback = self
        jsonCtrl.downloadedProductReceiver = self
        loadingIndicatorCtrl = LoadingIndicatorController(view)
        
        capturingCtrl.mainView = view
        capturingCtrl.startCapturing()
        
        typeSelection.backgroundColor = UIColor.white
        
        view.bringSubview(toFront: eanField)
        view.bringSubview(toFront: typeSelection)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    func receiveProduct(product: ProductEntry) {
        print("Product received")
        
        downloadedProduct = product
        loadingIndicatorCtrl.stopLoadingIndicator()
        downloadedInformation = true
        performSegue(withIdentifier: "Add2Enter", sender: nil)
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        if eanField.text != ""{
            if typeSelection.titleForSegment(at: typeSelection.selectedSegmentIndex) == "Product"{
                showAlert(sender: sender)
                
            }else{
                downloadedInformation = false
                performSegue(withIdentifier: "Add2Enter", sender: nil)
            }
        }
    }
    
    
    
    func showAlert(sender: UIBarButtonItem){
        let actionSheetCtrl = UIAlertController(title: "Download", message: "Would you like\nto download product info?", preferredStyle: .actionSheet)
        
        
        let noAction = UIAlertAction(title: "No thanks", style: .cancel) { action -> Void in
            self.downloadedInformation = false
            self.performSegue(withIdentifier: "Add2Enter", sender: nil)
        }
        actionSheetCtrl.addAction(noAction)
        
        
        let yesAction = UIAlertAction(title: "Yes please", style: .default){ action -> Void in
            self.loadingIndicatorCtrl.startLoadingIndicator()
            self.jsonCtrl.fetchData(forCode: self.eanField.text!)
            
        }
        
        
        actionSheetCtrl.addAction(yesAction)
        
        let popover = actionSheetCtrl.popoverPresentationController
        popover?.barButtonItem = sender
        
        self.present(actionSheetCtrl, animated: true){() -> Void in
            print("presenting alert")
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Add2Enter"{
            let destVC = segue.destination as! EnterDetailsViewController
            
            destVC.delegate = self
            
            if downloadedInformation == false{
                let emptyProduct = ProductEntry()
                emptyProduct.mType = typeSelection.titleForSegment(at: typeSelection.selectedSegmentIndex)!
                emptyProduct.mReceivedCode = eanField.text!
                destVC.downloadedProduct = emptyProduct
            }else{
                downloadedProduct?.mType = typeSelection.titleForSegment(at: typeSelection.selectedSegmentIndex)!
                downloadedProduct?.mReceivedCode = eanField.text!
                destVC.downloadedProduct = downloadedProduct
            }
            
            downloadedInformation = false
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if errors.errorType == ErrorTypes.networkingError{
            self.loadingIndicatorCtrl.stopLoadingIndicator()
        }
        
        let alertCtrl = errors.showError(inView: doneButton, completion: {() -> Void in
            self.navigationController!.popViewController(animated: true)
        })
        
        self.present(alertCtrl, animated: true){() -> Void in
            print("Presenting Error")
        }
    }
    
    //EnterDetailProtocol-Methode
    func detailsAccepted(ctrl: EnterDetailsViewController) {
        ctrl.navigationController!.popViewController(animated: true)
        delegate.handleNewData(ctrl: self)
    }
    
    
    //CaptureMetadataCallback-Methoden
    func setEANField(text: String) {
        eanField.text = text
    }
    
}
