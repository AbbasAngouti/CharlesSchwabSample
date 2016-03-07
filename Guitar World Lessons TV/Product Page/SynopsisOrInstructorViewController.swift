//
//  SynopsisOrInstructorViewController.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 12/16/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import UIKit

class SynopsisOrInstructorViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var playOrPurchaseButton: UIButton!
    
    var parentVC: ProductViewController?
    
    var lesson: MyLibraryLessonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = lesson?.lessonDescription
        titleLabel.text = lesson?.title
        
        if loggedIn() && lesson!.isLicensed {
            playOrPurchaseButton.setTitle("Play", forState: .Normal)
        } else if lesson!.isFree {
            playOrPurchaseButton.setTitle("Free", forState: .Normal)
        } else {
            playOrPurchaseButton.setTitle("Buy", forState: .Normal)
        }
    }

    @IBAction func dismissTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    
    @IBAction func playOrPurchaseButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.parentVC?.playOrpurchaseLesson(self.lesson!)
        }
    }
    
}
