//
//  CellSearch.swift
//  JWOMPA
//
//  Created by Reliant Tekk on 08/04/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class CellSearch: UITableViewCell {

    var titleText:UILabel!
    var descText:UILabel!
    var imageIcon:UIImageView!
    
    var s_height:CGFloat = screenHeight*(16/100)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageIcon.clipsToBounds = true
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let tableHeight = screenHeight - (110 + 55)
        
        
        let height:CGFloat = tableHeight/3
        let width:CGFloat = self.frame.size.width - height
        
        titleText = UILabel()
        titleText.frame = CGRect(x: s_height, y: s_height*(5/100), width: screenWidth - s_height*(120/100), height: s_height*(25/100))
        titleText.text = ""
        titleText.textAlignment = .left
        titleText.textColor = UIColor.black
        titleText.backgroundColor = UIColor.clear
        titleText.font = UIFont(name: "OpenSans-Regular", size: screenHeight * 0.025) // textFontFav
        self.addSubview(titleText)
        
        // lbl Description
        
        descText = UILabel()
        descText.frame = CGRect(x: s_height, y: s_height*(35/100), width: screenWidth - s_height*(120/100), height: s_height*(60/100))
        descText.text = ""
        descText.textAlignment = .left
        descText.textColor = UIColor.black
        descText.backgroundColor = UIColor.clear
//        descText.textAlignment = .left
//        descText.sizeToFit()
        descText.numberOfLines = 6
        descText.font = textFontDescription
        self.addSubview(descText)
        
        
        imageIcon = UIImageView()
        imageIcon.clipsToBounds = true
        imageIcon.frame = CGRect(x: s_height*(10/100), y: s_height*(10/100), width: s_height*(80/100), height: s_height*(80/100))
        imageIcon.contentMode = UIViewContentMode.scaleAspectFill
        self.addSubview(imageIcon)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
