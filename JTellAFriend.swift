//
//  JTellAFriend.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 05/04/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class JTellAFriend: BaseViewController , UIScrollViewDelegate , UITextFieldDelegate {

    let txtField1 : TextField = TextField()
    let txtField2 : TextField = TextField()
    let txtField3 : TextField = TextField()
    let txtField4 : TextField = TextField()
    let txtField5 : TextField = TextField()
    var yaxis : CGFloat = CGFloat()
    
    var scrollView:UIScrollView!
    
    var eq:Equelizer!
    
    
    var text_field:UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        JImage.shareInstance().destroy()
        self.view.backgroundColor = UIColor(red: 254/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        //scrollView.delegate = self
        self.setNavBar()
        self.setMyView()
    }
    
    func setMyView(){
        
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin    = statusBarHeight + navBarHeight
        
        JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
        JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: 60, y: 25, width: screenWidth - 120, height: 30), nameOfString: "TELL A FRIEND")
        
        JImage.shareInstance().setBackButton(CGRect(x: 15,y: 30,width: 20,height: 20))
        buttonBack.addTarget(self, action: #selector(JTellAFriend.BackButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: topMargin, width: screenWidth, height: screenHeight-topMargin)
        self.view.addSubview(scrollView)
        
        
        
        let lbl : UILabel = UILabel(frame: CGRect(x: screenWidth*(5/100) ,y: screenHeight*(3/100),width: screenWidth*(90/100),height: screenHeight*(10/100)))
        lbl.backgroundColor = UIColor.clear
        lbl.text = "Please enter email address to send friends an invitation to download app"
        lbl.textColor = UIColor.black
        lbl.numberOfLines = 2
        lbl.backgroundColor = UIColor.clear
        lbl.tintColor = UIColor(red: 130/255.0, green: 130/255.0, blue: 131/255.0, alpha: 1)
        lbl.font = UIFont(name: "OpenSans", size: screenHeight * 0.025)
        lbl.textAlignment = NSTextAlignment.left
        scrollView.addSubview(lbl)
        
        
        
        txtField1.frame = CGRect(x: screenWidth*(10/100), y:  screenHeight*(15/100), width: screenWidth*(80/100), height: 50)
        txtField1.placeholder = "Enter Email"
        txtField1.layer.cornerRadius = 4
        txtField1.clipsToBounds = true
        txtField1.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
        txtField1.delegate = self
        txtField1.tag = 111
        txtField1.returnKeyType = .next
        txtField1.keyboardType = .emailAddress
        txtField1.font = textFontTable
        scrollView.addSubview(txtField1)
        
        
        
        txtField2.frame = CGRect(x: screenWidth*(10/100), y: txtField1.frame.origin.y + txtField1.frame.size.height + 10, width: screenWidth*(80/100), height: 50)
        txtField2.placeholder = "Enter Email"
        txtField2.layer.cornerRadius = 4
        txtField2.clipsToBounds = true
        txtField2.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
        txtField2.delegate = self
        txtField2.tag = 112
        txtField2.returnKeyType = .next
        txtField2.keyboardType = .emailAddress
        txtField2.font = textFontTable
        scrollView.addSubview(txtField2)
        
        
        
        txtField3.frame = CGRect(x: screenWidth*(10/100), y: txtField2.frame.origin.y + txtField2.frame.size.height + 10, width: screenWidth*(80/100), height: 50)
        txtField3.placeholder = "Enter Email"
        txtField3.layer.cornerRadius = 4
        txtField3.clipsToBounds = true
        txtField3.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
        txtField3.delegate = self
        txtField3.tag = 113
        txtField3.returnKeyType = .next
        txtField3.keyboardType = .emailAddress
        txtField3.font = textFontTable
        scrollView.addSubview(txtField3)
        
        
        
        txtField4.frame = CGRect(x: screenWidth*(10/100), y: txtField3.frame.origin.y + txtField3.frame.size.height + 10, width: screenWidth*(80/100), height: 50)
        txtField4.placeholder = "Enter Email"
        txtField4.layer.cornerRadius = 4
        txtField4.clipsToBounds = true
        txtField4.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
        txtField4.delegate = self
        txtField4.tag = 114
        txtField4.returnKeyType = .next
        txtField4.keyboardType = .emailAddress
        txtField4.font = textFontTable
        scrollView.addSubview(txtField4)
        
        
        
        txtField5.frame = CGRect(x: screenWidth*(10/100), y: txtField4.frame.origin.y + txtField4.frame.size.height + 10, width: screenWidth*(80/100), height: 50)
        txtField5.placeholder = "Enter Email"
        txtField5.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
        txtField5.delegate = self
        txtField5.layer.cornerRadius = 4
        txtField5.clipsToBounds = true
        txtField5.tag = 115
        txtField5.returnKeyType = .next
        txtField5.keyboardType = .emailAddress
        txtField5.returnKeyType = .done
        txtField5.font = textFontTable
        scrollView.addSubview(txtField5)
        
        
        
        let buttonSubmit = UIButton()
        buttonSubmit.frame = CGRect(x: screenWidth*(10/100), y: txtField5.frame.origin.y + txtField5.frame.size.height + 25, width: screenWidth*(80/100), height: 50)
        buttonSubmit.backgroundColor = UIColor.clear
        buttonSubmit.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        buttonSubmit.backgroundColor = UIColor(red: 61/255.0, green: 156/255.0, blue: 147/255.0, alpha: 1)
        buttonSubmit.setTitleColor(UIColor.white, for: UIControlState())
        buttonSubmit.showsTouchWhenHighlighted = true
        buttonSubmit.layer.cornerRadius = 5
        buttonSubmit.setTitle("SUBMIT", for: UIControlState())
        buttonSubmit.addTarget(self, action: #selector(JTellAFriend.RegButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        scrollView.addSubview(buttonSubmit)
        
        
        
        self.scrollView.contentSize = CGSize(width: 0, height: screenHeight*(15/100) + 330)
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(JLoginVC.hideKeyBoard(_:)))
        self.view.addGestureRecognizer(tap)
        
        
        eq = Equelizer(frame: CGRect(x: screenWidth - 30, y: 20, width: 25, height: 30))
        eq.tapBtn.addTarget(self, action: #selector(self.imageTapped), for: UIControlEvents.touchUpInside)
        upperView.addSubview(eq)
        
    }
    
    func hideKeyBoard(_ sender:UITapGestureRecognizer){
        if(self.text_field != nil){
            self.text_field.resignFirstResponder()
        }
    }
    
    
    func setNavBar() {
        self.navigationController?.isNavigationBarHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
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
    
    
    
    func RegButtonTapped(_ sender:UIButton){
        
        if(txtField1.text == ""){
            obj_app.getAlert("Atleast one email is required")
        }else if (!self.isValidEmail(emailStr: txtField1.text!) && txtField1.text != "") || (!self.isValidEmail(emailStr: txtField2.text!) && txtField2.text != "") || (!self.isValidEmail(emailStr: txtField3.text!) && txtField3.text != "") || (!self.isValidEmail(emailStr: txtField4.text!) && txtField4.text != "") || (!self.isValidEmail(emailStr: txtField5.text!) && txtField5.text != "") {
                obj_app.getAlert("Enter a valid Email Address")
        }else{
            
            let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [txtField1.text!,txtField2.text!,txtField3.text!,txtField4.text!,txtField5.text!], forKeys: ["email_first" as NSCopying,"email_second" as NSCopying,"email_third" as NSCopying,"email_forth" as NSCopying,"email_five" as NSCopying])
            let strFunctionName = Constants().kTellAFriend
            
            WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
                
                let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
                
                if(isOk == true){
                    let message  = responseObject.object(forKey: "message") as! String;
                    let alertController = UIAlertController.init(title: "Message", message: message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default , handler: { (alertAction) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    let message  = responseObject.object(forKey: "message") as! String;
                    // MARK: TEST
//                    self.alertViewFromApp(messageString:message );
                }
                
                
                }) { (error, operation) -> Void in
                    
                        let message  = "Something wrong happning , Please wait for proper response of server";
                       self.alertViewFromApp(messageString:message );
            }
        }
    }
    
    func BackButtonTapped(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        text_field = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        text_field = textField
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTag:NSInteger = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    func keyboardWillShow(_ notification: Notification) {
        
        var info = (notification as NSNotification).userInfo!
        let keyboardSize: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let contentInsets:UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
        
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        var rect:CGRect = self.view.frame
        rect.size.height -= keyboardSize.height;
        
        if(self.text_field == nil){
            return
        }
        
        if(self.text_field.frame.origin.y < rect.size.height){
            return
        }
        
        if (!rect.contains(self.text_field.frame.origin)){
            let scrollPoint:CGPoint = CGPoint(x: 0.0, y: self.text_field.frame.origin.y - (rect.size.height - self.text_field.frame.size.height) + 60);
            self.scrollView.setContentOffset(scrollPoint, animated: false)
        }
    }
    
    func keyboardWillHide(_ sender: Notification) {
        
        let contentInsets:UIEdgeInsets = UIEdgeInsets.zero;
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = Constants().kEmailVerification
        let emailTest = NSPredicate(format:Constants().kSelfMatchQuerey, emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }

}
