//
//  OpeningPreferencesTwoTableViewCell.swift
//  JWOMPA
//
//  Created by BadhanGanesh on 22/02/18.
//  Copyright © 2018 Relienttekk. All rights reserved.
//

import UIKit

class OpeningPreferencesTwoTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var genreNameLabel: UILabel!
    @IBOutlet weak var dropdownAnchorView: UILabel!
    @IBOutlet weak var downArrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        self.genreNameLabel.font = textFontTableBold!
        self.indexLabel.font = textFontTableBold!
        self.indexLabel.setCornerRadius(3.0, withBorderWidth: 0, andBorderColor: .clear)
        self.genreNameLabel.setCornerRadius(3.0, withBorderWidth: 0, andBorderColor: .clear)
        self.containerView.setCornerRadius(3.0, withBorderWidth: 0, andBorderColor: .clear)
        
        let degrees = 90.0
        let radians = CGFloat(degrees * Double.pi / 180)
        downArrowImageView.image = downArrowImageView.image?.withRenderingMode(.alwaysTemplate)
        downArrowImageView.layer.transform = CATransform3DMakeRotation(radians, 0, 0, 1)        
    }
    
}
