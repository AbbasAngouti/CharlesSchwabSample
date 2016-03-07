/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A `UICollectionViewCell` subclass used to display `DataItem`s within `UICollectionView`s.
*/

import UIKit

class ProductItemCollectionViewCell: UICollectionViewCell {
    // MARK: Properties
    
    static let reuseIdentifier = "DataItemCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var instructorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var guitarTypeLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var representedDataItem: ProductOnlyItem?
    
    // MARK: Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // These properties are also exposed in Interface Builder.
        imageView.adjustsImageWhenAncestorFocused = true
        imageView.clipsToBounds = false
        
        if let titleLabel = titleLabel {
            titleLabel.textColor = UIColor.blackColor()
        }
        
        if let instructorLabel = instructorLabel {
            instructorLabel.textColor = UIColor.blackColor()
        }
        
        if let genreLabel = genreLabel {
            genreLabel.textColor = UIColor.blackColor()
        }
        
        if let guitarTypeLabel = guitarTypeLabel {
            guitarTypeLabel.textColor = UIColor.blackColor()
        }
        
    }
    
    // MARK: UICollectionReusableView
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let titleLabel = titleLabel {
            titleLabel.textColor = UIColor.blackColor()
        }
        
        if let instructorLabel = instructorLabel {
            instructorLabel.textColor = UIColor.blackColor()
        }
        
        if let genreLabel = genreLabel {
            genreLabel.textColor = UIColor.blackColor()
        }
        
        if let guitarTypeLabel = guitarTypeLabel {
            guitarTypeLabel.textColor = UIColor.blackColor()
        }
    }
    
    // MARK: UIFocusEnvironment
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        /*
            Update the label's alpha value using the `UIFocusAnimationCoordinator`.
            This will ensure all animations run alongside each other when the focus
            changes.
        */
        coordinator.addCoordinatedAnimations({ [unowned self] in
            if self.focused {
                if let titleLabel = self.titleLabel {
                    titleLabel.textColor = UIColor.whiteColor()
                }
                
                if let instructorLabel = self.instructorLabel {
                    instructorLabel.textColor = UIColor.whiteColor()
                }
                
                if let genreLabel = self.genreLabel {
                    genreLabel.textColor = UIColor.whiteColor()
                }
                
                if let guitarTypeLabel = self.guitarTypeLabel {
                    guitarTypeLabel.textColor = UIColor.whiteColor()
                }
            }
            else {
                if let titleLabel = self.titleLabel {
                    titleLabel.textColor = UIColor.blackColor()
                }
                
                if let instructorLabel = self.instructorLabel {
                    instructorLabel.textColor = UIColor.blackColor()
                }
                
                if let genreLabel = self.genreLabel {
                    genreLabel.textColor = UIColor.blackColor()
                }
                
                if let guitarTypeLabel = self.guitarTypeLabel {
                    guitarTypeLabel.textColor = UIColor.blackColor()
                }
            }
        }, completion: nil)
    }
}
