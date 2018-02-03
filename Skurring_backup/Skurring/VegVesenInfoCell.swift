//
//  vegVesenInfoCell.swift
//  Skurring
//
//  Created by Marius Fagerhol on 09/11/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit

class VegVesenInfoCell: UITableViewCell {
    
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    
    func configureCell(vegTrafikkObject: VegvesenCollectionObject, attributeColor: UIColor, cachedDesc: NSMutableAttributedString? = nil, cachedTitle: NSMutableAttributedString? = nil) {
        if let cachedDesc = cachedDesc, let theCachedTitle = cachedTitle {
            descriptionTitle.attributedText = cachedDesc
            messageTitle.attributedText = theCachedTitle
        } else {
            giveMessageColor(message: vegTrafikkObject.getTitle.formatDescription(), messageLabel: messageTitle, color: attributeColor, notFormattedMessage: vegTrafikkObject.getTitle)
            giveTextColor(desc: vegTrafikkObject.getDesc.formatDescription(), descLabel: descriptionTitle, color: attributeColor, notformattedDesc: vegTrafikkObject.getDesc)
        }
    }
    
    
    private func giveTextColor(desc: String, descLabel: UILabel, color: UIColor, notformattedDesc: String) {
        let gjelderFra = "Gjelder fra"
        let gjelderTil = "Gjelder til"
        
        let rangeGjelderFra = (desc as NSString).range(of: gjelderFra)
        let attributeFra = NSMutableAttributedString.init(string: desc)
        attributeFra.addAttribute(NSForegroundColorAttributeName, value: color, range: rangeGjelderFra)
        
        let rangeGjelderTil = (desc as NSString).range(of: gjelderTil)
        let attributeTil = NSMutableAttributedString.init(attributedString: attributeFra)
        attributeTil.addAttribute(NSForegroundColorAttributeName, value: color, range: rangeGjelderTil)
        
        descLabel.attributedText = attributeTil
        
        SettingsVC.formatedVegTrafikkDesc.setObject(attributeTil, forKey: notformattedDesc as NSString)
        
    }
    
    private func giveMessageColor(message: String, messageLabel: UILabel, color: UIColor, notFormattedMessage: String) {
        let possibleRoadnames = ["Ev ", "Rv ", "Fv "]
        var attributedString: NSMutableAttributedString?
        var foundName = false
        for roadname in possibleRoadnames {
            if message.contains(roadname) {
                let range = (message as NSString).range(of: roadname)
                attributedString = NSMutableAttributedString.init(string: message)
                if let atrString = attributedString {
                    atrString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
                    messageLabel.attributedText = atrString
                    SettingsVC.formatedVegTrafikkTitle.setObject(atrString, forKey: notFormattedMessage as NSString)
                }
                foundName = true
                break
            }
        }
        if !foundName {
            messageLabel.text = message
            let attributedString = NSMutableAttributedString.init(string: message)
            SettingsVC.formatedVegTrafikkTitle.setObject(attributedString, forKey: notFormattedMessage as NSString)
        }
        
    }
}
