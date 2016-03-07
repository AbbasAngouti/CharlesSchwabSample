//
//  ProductionCollectionViewCell.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 11/5/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import UIKit

// TODO: do we need this?
class ProductionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var featuredImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func commonInit() {
        // Initialization code
        
        self.layoutIfNeeded()
        self.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if (self.focused) {
            self.featuredImage.adjustsImageWhenAncestorFocused = true
        } else {
            self.featuredImage.adjustsImageWhenAncestorFocused = false
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        featuredImage.adjustsImageWhenAncestorFocused = true
        featuredImage.clipsToBounds = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
