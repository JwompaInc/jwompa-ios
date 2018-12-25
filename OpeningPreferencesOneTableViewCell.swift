//
//  OpeningPreferencesOneTableViewCell.swift
//  JWOMPA
//
//  Created by BadhanGanesh on 23/02/18.
//  Copyright © 2018 Relienttekk. All rights reserved.
//

import UIKit

class OpeningPreferencesOneTableViewCell: UITableViewCell {
    
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var gapCreatingView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yellowButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameLabel.font = textFontTableBold!
        self.selectionStyle = .none
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            UIView.animate(withDuration: 0.15, animations: {
                self.yellowView.backgroundColor = UIColor.init(hex: 0x599992, alpha: 1.0)
                self.nameLabel.textColor = .white
            })
        } else {
            UIView.animate(withDuration: 0.15, animations: {
                self.yellowView.backgroundColor = UIColor.init(hex: 0xF9DA6D, alpha: 1.0)
                self.nameLabel.textColor = .black
            })
        }
        
    }
    
}
