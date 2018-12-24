//
//  JForgotPasswordVC.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 19/02/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class JForgotPasswordVC: BaseViewController, UITextFieldDelegate , UIScrollViewDelegate {
    
    var textFieldFP : UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBar()
        JImage.shareInstance().destroy()
        self.view.backgroundColor = UIColor(red: 254/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
    }
    
    var willAppearCount = 0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if willAppearCount == 0 {
            self.setView()
        }
        willAppearCount += 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // for view
    
    func setView() {
        
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin = statusBarHeight + navBarHeight
        
        _ = JImage.shareInstance().setStatusBarDarkView(CGRect.init(x: 0, y: 0, width: screenWidth, height: 20), viewController: self)
        JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
        
        let lblWidth : CGFloat = screenWidth * 0.70
        let lblHeight : CGFloat = screenHeight * 0.04
        let lblLeftMargin : CGFloat = screenWidth/2-lblWidth/2
        let _ : CGFloat = UIApplication.shared.statusBarFrame.size.height/2 + upperView.bounds.size.height/2-lblHeight/2
        
        JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: lblLeftMargin, y: 25, width: lblWidth, height: lblHeight), nameOfString: "FORGOT PASSWORD")
        
        JImage.shareInstance().setBackButton(CGRect(x: 16, y: 26, width: 25, height: 25))
        
        _ = JImage.shareInstance().setMyScrollView(CGRect(x: 0, y: statusBarHeight + navBarHeight + 20, width: screenWidth, height: screenHeight-topMargin), viewController: self)
        
        let imageViewWidth : CGFloat = screenWidth * 0.30
        let imageViewHeight : CGFloat = screenHeight * 0.25
        let imageViewLeft : CGFloat = screenWidth/2 - imageViewWidth/2
        let imageViewTop : CGFloat = screenHeight * 0.07
        
        JImage.shareInstance().setMyImgView(CGRect(x: imageViewLeft, y: imageViewTop, width: imageViewWidth, height: imageViewHeight))
        
        let viewWidth = screenWidth * 0.80
        let viewHeight = screenHeight * 0.08
        let viewLeftMargin = screenWidth/2 - viewWidth/2
        let viewTopMargin = imageViewTop + imageViewHeight + screenHeight * 0.10 //screenHeight * 0.15 + screenHeight * 0.20
        
        let colorViewFP : UIView = UIView()
        colorViewFP.frame = CGRect(x: viewLeftMargin, y: viewTopMargin, width: viewWidth, height: viewHeight)
        colorViewFP.layer.borderColor = UIColor(red: 218/255.0, green: 218/255.0, blue: 218/255.0, alpha: 1).cgColor
        colorViewFP.layer.borderWidth = 1.0
        colorViewFP.layer.cornerRadius = 4
        colorViewFP.clipsToBounds = true
        colorViewFP.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
        scrollView.addSubview(colorViewFP)
        
        let tfWidth = screenWidth * 0.65
        let tfHeight = viewHeight * 0.70
        let tfLeft = screenWidth * 0.15
        let tfTop = viewHeight/2 - tfHeight/2
        
        textFieldFP  = UITextField()
        textFieldFP.frame = CGRect(x: tfLeft, y: tfTop, width: tfWidth, height: tfHeight)
        textFieldFP.placeholder = "Enter your email address";
        textFieldFP.delegate = self
        textFieldFP.font = textFontTextFields
        textFieldFP.keyboardType = .emailAddress
        textFieldFP.returnKeyType = .done
        textFieldFP.delegate = self
        textFieldFP.backgroundColor = UIColor.clear
        colorViewFP.addSubview(textFieldFP)
        
        let imgViewWidth = colorViewFP.bounds.size.width * 0.10
        let imgViewHeight = viewHeight * 0.70
        let imgLeft = colorViewFP.bounds.size.width * 0.05
        let imgTop = viewHeight/2 - tfHeight/2
        
        let imageView : UIImageView = UIImageView(frame: CGRect(x: imgLeft, y: imgTop, width: imgViewWidth, height: imgViewHeight))
        imageView.image = UIImage(named: "Email")
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        colorViewFP.addSubview(imageView)
        
        buttonBack.addTarget(self, action: #selector(JForgotPasswordVC.BackButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        let buttonSendOTPWidth = screenWidth * 0.80
        let buttonSendOTPHeight = screenHeight * 0.07
        let buttonSendOTPLeft = screenWidth/2 - buttonSendOTPWidth/2
        let buttonSendOTPTop = viewTopMargin + viewHeight + screenHeight * 0.05
        
        _ = JImage.shareInstance().setButton(CGRect(x: buttonSendOTPLeft, y: buttonSendOTPTop, width: buttonSendOTPWidth, height: buttonSendOTPHeight), nameOfTitle: "SEND CODE")
        button.addTarget(self, action: #selector(JForgotPasswordVC.OTPButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        let buttonAlreadyWidth = screenHeight * (58/100)
        let buttonAlreadyHeight = CGFloat(35.0)
        let buttonAlreadyLeft = screenWidth/2 - buttonAlreadyWidth/2
        let buttonAlreadyTop = screenHeight * 0.75
        
        _ = JImage.shareInstance().setAlreadyButton(CGRect(x: buttonAlreadyLeft, y: buttonAlreadyTop, width: buttonAlreadyWidth + 5, height: buttonAlreadyHeight), nameOfTitle: "Already have an account ? Sign In")
        
        let lblLineS : UILabel = UILabel(frame: CGRect(x: buttonAlready.frame.origin.x,y: buttonAlreadyTop + screenHeight * 0.045 ,width: buttonAlready.bounds.width,height: screenHeight * 0.002))
        lblLineS.backgroundColor = UIColor(red: 154/255.0, green: 155/255.0, blue: 156/255.0, alpha: 1)
        scrollView.addSubview(lblLineS)
        
        buttonAlready.addTarget(self, action: #selector(JForgotPasswordVC.GoToRoot(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func setNavBar(){
        self.navigationController?.isNavigationBarHidden=true
        self.automaticallyAdjustsScrollViewInsets=false
    }
    
    func GoToRoot(_ sender:UIButton){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func BackButtonTapped(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func OTPButtonTapped(_ sender:UIButton){
        
        if Validator.validateEmailAddress(self.textFieldFP.text! as NSString) {
            
            let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [textFieldFP.text!], forKeys: ["email" as NSCopying]);
            let strFunctionName = Constants().kForgotPassswordURL
            
            WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
                
                let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
                
                if(isOk == true){
                    
                    let userId:NSString = "\(responseObject.object(forKey: "id") as! NSNumber)" as NSString
                    
                    let userDefault : UserDefaults = UserDefaults.standard
                    userDefault.setValue(userId, forKey: "USER_ID")
                    
                    var strUID : String = String()
                    strUID = (userDefault.object(forKey: "USER_ID") as? String)!
                    
                    let strFPID : String = "\(responseObject.object(forKey: "id") as! NSNumber)"
                    
                    //go on TPQuesitionsVc
                    let obj_OTP = JOTPVC(nibName: "JOTPVC", bundle: nil)
                    obj_OTP.strOTP = strFPID
                    obj_OTP.strOTPUID = strUID
                    self.navigationController?.pushViewController(obj_OTP, animated: true)
                } else {
                    let message  = responseObject.object(forKey: "message") as! String;
                    self.alertViewFromApp(messageString:message );
                }
                
                
            }) { (error, operation) -> Void in
                self.alertViewFromApp(messageString:error.localizedDescription );
            }
        } else {
            obj_app.alertViewFromApp(messageString: "Invalid email address")
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(JForgotPasswordVC.hideKeyBoard(_:)))
        self.view.addGestureRecognizer(tap)
        
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            scrollView.setContentOffset(CGPoint(x: 0, y: textField.bounds.size.height * 3), animated: true)
        }) 
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }) 
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }) 
    }
    
    func hideKeyBoard(_ sender:UITapGestureRecognizer){
        textFieldFP.resignFirstResponder()
    }
}
