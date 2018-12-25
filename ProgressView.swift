//
//  ProgressView.swift
//  CustomProgressBar
//
//  Created by Sztanyi Szabolcs on 16/10/14.
//  Copyright (c) 2014 Sztanyi Szabolcs. All rights reserved.
//

//import UIKit
//var imgSong: UIImageView!
//var TTime:Double!
//
//class ProgressView: UIView {
//
//    private let progressLayer: CAShapeLayer = CAShapeLayer()
//    
//    required init?(coder aDecoder: NSCoder) {
//        imgSong = UIImageView()
//        super.init(coder: aDecoder)
//        createProgressLayer()
//        createLabel()
//    }
//    
//    override init(frame: CGRect) {
//        imgSong = UIImageView()
//        super.init(frame: frame)
//        createProgressLayer()
//        createLabel()
//    }
//    
//    func createLabel() {
//  
//        let centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)
//        let imgx = centerPoint.x - CGRectGetWidth(frame)/2
//        let imgy = centerPoint.y - CGRectGetHeight(frame)/2
//        
//        imgSong.removeFromSuperview()
//        
//        let width = imageViewTrans.bounds.size.width * 0.40
//        let height = imageViewTrans.bounds.size.height * 0.40
//        let left = imageViewTrans.bounds.size.width/2 - width/2
//        let top = imageViewTrans.bounds.size.height - height/2
//      // let left = imgx/2 + screenWidth * 0.009 //- width/2
//      // let top =  imgy/2 + screenHeight * 0.010  //- height/2
//        imgSong = UIImageView(frame:CGRectMake(left, top, width, height))
//        imgSong.layer.borderColor = UIColor(red: 218/255.0, green: 218/255.0, blue: 218/255.0, alpha: 1).CGColor
//        imgSong.layer.borderWidth = 1.0
//        imgSong.layer.cornerRadius = imgSong.frame.size.width/2
//        imgSong.clipsToBounds = true
//        imgSong.contentMode = UIViewContentMode.ScaleAspectFill
//        addSubview(imgSong)
//        
//        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: imgSong, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
//        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: imgSong, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
//    }
//    
//    private func createProgressLayer() {
//        let startAngle = CGFloat(-M_PI_2)
//        let endAngle = CGFloat(M_PI * 2 + M_PI_2)
//        let centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)
//        let gradientMaskLayer = gradientMask()
//        
//        progressLayer.path = UIBezierPath(arcCenter:centerPoint, radius: CGRectGetWidth(frame)/2 - 05 , startAngle:startAngle, endAngle:endAngle, clockwise: true).CGPath
//        progressLayer.backgroundColor = UIColor.clearColor().CGColor
//        progressLayer.fillColor = nil
//        progressLayer.strokeColor = UIColor.blackColor().CGColor
//        progressLayer.lineWidth = 8.0
//        progressLayer.strokeStart = 0.0
//        progressLayer.strokeEnd = 0.0
//        layer.backgroundColor = UIColor.clearColor().CGColor
//       // layer.frame = CGRectMake(100, statusBarHeight, 100, 100)
//        gradientMaskLayer.mask = progressLayer
//        layer.addSublayer(gradientMaskLayer)
//    }
//    
//    private func gradientMask() -> CAGradientLayer {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = bounds
//
//        gradientLayer.locations = [0.0, 1.0]
//        
//        let colorTop: AnyObject = UIColor(red: 64/255.0, green: 154/255.0, blue: 145/255.0, alpha: 1).CGColor
//        let colorBottom: AnyObject = UIColor(red: 64/255.0, green: 154/255.0, blue: 145/255.0, alpha: 1).CGColor
//        let arrayOfColors: [AnyObject] = [colorTop, colorBottom]
//        gradientLayer.colors = arrayOfColors
//       // gradientLayer.frame = CGRectMake(100, statusBarHeight, 100, 100)
//        
//        return gradientLayer
//    }
//    
//    func hideProgressView() {
//        progressLayer.strokeEnd = 0.0
//        progressLayer.removeAllAnimations()
//      //  progressLabel.text = "Load content"
//    }
//    
//    func animateProgressView(PTime:Double, pauseP:Bool) {
//   
//        //   progressLabel.text = "Loading..."
//        progressLayer.strokeEnd     = 0.0
//       //  TTime                      = (total as NSString).doubleValue
//        let animation               = CABasicAnimation(keyPath: "strokeEnd")
//        
//        animation.fromValue         = CGFloat(PTime*0.1)
//        if pauseP == true{
//            
//           animation.toValue        = CGFloat(PTime*0.1)
//            
//        }else{
//        
//        animation.toValue           = CGFloat(1)
//           
//        }
//    
//         animation.duration         = totalSec
//    
//        animation.delegate          = self
//        animation.removedOnCompletion = false
//        animation.additive          = true
//        animation.fillMode          = kCAFillModeForwards
//        progressLayer.addAnimation(animation, forKey: "strokeEnd")
//    }
//    
//    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//     //   progressLabel.text = "Done"
//    }
//}
//



