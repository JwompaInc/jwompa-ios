//
//  JSearchVC.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 04/04/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class JSearchVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        JImage.shareInstance().destroy()
        self.view.backgroundColor = UIColor(red: 254/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        self.setNavBar()
        self.setMyView()
    }

    func setNavBar()
    {
        self.navigationController?.isNavigationBarHidden=true
        self.automaticallyAdjustsScrollViewInsets=false
    }
    
    func setMyView()
    {
        let navBarHeight    : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin    = statusBarHeight + navBarHeight + screenHeight * 0.03
        
        _ = JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
        
        // Setting Label on Upper View
        
        let lblWidth : CGFloat = screenWidth * 0.70
        let lblHeight : CGFloat = screenHeight * 0.04
        let lblLeftMargin : CGFloat = screenWidth/2-lblWidth/2
        let lblTopMargin : CGFloat = UIApplication.shared.statusBarFrame.size.height/2 + upperView.bounds.size.height/2-lblHeight/2
        
        let searchBar: UISearchBar = UISearchBar(frame: CGRect(x: lblLeftMargin, y: lblTopMargin, width: lblWidth, height: lblHeight))
        upperView.addSubview(searchBar)
               
         _ = JImage.shareInstance().setBackButton(CGRect(x: 16, y: lblTopMargin, width: screenWidth * 0.10, height: lblHeight))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


