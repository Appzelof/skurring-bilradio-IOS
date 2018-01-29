//
//  CarPlateVC.swift
//  Skurring
//
//  Created by Daniel Bornstedt on 11/09/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit

class CarPlateVC: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        loadPage()
    }
    
    func loadPage() {
        let link = "https://www.vegvesen.no/kjoretoy/Kjop+og+salg/Kjøretøyopplysninger"
        let url = URL(string: link)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
}
