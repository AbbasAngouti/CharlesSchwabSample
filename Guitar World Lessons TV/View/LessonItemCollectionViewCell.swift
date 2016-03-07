//
//  LessonItemCollectionViewCell.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 12/2/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import UIKit

class LessonItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let reuseIdentifier = "LessonItemCell"
    
    var lesson: MyLibraryLessonItem?
    
    var parentVC: UIViewController?
    @IBOutlet weak var backgroundGrayView: UIView!
//    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    var representedDataItem: MyLibraryLessonItem?
    
    // MARK: Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = UIColor.blackColor()
        subtitleLabel.textColor = UIColor.blackColor()
        runtimeLabel.textColor = UIColor.blackColor()
        if let priceLabel = priceLabel {
            priceLabel.textColor = UIColor.blackColor()
        }
        
    }
    
    
    // MARK: UICollectionReusableView
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.textColor = UIColor.blackColor()
        subtitleLabel.textColor = UIColor.blackColor()
        runtimeLabel.textColor = UIColor.blackColor()
        if let priceLabel = priceLabel {
            priceLabel.textColor = UIColor.blackColor()
        }
    }
    
    override func canBecomeFocused() -> Bool {
        return false
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {

        coordinator.addCoordinatedAnimations({ [unowned self] in
            var theButton = UIButton()
            if let btn = self.infoButton {
                theButton = btn
            } else if let btn = self.playButton {
                theButton = btn
            }
            if theButton.focused {
                self.titleLabel.textColor = UIColor.whiteColor()
                self.subtitleLabel.textColor = UIColor.whiteColor()
                self.runtimeLabel.textColor = UIColor.whiteColor()
                if let priceLabel = self.priceLabel {
                    priceLabel.textColor = UIColor.whiteColor()
                }
            }
            else {
                self.titleLabel.textColor = UIColor.blackColor()
                self.subtitleLabel.textColor = UIColor.blackColor()
                self.runtimeLabel.textColor = UIColor.blackColor()
                if let priceLabel = self.priceLabel {
                    priceLabel.textColor = UIColor.blackColor()
                }
            }
            }, completion: nil)
    }
    
    
    // MARK: - Pop up info
    @IBAction func infoTapped(sender: UIButton) {
        if let pVC = self.parentVC as? ProductViewController {
            pVC.showSynopsisOrInstrocutorWithTitleForLesson(self.lesson!)
        }
    }
    
    // MARK: - Play or Purchase lesson
    @IBAction func playButtonTapped(sender: AnyObject) {
        if let pVC = self.parentVC as? ProductViewController {
            pVC.playOrpurchaseLesson(self.lesson!)
        } else if let pVC = self.parentVC as? MyLibraryViewController {
            pVC.playVideoForLesson(self.lesson!)
        }
    }
    
}

