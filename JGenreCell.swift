//
//  JGenreCell.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 14/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class JGenreCell: UITableViewCell {
    var vcMain : UIView!
    var lblName : UILabel!
    var lblDescr : UILabel!
    // var txtViewDes : UITextView!
    var imageViewRecent : UIImageView!
    var lblLine : UILabel!
    
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
        lblName.textAlignment = .center
        lblName.textColor = UIColor.gray
        lblName.backgroundColor = UIColor.clear
        lblName.font = textFontTable
        vcMain.addSubview(lblName)
        
        
    }
    
    func destroyAllFrames()
    {
        vcMain.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        lblName.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
    }
    
    func getInfoDict(_ dictInfo:NSDictionary, tag:Int ,cellHeight:CGFloat, cellWidth:CGFloat)
    {
        print(dictInfo)
        
        self.contentView.frame = CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight)
        self.destroyAllFrames()
        
        let width : CGFloat = cellWidth * 0.80
        let height : CGFloat = cellHeight * 0.80
        let leftMargin : CGFloat = cellWidth * 0.10
        let topMargin  : CGFloat = cellHeight/2 - height/2
        
        // Label Name
        
        lblName.frame = CGRect(x: leftMargin,y: topMargin, width: width, height: height)
        lblName.text =  String(format: "%@",dictInfo.object(forKey: "") as! String )
        lblName.backgroundColor = UIColor.red
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
