//
//  JABoutJwompa.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 22/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit
import AFNetworking

class JABoutJwompa: BaseViewController,UITextViewDelegate {
    
    var arrayAUS : NSMutableArray = NSMutableArray()
    var imageViewHeight : CGFloat = CGFloat()
    var imageViewTop : CGFloat = CGFloat()

    var eq:Equelizer!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavBar()
        JImage.shareInstance().destroy()
        self.view.backgroundColor = UIColor(red: 254/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        self.setMyView()
        
        let strFunctionName = Constants().kAboutus
        
        WebService.callGetServicewithStringPerameters(StringPerameter: "", FunctionName: strFunctionName, succes: { (responseObject:NSMutableDictionary, operation:AFHTTPRequestOperation) in
            
            if(responseObject.object(forKey: "user_data") != nil){

                self.arrayAUS = ((responseObject.object(forKey: "user_data") as! NSArray).mutableCopy() as? NSMutableArray)!

                var str : String = String()
                str = ((self.arrayAUS.object(at: 0) as! NSDictionary).object(forKey: "description") as? String)!

                let attrstr1 = try! NSAttributedString(data: str .data(using: String.Encoding.utf8)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)

                let txtView : UITextView = UITextView()
                txtView.frame = CGRect(x: 0, y: self.imageViewHeight + self.imageViewTop, width: screenWidth, height: screenHeight - upperView.bounds.size.height)
                txtView.delegate = self
                txtView.backgroundColor = UIColor.clear
                txtView.isUserInteractionEnabled = false
                txtView.attributedText = attrstr1
                self.view.addSubview(txtView)
            }

        }) { (error, operation) in
            self.alertViewFromApp(messageString: error.description)
        }
    }
    
    // Set Nav Bar
    
    func setNavBar(){
        self.navigationController?.isNavigationBarHidden=true
        self.automaticallyAdjustsScrollViewInsets=false
    }
    
    func setMyView(){
        
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin    = statusBarHeight + navBarHeight
        
        JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
        JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: 60, y: 25, width: screenWidth - 120, height: 30), nameOfString: "ABOUT JWOMPA")
        
        JImage.shareInstance().setBackButton(CGRect(x: 15,y: 30,width: 20,height: 20))
        buttonBack.addTarget(self, action: #selector(JABoutJwompa.BackButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        
        let imageViewWidth : CGFloat = screenWidth * 0.30
        imageViewHeight  = screenHeight * 0.25
        let imageViewLeft : CGFloat = screenWidth/2 - imageViewWidth/2
        imageViewTop = upperView.bounds.size.height + screenHeight * 0.02
        
        let imageView : UIImageView = UIImageView(frame: CGRect(x: imageViewLeft, y: imageViewTop, width: imageViewWidth, height: imageViewHeight))
        imageView.image = UIImage(named:"logo-380")
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.backgroundColor = UIColor.clear
        self.view.addSubview(imageView)
        
        
        
        
        eq = Equelizer(frame: CGRect(x: screenWidth - 30, y: 20, width: 25, height: 30))
        eq.tapBtn.addTarget(self, action: #selector(self.imageTapped), for: UIControlEvents.touchUpInside)
        upperView.addSubview(eq)
    }
    
    
    func imageTapped(){
        
        print("image taped")
        
        var flag = 0
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: JPlayerVC.self) {
                flag = 1
                self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                break
            }
        }
        
        if(flag == 0 && AudioPlayerModel.shared.MainPlayerVC != nil){
            self.navigationController?.pushViewController(AudioPlayerModel.shared.MainPlayerVC, animated: true)
        }
    }
    
    
    func BackButtonTapped(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