//import UIKit
//var imgSong: UIImageView!
//var TTime:Double!
//
//class ProgressView: UIView {
//    
//    private let progressLayer: CAShapeLayer = CAShapeLayer()
//    
//    required init?(coder aDecoder: NSCoder) {
//        imgSong = UIImageView()
//        super.init(coder: aDecoder)
//        createProgressLayer()
//        createLabel()
//    }
//    
//    override init(frame: CGRect) {
//        imgSong = UIImageView()
//        super.init(frame: frame)
//        createProgressLayer()
//        createLabel()
//    }
//    
//    func createLabel() {
//        
//        let centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)
//        let imgx = centerPoint.x - CGRectGetWidth(frame)/2
//        let imgy = centerPoint.y - CGRectGetHeight(frame)/2
//        
//        imgSong.removeFromSuperview()
//        let width = screenWidth * 0.40
//        let height = screenWidth * 0.40
//        let left = imageViewTrans.bounds.size.width/2 - width/2
//        let top = imageViewTrans.bounds.size.height - height/2
////      let left = imgx/2 + screenWidth * 0.009 //- width/2
////      let top =  imgy/2 + screenHeight * 0.010  //- height/2
//        imgSong = UIImageView(frame:CGRectMake(left, top, width, height))
//        imgSong.layer.borderColor = UIColor(red: 218/255.0, green: 218/255.0, blue: 218/255.0, alpha: 1).CGColor
//        imgSong.layer.borderWidth = 1.0
//        imgSong.layer.cornerRadius = imgSong.frame.size.width/2
//        imgSong.clipsToBounds = true
//        imgSong.contentMode = UIViewContentMode.ScaleAspectFill
//        addSubview(imgSong)
//        
//        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: imgSong, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
//        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: imgSong, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
//    }
//    
//    private func createProgressLayer() {
//        let startAngle = CGFloat(-M_PI_2)
//        let endAngle = CGFloat(M_PI * 2 + M_PI_2)
//        let centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)
//        
//        let gradientMaskLayer = gradientMask()
//        progressLayer.path = UIBezierPath(arcCenter:centerPoint, radius: CGRectGetWidth(frame)/2 - 05 , startAngle:startAngle, endAngle:endAngle, clockwise: true).CGPath
//        progressLayer.backgroundColor = UIColor.redColor().CGColor
//        progressLayer.fillColor = nil
//        progressLayer.strokeColor = UIColor.blackColor().CGColor
//        progressLayer.lineWidth = 8.0
//        progressLayer.strokeStart = 0.0
//        progressLayer.strokeEnd = 0.0
//        
//        gradientMaskLayer.mask = progressLayer
//        layer.addSublayer(gradientMaskLayer)
//    }
//    
//    private func gradientMask() -> CAGradientLayer {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = bounds
//        
//        gradientLayer.locations = [0.0, 1.0]
//        
//        let colorTop: AnyObject = UIColor(red: 64/255.0, green: 154/255.0, blue: 145/255.0, alpha: 1).CGColor
//        let colorBottom: AnyObject = UIColor(red: 64/255.0, green: 154/255.0, blue: 145/255.0, alpha: 1).CGColor
//        let arrayOfColors: [AnyObject] = [colorTop, colorBottom]
//        gradientLayer.colors = arrayOfColors
//        
//        return gradientLayer
//    }
//    
//    func hideProgressView() {
//        progressLayer.strokeEnd = 0.0
//        progressLayer.removeAllAnimations()
//        //  progressLabel.text = "Load content"
//    }
//    
//    func animateProgressView(PTime:Double, pauseP:Bool) {
//        
//        //   progressLabel.text = "Loading..."
//        progressLayer.strokeEnd     = 0.0
//        //  TTime                      = (total as NSString).doubleValue
//        let animation               = CABasicAnimation(keyPath: "strokeEnd")
//        
//        animation.fromValue         = CGFloat(PTime*0.1)
//        if pauseP == true{
//            
//            animation.toValue        = CGFloat(PTime*0.1)
//            
//        }else{
//            
//            animation.toValue           = CGFloat(1)
//            
//        }
//        
//        animation.duration         = totalSec
//        
//        animation.delegate          = self
//        animation.removedOnCompletion = false
//        animation.additive          = true
//        animation.fillMode          = kCAFillModeForwards
//        progressLayer.addAnimation(animation, forKey: "strokeEnd")
//    }
//    
//    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//        //   progressLabel.text = "Done"
//    }
//}



