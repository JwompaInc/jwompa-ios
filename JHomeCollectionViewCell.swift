//
//  JHomeCollectionViewCell.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 01/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class JHomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewCollView: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var eqView: UIView!
    @IBOutlet weak var eqTopConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewCollView.clipsToBounds = true
        imageViewCollView.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        imageViewCollView.clipsToBounds = true
        imageViewCollView.contentMode = .scaleAspectFill
        
        self.eqView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    
    override func didMoveToSuperview() {
        if DeviceType.IS_IPHONE_SE {
            self.eqTopConstraint.constant = -0.4
        } else if DeviceType.IS_IPHONE_7 {
            self.eqTopConstraint.constant = -0.7
        } else if DeviceType.IS_IPHONE_7PLUS {
            self.eqTopConstraint.constant = -0.7
        } else if DeviceType.IS_IPHONE_X {
            self.eqTopConstraint.constant = -0.9
        }
        
        self.updateConstraints()
        self.updateConstraintsIfNeeded()

    }
   
    
//    override init(frame:CGRect) {
//        super.init(frame:frame)
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    var imageViewCollView : UIImageView = UIImageView()
//    var lbl : UILabel = UILabel()
//    var eqView: UIView = UIView()
    
//    override init(frame:CGRect) {
//
//        super.init(frame:frame)
//
//        let width = frame.size.width
//        let height = frame.size.height
//        let left = contentView.bounds.size.width/2 - width/2
//
//        imageViewCollView = UIImageView(frame: CGRect(x: left, y: 0,width: width, height: height*(85/100))) // height*(65/100)
//        imageViewCollView.layer.borderColor = UIColor(red: 218/255.0, green: 218/255.0, blue: 218/255.0, alpha: 1).cgColor
//        imageViewCollView.layer.borderWidth = 1.0
//        imageViewCollView.contentMode = UIViewContentMode.scaleAspectFill
//        imageViewCollView.clipsToBounds = true
//        self.contentView.addSubview(imageViewCollView)
//
//        let lblWidth  = contentView.bounds.size.width - 30
//        let lblHeight = contentView.bounds.size.height - height
//        let lblLeft   = contentView.bounds.size.width/2 - lblWidth/2
//        let lblTop    = height
//
//        lbl = UILabel(frame: CGRect(x: lblLeft, y: height*(80/100),width: lblWidth, height: height*(33/100)))
//        lbl.backgroundColor = UIColor.clear
//        lbl.textColor = UIColor.black
//        lbl.backgroundColor = UIColor.clear
//        lbl.font = textFont
//        lbl.numberOfLines = 2
//        lbl.textAlignment = NSTextAlignment.center
//        lbl.backgroundColor = .lightGray
//        self.contentView.addSubview(lbl)
//
//        eqView = UIView(frame: CGRect(x: self.contentView.frame.width - 25, y: height*(80/100), width: 25, height: 25))
//        eqView.backgroundColor = .red
//        self.contentView.addSubview(eqView)
//    }
    
}
