//
//  LoginViewController.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 11/6/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAccountLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotPwdButton: UIButton!
    
    var loggedInView = UIView()
    var logoutButton = UIButton()
    var messageTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if loggedIn() {
            self.showLoggedIn()
        } else {
            showLogin()
        }
    }
    
    override var preferredFocusedView: UIView? {
        if loggedIn() {
            return logoutButton
        } else {
            return emailTextField
        }
    }
    
    // MARK: - Login password
    @IBAction func loginTapped(sender: UIButton) {
        guard let email = emailTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) where email.characters.count > 0 else {
            errorLabel.text = "Email is required!";
            return
        }
        
        guard let password = passwordTextField.text where password.characters.count > 0 else {
            errorLabel.text = "Password is required!";
            return
        }
        
        errorLabel.text = ""
        
        performLogin(email, password: password, success: { (result) -> () in
            setSession(result["session"]! as String)
            setUsername(email)
            setPassword(password)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if loggedIn() {
                    self.showLoggedIn()
                } else {
                    self.showLogin()
                }
            })
            }) { (message) -> () in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.errorLabel.text = message
                })
        }
    }
    
    // MARK: - Show Log In
    func showLogin() {
        self.loggedInView.removeFromSuperview()
        self.emailTextField.hidden = false
        self.passwordTextField.hidden = false
        self.loginButton.hidden = false
        self.errorLabel.hidden = false
        self.dontHaveAccountLabel.hidden = false
        self.registerButton.hidden = false
        self.forgotPwdButton.hidden = false
    }
    
    
    // MARK: - Show Logged In
    func showLoggedIn() {
        self.loggedInView.removeFromSuperview()
        
        self.emailTextField.hidden = true
        self.passwordTextField.hidden = true
        self.loginButton.hidden = true
        self.errorLabel.hidden = true
        self.dontHaveAccountLabel.hidden = true
        self.registerButton.hidden = true
        self.forgotPwdButton.hidden = true
        
        loggedInView = UIView(frame: CGRectMake(0, 0, 1280, 1080))
        loggedInView.backgroundColor = UIColor.clearColor()
        
        messageTextView = UITextView(frame: CGRectMake(70, 164, 1140, 190))
        messageTextView.font = UIFont.systemFontOfSize(46, weight: UIFontWeightMedium)
        messageTextView.text = "You are already logged in."
        messageTextView.userInteractionEnabled = false
        loggedInView.addSubview(messageTextView)
        
        logoutButton = UIButton(type: UIButtonType.System)
        logoutButton.frame = CGRectMake(506, 397, 225, 70)
        
        logoutButton.addTarget(self, action: "logoutTapped:", forControlEvents: UIControlEvents.PrimaryActionTriggered)
        logoutButton.setTitle("Log Out", forState: UIControlState.Normal)
        loggedInView.addSubview(logoutButton)
        
        self.view.addSubview(loggedInView)
        self.preferredFocusedView
    }
    
    func logoutTapped(_: AnyObject) {
        let title = NSLocalizedString("Warning!", comment: "")
        let message = NSLocalizedString("Are you sure you want to log out?", comment: "")
        let cancelButtonTitle = NSLocalizedString("No", comment: "")
        let deleteButtonTitle = NSLocalizedString("Yes", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Create the actions.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel) { _ in
            print("The \"Other\" alert's cancel action occurred.")
        }
        
        let deleteAction = UIAlertAction(title: deleteButtonTitle, style: .Destructive) { _ in
            print("Logged out!")
            setSession("")
            self.showLogin()
        }
        
        // Add the actions.
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}