//import UIKit
//var imgSong: UIImageView!
//var TTime:Double!
//
//class ProgressView: UIView {
//    
//    private let progressLayer: CAShapeLayer = CAShapeLayer()
//    
//    required init?(coder aDecoder: NSCoder) {
//        imgSong = UIImageView()
//        super.init(coder: aDecoder)
//        createProgressLayer()
//        createLabel()
//    }
//    
//    override init(frame: CGRect) {
//        imgSong = UIImageView()
//        super.init(frame: frame)
//        createProgressLayer()
//        createLabel()
//    }
//    
//    func createLabel() {
//        
//        let centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)
//        let imgx = centerPoint.x - CGRectGetWidth(frame)/2
//        let imgy = centerPoint.y - CGRectGetHeight(frame)/2
//        
//        imgSong.removeFromSuperview()
//        imgSong = UIImageView(frame:CGRectMake(imgx+30 , imgy+30 , 100, 100))
//        imgSong.layer.borderColor = UIColor(red: 218/255.0, green: 218/255.0, blue: 218/255.0, alpha: 1).CGColor
//        imgSong.layer.borderWidth = 1.0
//        imgSong.layer.cornerRadius = imgSong.frame.size.width/2
//        imgSong.clipsToBounds = true
//        imgSong.contentMode = UIViewContentMode.ScaleAspectFill
//        addSubview(imgSong)
//        
//        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: imgSong, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
//        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: imgSong, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
//    }
//    
//    private func createProgressLayer() {
//        let startAngle = CGFloat(-M_PI_2)
//        let endAngle = CGFloat(M_PI * 2 + M_PI_2)
//        let centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)
//        
//        let gradientMaskLayer = gradientMask()
//        progressLayer.path = UIBezierPath(arcCenter:centerPoint, radius: CGRectGetHeight(frame)/2-25, startAngle:startAngle, endAngle:endAngle, clockwise: true).CGPath
//        progressLayer.backgroundColor = UIColor.clearColor().CGColor
//        progressLayer.fillColor = nil
//        progressLayer.strokeColor = UIColor.blackColor().CGColor
//        progressLayer.lineWidth = 8.0
//        progressLayer.strokeStart = 0.0
//        progressLayer.strokeEnd = 0.0
//        
//        gradientMaskLayer.mask = progressLayer
//        layer.addSublayer(gradientMaskLayer)
//    }
//    
//    private func gradientMask() -> CAGradientLayer {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = bounds
//        
//        gradientLayer.locations = [0.0, 1.0]
//        
//        let colorTop: AnyObject = UIColor(red: 64/255.0, green: 154/255.0, blue: 145/255.0, alpha: 1).CGColor
//        let colorBottom: AnyObject = UIColor(red: 64/255.0, green: 154/255.0, blue: 145/255.0, alpha: 1).CGColor
//        let arrayOfColors: [AnyObject] = [colorTop, colorBottom]
//        gradientLayer.colors = arrayOfColors
//        
//        return gradientLayer
//    }
//    
//    func hideProgressView() {
//        progressLayer.strokeEnd = 0.0
//        progressLayer.removeAllAnimations()
//        //  progressLabel.text = "Load content"
//    }
//    
//    func animateProgressView(PTime:Double, pauseP:Bool) {
//        
//        //   progressLabel.text = "Loading..."
//        progressLayer.strokeEnd     = 0.0
//        //  TTime                      = (total as NSString).doubleValue
//        let animation               = CABasicAnimation(keyPath: "strokeEnd")
//        
//        animation.fromValue         = CGFloat(PTime*0.1)
//        if pauseP == true{
//            
//            animation.toValue        = CGFloat(PTime*0.1)
//            
//        }else{
//            
//            animation.toValue           = CGFloat(1)
//            
//        }
//        
//        animation.duration         = totalSec
//        
//        animation.delegate          = self
//        animation.removedOnCompletion = false
//        animation.additive          = true
//        animation.fillMode          = kCAFillModeForwards
//        progressLayer.addAnimation(animation, forKey: "strokeEnd")
//    }
//    
//    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//        //   progressLabel.text = "Done"
//    }
//}
//
//


