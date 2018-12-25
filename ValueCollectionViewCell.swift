//
//  ValueCollectionViewCell.swift
//  JWOMPA
//
//  Created by Badhan Ganesh on 10/26/17.
//  Copyright © 2017 Relienttekk. All rights reserved.
//

import UIKit

class ValueCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }

}
