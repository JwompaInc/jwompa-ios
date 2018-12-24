//
//  JSettingCell.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 14/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class JSettingCell: UITableViewCell {

    var vcMain : UIView!
    var lblName : UILabel!
    var lblLine : UILabel!
    var timeRemainingLabel : UILabel!
    var imageViewArrow : UIImageView = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // main view
        
        vcMain = UIView()
        vcMain.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        vcMain.backgroundColor = UIColor.white
        self.contentView .addSubview(vcMain)
        
        // lbl Name
        
        lblName = UILabel()
        lblName.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        lblName.text = ""
        lblName.textAlignment = .left
        lblName.textColor = UIColor.gray
        lblName.backgroundColor = UIColor.clear
        lblName.font = textFontTable
        vcMain.addSubview(lblName)
        
        
        lblLine = UILabel()
        lblLine.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        lblLine.text = ""
        lblLine.textAlignment = .center
        lblLine.textColor = UIColor.gray
        lblLine.backgroundColor = UIColor.clear
        lblLine.font = textFontFav
        vcMain.addSubview(lblLine)
        
        // imageview
        
        imageViewArrow  = UIImageView()
        imageViewArrow.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        imageViewArrow.image = UIImage(named: "arrowImage")
        vcMain.addSubview(imageViewArrow)
        
        
        timeRemainingLabel = UILabel()
        timeRemainingLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        timeRemainingLabel.text = ""
        timeRemainingLabel.textAlignment = .right
        timeRemainingLabel.textColor = UIColor(red: 61/255.0, green: 156/255.0, blue: 147/255.0, alpha: 1)
        timeRemainingLabel.backgroundColor = UIColor.clear
        timeRemainingLabel.font = textFontFavItalic
        timeRemainingLabel.isHidden = true
        vcMain.addSubview(timeRemainingLabel)
        
        
        let cellWidth = screenWidth
        let cellHeight = screenHeight * 0.08
        self.contentView.frame = CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight)
       
        let width : CGFloat = cellWidth * 0.80
        let height : CGFloat = cellHeight * 0.80
        let leftMargin : CGFloat = cellWidth * 0.10
        let topMargin  : CGFloat = cellHeight/2 - height/2
        
        // Label Name
        
        lblName.frame = CGRect(x: leftMargin,y: topMargin, width: width, height: height)
        lblName.text =  ""
        lblName.backgroundColor = UIColor.clear
    
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        timeRemainingLabel.frame = CGRect(x: self.imageViewArrow.frame.origin.x - 65, y: self.imageViewArrow.frame.origin.y, width: 55, height: self.imageViewArrow.frame.size.height)
    }
    
}
