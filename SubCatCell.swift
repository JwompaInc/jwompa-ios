//
//  SubCatCell.swift
//  Jwompa
//
//  Created by Ranjeet Singh on 13/01/17.
//  Copyright © 2017 Relienttekk. All rights reserved.
//

import UIKit

class SubCatCell: UITableViewCell {

    var screenW:CGFloat!
    var screenH:CGFloat!
    
    var iconImage:UIImageView!
    var cellTitle:UILabel!
    var rightImg:UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(hex: 0x107068, alpha: 1)
        
        screenW = screenWidth*(80/100)
        screenH = screenHeight*(8/100)
        
        
        cellTitle = UILabel()
        cellTitle.textColor = UIColor.white
        cellTitle.font = UIFont(name: "FuturaBT-Book", size: 16)
        cellTitle.frame = CGRect(x:screenW*(25/100), y:0, width:screenW*(75/100) - screenH, height:screenH)
//        cellTitle.sizeToFit()
        self.addSubview(cellTitle)
        
        let valOne = screenW*(85/100)
        let valTwo = screenH*(30/100)
        let xVal = (valOne) + (valTwo)
        let yVal = screenH*(30/100)
        let widthVal = screenH*(40/100)
        let heightVal = screenH*(40/100)
        
        rightImg = UIImageView()
        rightImg.frame = CGRect(x: xVal, y: yVal, width: widthVal, height: heightVal)
        rightImg.contentMode = UIViewContentMode.scaleAspectFit
        rightImg.image = UIImage(named: "arrowGreenImage")
        self.addSubview(rightImg)
        
        let line:CALayer = CALayer()
        line.setValue(1123, forKey: "layertag")
        line.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 1.5) // CGRect(x: screenW*(20/100), y: 0, width: screenW*(80/100), height: 0.6)
        line.backgroundColor = UIColor(hex: 0x1abaae, alpha: 1.5).cgColor
        self.layer.addSublayer(line)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
