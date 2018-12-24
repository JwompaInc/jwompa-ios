//
//  JRegistrationVC.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 19/02/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit
import FirebaseInstanceID

var strUserName:String!

class JRegistrationVC: BaseViewController, UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate,CityListDelegate {

    var yaxis : CGFloat = CGFloat()
    
    var scrollView:UIScrollView!
    
    var emailTxtFld : ImageTextField = ImageTextField() // Email text field
    var firstNameTextFld : ImageTextField = ImageTextField() // full name
    var passwordTxtFld : ImageTextField = ImageTextField() // password
    var confirmPasswordTxtFld : ImageTextField = ImageTextField() // confirm password
    var werRUFrmTextFld : ImageTextField = ImageTextField() // where are you from
    var dobTextFld : ImageTextField = ImageTextField() // birth date
    var lastNameTxtFld: ImageTextField = ImageTextField()
    let redColor = UIColor.init(red: 217/255, green: 31/255, blue: 38/255, alpha: 1).cgColor
    let greenColor = UIColor.init(red: 54/255, green: 146/255, blue: 68/255, alpha: 1).cgColor
    var cityListVC:CityListViewController!
    
    var text_field:UITextField!
    
    
    let arrayForTextField : NSMutableArray = NSMutableArray()
    var tagBtnAgree:Int!
    var ViewForDatePicker : UIView = UIView()
    var doneToolBarDate : UIToolbar = UIToolbar()
    var datePicker : UIDatePicker = UIDatePicker()
    var dateForParam: String = ""

    var isRegistrationSuccess: Bool!
    var willAppearCount = 0
    
    var openingPreference1VC:OpeningPreferencesViewController1!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if willAppearCount == 0 {
            self.setMyView()
        }
        willAppearCount += 1
        
        
        if let isRegistrationSuccessValue = isRegistrationSuccess {
            if isRegistrationSuccessValue {
                self.emailTxtFld.text = ""
                self.firstNameTextFld.text = ""
                self.lastNameTxtFld.text = ""
                self.passwordTxtFld.text = ""
                self.confirmPasswordTxtFld.text = ""
                self.werRUFrmTextFld.text = ""
                self.dobTextFld.text = ""
            }
        }
        
