//
//  ProductTableViewDataSource.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 24.05.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit

class ProductTableViewDataSource: NSObject, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate{
    fileprivate let products : ProductModel = ProductModel()
    var originalProducts : [ProductEntry]!
    var filteredProducts : [ProductEntry]!
    var callback : SearchCallbackReceiver!
    var originalProductsSet : Bool = false
    var table : UITableView!
    
    init(callbackReceiver : SearchCallbackReceiver) {
        callback = callbackReceiver
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.numberOfEntries()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ProductTableViewCell
        let index = indexPath.row
        let entry = products.getElement(at: index)
        
        cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell")! as! ProductTableViewCell
        
        cell.hersteller.text = entry.mCompany
        cell.typ.text = entry.mType
        cell.kurzbeschreibung.text = entry.mShortDescription
        cell.wert.text = "\(entry.mPrice)"
        cell.code.text = "\(entry.mReceivedCode)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let cell = tableView.cellForRow(at: indexPath) as! ProductTableViewCell
            //LÖSCHEN MIT EAN
            products.removeElement(withCode: cell.code.text!)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            let contentCtrl = ContentController()
            contentCtrl.saveData()
        }
    }
    
    
    //SUCHE
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filter(searchText: searchBar.text!, scope: scope)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filter(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func filter(searchText : String, scope: String = "All"){
        // products Model wird erst aus gespeicherten datan geladen, wenn tabelle angezeigt wird -> in init methode noch leer
        // hier: einmaliges setzen der originalProducts, um als "default" model gesamte Liste zu haben
        if originalProductsSet == false{
            originalProducts = products.getAllElements()
            originalProductsSet = true
        }
        
        //wenn Suche leer -> originalProducts (also alle Produkte) anzeigen
        if searchText == "" && scope == "All"{
            products.overwriteProducts(savedProducts: originalProducts)
        }
            //wenn Suche nicht leer -> alle Produkte filtern und diese anzeigen
        else{
            if searchText != ""{
                filteredProducts = products.getAllElements().filter({ $0.mShortDescription.lowercased().contains(searchText.lowercased()) && isType(entry: $0, type: scope) ||
                    $0.mCompany.lowercased().contains(searchText.lowercased()) && isType(entry: $0, type: scope)})
                products.overwriteProducts(savedProducts: filteredProducts)
            }
            else{
                products.overwriteProducts(savedProducts: originalProducts)
                filteredProducts = products.getAllElements().filter({isType(entry: $0, type: scope)})
                products.overwriteProducts(savedProducts: filteredProducts)
            }
            
        }
        
        callback.updateTableViewWithSearchResults()
    }
    
    
    fileprivate func isType(entry: ProductEntry, type: String)->Bool{
        switch type {
        case "Products":
            return entry.mType == "Product"
        case "Coupons":
            return entry.mType == "Coupon"
        case "Links":
            return entry.mType == "Link"
        default:
            return true
        }
    }
    
    //Zurücksetzen des Models beim Beenden der Suche
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.selectedScopeButtonIndex = 0
    }
    
    

}
