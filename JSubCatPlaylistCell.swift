//
//  JSubCatPlaylistCell.swift
//  JWOMPA
//
//  Created by BadhanGanesh on 22/03/18.
//  Copyright © 2018 Relienttekk. All rights reserved.
//

import UIKit

class JSubCatPlaylistCell: UITableViewCell {
    
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblDescr : UILabel!
    @IBOutlet weak var imageViewSubCat : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font = textFontTableBoldPlaylist
        lblDescr.font = textFontDescription
    }
    
}

