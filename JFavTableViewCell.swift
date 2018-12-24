//
//  JFavTableViewCell.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 14/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class JFavTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblDescr : UILabel!
    @IBOutlet weak var imageViewFav : UIImageView!
    @IBOutlet weak var nowPlayingLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font = textFontTableBoldPlaylist
        lblDescr.font = textFontDescription
        
        nowPlayingLbl.isHidden = true
        nowPlayingLbl.text = "Now playing..."
        nowPlayingLbl.font = UIFont.init(name: "Lato-Italic", size: 12)
        nowPlayingLbl.textColor = UIColor(red: 64/255, green: 155/255, blue: 146/255, alpha: 1)
    }
}
