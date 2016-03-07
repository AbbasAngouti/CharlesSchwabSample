//
//  InfoViewController.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 10/30/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var infoTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let infoUrl = NSURL(string: "https://guitarworldlessons.com/services/templates/info_popup.php")!
        
        do {
            let infoHtmlString = try String(contentsOfURL: infoUrl)
            let attributedInfo = String.htmlToAttributedString(infoHtmlString)
            infoTextView.attributedText = attributedInfo
        } catch {
            
        }
    }
}


extension String {
    static func htmlToAttributedString(htmlEncodedString: String) -> NSAttributedString {
        do {
            let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedOptions : [String: AnyObject] = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
            ]
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            return attributedString
        } catch {
            fatalError("Unhandled error: \(error)")
        }
    }
}