     //   bannerView.removeFromSuperview()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBar()
        JImage.shareInstance().destroy()
        self.view.backgroundColor = UIColor(red: 254/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavBar()
    {
        self.navigationController?.isNavigationBarHidden=true
        self.automaticallyAdjustsScrollViewInsets=false
    }
    
    func BackButtonTapped(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    func setMyView() {
        
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin    = statusBarHeight + navBarHeight
        
        _ = JImage.shareInstance().setStatusBarDarkView(CGRect.init(x: 0, y: 0, width: screenWidth, height: 20), viewController: self)
        _ = JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
        _ = JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: self.view.center.x - 60, y: 25, width: 120, height: 24), nameOfString: "SIGN UP")
        _ = JImage.shareInstance().setBackButton(CGRect(x: 15, y: 26, width: 20, height: 20))
        
        // Setting Label on Upper View
//        let lblWidth : CGFloat = screenWidth * 0.70
//        let lblHeight : CGFloat = screenHeight * 0.04
//        let _ : CGFloat = screenWidth/2-lblWidth/2
//        let _ : CGFloat = UIApplication.shared.statusBarFrame.size.height/2 + upperView.bounds.size.height/2-lblHeight/2
        
        buttonBack.addTarget(self, action: #selector(JRegistrationVC.BackButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: topMargin, width: screenWidth, height: screenHeight-topMargin)
        self.view.addSubview(scrollView)
        
        
        /*let imageIcon = GlobelUI.shared.getImageView(CGRect(x: self.scrollView.frame.size.width*(20/100), y: self.scrollView.frame.size.height*(3/100), width: self.scrollView.frame.size.width*(60/100), height: self.scrollView.frame.size.height*(25/100)), backColor: UIColor.clear, cornerRadius: 0, clipBound: true, borderWidth: 0, borderColor: UIColor.clear)
        imageIcon.contentMode = UIViewContentMode.scaleAspectFit
        imageIcon.image = UIImage(named: "logo")
        self.scrollView.addSubview(imageIcon)*/
        
        let screenW:CGFloat = screenWidth
        
        
        let lbl_top : UILabel = UILabel(frame: CGRect(x: screenW*(8/100), y:  25, width: screenW*(84/100), height: screenHeight*(4/100)))
        lbl_top.backgroundColor = UIColor.clear
        lbl_top.text = "All fields are required"
        lbl_top.textColor = UIColor.gray
        lbl_top.numberOfLines = 1
        lbl_top.font = UIFont(name: "Lato-Italic", size: screenHeight*(2/100))
        lbl_top.textAlignment = NSTextAlignment.left
        scrollView.addSubview(lbl_top)
        
        
        
        emailTxtFld = ImageTextField(frame: CGRect(x: screenW*(8/100), y:  lbl_top.frame.origin.y + lbl_top.frame.size.height + 5, width: screenW*(84/100), height: 53))
        emailTxtFld.setimage("Email")
        emailTxtFld.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
        emailTxtFld.layer.cornerRadius = 5
        emailTxtFld.textColor = UIColor.gray
        emailTxtFld.layer.borderColor = UIColor.gray.withAlphaComponent(0.7).cgColor
        emailTxtFld.layer.borderWidth = 0.5
        emailTxtFld.placeholder = "Email"
        emailTxtFld.autocorrectionType = .no
        emailTxtFld.autocapitalizationType = .none
        emailTxtFld.delegate = self
        emailTxtFld.keyboardType = UIKeyboardType.emailAddress
        emailTxtFld.font = textFontTable
        emailTxtFld.tag = 110
        scrollView.addSubview(emailTxtFld)
        
        
        firstNameTextFld = ImageTextField(frame: CGRect(x: screenW*(8/100), y: emailTxtFld.frame.origin.y + emailTxtFld.frame.size.height + 15, width: screenW*(84/100), height: 53))
        firstNameTextFld.setimage("password")
        firstNameTextFld.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
        firstNameTextFld.layer.cornerRadius = 5
        firstNameTextFld.textColor = UIColor.gray
        firstNameTextFld.layer.borderColor = UIColor.gray.withAlphaComponent(0.7).cgColor
        firstNameTextFld.layer.borderWidth = 0.5
        firstNameTextFld.placeholder = "Password"
        firstNameTextFld.isSecureTextEntry = true
        firstNameTextFld.delegate = self
        firstNameTextFld.font = textFontTable
        firstNameTextFld.tag = 111
        scrollView.addSubview(firstNameTextFld)
        
        // Last Name
        lastNameTxtFld = ImageTextField(frame: CGRect(x: screenW*(8/100), y: firstNameTextFld.frame.origin.y + firstNameTextFld.frame.size.height + 15, width: screenW*(84/100), height: 53))
        lastNameTxtFld.setimage("password")
        lastNameTxtFld.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
        lastNameTxtFld.layer.cornerRadius = 5
        lastNameTxtFld.textColor = UIColor.gray
        lastNameTxtFld.layer.borderColor = UIColor.gray.withAlphaComponent(0.7).cgColor
        lastNameTxtFld.layer.borderWidth = 0.5
        lastNameTxtFld.placeholder = "Re-type Password" // "Confirm Password"
        lastNameTxtFld.isSecureTextEntry = true
        lastNameTxtFld.delegate = self
        lastNameTxtFld.font = textFontTable
        lastNameTxtFld.tag = 112
        scrollView.addSubview(lastNameTxtFld)
        
        
        passwordTxtFld = ImageTextField(frame: CGRect(x: screenW*(8/100), y: lastNameTxtFld.frame.origin.y + lastNameTxtFld.frame.size.height + 15, width: screenW*(84/100), height: 53))
        passwordTxtFld.setimage("username")
        passwordTxtFld.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
        passwordTxtFld.layer.cornerRadius = 5
        passwordTxtFld.textColor = UIColor.gray
        passwordTxtFld.layer.borderColor = UIColor.gray.withAlphaComponent(0.7).cgColor
        passwordTxtFld.layer.borderWidth = 0.5
        passwordTxtFld.placeholder = "First Name"
//        passwordTxtFld.isSecureTextEntry = true
        passwordTxtFld.delegate = self
        passwordTxtFld.font = textFontTable
        passwordTxtFld.tag = 113
        scrollView.addSubview(passwordTxtFld)
        
        
        confirmPasswordTxtFld = ImageTextField(frame: CGRect(x: screenW*(8/100), y: passwordTxtFld.frame.origin.y + passwordTxtFld.frame.size.height + 15, width: screenW*(84/100), height: 53))
        confirmPasswordTxtFld.setimage("username")
        confirmPasswordTxtFld.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
        confirmPasswordTxtFld.layer.cornerRadius = 5
        confirmPasswordTxtFld.textColor = UIColor.gray
        confirmPasswordTxtFld.layer.borderColor = UIColor.gray.withAlphaComponent(0.7).cgColor
        confirmPasswordTxtFld.layer.borderWidth = 0.5
        confirmPasswordTxtFld.placeholder = "Last Name"
//        confirmPasswordTxtFld.isSecureTextEntry = true
        confirmPasswordTxtFld.delegate = self
        confirmPasswordTxtFld.font = textFontTable
        confirmPasswordTxtFld.tag = 114
        scrollView.addSubview(confirmPasswordTxtFld)
        
        
        
        werRUFrmTextFld = ImageTextField(frame: CGRect(x: screenW*(8/100), y: confirmPasswordTxtFld.frame.origin.y + confirmPasswordTxtFld.frame.size.height + 15, width: screenW*(84/100), height: 53))
        werRUFrmTextFld.setimage("password")
        werRUFrmTextFld.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
        werRUFrmTextFld.layer.cornerRadius = 5
        werRUFrmTextFld.textColor = UIColor.gray
        werRUFrmTextFld.layer.borderColor = UIColor.gray.withAlphaComponent(0.7).cgColor
        werRUFrmTextFld.layer.borderWidth = 0.5
        werRUFrmTextFld.placeholder = "where are you from?"
        werRUFrmTextFld.delegate = self
        werRUFrmTextFld.font = textFontTable
        werRUFrmTextFld.tag = 115
        scrollView.addSubview(werRUFrmTextFld)
        
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        //        datePickerView.minuteInterval = 15        
        datePicker = datePickerView
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(JAccountVC.doneTapped))
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
        
        
        dobTextFld = ImageTextField(frame: CGRect(x: screenW*(8/100), y: werRUFrmTextFld.frame.origin.y + werRUFrmTextFld.frame.size.height + 15, width: screenW*(84/100), height: 53))
        dobTextFld.setimage("date")
        dobTextFld.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
        dobTextFld.layer.cornerRadius = 5
        dobTextFld.textColor = UIColor.gray
        dobTextFld.layer.borderColor = UIColor.gray.withAlphaComponent(0.7).cgColor
        dobTextFld.layer.borderWidth = 0.5
        dobTextFld.placeholder = "MM/DD/YY"
        dobTextFld.delegate = self
        dobTextFld.font = textFontTable
        dobTextFld.tag = 116
        dobTextFld.inputView = datePickerView
        dobTextFld.inputAccessoryView = toolBar
        scrollView.addSubview(dobTextFld)
        
        
        let buttonRegister = UIButton()
        buttonRegister.frame = CGRect(x: screenW*(8/100), y: dobTextFld.frame.origin.y + dobTextFld.frame.size.height + 25, width: screenW*(84/100), height: 53)
        buttonRegister.backgroundColor = UIColor.clear
        buttonRegister.titleLabel?.font = UIFont.init(name: "Lato-Regular", size: 18) // UIFont.systemFont(ofSize: 18)
        buttonRegister.backgroundColor = UIColor(red: 61/255.0, green: 156/255.0, blue: 147/255.0, alpha: 1)
        buttonRegister.setTitleColor(UIColor.white, for: UIControlState())
        buttonRegister.showsTouchWhenHighlighted = true
        buttonRegister.layer.cornerRadius = 5
        buttonRegister.setTitle("Sign Up", for: UIControlState())
        buttonRegister.addTarget(self, action: #selector(self.RegButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        scrollView.addSubview(buttonRegister)
        
        
        
        let buttonLogin = UIButton()
        buttonLogin.frame = CGRect(x: (view.frame.size.width / 2) - ((screenW*(50/100)) / 2), y: buttonRegister.frame.origin.y + buttonRegister.frame.size.height + 5, width: screenW*(58/100), height: 35)
        buttonLogin.backgroundColor = UIColor.clear
//        buttonLogin.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        buttonLogin.titleLabel?.font = UIFont.init(name: "Lato-Regular", size: 13)
        buttonLogin.setTitleColor(UIColor.white, for: UIControlState())
        buttonLogin.showsTouchWhenHighlighted = true
        buttonLogin.layer.cornerRadius = 5
        buttonLogin.setTitleColor(UIColor.darkGray.withAlphaComponent(0.8), for: .normal)
//        buttonLogin.setTitleColor(UIColor(red: 154/255.0, green: 155/255.0, blue: 156/255.0, alpha: 1), for: UIControlState.normal)
        buttonLogin.setTitle("Already have an account ? Sign in", for: UIControlState())
        buttonLogin.addTarget(self, action: #selector(self.GoToRoot(_:)), for: UIControlEvents.touchUpInside)
        scrollView.addSubview(buttonLogin)
        
        let stringSize = (buttonLogin.titleLabel?.text as! NSString).size(attributes: [NSFontAttributeName:buttonLogin.titleLabel?.font])
        var frame = buttonLogin.frame
        frame.size.width = stringSize.width
        buttonLogin.frame = frame
        buttonLogin.center.x = view.center.x
        
        let labelBottom = UILabel()
        labelBottom.frame = CGRect(x: buttonLogin.frame.origin.x, y: buttonLogin.frame.origin.y + buttonLogin.frame.size.height - 8, width: buttonLogin.frame.size.width, height: 1)
        labelBottom.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        scrollView.addSubview(labelBottom)
        
        
        
        self.scrollView.contentSize = CGSize(width: 0, height: buttonLogin.frame.origin.y + buttonLogin.frame.size.height + 30)
        
        cityListVC = CityListViewController()
        cityListVC.delegate = self
        
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(JLoginVC.hideKeyBoard(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    func hideKeyBoard(_ sender:UITapGestureRecognizer){
        if(self.text_field != nil){
            self.text_field.resignFirstResponder()
        }
    }
    
    
    func CitySelectClick(){
        self.cityListVC.countryPlaceholder = "where are you from?"
        self.present(cityListVC, animated: true) { () -> Void in
            
        }
    }
    
    func selectedCity(city: String) {
        werRUFrmTextFld.text = city
//        werRUFrmTextFld.layer.borderWidth = 1
//        werRUFrmTextFld.layer.borderColor = self.greenColor
    }
    
    
    
    func doneTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dobTextFld.text = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateForParam = dateFormatter.string(from: datePicker.date)
        dobTextFld.resignFirstResponder()
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM-dd-yyyy" // yyyy-MM-dd
        dobTextFld.text = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateForParam = dateFormatter.string(from: datePicker.date)
    }

    
    func RegButtonTapped(_ sender:UIButton)
    {
        if(emailTxtFld.text == "") || !self.isValidEmail(emailStr: emailTxtFld.text!) {
            self.alertViewFromApp(messageString:"Enter Proper Email Address.")
            emailTxtFld.becomeFirstResponder()
            return
        }else if(firstNameTextFld.text == ""){
            self.alertViewFromApp(messageString:"Password can not be blank.")
            firstNameTextFld.becomeFirstResponder()
            return
        }else if(lastNameTxtFld.text == ""){
            self.alertViewFromApp(messageString:"Confirm Password can not be blank.")
            lastNameTxtFld.becomeFirstResponder()
            return
        }else if(firstNameTextFld.text != lastNameTxtFld.text){
            self.alertViewFromApp(messageString:"Password and confirm password do not match.")
            firstNameTextFld.becomeFirstResponder()
            return
        }else if(passwordTxtFld.text == ""){
            self.alertViewFromApp(messageString:"First Name can not be blank.")
            passwordTxtFld.becomeFirstResponder()
            return
        }else if(confirmPasswordTxtFld.text == ""){
            self.alertViewFromApp(messageString:"Last Name can not be blank.")
            confirmPasswordTxtFld.becomeFirstResponder()
            return
        }else if(werRUFrmTextFld.text == ""){
            self.alertViewFromApp(messageString:"Country Name can not be blank.")
            return
        }else if(dobTextFld.text == ""){
            self.alertViewFromApp(messageString:"Birth Date can not be blank.")
            dobTextFld.becomeFirstResponder()
            return
        }
        
 
        let trimmedString = (emailTxtFld.text!).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [trimmedString,passwordTxtFld.text!,confirmPasswordTxtFld.text!, firstNameTextFld.text!,werRUFrmTextFld.text!,self.dateForParam], forKeys: [Constants().kemailParam as NSCopying,Constants().kfirst_nameParam as NSCopying,Constants().klast_nameParam as NSCopying,Constants().kpasswordParam as NSCopying,Constants().kcountryParam as NSCopying,Constants().kdobParam as NSCopying]); // dobTextFld.text!
        
        let strFunctionName = Constants().kRegistrationURL
        print("JWOMPA: reistration param \(String(describing: perameteres))")
        print("JWOMPA: reistration url \(strFunctionName)")
        
        WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in

            NSLog("responce object %@",  responseObject as NSMutableDictionary);
            let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool

            if(isOk == true) {

                var DOB : String = String()
                DOB = self.dateForParam // self.dobTextFld.text!

                userDefault.setValue(DOB, forKey: "DOB")
                
                self.isRegistrationSuccess = true
                self.executeLogin()

            }
            else
            {
                let message  = responseObject.object(forKey: "message") as! String;
                self.alertViewFromApp(messageString:message)
            }
        }) { (error, operation) -> Void in
               self.alertViewFromApp(messageString:error.localizedDescription);
        }
    }
    
    
    func userSelectedPreferenceFromService(_ sender: UIButton) {
        
        let strFunctionName = "api/getuserpreference"
        WebService.callGetServicewithStringPerameters(StringPerameter: "", FunctionName: strFunctionName, succes: { [unowned self] (responseDictionary, operation) in
            
            let preferencesArray = responseDictionary["preference_one"] as? [[String:Any]]
            if let preferencesArray = preferencesArray {
                if preferencesArray.count == 0 { //User has come for first time
                    print("User has logged in for the first time")
                    self.openingPreference1VC = OpeningPreferencesViewController1()
                    self.openingPreference1VC.delegate = self
                    let openingNavC = UINavigationController.init(rootViewController: (self.openingPreference1VC)!)
                    openingNavC.setNavigationBarHidden(true, animated: false)
                    self.present(openingNavC, animated: true, completion: nil)
                } else {
                    let vcHOME:JHomeVC = JHomeVC()
                    self.navigationController?.pushViewController(vcHOME, animated: true)
                }
            }
        }) { (error, operation) in
            self.alertViewFromApp(messageString: error.description)
        }
    }
    
    func executeLogin() {
        
        // get all textfields here..
        let txtFieldEmail:    UITextField!   = self.emailTxtFld // arrayForTextField.object(at: 0) as! UITextField;
        let txtFieldPassword :UITextField!   = self.firstNameTextFld  // arrayForTextField.object(at: 1) as! UITextField;
        
        let arr: NSArray! = NSArray(objects: txtFieldEmail,txtFieldPassword);
        
        //check everything...
        let dict :NSDictionary = Validator.getAllTxtFields(arrtxtFieldsIs: arr, placHoldrEmail: "E-mail", placePhoneNumber: "Mobile Number")
        
        NSLog("%@", dict);
        
        let flag  : String = (dict.object(forKey: "flag") as! String);
        
        if flag == "1" {
            // get all textfields here..
            let txtFieldEmail :    UITextField!   = self.emailTxtFld
            let txtFieldPassword : UITextField!   = self.firstNameTextFld
            
            let trimmedString = (txtFieldEmail.text!).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [trimmedString,txtFieldPassword.text!], forKeys: ["email" as NSCopying,"password" as NSCopying])
            let strFunctionName = Constants().kLoginURL
            
            WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
                
                DispatchQueue.main.async {
                    self.view.endEditing(true)
                }
                
                NSLog(" %@",  responseObject as NSMutableDictionary);
                let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
                
                if isOk == true {
                    
                    let accessToken = responseObject.object(forKey: "access_token") as! String
                    let userData:NSDictionary = responseObject.value(forKey: "user_data") as! NSDictionary
                    let userId:String = "\(userData.object(forKey: "id") as! NSNumber)"
                    
                    let firstName: String = userData.object(forKey: "first_name") as! String
                    let lastName: String = userData.object(forKey: "last_name") as! String
                    
                    let user_Name: String = firstName
                    let userEmailID : String = userData.object(forKey: "email") as! String
                    
                    let userOriginalCountry:String? = userData.object(forKey: "country") as? String
                    let userCurrentCountry:String? = userData.object(forKey: "currentcountry") as? String
                    let userDOB:String? = userData.object(forKey: "dob") as? String
                    let userLanguage:String? = userData.object(forKey: "language") as? String
                    let gender = userData.object(forKey: "gender") as? Int
                    let password = userData.object(forKey: "password") as? String
                    
                    loginType = .Normal
                    userDefault.set(loginType.rawValue, forKey: "LoginType")
                    
                    print(accessToken)
                    
                    userDefault.set(accessToken, forKey: "ACCESS_TOKEN")
                    userDefault.setValue(userId, forKey: "USER_ID")
                    userDefault.setValue(user_Name, forKey: "USER_NAME")
                    userDefault.setValue(firstName, forKey: "first_name")
                    userDefault.setValue(lastName, forKey: "last_name")
                    userDefault.setValue(userEmailID, forKey: "USER_EMAIL")
                    userDefault.setValue("yes", forKey: "isLogin")
                    
                    userDefault.setValue(txtFieldPassword.text!, forKey: "UserPassword")
                    userDefault.setValue(userOriginalCountry, forKey: "country")
                    userDefault.setValue(userCurrentCountry, forKey: "currentCountry")
                    userDefault.setValue(userDOB, forKey: "DOB")
                    userDefault.setValue(userLanguage, forKey: "LANGUAGE")
                    userDefault.setValue(gender, forKey: "GENDER")
                    userDefault.set(password, forKey: "password")
                    
                    
                    strUSerID = userDefault.value(forKey: "USER_ID") as! String?
                    userName = userDefault.value(forKey: "USER_NAME") as! String
                    userEmail = userDefault.value(forKey: "USER_EMAIL") as! String
                    
                    
                    let txtEmail : UITextField = self.emailTxtFld
                    let txtPass : UITextField = self.firstNameTextFld
                    txtEmail.text = ""
                    txtPass.text = ""
                    
                    self.userSelectedPreferenceFromService(UIButton())
                    (UIApplication.shared.delegate as! AppDelegate).sendTokenToBackend(InstanceID.instanceID().token() ?? "")
                }else{
                    let message  = responseObject.object(forKey: "message") as! String;
                    self.alertViewFromApp(messageString:message)
                }
                
                
            }) { (error, operation) -> Void in
                if operation.response?.statusCode == 401 {
                    self.alertViewFromApp(messageString:"Username or password incorrect.")
                } else {
                    self.alertViewFromApp(messageString:error.localizedDescription)
                }
            }
        }
        
    }
    
    func GoToRoot(_ sender:UIButton){
        self.navigationController?.popToRootViewController(animated: true)
    }

    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        text_field = textField
        
        if(textField == werRUFrmTextFld){
            self.lastNameTxtFld.resignFirstResponder()
            self.firstNameTextFld.resignFirstResponder()
            self.emailTxtFld.resignFirstResponder()
            self.passwordTxtFld.resignFirstResponder()
            self.confirmPasswordTxtFld.resignFirstResponder()
            textField.resignFirstResponder()
            self.CitySelectClick()
        }
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = Constants().kEmailVerification
        let emailTest = NSPredicate(format:Constants().kSelfMatchQuerey, emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        text_field = textField
        if textField.text != "" {
            if textField == emailTxtFld {
                // validate for email entered
                if isValidEmail(emailStr: textField.text!) {
                    // show green color around textFiled
                    textField.layer.borderWidth = 1
                    textField.layer.borderColor = self.greenColor
                } else {
                    // show red color around textFiled
                    textField.layer.borderWidth = 1
                    textField.layer.borderColor = self.redColor
                }
            } else if textField == firstNameTextFld || textField == lastNameTxtFld {
                if lastNameTxtFld.text! != "" {
//                    lastNameTxtFld.layer.borderWidth = 1
//                    lastNameTxtFld.layer.borderColor = self.greenColor
                    if firstNameTextFld.text != "" {
                        firstNameTextFld.layer.borderWidth = 1
                        firstNameTextFld.layer.borderColor = self.greenColor
                        if lastNameTxtFld.text! == firstNameTextFld.text! {
                            // Password match
                            lastNameTxtFld.layer.borderWidth = 1
                            lastNameTxtFld.layer.borderColor = self.greenColor
                            firstNameTextFld.layer.borderWidth = 1
                            firstNameTextFld.layer.borderColor = self.greenColor
                        } else {
                            // Entered password and confirm password not same
                            lastNameTxtFld.layer.borderWidth = 1
                            lastNameTxtFld.layer.borderColor = self.redColor
                            firstNameTextFld.layer.borderWidth = 1
                            firstNameTextFld.layer.borderColor = self.redColor
                        }
                    }
                }
            } else {
//                textField.layer.borderWidth = 1
//                textField.layer.borderColor = self.greenColor
            }
        }
        
        if textField.text == "" {
//            textField.layer.borderWidth = 1
//            textField.layer.borderColor = self.redColor
        }
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
            let scrollPoint:CGPoint = CGPoint(x: 0.0, y: self.text_field.frame.origin.y - (rect.size.height - self.text_field.frame.size.height)+10);
            self.scrollView.setContentOffset(scrollPoint, animated: false)
        }
    }
    
    func keyboardWillHide(_ sender: Notification) {
        
        let contentInsets:UIEdgeInsets = UIEdgeInsets.zero;
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }

}

extension JRegistrationVC: PreferenceCompletionDelegate {
    func didFinishChoosingPreference() {
        self.openingPreference1VC.dismiss(animated: true) {
            let vcHOME:JHomeVC = JHomeVC()
            self.navigationController?.pushViewController(vcHOME, animated: true)
        }
        self.openingPreference1VC = nil
    }
}
