//
//  SidemenuCell.swift
//  Jwompa
//
//  Created by Ranjeet Singh on 20/12/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class SidemenuCell: UITableViewCell {

    var iconImage : UIImageView!
    var cellTitle : UILabel!
    
    var screenW:CGFloat = screenWidth*(80/100)
    var screenH:CGFloat = screenHeight*(8/100)
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        
        
        iconImage = UIImageView(frame: CGRect(x: screenH*(10/100),y: screenH*(10/100),width: screenH*(80/100),height: screenH*(80/100)))
        iconImage.backgroundColor  = UIColor.clear
        self.addSubview(iconImage)
        
        
        cellTitle         = UILabel()
        cellTitle.frame   = CGRect(x: screenH,y: screenH*(10/100),width: screenW - screenH*(110/100),height: screenH*(80/100))
        cellTitle.font    = textSplashBoardCell
        cellTitle.backgroundColor = UIColor.clear
        cellTitle.textColor = UIColor.white
        cellTitle.layer.cornerRadius = 5.0
        self.addSubview(cellTitle)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