//
//import UIKit
//var imgSong: UIImageView!
//var TTime:Double!
//
//class ProgressView: UIView {
//    
//    private let progressLayer: CAShapeLayer = CAShapeLayer()
//    
//    required init?(coder aDecoder: NSCoder) {
//        imgSong = UIImageView()
//        super.init(coder: aDecoder)
//        createProgressLayer()
//        createLabel()
//    }
//    
//    override init(frame: CGRect) {
//        imgSong = UIImageView()
//        super.init(frame: frame)
//        createProgressLayer()
//        createLabel()
//    }
//    
//    func createLabel() {
//        
//        let centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)
//        let imgx = centerPoint.x - CGRectGetWidth(frame)/2
//        let imgy = centerPoint.y - CGRectGetHeight(frame)/2
//    
//       // NSLog("Center Point %@", centerPoint)
//        NSLog("x %@",imgx)
//        NSLog("y %@",imgy)
//        
//        imgSong.removeFromSuperview()
//        imgSong = UIImageView(frame:CGRectMake(imgx+30 , imgy+30 , 100, 100))
//        imgSong.layer.borderColor = UIColor(red: 218/255.0, green: 218/255.0, blue: 218/255.0, alpha: 1).CGColor
//        imgSong.layer.borderWidth = 1.0
//        imgSong.layer.cornerRadius = imgSong.frame.size.width/2
//        imgSong.clipsToBounds = true
//        imgSong.contentMode = UIViewContentMode.ScaleAspectFill
//        addSubview(imgSong)
//        
//        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: imgSong, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
//        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: imgSong, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
//    }
//    
//    private func createProgressLayer() {
//        let startAngle = CGFloat(-M_PI_2)
//        let endAngle = CGFloat(M_PI * 2 + M_PI_2)
//        let centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)
//        
//        let gradientMaskLayer = gradientMask()
//        progressLayer.path = UIBezierPath(arcCenter:centerPoint, radius: CGRectGetHeight(frame)/2 - 25, startAngle:startAngle, endAngle:endAngle, clockwise: true).CGPath
//        //progressLayer.frame = CGRectMake(100, 100, 200, 200)
//        progressLayer.backgroundColor = UIColor.clearColor().CGColor
//        progressLayer.fillColor = nil
//        progressLayer.strokeColor = UIColor.blackColor().CGColor
//        progressLayer.lineWidth = 8.0
//        progressLayer.strokeStart = 0.0
//        progressLayer.strokeEnd = 0.0
//        gradientMaskLayer.mask = progressLayer
//        layer.backgroundColor = UIColor.redColor().CGColor
//        gradientMaskLayer.mask = progressLayer
//        layer.addSublayer(gradientMaskLayer)
//    }
//    
//    private func gradientMask() -> CAGradientLayer {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.bounds
//        
//        gradientLayer.locations = [0.0, 1.0]
//        
//        let colorTop: AnyObject = UIColor(red: 64/255.0, green: 154/255.0, blue: 145/255.0, alpha: 1).CGColor
//        let colorBottom: AnyObject = UIColor(red: 64/255.0, green: 154/255.0, blue: 145/255.0, alpha: 1).CGColor
//        let arrayOfColors: [AnyObject] = [colorTop, colorBottom]
//        gradientLayer.colors = arrayOfColors
//        
//        return gradientLayer
//    }
//    
//    func hideProgressView() {
//        progressLayer.strokeEnd = 0.0
//        progressLayer.removeAllAnimations()
//        //  progressLabel.text = "Load content"
//    }
//    
//    func animateProgressView(PTime:Double, pauseP:Bool) {
//        
//        //   progressLabel.text = "Loading..."
//        progressLayer.strokeEnd     = 0.0
//        //  TTime                      = (total as NSString).doubleValue
//        let animation               = CABasicAnimation(keyPath: "strokeEnd")
//        
//        animation.fromValue         = CGFloat(PTime*0.1)
//        if pauseP == true{
//            
//            animation.toValue        = CGFloat(PTime*0.1)
//            
//        }else{
//            
//            animation.toValue           = CGFloat(1)
//            
//        }
//        
//        animation.duration         = totalSec
//        
//        animation.delegate          = self
//        animation.removedOnCompletion = false
//        animation.additive          = true
//        animation.fillMode          = kCAFillModeForwards
//        progressLayer.addAnimation(animation, forKey: "strokeEnd")
//    }
//    
//    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//        //   progressLabel.text = "Done"
//    }
//}
//
//
//


