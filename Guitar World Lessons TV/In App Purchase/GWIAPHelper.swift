//
//  GWIAPHelper.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 11/17/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import UIKit

class GWIAPHelper: IAPHelper {
    class var sharedInstance: GWIAPHelper {
        // TODO: rewrite this singleton
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: GWIAPHelper? = nil
        }
        dispatch_once(&Static.onceToken) {
            let productIdentifiers = getProductIdsOniTunesConnect()
            Static.instance = GWIAPHelper(withProductIdentifiers: Set(productIdentifiers))
        }
        return Static.instance!
    }

}
