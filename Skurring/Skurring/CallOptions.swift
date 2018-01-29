//
//  CallOptions.swift
//  Skurring
//
//  Created by Marius Fagerhol on 21/11/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit

struct Options {
    var companyImage = ""
    var number = ""
    var phoneImage = ""
}

class CallOptions {
    let phoneImage = "blackPhone"
    
    public func getVeiHelp() -> [Options] {
        return [Options.init(companyImage: "Naf", number: "tel://08505", phoneImage: phoneImage), Options.init(companyImage: "VikingLogo", number: "tel://06000", phoneImage: phoneImage), Options.init(companyImage: "Falck", number: "tel://02222", phoneImage: phoneImage)]
    }
    
    public func getNødHjelp() -> [Options] {
        return [Options.init(companyImage: "logo", number: "tel://110", phoneImage: phoneImage), Options.init(companyImage: "POLITIET1", number: "tel://112", phoneImage: phoneImage), Options.init(companyImage: "ambulanse", number: "tel://113", phoneImage: phoneImage)]
    }
    
}
