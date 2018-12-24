//
//  JImage.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 18/02/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

var jimg : JImage!

var imageView : UIImageView!
var scrollView : UIScrollView!
var textFieldSinglton : UITextField!
var upperView : UIView!
var darkView: UIView!
var buttonBack : UIButton!
var buttonAlready : UIButton!
var button : UIButton!
//var button : UIButton!
var viewSinglton : UIView!

class JImage: NSObject {
    
    class func shareInstance()-> JImage
    {
        if(jimg==nil)
        {
            jimg = JImage()
        }
        return jimg
    }
    
    func setUpperView(_ frameUpperView:CGRect,viewController: UIViewController) -> CGFloat{
        upperView  = UIView(frame: frameUpperView)
        
        upperView.backgroundColor = UIColor.init(hex: 0xffd858, alpha: 1.0)
        viewController.view.addSubview(upperView)
        return upperView.bounds.size.height
    }
    
    func setStatusBarDarkView(_ frameUpperView:CGRect,viewController: UIViewController) -> CGFloat {
        darkView  = UIView(frame: frameUpperView)
        darkView.backgroundColor = UIColor.init(hex: 0xffd858, alpha: 1.0)
        viewController.view.addSubview(darkView)
        return darkView.bounds.size.height
    }
    
    func setBackButton(_ frameBackButton:CGRect) -> CGFloat
    {
        buttonBack = UIButton(frame:frameBackButton)
        buttonBack.setImage(UIImage(named: "BackButton"), for: UIControlState())
        buttonBack.showsTouchWhenHighlighted=true
        upperView.addSubview(buttonBack)
        return buttonBack.bounds.size.height
    }
    
    func SetLabelOnUpperView(_ framelbl:CGRect,nameOfString:String) ->CGFloat
    {
        let lbl : UILabel = UILabel(frame: framelbl)
        lbl.backgroundColor = UIColor.clear
        lbl.text = nameOfString
        lbl.textColor = UIColor.black
        lbl.font = UIFont(name:"FuturaPT-Medium", size: screenHeight * 0.033) // textFontHeader
        lbl.textAlignment = NSTextAlignment.center
        upperView.addSubview(lbl)
        
        return lbl.bounds.size.height
    }
    
    func SetLabelOnUpperViewWithNormalFont(_ framelbl:CGRect,nameOfString:String) ->CGFloat
    {
        let lbl : UILabel = UILabel(frame: framelbl)
        lbl.backgroundColor = UIColor.clear
        lbl.text = nameOfString
        lbl.textColor = UIColor.black
        lbl.font = UIFont(name:"FuturaPT-Book", size: 21)
        lbl.textAlignment = NSTextAlignment.center
        lbl.adjustsFontSizeToFitWidth = true
        upperView.addSubview(lbl)
        
        return lbl.bounds.size.height
    }
    
    func setTimerLabelText(timeString: String) {
        let timerLabel = UILabel.init(frame: CGRect.init(x: 0, y: upperView.frame.size.height - 30, width: upperView.frame.size.width, height: 30))
        timerLabel.backgroundColor = UIColor(red: 253/255.0, green: 217/255.0, blue: 88/255.0, alpha: 1)
        
        timerLabel.tag = 555
        timerLabel.text = timeString
        timerLabel.textColor = .black
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.systemFont(ofSize: 12.0)
        
        if !upperView.subviews.contains(timerLabel) {
            UIView.animate(withDuration: 0.2, animations: {
                upperView.addSubview(timerLabel)
            })
        }
    }
    