import UIKit
var imgSong: UIImageView!
var TTime:Double!

class ProgressView: UIView,CAAnimationDelegate {
    
    fileprivate let progressLayer: CAShapeLayer = CAShapeLayer()

    required init?(coder aDecoder: NSCoder) {
        imgSong = UIImageView()
        super.init(coder: aDecoder)
        createProgressLayer()
        createLabel()
    }
    
    override init(frame: CGRect) {
        imgSong = UIImageView()
        super.init(frame: frame)
        createProgressLayer()
        createLabel()
    }
    
    func createLabel() {
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
       {
            //let centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)
            let width = screenWidth * 0.48
            let height = screenWidth * 0.48
            let imgx = frame.width/2 - width/2 //centerPoint.x - CGRectGetWidth(frame)/2
            let imgy = frame.height/2 - height/2//centerPoint.y - CGRectGetHeight(frame)/2
            imgSong.removeFromSuperview()
            
            // let left = imgx/2 - width/2
            // let top =  imgy/2 - height/2
            // imgSong = UIImageView(frame:CGRectMake(left, top, width, height))
            imgSong = UIImageView(frame:CGRect(x: imgx , y: imgy , width: width, height: height))
            imgSong.layer.borderColor = UIColor(red: 218/255.0, green: 218/255.0, blue: 218/255.0, alpha: 1).cgColor
            imgSong.layer.borderWidth = 1.0
            imgSong.layer.cornerRadius = imgSong.frame.size.width/2
            imgSong.clipsToBounds = true
            imgSong.contentMode = UIViewContentMode.scaleAspectFill
            self.addSubview(imgSong)
        
            addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: imgSong, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: imgSong, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        }
            
        else if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            imgSong.isHidden = true
            
//            //let centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)
//            let width = screenWidth * 0.45
//            let height = screenWidth * 0.45
//            let imgx = CGRectGetWidth(frame)/2 - width/2 //centerPoint.x - CGRectGetWidth(frame)/2
//            let imgy = CGRectGetHeight(frame)/2 - height/2//centerPoint.y - CGRectGetHeight(frame)/2
//            imgSong.removeFromSuperview()
//            
//            // let left = imgx/2 - width/2
//            // let top =  imgy/2 - height/2
//            // imgSong = UIImageView(frame:CGRectMake(left, top, width, height))
//            imgSong = UIImageView(frame:CGRectMake(imgx , imgy , width, height))
//            imgSong.layer.borderColor = UIColor(red: 218/255.0, green: 218/255.0, blue: 218/255.0, alpha: 1).CGColor
//            imgSong.layer.borderWidth = 1.0
//            imgSong.layer.cornerRadius = imgSong.frame.size.width/2
//            imgSong.clipsToBounds = true
//            imgSong.contentMode = UIViewContentMode.ScaleAspectFill
//            self.addSubview(imgSong)
//            
//            addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: imgSong, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: imgSong, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
            
            
        }
    }
    
    fileprivate func createProgressLayer() {
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(M_PI * 2 + M_PI_2)
        let centerPoint = CGPoint(x: frame.width/2 , y: frame.height/2)
        
        let gradientMaskLayer = gradientMask()
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
                let radiusIphone = screenWidth * 0.50/2
                progressLayer.path = UIBezierPath(arcCenter:centerPoint, radius: radiusIphone , startAngle:startAngle, endAngle:endAngle, clockwise: true).cgPath
                progressLayer.backgroundColor = UIColor.clear.cgColor
                progressLayer.fillColor = nil
                progressLayer.strokeColor = UIColor.black.cgColor
                progressLayer.lineWidth = 9.0
                progressLayer.strokeStart = 0.0
                progressLayer.strokeEnd = 0.0
                layer.backgroundColor = UIColor.clear.cgColor
                //layer.frame = CGRectMake(0, 0, screenWidth, screenHeight)
                gradientMaskLayer.mask = progressLayer
                layer.addSublayer(gradientMaskLayer)
            
        }
            
        else if(UIDevice.current.userInterfaceIdiom == .pad)
        {
//            let radiusIphone = screenWidth * 0.47/2
//            progressLayer.path = UIBezierPath(arcCenter:centerPoint, radius: radiusIphone , startAngle:startAngle, endAngle:endAngle, clockwise: true).CGPath
//            progressLayer.backgroundColor = UIColor.clearColor().CGColor
//            progressLayer.fillColor = nil
//            progressLayer.strokeColor = UIColor.blackColor().CGColor
//            progressLayer.lineWidth = 10.0
//            progressLayer.strokeStart = 0.0
//            progressLayer.strokeEnd = 0.0
//            layer.backgroundColor = UIColor.redColor().CGColor
//            //layer.frame = CGRectMake(0, 0, screenWidth, screenHeight)
//            gradientMaskLayer.mask = progressLayer
//            layer.addSublayer(gradientMaskLayer)

            
            progressLayer.path = UIBezierPath(arcCenter:centerPoint, radius: frame.width/2 - 05 , startAngle:startAngle, endAngle:endAngle, clockwise: true).cgPath
            progressLayer.backgroundColor = UIColor.clear.cgColor
            progressLayer.fillColor = nil
            progressLayer.strokeColor = UIColor.black.cgColor
            progressLayer.lineWidth = 8.0
            progressLayer.strokeStart = 0.0
            progressLayer.strokeEnd = 0.0
            layer.backgroundColor = UIColor.clear.cgColor
            gradientMaskLayer.mask = progressLayer
            layer.addSublayer(gradientMaskLayer)
        }
        
    }
    
    fileprivate func gradientMask() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.locations = [0.0, 1.0]
        
        let colorTop: AnyObject = UIColor(red: 64/255.0, green: 154/255.0, blue: 145/255.0, alpha: 1).cgColor
        let colorBottom: AnyObject = UIColor(red: 64/255.0, green: 154/255.0, blue: 145/255.0, alpha: 1).cgColor
        let arrayOfColors: [AnyObject] = [colorTop, colorBottom]
        gradientLayer.colors = arrayOfColors
        return gradientLayer
    }
    
    func hideProgressView() {
        progressLayer.strokeEnd = 0.0
        progressLayer.removeAllAnimations()
        //  progressLabel.text = "Load content"
    }
    
    func animateProgressView(_ PTime:Double, pauseP:Bool) {
        
        //   progressLabel.text = "Loading..."
        progressLayer.strokeEnd     = 0.0
        //  TTime                      = (total as NSString).doubleValue
        let animation               = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.fromValue         = CGFloat(PTime*0.1)
        if pauseP == true{
            
            animation.toValue        = CGFloat(PTime*0.1)
            
        }else{
            
            animation.toValue           = CGFloat(1)
            
        }
        
        animation.duration            = totalSec
        animation.delegate            = self
        animation.isRemovedOnCompletion = false
        animation.isAdditive            = true
        animation.fillMode            = kCAFillModeForwards
        progressLayer.add(animation, forKey: "strokeEnd")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //   progressLabel.text = "Done"
    }
}


