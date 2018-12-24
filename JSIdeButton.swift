//
//  JSIdeButton.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 08/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

var jSideButton : JSIdeButton!

var buttonSide : UIButton!

class JSIdeButton: NSObject {
    
    class func shareInstance()-> JSIdeButton
    {
        if(jSideButton==nil)
        {
            jSideButton = JSIdeButton()
        }
        return jSideButton
    }
    
    func setSideButton(_ frameBackButton:CGRect) -> CGFloat
    {
        buttonSide = UIButton(frame:frameBackButton)
        buttonSide.setImage(UIImage(named: "BackButton"), for: UIControlState())
        buttonSide.showsTouchWhenHighlighted=true
        upperView.addSubview(buttonSide)
        return buttonSide.bounds.size.height
    }

    
    
    
    func destroy()
    {
        jSideButton = nil;
        
    }

}
