//
//  RadioListLoadingVIew.swift
//  Skurring
//
//  Created by Marius Fagerhol on 17/01/2019.
//  Copyright © 2019 Appzelof. All rights reserved.
//

import UIKit

class RadioListLoadingView: UIView {
    
    /* Dette er viewet som brukes for å vise at data laster på RadioListVC */
    
    @IBOutlet weak var loadingLbl: UILabel!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /* Når firebase data laster inn så blir viewt animert til å vises */
    
    func isLoading() {
        loadingActivity.startAnimating()
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.isHidden = false
        }
    }
    
    /* Når dataen er lastet ned så animeres viewet opp altså vekk */
    
    func finishedLoading() {
        loadingActivity.stopAnimating()
        UIView.animate(withDuration: 0.05, animations: {
            self.alpha = 0
        }) { (finished) in
            if finished {
                UIView.animate(withDuration: 0.15, animations: {
                    self.isHidden = true
                }, completion: nil)
            }
        }
    }
    
    
    
}
