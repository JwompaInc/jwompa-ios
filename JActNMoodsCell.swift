//
//  JActNMoodsCell.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 14/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit


class JActNMoodsCell: UITableViewCell {
    
    var vcMain : UIView!
    var lblName : UILabel!
    var lblLine : UILabel!
    var imageViewArrow : UIImageView = UIImageView()
   // var buttonCell : UIButton!
    
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
        
        // lbl Line
        
        lblLine = UILabel()
        lblLine.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        lblLine.text = ""
        lblLine.textAlignment = .left
        lblLine.textColor = UIColor.clear
        lblLine.font = UIFont(name: "", size: screenHeight * 0.020)
        vcMain.addSubview(lblLine)
        
        // imageview
        
        imageViewArrow  = UIImageView()
        imageViewArrow.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        imageViewArrow.image = UIImage(named: "arrowImage")
        vcMain.addSubview(imageViewArrow)

        
//        buttonCell = UIButton()
//        buttonCell.frame = CGRectMake(0, 0, 0, 0)
//        buttonCell.backgroundColor = UIColor.clearColor()
//        vcMain.addSubview(buttonCell)
        
    }
    
    func destroyAllFrames()
    {
        vcMain.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        lblName.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        lblLine.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
    }
    
    func getInfoDict(_ dictInfo:NSDictionary, tag:Int ,cellHeight:CGFloat, cellWidth:CGFloat)
    {
        print(dictInfo)
        
        self.contentView.frame = CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight)
        self.destroyAllFrames()
        
        let width : CGFloat = cellWidth * 0.80
        let height : CGFloat = cellHeight * 0.80
        let leftMargin : CGFloat = cellWidth * 0.05
        let topMargin  : CGFloat = cellHeight/2 - height/2
        
        // Label Name
        
        lblName.frame = CGRect(x: leftMargin,y: topMargin, width: width, height: height)
        lblName.text =  String(format: "%@",dictInfo.object(forKey: "name") as! String )
        lblName.backgroundColor = UIColor.clear
        lblName.textColor = UIColor.black
        
        
        let widthImageView = cellWidth * 0.05
        let heightImageView = cellWidth * 0.05
        let leftMarginImageView = cellWidth * 0.90
        let topMarginImageView = cellHeight/2 - heightImageView/2
        
        imageViewArrow.frame = CGRect(x: leftMarginImageView, y: topMarginImageView, width: widthImageView, height: heightImageView)
        imageViewArrow.image = UIImage(named: "arrowImage")

//        lblLine.frame = CGRectMake(0, cellHeight * 0.95 , cellWidth, cellHeight * 0.02)
//        lblLine.backgroundColor = UIColor(red: 190/255.0, green: 191/255.0, blue: 191/255.0, alpha: 1)
        
//        var heightButton = cellHeight * 0.80
//        var topmarginbutton = cellHeight/2 - height/2
        
//        buttonCell.tag = tag
//        buttonCell.frame = CGRectMake(0,topmarginbutton, cellWidth,heightButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
