//
//  JOTPVC.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 19/02/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit


class JOTPVC: BaseViewController, UITextFieldDelegate , UIScrollViewDelegate {

    var strOTP : String = String()
    var strOTPUID : String = String()
    
    var eq:Equelizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavBar()
        JImage.shareInstance().destroy()
        self.view.backgroundColor = UIColor(red: 254/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        scrollView.delegate = self
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
    
    func setView(){
        
        let navBarHeight    : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        
        let topMargin    = statusBarHeight + navBarHeight

        JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
        
        let lblWidth : CGFloat = screenWidth * 0.70
        let lblHeight : CGFloat = screenHeight * 0.04
        let lblLeftMargin : CGFloat = screenWidth/2-lblWidth/2
        let lblTopMargin : CGFloat = UIApplication.shared.statusBarFrame.size.height/2 + upperView.bounds.size.height/2-lblHeight/2
        
        JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: lblLeftMargin, y: 25, width: lblWidth, height: lblHeight), nameOfString: "ENTER CODE")
        
        JImage.shareInstance().setBackButton(CGRect(x: 16, y: 26, width: 25, height: 25))
        
        JImage.shareInstance().setMyScrollView(CGRect(x: 0, y: statusBarHeight + navBarHeight + 20, width: screenWidth, height: screenHeight-topMargin), viewController: self)
        
