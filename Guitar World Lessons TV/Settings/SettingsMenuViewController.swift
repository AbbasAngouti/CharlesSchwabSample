//
//  SettingsMenuViewController.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 11/19/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import UIKit

class SettingsMenuViewController: MenuTableViewController {

    override var segueIdentifierMap: [[String]] {
        return [
            [
                "pushHelp",
                "pushLogin",
                "pushRecoverPassword",
                "pushRestoreYourPurchases"
            ]
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

}