    func destroytimerLabel() {
        var timerLabel = upperView.viewWithTag(555)
        if let timerLabell = timerLabel {
            UIView.animate(withDuration: 0.2, animations: {
                timerLabell.frame = CGRect.init(x: 0, y: 0, width: upperView.frame.size.width, height: 0)
                timerLabell.alpha = 0.0
                upperView.layoutIfNeeded()
            }) { (done) in
                timerLabel?.removeFromSuperview()
                timerLabel = nil
            }
        }
    }

//    func SetImageOnUpperView(frameImageView:CGRect) -> CGFloat
//    {
//        var imageViewIcon : UIImageView = UIImageView(frame: frameImageView)
//        imageViewIcon.image = UIImage(named:"ICON")
//        imageViewIcon.contentMode = UIViewContentMode.ScaleAspectFill
//        imageViewIcon.backgroundColor = UIColor.clearColor()
//        upperView .addSubview(imageViewIcon)
//        
//        return imageViewIcon.bounds.size.height
//        
//    }
//    
    func setMyScrollView(_ frame:CGRect ,viewController:UIViewController) -> CGFloat
    {
        scrollView = UIScrollView()
        scrollView.frame = frame
        scrollView.backgroundColor = UIColor.clear
        scrollView.isScrollEnabled = true;
        viewController.view.addSubview(scrollView)
        return scrollView.bounds.size.height
    }
    
    func setMyImgView(_ frame:CGRect) -> CGFloat
    {
        imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named:"logo-504")
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.backgroundColor = UIColor.clear
        scrollView .addSubview(imageView)
        
        return imageView.bounds.size.height
    }
    
    func setAlreadyButton(_ frameAlreadyButton:CGRect,nameOfTitle:String) -> CGFloat
    {
        
        buttonAlready = UIButton(frame: frameAlreadyButton)
        buttonAlready.titleLabel?.font = textFontTextFields
        buttonAlready.setTitleColor(UIColor(red: 154/255.0, green: 155/255.0, blue: 156/255.0, alpha: 1), for: UIControlState())
        buttonAlready.backgroundColor = UIColor.clear
        buttonAlready.showsTouchWhenHighlighted = true
        buttonAlready.setTitle(nameOfTitle, for: UIControlState())
        
        let stringSize = (nameOfTitle as NSString).size(attributes: [NSFontAttributeName:(buttonAlready.titleLabel?.font)!])
        var frame = buttonAlready.frame
        frame.size.width = stringSize.width
        buttonAlready.frame = frame
        buttonAlready.center.x = UIScreen.main.bounds.midX
        
        scrollView.addSubview(buttonAlready)
        
        return buttonAlready.bounds.size.height
    }
    
    func setButton(_ frameAlreadyButton:CGRect,nameOfTitle:String) -> CGFloat
    {
        button = UIButton(frame: frameAlreadyButton)
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = textButton
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.backgroundColor = UIColor(red: 61/255.0, green: 156/255.0, blue: 147/255.0, alpha: 1)
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.showsTouchWhenHighlighted = true
        button.setTitle(nameOfTitle, for: UIControlState())
        scrollView.addSubview(button)
        return button.bounds.size.height
    }

    func setView(_ frameOfView:CGRect) -> CGFloat
    {
//        let viewWidth = screenWidth * 0.80
//        let viewHeight = screenHeight * 0.08
//        let viewLeftMargin = screenWidth/2 - viewWidth/2
//        let viewTopMargin = screenHeight * 0.15 + screenHeight * 0.20
        
        viewSinglton = UIView()
        viewSinglton.frame = frameOfView
        viewSinglton.layer.cornerRadius = 4
        viewSinglton.clipsToBounds = true
        viewSinglton.layer.borderColor = UIColor(red: 218/255.0, green: 218/255.0, blue: 218/255.0, alpha: 1).cgColor
        viewSinglton.layer.borderWidth = 1.0
        viewSinglton.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
        scrollView.addSubview(viewSinglton)
        
       return viewSinglton.bounds.size.height
    }
    
    func setTextField(_ frameOfTextField:CGRect, placeholderName : String) -> CGFloat
    {
        textFieldSinglton = UITextField(frame: frameOfTextField)
        textFieldSinglton.placeholder = placeholderName
        textFieldSinglton.backgroundColor = UIColor.clear
        textFieldSinglton.font = textFontTextFields
        textFieldSinglton.keyboardType = .numberPad
        textFieldSinglton.returnKeyType = .done
        textFieldSinglton.textAlignment = .center
        viewSinglton.addSubview(textFieldSinglton)
        return textFieldSinglton.bounds.size.height
    }
    
    func destroy()
    {
        jimg = nil;
        NotificationCenter.default.removeObserver(self)
    }

}
