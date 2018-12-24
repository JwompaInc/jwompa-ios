//
//  ImageTextField.swift
//  BurgerKing
//
//  Created by Ranjeet Singh on 17/03/16.
//  Copyright © 2016 JBIT. All rights reserved.
//

import UIKit

class ImageTextField: UITextField {

    var padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    var imageIcon:UIImageView!
    var underLine:CALayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageIcon = GlobelUI.shared.getImageView(CGRect(x: frame.size.height*(20/100), y: frame.size.height*(20/100), width: frame.size.height*(60/100), height: frame.size.height*(60/100)), backColor: UIColor.clear, cornerRadius: 0, clipBound: true, borderWidth: 0, borderColor: UIColor.clear)
        imageIcon.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(imageIcon)
        
        underLine = CALayer()
        underLine.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.size.width, height: 1)
        underLine.backgroundColor = UIColor.clear.cgColor
        self.layer.addSublayer(underLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    fileprivate func newBounds(_ bounds: CGRect) -> CGRect {
        
        padding = UIEdgeInsets(top: 0, left: frame.size.height, bottom: 0, right: frame.size.height*(10/100));
        
        var newBounds = bounds
        newBounds.origin.x += padding.left
        newBounds.origin.y += padding.top
        newBounds.size.height -= padding.top + padding.bottom
        newBounds.size.width -= padding.left + padding.right
        return newBounds
    }
    
    func setimage(_ imageName:String){
        imageIcon.image = UIImage(named: imageName)
    }

}
