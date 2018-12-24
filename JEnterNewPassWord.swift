
//  JEnterNewPassWord.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 18/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class JEnterNewPassWord: BaseViewController,UITextFieldDelegate, UIScrollViewDelegate {

    var arrayForTextField : NSMutableArray!
    var strFPUID : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyBoard:")
//        self.view.addGestureRecognizer(tap)
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
    
    func hideKeyBoard(_ sender:UITapGestureRecognizer){
        SideView.sharedInstance().closeView()
        
        for i in 0   ..< arrayForTextField.count {
            let txt:UITextField! = arrayForTextField.object(at: i) as! UITextField;
            txt.resignFirstResponder();
        }
    }
    
        
    func setNavBar(){
        self.navigationController?.isNavigationBarHidden=true
        self.automaticallyAdjustsScrollViewInsets=false
    }
    
    func BackButtonTapped(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setView(){
        
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin    = statusBarHeight + navBarHeight
        
        JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
        
        let lblWidth : CGFloat = screenWidth * 0.70
        let lblHeight : CGFloat = screenHeight * 0.04
        let lblLeftMargin : CGFloat = screenWidth/2-lblWidth/2
        let lblTopMargin : CGFloat = UIApplication.shared.statusBarFrame.size.height/2 + upperView.bounds.size.height/2-lblHeight/2
        
        JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: lblLeftMargin, y: 25, width: lblWidth, height: lblHeight), nameOfString: "ENTER NEW PASSWORD")
        JImage.shareInstance().setBackButton(CGRect(x: 16, y: 26, width: 25, height: 25))
        
        
        _ = JImage.shareInstance().setMyScrollView(CGRect(x: 0, y: statusBarHeight + navBarHeight + 20, width: screenWidth, height: screenHeight-topMargin), viewController: self)
        buttonBack.addTarget(self, action: #selector(JEnterNewPassWord.BackButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        let imageViewWidth : CGFloat = screenWidth * 0.30
        let imageViewHeight : CGFloat = screenHeight * 0.25
        let imageViewLeft : CGFloat = screenWidth/2 - imageViewWidth/2
        let imageViewTop : CGFloat = screenHeight * 0.07
        
        _ = JImage.shareInstance().setMyImgView(CGRect(x: imageViewLeft, y: imageViewTop, width: imageViewWidth, height: imageViewHeight))
        
        //// For View of Reg
        
        let arrayForView : NSMutableArray = NSMutableArray()
        
        let viewWidth = screenWidth * 0.80
        let viewHeight = screenHeight * 0.08
        let viewLeftMargin = screenWidth/2 - viewWidth/2
        var viewTopMargin  = imageViewTop + imageViewHeight + screenHeight * 0.03
        
        //// For TextField
        
        arrayForTextField = NSMutableArray()
        let arrayForPlaceHolder : NSMutableArray = NSMutableArray(objects: "Enter Password","Re-Enter Password")
        
        let tfRegWidth = screenWidth * 0.65
        let tfRegHeight = viewHeight * 0.70
        let tfRegLeft = screenWidth * 0.15
        let tfRegTop = viewHeight/2 - tfRegHeight/2
        
        // For Image View
        
        let arrayForImage : NSMutableArray = NSMutableArray(objects: UIImage(named: "password")!,UIImage(named: "password")!)
        
        for iView in 0...1 {
            let  colorView = UIView(frame: CGRect(x: viewLeftMargin,y: viewTopMargin,width: viewWidth,height: viewHeight))
            colorView.layer.borderColor = UIColor(red: 218/255.0, green: 218/255.0, blue: 218/255.0, alpha: 1).cgColor
            colorView.layer.borderWidth = 1.0
            colorView.layer.cornerRadius = 4
            colorView.clipsToBounds = true
            colorView.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
            colorView.tag = iView
            
            let textFieldWelcome:UITextField = UITextField(frame: CGRect(x: tfRegLeft,y: tfRegTop,width: tfRegWidth,height: tfRegHeight))
            textFieldWelcome.tag = iView
            textFieldWelcome.placeholder = arrayForPlaceHolder.object(at: iView) as? String
            textFieldWelcome.backgroundColor = UIColor.clear
            textFieldWelcome.delegate = self
            textFieldWelcome.font = textFontTextFields
            
            if(iView == 0){
                textFieldWelcome.isSecureTextEntry = true
//                textFieldWelcome.text = ""
                textFieldWelcome.returnKeyType = .next
            }else{
                textFieldWelcome.isSecureTextEntry = true
//                textFieldWelcome.text = ""
                textFieldWelcome.returnKeyType = .done
            }
            
            arrayForView.add(colorView)
            arrayForTextField.add(textFieldWelcome)
            
            print(viewTopMargin)
            print(textFieldWelcome)
            
            scrollView.addSubview(arrayForView.object(at: iView) as! UIView)
            colorView.addSubview(arrayForTextField.object(at: iView) as! UITextField)
            
            viewTopMargin += screenHeight * 0.10
            
            let imgViewWidth = colorView.bounds.size.width * 0.10
            let imgViewHeight = viewHeight * 0.70
            let imgLeft = colorView.bounds.size.width * 0.05
            let imgTop = viewHeight/2 - tfRegHeight/2
            
            let imageView : UIImageView = UIImageView(frame: CGRect(x: imgLeft, y: imgTop, width: imgViewWidth, height: imgViewHeight))
            imageView.image = arrayForImage.object(at: iView) as? UIImage
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            imageView.backgroundColor = UIColor.clear
            colorView.addSubview(imageView)
    }
        
        
        let buttonRegWidth = screenWidth * 0.80
        let buttonRegHeight = screenHeight * 0.07
        let buttonRegLeft = screenWidth/2 - buttonRegWidth/2
        let buttonRegTop = viewTopMargin + screenHeight * 0.02 + 20
        
                
        _ = JImage.shareInstance().setStatusBarDarkView(CGRect.init(x: 0, y: 0, width: screenWidth, height: 20), viewController: self)
        _ = JImage.shareInstance().setButton(CGRect(x: buttonRegLeft, y: buttonRegTop, width: buttonRegWidth, height: buttonRegHeight), nameOfTitle: "SUBMIT")
        
        
        button.addTarget(self, action: #selector(JEnterNewPassWord.NewPasswordTapped(_:)), for: UIControlEvents.touchUpInside)
        
        
        let buttonAlreadyWidth = screenHeight * (58/100)
        let buttonAlreadyHeight = CGFloat(35.0)
        let buttonAlreadyLeft = screenWidth/2 - buttonAlreadyWidth/2
        let buttonAlreadyTop = screenHeight * 0.75
        
        _ = JImage.shareInstance().setAlreadyButton(CGRect(x: buttonAlreadyLeft, y: buttonAlreadyTop, width: buttonAlreadyWidth + 5, height: buttonAlreadyHeight), nameOfTitle: "Already have an account ? Sign In")
        
        let lblLineS : UILabel = UILabel(frame: CGRect(x: buttonAlready.frame.origin.x,y: buttonAlreadyTop + screenHeight * 0.045 ,width: buttonAlready.bounds.width,height: screenHeight * 0.002))
        lblLineS.backgroundColor = UIColor(red: 154/255.0, green: 155/255.0, blue: 156/255.0, alpha: 1)
        scrollView.addSubview(lblLineS)
        
        buttonAlready.addTarget(self, action: #selector(JEnterNewPassWord.GoToRoot(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    func GoToRoot(_ sender:UIButton){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(JEnterNewPassWord.hideKeyBoard(_:)))
        self.view.addGestureRecognizer(tap)
        
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            scrollView.setContentOffset(CGPoint(x: 0, y: textField.bounds.size.height * 3), animated: true)
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let txtEmail:UITextField! = arrayForTextField.object(at: 0) as! UITextField
        let txtPass:UITextField! = arrayForTextField.object(at: 1) as! UITextField
        
        if(textField == txtEmail){
            txtPass.becomeFirstResponder()
        }else{
            txtPass.resignFirstResponder()
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }) 
        
        
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }) 
    }
    
    func NewPasswordTapped(_ sender:UIButton){
        
        // get all textfields here..
        let txtFieldEmail:    UITextField!   = arrayForTextField.object(at: 0) as! UITextField;
        let txtFieldPassword :UITextField!   = arrayForTextField.object(at: 1) as! UITextField;
        
        if(txtFieldEmail.text == txtFieldPassword.text){
            
            // get all textfields here..
            let txtFieldEmail :    UITextField!   = arrayForTextField.object(at: 0) as! UITextField;
            let txtFieldPassword : UITextField!   = arrayForTextField.object(at: 1) as! UITextField;
            
            let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [strFPUID,txtFieldEmail.text!], forKeys: ["id" as NSCopying,"password" as NSCopying]);
            let strFunctionName = Constants().kNewPassword
            
            WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
                
                let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
                
                if(isOk == true){
                   self.navigationController?.popToRootViewController(animated: true)
                    let message  = responseObject.object(forKey: "message") as! String;
                    self.alertViewFromApp(messageString:message);
                }else{
                    let message  = responseObject.object(forKey: "message") as! String;
                    self.alertViewFromApp(messageString:message);
                }
                
                }) { (error, operation) -> Void in
                    let message  = "Something went wrong!"
                    self.alertViewFromApp(messageString:message );
        }
        
        }else{
            self.alertViewFromApp(messageString:"Password not Matching");
        }
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


