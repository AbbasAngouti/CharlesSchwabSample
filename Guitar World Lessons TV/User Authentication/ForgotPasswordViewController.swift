//
//  ForgotPasswordViewController.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 11/13/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func submitButtonTapped(sender: UIButton) {
        let email = emailTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        guard email.length() > 0 else {
            self.errorLabel.hidden = false
            self.errorLabel.text = "Email address can't be empty."
            return
        }
        if (!isAValidEmail(email)) {
            errorLabel.hidden = false
            errorLabel.text = "Invalid email address."
        } else {
            self.errorLabel.text = ""
            
            requestForPasswordReset(email, success: { (success) -> () in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.errorLabel.text = success["message"]!
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        
                    })
                })
                }, failure: { (failure) -> () in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.errorLabel.text = failure
                    })
            })
        }
    }
}
