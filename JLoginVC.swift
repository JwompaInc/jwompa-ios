//
//  JLoginVC.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 19/02/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class JLoginVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavBar()
        JImage.shareInstance().destroy()
        self.view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 1/255.0, alpha: 1)
        
        let width = screenWidth * 0.80
        let height = screenHeight * 0.20
        let left = screenWidth/2 - width/2
        let top = screenHeight/2 - height/2
    
        let lbl : UILabel = UILabel(frame: CGRect(x: left,y: top,width: width ,height: height))
        lbl.backgroundColor = UIColor.clear
        lbl.text = "Home Page is Under Construction! Click on the Screen to go to the Welcome Page"
        lbl.textColor = UIColor.white
        lbl.numberOfLines = 5
        lbl.font = textFont
        lbl.textAlignment = NSTextAlignment.center
        self.view.addSubview(lbl)
        
        _ = JImage.shareInstance().setBackButton(CGRect(x: 15, y: 30, width: 25, height: 25))
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(JLoginVC.hideKeyBoard(_:)))
        self.view.addGestureRecognizer(tap)
    
    }

    func hideKeyBoard(_ sender:UITapGestureRecognizer){
        self.navigationController?.popViewController(animated: true)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavBar(){
        self.navigationController?.isNavigationBarHidden=true
        self.automaticallyAdjustsScrollViewInsets=false
    }
    

}
