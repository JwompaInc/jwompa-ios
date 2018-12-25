//
//  TrandingTblCell.swift
//  JWOMPA
//
//  Created by Ranjeet Singh on 14/11/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class TrandingTblCell: UITableViewCell {

    var screenW:CGFloat!
    var screenH:CGFloat!
    
    var cellTitle:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        screenW = UIScreen.main.bounds.width
        screenH = 35
        
        cellTitle = UILabel()
        cellTitle.textAlignment = NSTextAlignment.center
        cellTitle.textColor = UIColor.gray
        cellTitle.font = UIFont.systemFont(ofSize: screenH*(45/100))
        cellTitle.frame = CGRect(x : screenW*(10/100), y : screenH*(10/100), width : screenW*(80/100), height : screenH*(80/100))
        self.addSubview(cellTitle)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
