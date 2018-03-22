//
//  EnterDetailsViewController.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 31.05.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit

class EnterDetailsViewController: UIViewController {
    
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var shortDescription: UITextField!
    @IBOutlet weak var valuePicker: UIPickerView!
    @IBOutlet weak var fullDescription: UITextField!
    @IBOutlet weak var receivedCode: MyTextField!
    
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var shortDescLabel: UILabel!
    
    var valuePickerDataSource : ValuePickerDataSource!
    var valuePickerDelegate : ValuePickerDelegate!
    
    var downloadedProduct : ProductEntry?
    
    var delegate : EnterDetailProtocol!
    var scannedCode : String!
    var type : String!
    
    var editMode = false //true if accessed from ShowDetailsViewController
    
    let enterDetailsController = EnterDetailsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receivedCode.text = downloadedProduct?.mReceivedCode
        type = downloadedProduct?.mType
        valuePickerDelegate = valuePicker.delegate as! ValuePickerDelegate!
        valuePickerDataSource = valuePicker.dataSource as! ValuePickerDataSource!
        
        if downloadedProduct?.mCompany != ""{
            insertDownloadedData()
        }else{
            companyName.text = "No information recived"
        }
        // Do any additional setup after loading the view.
    }
    
    
    //Insert existing Information
    func insertDownloadedData(){
        companyName.text = downloadedProduct?.mCompany
        shortDescription.text = downloadedProduct?.mShortDescription
        fullDescription.text = downloadedProduct?.mDescription
        setValuePicker(value: (downloadedProduct?.mPrice)!)
    }
    
    func setValuePicker(value : String){
        
        var list = enterDetailsController.getPriceArray(value: value, editMode: editMode)
        
        var component = 5
        
        for pos in 0..<list.count{
            let row = Int(String(list[pos]))
            
            if component == 3 {
                component = 2
            }
            
            valuePicker.selectRow(row!, inComponent: component, animated: false)
            component -= 1
        }
    }
    
    //Extract Picker-Value as String
    private func getValueFromPicker()->String{
        var resValue = ""
        var onlyZero = true
        for i in 0..<valuePicker.numberOfComponents {
            let str = valuePickerDataSource.getData(for: i, in: valuePicker.selectedRow(inComponent: i))
            if !onlyZero{
                resValue.append(str)
            }else if str != "0" && onlyZero{
                onlyZero = false
                resValue.append(str)
            }
        }
        
        if resValue[resValue.startIndex] == ","{
            var leadingZero = ""
            for pos in 0..<resValue.characters.count{
                if pos == 0{
                    leadingZero.append("0")
                }else{
                    leadingZero.append(resValue[resValue.index(resValue.startIndex, offsetBy: pos-1)])
                }
            }
            leadingZero.append(resValue[resValue.index(before: resValue.endIndex)])
            resValue = leadingZero
        }
        return resValue
    }
    
    
    func checkInput()->Bool{
        if companyName.text == ""{
            companyLabel.textColor = UIColor.red
            return false
        }else if shortDescription.text == ""{
            shortDescLabel.textColor = UIColor.red
            return false
        }
        return true
    }
    
    func setTextColorNormal(){
        valueLabel.textColor = UIColor.black
        companyLabel.textColor = UIColor.black
        shortDescLabel.textColor = UIColor.black
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        setTextColorNormal()
        if checkInput(){
            enterDetailsController.saveDetails(aCompany: companyName.text!, aShortDescription: shortDescription.text!, aDescription: fullDescription.text, aType: type, aValue: getValueFromPicker(), aCode: receivedCode.text!, aBarcode: nil, editMode: editMode)
            delegate.detailsAccepted(ctrl: self)
        }
    }
}
