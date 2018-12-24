//
//  EQView.swift
//  JWOMPA
//
//  Created by Ranjeet Singh on 15/11/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class EQView: UIView {

    var height:CGFloat = 0
    var width:CGFloat = 0
    
    var line1:CALayer = CALayer()
    var line2:CALayer = CALayer()
    var line3:CALayer = CALayer()
    var line4:CALayer = CALayer()
    
    var duration1:Float = 0
    var duration2:Float = 0
    var duration3:Float = 0
    var duration4:Float = 0
    
    var height1:CGFloat = 0.0
    var height2:CGFloat = 0.0
    var height3:CGFloat = 0.0
    var height4:CGFloat = 0.0
    
    var isPlaying:Bool = true
    
    var isFirstTime:Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        width = self.frame.width
        height = 20  //self.frame.height
        
        line1.frame = CGRect(x: 0, y: height, width: width*(20/100), height: 0)
        line1.backgroundColor = UIColor.black.cgColor
        line1.cornerRadius = 1.2
        self.layer.addSublayer(line1)
        
        
        line2.frame = CGRect(x: width*(25/100), y: height, width: width*(20/100), height: 0)
        line2.backgroundColor = UIColor.black.cgColor
        line2.cornerRadius = 1.2
        self.layer.addSublayer(line2)
        
        
        line3.frame = CGRect(x: width*(50/100), y: height, width: width*(20/100), height: 0)
        line3.backgroundColor = UIColor.black.cgColor
        line3.cornerRadius = 1.2
        self.layer.addSublayer(line3)
        
        
        line4.frame = CGRect(x: width*(75/100), y: height, width: width*(20/100), height: 0)
        line4.backgroundColor = UIColor.black.cgColor
        line4.cornerRadius = 1.2
        self.layer.addSublayer(line4)
        
        self.start()
    }
    
    func start(){
        
        if isFirstTime{
            isFirstTime = false
            Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(EQView.start1), userInfo: nil, repeats: true)
            Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(EQView.start2), userInfo: nil, repeats: true)
            Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(EQView.start3), userInfo: nil, repeats: true)
            Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(EQView.start4), userInfo: nil, repeats: true)
        }
        //self.start1()
        //self.start2()
        //self.start3()
        //self.start4()
    }
    
    
    func startEq(){
    
        isPlaying = true
        
        line1.isHidden = false
        line2.isHidden = false
        line3.isHidden = false
        line4.isHidden = false
    }
    
    func start1(){
        line1.frame = CGRect(x: 0, y: height, width: width*(20/100), height: 0)
        height1 = CGFloat(Int(arc4random_uniform(UInt32(height))))
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.line1.frame.origin.y = self.height - self.height1
            self.line1.frame.size.height = self.height1
            
        }) { (finished:Bool) in
            
        }
    }
    
    func start2(){
        height2 = CGFloat(Int(arc4random_uniform(UInt32(height))))
        line2.frame = CGRect(x: width*(25/100), y: height, width: width*(20/100), height: 0)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.line2.frame.origin.y = self.height - self.height2
            self.line2.frame.size.height = self.height2
            
        }) { (finished:Bool) in
            
        }
    }
    
    func start3(){
        height3 = CGFloat(Int(arc4random_uniform(UInt32(height))))
        line3.frame = CGRect(x: width*(50/100), y: height, width: width*(20/100), height: 0)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.line3.frame.origin.y = self.height - self.height3
            self.line3.frame.size.height = self.height3
            
        }) { (finished:Bool) in
            
        }
    }
    
    
    func start4(){
        height4 = CGFloat(Int(arc4random_uniform(UInt32(height))))
        line4.frame = CGRect(x: width*(75/100), y: height, width: width*(22/100), height: 0)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.line4.frame.origin.y = self.height - self.height4
            self.line4.frame.size.height = self.height4
            
        }) { (finished:Bool) in
            
        }
    }
    
    func stopEq(){
        isPlaying = false
        

        line1.isHidden = true
        line2.isHidden = true
        line3.isHidden = true
        line4.isHidden = true
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
