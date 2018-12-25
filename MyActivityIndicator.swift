//
//  MyActivityIndicator.swift
//  Swift_FirstDemo
//
//  Created by Umesh Palshikar on 03/02/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

var vcActivity : MyActivityIndicator!
var activity  : UIActivityIndicatorView!

class MyActivityIndicator: UIView {
    
    
    //MARK : class method...
    class func  sharedInstance()-> MyActivityIndicator
    {
        if (vcActivity == nil)
        {
            vcActivity          =  MyActivityIndicator();
            vcActivity.frame    =  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight);
        }
        return vcActivity;
    }
    //MARK: START
    func startMyActivity()
    {
        activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge);
        activity.tintColor = UIColor.white
        activity.frame = CGRect(x: 0, y: 0, width: screenWidth*0.3, height: screenWidth*0.3);
        activity.center = vcActivity.center;
        activity.startAnimating();
        activity.color = UIColor.orange
        vcActivity.addSubview(activity);
        UIApplication.shared.keyWindow?.addSubview(vcActivity);
    }
    
    //MARK: STOP
    func stopMyActivity()
    {
        
        if(vcActivity != nil)
        {
            vcActivity.removeFromSuperview();
            vcActivity = nil;
        }
        
        if(activity != nil)
        {
            activity.stopAnimating();
            
            activity   = nil;
        }
        
    }


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
