//
//  ActivityIndicatorViewController.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 12/8/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import UIKit

class ActivityIndicatorViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorGrayBackgroundView: UIView!
    
    var message = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = message

        activityIndicator.startAnimating()
        activityIndicatorGrayBackgroundView.layer.cornerRadius = 10
    }
    
    override func viewDidDisappear(animated: Bool) {
        ND.removeObserver(self, name: NOTIFICATION_PRODUCTS_ON_ITUNES_CONNECTED_LOADED, object: nil)
        ND.removeObserver(self, name: NOTIFICATION_FINILIZE_PURCHASE, object: nil)
        
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        ND.addObserver(self, selector: "dismissSelf:", name: NOTIFICATION_PRODUCTS_ON_ITUNES_CONNECTED_LOADED, object: nil)
        ND.addObserver(self, selector: "dismissSelf:", name: NOTIFICATION_FINILIZE_PURCHASE, object: nil)
        ND.addObserver(self, selector: "dismissSelf:", name: NOTIFICATION_FAILED_PURCHASE, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        activityIndicator.stopAnimating()
    }

    
    func dismissSelf(notification: NSNotification) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
}
