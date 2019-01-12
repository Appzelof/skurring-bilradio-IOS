//
//  RadioList.swift
//  Skurring
//
//  Created by Daniel Bornstedt on 20.02.2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit


class RadioListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TheSearchBar: UISearchBar!
    var arrayList = radioInformation.theStationObjects
    var filteredArrayList = radioInformation.theFilteredStationsObjects
    
    var inSearchMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.TheSearchBar.delegate = self
        self.TheSearchBar.returnKeyType = .done
    }
    
    //SearchBarMetoder
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.TheSearchBar.text != "" {
            self.inSearchMode = true
            self.TheSearchBar.setShowsCancelButton(true, animated: true)
            let lower = self.TheSearchBar.text!.lowercased()
            filteredArrayList = radioInformation.theStationObjects.filter({ $0.radioSearchName.range(of: lower) != nil})
            self.tableView.reloadData()
        } else {
            self.inSearchMode = false
            self.TheSearchBar.setShowsCancelButton(true, animated: true)
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.TheSearchBar.text = ""
        self.TheSearchBar.delegate?.searchBar!(self.TheSearchBar, textDidChange: self.TheSearchBar.text!)
        self.TheSearchBar.setShowsCancelButton(false, animated: true)
        self.TheSearchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.TheSearchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.scrollToTop()
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.TheSearchBar.resignFirstResponder()
    }

    
    //ScrollViewMetode for å legge ned tastaturet hvis brukeren scroller
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.TheSearchBar.setShowsCancelButton(false, animated: true)
        self.TheSearchBar.resignFirstResponder()
    }
    
    
    //TableViewMetoder
    
    //Her i denne didSelectRowAt funksjonen så bruker jeg actionInt for å bytte verdien i objektet som ble klikket på.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var index: RadioPlayer!
        
        if !inSearchMode {
            index = arrayList[indexPath.row]
        } else {
            index = filteredArrayList[indexPath.row]
        }
        
        let Object = MainScreenRadioObjects.init(image: index.imgPNG, URL: index.radioStream, radioInfo: index.radioINFO)
        MainScreenRadioObjects.mainScreenRadioObjectsArray[actionInt] = Object
        
        saveData()
        self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !inSearchMode {
            return arrayList.count
        } else {
            return filteredArrayList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index: RadioPlayer!
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as? RadioInfoCell{
            
            if !inSearchMode {
                index = arrayList[indexPath.row]
                cell.updateUI(information: index)
            } else {
                index = filteredArrayList[indexPath.row]
                cell.updateUI(information: index)
            }
            return cell
        } else {
            return RadioInfoCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        /*
            Lager tilbakeknapp programatisk.
            Denne koden lager en knapp med action med å legge ned viewcontrolleren.
            Knappen blir lagt til footeren på tableviewet.
         */
       
        let bkButon = UIButton.init(frame: view.bounds)
        bkButon.backgroundColor = UIColor.white
        bkButon.setImage(UIImage(named: "down"), for: .normal)
        bkButon.imageView?.contentMode = .scaleAspectFit
        bkButon.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return bkButon
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func scrollToTop() {
        self.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
    }
    
    @objc private func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
