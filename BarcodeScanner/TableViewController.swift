//
//  ViewController.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 08.05.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//

import UIKit
import AVFoundation

class TableViewController: UITableViewController, SearchCallbackReceiver, AddNewProductProtocol {
    
    var dataSource : UITableViewDataSource!
    var delegate : UITableViewDelegate!
    var contentCtrl : ContentController!
    
    let searchCtrl = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dataSource = ProductTableViewDataSource(callbackReceiver: self)
        delegate = ProductTableViewDelegate()
        
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        contentCtrl = ContentController()
        
        //SearchBar
        searchCtrl.searchResultsUpdater = dataSource as! UISearchResultsUpdating?
        searchCtrl.searchBar.delegate = dataSource as! UISearchBarDelegate?
        searchCtrl.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = false
        searchCtrl.searchBar.scopeButtonTitles = ["All", "Products", "Coupons", "Links"]
        searchCtrl.hidesNavigationBarDuringPresentation = false
        
        tableView.tableHeaderView = searchCtrl.searchBar
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        contentCtrl.loadSavedData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchCtrl.isActive = false
        
        if segue.identifier == "Display2Add"{
            let destVC = segue.destination as! AddProductViewController
            destVC.delegate = self
        }else if segue.identifier == "Display2Details"{
            let cell = tableView.cellForRow(at: tableView.indexPathForSelectedRow!) as! ProductTableViewCell
            let entry = contentCtrl.getProductEntry(forEAN: cell.code.text!)
            let destVC = segue.destination as! ShowDetailsViewContoller
            destVC.item = entry
        }
    }

    //New Data saved
    func handleNewData(ctrl: AddProductViewController) {
        ctrl.navigationController!.popViewController(animated: true)
        tableView.reloadData()
    }
    
    //Refresh while searching
    func updateTableViewWithSearchResults() {
        tableView.reloadData()
    }


}

