//
//  GlobelUI.swift
//  LPG
//
//  Created by Ranjeet Singh on 10/09/15.
//  Copyright (c) 2015 Ranjeet Singh. All rights reserved.
//

import UIKit

class GlobelUI: NSObject{
   
    
    static let shared : GlobelUI = {
        let instance = GlobelUI()
        return instance
    }()
    
    func getImageView(_ frame:CGRect,backColor:UIColor,cornerRadius:CGFloat,clipBound:Bool,borderWidth:CGFloat,borderColor:UIColor) ->UIImageView
    {
        
        let imageView = UIImageView()
        imageView.frame = frame
        imageView.backgroundColor = backColor
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.borderWidth = borderWidth
        imageView.layer.borderColor = borderColor.cgColor
        imageView.clipsToBounds = clipBound
    
        return imageView
    }

}