        buttonBack.addTarget(self, action: #selector(JOTPVC.BackButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        let imageViewWidth : CGFloat = screenWidth * 0.30
        let imageViewHeight = screenHeight * 0.25
        let imageViewLeft : CGFloat = screenWidth/2 - imageViewWidth/2
        let imageViewTop  = screenHeight * 0.07
        
        JImage.shareInstance().setMyImgView(CGRect(x: imageViewLeft, y: imageViewTop, width: imageViewWidth, height: imageViewHeight))
        
        let lblOTPWidth = screenWidth * 0.50
        let lblOTPHeight = screenHeight * 0.10
        let lblOTPLeftMargin = screenWidth/2 - lblOTPWidth/2
        let lblOTPTopMargin = imageViewTop + imageViewHeight + screenHeight * 0.02
        
        let label: UILabel = UILabel(frame: CGRect(x: lblOTPLeftMargin,y: lblOTPTopMargin,width: lblOTPWidth,height: lblOTPHeight))
        label.textAlignment = .center
        label.font = textFontTextFields
        label.numberOfLines = 3
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor(red: 154/255.0, green: 155/255.0, blue: 156/255.0, alpha: 1)
        label.text = "Please check your inbox for a code sent to you."
        scrollView.addSubview(label)
        
        
        let viewWidth = screenWidth * 0.80
        let viewHeight = screenHeight * 0.08
        let viewLeftMargin = screenWidth/2 - viewWidth/2
        let viewTopMargin = lblOTPTopMargin + lblOTPHeight + screenHeight * 0.03

        JImage.shareInstance().setView(CGRect(x: viewLeftMargin, y: viewTopMargin, width: viewWidth, height: viewHeight))
        
        let tfWidth = screenWidth * 0.80
        let tfHeight = viewHeight * 0.70
        let tfTop = viewHeight/2 - tfHeight/2
        
        JImage.shareInstance().setTextField(CGRect(x: 0, y: tfTop, width: tfWidth, height: tfHeight), placeholderName: "Enter Code")

        textFieldSinglton.delegate = self
        
        let buttonSendOTPWidth = screenWidth * 0.80
        let buttonSendOTPHeight = screenHeight * 0.07
        let buttonSendOTPLeft = screenWidth/2 - buttonSendOTPWidth/2
        let buttonSendOTPTop = viewTopMargin + viewHeight + screenHeight * 0.03

        JImage.shareInstance().setButton(CGRect(x: buttonSendOTPLeft, y: buttonSendOTPTop, width: buttonSendOTPWidth, height: buttonSendOTPHeight), nameOfTitle: "SUBMIT")
        
        button.addTarget(self, action:#selector(JOTPVC.SubmitButtonTapped(_:)), for:UIControlEvents.touchUpInside)
        
        let buttonAlreadyWidth = screenHeight * (58/100)
        let buttonAlreadyHeight = CGFloat(35.0)
        let buttonAlreadyLeft = screenWidth/2 - buttonAlreadyWidth/2
        let buttonAlreadyTop = screenHeight * 0.75
        
        _ = JImage.shareInstance().setStatusBarDarkView(CGRect.init(x: 0, y: 0, width: screenWidth, height: 20), viewController: self)
        _ = JImage.shareInstance().setAlreadyButton(CGRect(x: buttonAlreadyLeft, y: buttonAlreadyTop, width: buttonAlreadyWidth + 5, height: buttonAlreadyHeight), nameOfTitle: "Already have an account ? Sign In")
        
        let lblLineS : UILabel = UILabel(frame: CGRect(x: buttonAlready.frame.origin.x,y: buttonAlreadyTop + screenHeight * 0.045 ,width: buttonAlready.bounds.width,height: screenHeight * 0.002))
        
        lblLineS.backgroundColor = UIColor(red: 154/255.0, green: 155/255.0, blue: 156/255.0, alpha: 1)
        scrollView.addSubview(lblLineS)
        
        buttonAlready.addTarget(self, action: #selector(JOTPVC.GoToRoot(_:)), for: UIControlEvents.touchUpInside)
        
        
        
        eq = Equelizer(frame: CGRect(x: screenWidth - 30, y: 20, width: 25, height: 30))
        eq.tapBtn.addTarget(self, action: #selector(self.imageTapped), for: UIControlEvents.touchUpInside)
        upperView.addSubview(eq)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(JHomeVC.imageTapped))
        eq.isUserInteractionEnabled = true
        eq.addGestureRecognizer(tapGestureRecognizer)
        
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
    
    func GoToRoot(_ sender:UIButton){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func SubmitButtonTapped(_ sender:UIButton){
        
        let arr: NSArray! = NSArray(object: textFieldSinglton);
        
        //check everything...
        let dict :NSDictionary = Validator.getAllTxtFields(arrtxtFieldsIs: arr, placHoldrEmail: "Email Address", placePhoneNumber: "Mobile Number")
        
        let flag  : Int32 = ((dict.object(forKey: "flag") as AnyObject).int32Value)!;
        
        if(flag == 1){
            let perameteres:NSMutableDictionary! = NSMutableDictionary(objects:[strOTP,textFieldSinglton.text!], forKeys:  ["id" as NSCopying,"password_reset_code" as NSCopying]);
            let strFunctionName = Constants().kVerifyOtp
            
            WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
                
                let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
                
                if(isOk == true){
                    
                    //                    let userId:NSString = NSString(format: "%d",(responseObject.objectForKey("user_id")?.intValue)! );
                    //
                    //                    // let fullName:NSString = NSString(format: "%@",responseObject.objectForKey("full_name") as! String );
                    //
                    //                    userDefault.setValue(userId, forKey: userIdKey);
                    //                    strUSerID = userDefault.objectForKey(userIdKey) as! String;
                    //                    //userDefault.setValue(fullName, forKey: userNameKey);
                    //
                    //                    strUserName = userDefault.objectForKey(userIdKey) as! String;
                    //
                    //                    NSLog("strUserName %@",strUserName );
                    
                    
                    //go on TPQuesitionsVc
                    
                    let message  = responseObject.object(forKey: "message") as! String;
                  
                    let enterNewPass : JEnterNewPassWord = JEnterNewPassWord()
                    enterNewPass.strFPUID = self.strOTPUID
                    self.navigationController?.pushViewController(enterNewPass, animated: true)
                
                }else{
                    let message  = responseObject.object(forKey: "message") as! String;
                    self.alertViewFromApp(messageString:message );
                }
                
                
                }) { (error, operation) -> Void in
                    
                    //     let message  = "Something wrong happning , Please wait for proper response of server";
                    //   self.alertViewFromApp(messageString:message );
            }
        }
    }

    
    func setNavBar(){
        self.navigationController?.isNavigationBarHidden=true
        self.automaticallyAdjustsScrollViewInsets=false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(JOTPVC.hideKeyBoard(_:)))
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
    
    func hideKeyBoard(_ sender:UITapGestureRecognizer)
    {
        
       textFieldSinglton.resignFirstResponder()
    }

}
