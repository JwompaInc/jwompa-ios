//
//  JAccountVC.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 14/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

protocol SocialLoginDelegate:class {
    
    func executeFacebookLogin()
    func executeGoogleLogin()
    
}

class JAccountVC: UIViewController, UIPickerViewDelegate, CityListDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var whereAreYouFromButton: UIButton!
    @IBOutlet weak var whereAreYouLocatedButton: UIButton!
    @IBOutlet weak var understandAnAfricanLanguageButton: UIButton!
    @IBOutlet weak var signInWithFBButton: UIButton!
    @IBOutlet weak var signInWithGoogleButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var passwordTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var thinLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordThinLine:UILabel!
    
    var ViewForDatePicker : UIView = UIView()
    var doneToolBarDate : UIToolbar = UIToolbar()
    var datePicker : UIDatePicker = UIDatePicker()
    var eq:Equelizer!
    
    var cityListVC:CityListViewController!
    
    var text_field:UITextField!
    
    var isFromAddLocation: Bool = false
    var clickedCountryButton: UIButton? = nil
    fileprivate var dropdown = DropDown()
    var savedPassword = userDefault.object(forKey: "UserPassword") as? String
    
    init() {
        super.init(nibName: "JAccountVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func eqButtonTapped(){
        let jpl : JPlayerVC = JPlayerVC(nibName: "JPlayerVC", bundle: nil)
        self.navigationController?.pushViewController(jpl, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      //  bannerView.removeFromSuperview()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = CGSize(width: 0, height: 650)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBar()
        JImage.shareInstance().destroy()
        self.view.backgroundColor = UIColor(red: 254/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        DispatchQueue.main.async {
            
            self.EnableAllField()
            self.setMyView()
            self.configureDropdown()
            
            if self.isFromAddLocation {
                self.clickedCountryButton = self.whereAreYouFromButton
                self.cityListVC.countryPlaceholder = "where are you from?"
                self.CitySelectClick()
            }
        }
    }
    
    func configureDropdown() {
        
        //Configure dropdown
        dropdown.dataSource = ["None", "Arabic-Berber","Afrikaans","Akan (Twi)","Amharic","Arabic","Bambara","Bemba","Chichewa","Dho(luo)","English","Ewé","French","Fula","Hausa","Igbo","Kikuyu","Kinyarwanda","Kirundi","Kongo (Kikongo)","Lingala","Luganda","Malagasy","Mandinka","Mossi","Nuer","Oromo","Oshiwambo","Portuguese","Portuguese Creole","Sango (Sangho)","Sesotho","Setswana (Tswana)","Seychellois Creole","Shona","Sierra Leonean Creole","Somali","Spanish","Swahili","Swazi","Tigrinya","Tshiluba (Luba-Kasai)","Umbundu","Wolof","Xhosa","Yoruba","Zulu","Other"]
        
        dropdown.anchorView = self.understandAnAfricanLanguageButton
        dropdown.width = self.view.frame.size.width * 1/1.5
        dropdown.direction = .top
        dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)
        
        //Dropdown selection config
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            UIView.performWithoutAnimation {
                self.understandAnAfricanLanguageButton.setTitle(item, for: .normal)
                self.understandAnAfricanLanguageButton.layoutIfNeeded()
            }
            self.view.endEditing(true)
        }
    }
    
    
    func setNavBar(){
        self.navigationController?.isNavigationBarHidden=true
        self.automaticallyAdjustsScrollViewInsets=false
    }
    
    func setMyView() {
        
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin    = statusBarHeight + navBarHeight
        
        _ = JImage.shareInstance().setStatusBarDarkView(CGRect.init(x: 0, y: 0, width: screenWidth, height: 20), viewController: self)
        _ = JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
        _ = JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: 60, y: 25, width: screenWidth - 120, height: 30), nameOfString: "PROFILE")
        
        self.cancelButton.addTarget(self, action: #selector(cancelbuttonTapped(_:)), for: .touchUpInside)
        
        // Setting Label on Upper View
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(JAccountVC.respondToSwipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(JAccountVC.respondToSwipeLeft(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        
        let buttonSideView = UIButton(frame: CGRect(x: 15,y: 30,width: 25,height: 25))
        buttonSideView.backgroundColor = UIColor.clear
        buttonSideView.titleLabel?.font = textFontFPAl
        buttonSideView.setTitleColor(UIColor(red: 154/255.0, green: 155/255.0, blue: 156/255.0, alpha: 1), for: UIControlState())
        buttonSideView.backgroundColor = UIColor.clear
        buttonSideView.showsTouchWhenHighlighted = true
        var image : UIImage = UIImage()
        image = UIImage(named: "SideButton")!
        buttonSideView.setImage(image, for: UIControlState())
        upperView.addSubview(buttonSideView)
        
        buttonSideView.addTarget(self, action: #selector(self.homeBtnTapped), for: UIControlEvents.touchUpInside)
        
        eq = Equelizer(frame: CGRect(x: screenWidth - 30, y: 20, width: 25, height: 30))
        eq.tapBtn.addTarget(self, action: #selector(self.imageTapped), for: UIControlEvents.touchUpInside)
        upperView.addSubview(eq)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(JAccountVC.imageTapped))
        eq.isUserInteractionEnabled = true
        eq.addGestureRecognizer(tapGestureRecognizer)
        
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        datePicker = datePickerView
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(JAccountVC.doneTapped))
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        dobTextField.inputView = datePickerView
        dobTextField.inputAccessoryView = toolBar
        
        var strDOB : String = String()
        
        if userDefault.value(forKey: "DOB") as? String == nil || userDefault.value(forKey: "DOB") as? String == "0000-00-00" || userDefault.value(forKey: "DOB") as? String == "" || (((userDefault.value(forKey: "DOB") as? String) ?? "")?.isEmpty)! {
            strDOB = "MM/DD/YYYY"
            dobTextField.text = strDOB
        } else {
            strDOB = (userDefault.value(forKey: "DOB") as? String)!
            
            let inputDateFormatter = DateFormatter()
            inputDateFormatter.dateFormat = "yyyy-MM-dd"
            let inputDate = inputDateFormatter.date(from: strDOB)
            
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MM/dd/yyyy"
            
            dobTextField.text = (outputDateFormatter.string(from: ((inputDate != nil) ? inputDate : outputDateFormatter.date(from: strDOB))!))
            
            datePickerView.setDate(((inputDate != nil) ? inputDate : outputDateFormatter.date(from: strDOB))!, animated: false)
        }
        
        let fn = userDefault.object(forKey: "first_name") as? String
        let ln = userDefault.object(forKey: "last_name") as? String
        
        signInWithFBButton.titleLabel?.adjustsFontSizeToFitWidth = true
        signInWithGoogleButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        switch loginType {
            
        case .Facebook:
            
            self.passwordTopConstraint.constant = 0
            self.passwordBottomConstraint.constant = 0
            self.thinLabelBottomConstraint.constant = -10
            self.passwordTextField.isHidden = true
            self.passwordThinLine.isHidden = true
            self.passwordLabel.isHidden = true
            
            self.emailTextField.isUserInteractionEnabled = false
            self.firstnameTextField.isUserInteractionEnabled = false
            self.lastnameTextField.isUserInteractionEnabled = false
            
            UIView.performWithoutAnimation {
                self.signInWithFBButton.setTitle("Signed in as \((fn ?? "") + (ln ?? ""))", for: .normal)
                self.signInWithFBButton.layoutIfNeeded()
            }
            break
            
        case .Google:
            
            self.passwordTopConstraint.constant = 0
            self.passwordBottomConstraint.constant = 0
            self.thinLabelBottomConstraint.constant = -10
            self.passwordTextField.isHidden = true
            self.passwordThinLine.isHidden = true
            self.passwordLabel.isHidden = true
            
            self.emailTextField.isUserInteractionEnabled = false
            self.firstnameTextField.isUserInteractionEnabled = false
            self.lastnameTextField.isUserInteractionEnabled = false
            
            UIView.performWithoutAnimation {
                self.signInWithGoogleButton.setTitle(" Signed in as \((fn ?? "") + (ln ?? ""))", for: .normal)
                self.signInWithGoogleButton.layoutIfNeeded()
            }
                        
            break
            
        case .Normal:
            
            self.emailTextField.isUserInteractionEnabled = true
            self.firstnameTextField.isUserInteractionEnabled = true
            self.lastnameTextField.isUserInteractionEnabled = true
            
            UIView.performWithoutAnimation {
                self.signInWithFBButton.setTitle("Sign in with Facebook", for: .normal)
                self.signInWithGoogleButton.setTitle(" Sign in with Google+", for: .normal)
                self.signInWithFBButton.layoutIfNeeded()
                self.signInWithGoogleButton.layoutIfNeeded()
            }
            
            break
            
        }
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.text = userDefault.object(forKey: "UserPassword") as? String
        
        genderTextField.text = ((userDefault.object(forKey: "GENDER")) as? Int) == 2 ? "Female" : "Male"
        firstnameTextField.text = fn
        lastnameTextField.text = ln
        emailTextField.text = userEmail
        
        
        let userOriginalCountry = (userDefault.object(forKey: "country") as? String) ?? "None"
        let userCurrentCountry = (userDefault.object(forKey: "currentCountry") as? String) ?? "None"
        let userLanguage = ((userDefault.object(forKey: "LANGUAGE") as? String) ?? "None") == "" ? "None" : ((userDefault.object(forKey: "LANGUAGE") as? String) ?? "None")
        
        
        UIView.performWithoutAnimation {
            whereAreYouFromButton.setTitle(userOriginalCountry.isEmpty ? "None" : userOriginalCountry, for: .normal)
            whereAreYouLocatedButton.setTitle(userCurrentCountry.isEmpty ? "None" : userCurrentCountry, for: .normal)
            understandAnAfricanLanguageButton.setTitle(userLanguage, for: .normal)
            
            whereAreYouFromButton.layoutIfNeeded()
            whereAreYouLocatedButton.layoutIfNeeded()
            understandAnAfricanLanguageButton.layoutIfNeeded()
        }
        
        saveButton.addTarget(self, action: #selector(JAccountVC.savebuttonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        cityListVC = CityListViewController()
        cityListVC.delegate = self
        
    }
    
    func homeBtnTapped()  {
        SideView.sharedInstance().vController = self
        SideView.sharedInstance().setSideView()
        SideView.sharedInstance().openView()
    }
    
    func removeSavedPrefs(_ isFB: Bool) {
        
        strUSerID = userDefault.value(forKey: "") as? String
        userDefault.setValue("no", forKey: "isLogin")
        
        userDefault.setValue(nil, forKey: "country")
        userDefault.setValue(nil, forKey: "currentCountry")
        userDefault.setValue(nil, forKey: "language")
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        GIDSignIn.sharedInstance().signOut()
        
        SearchModel.shared.removeAll()
        AudioPlayerModel.shared.clearSongArray()
        SleepTimer.shared.invalidTimer()
        AudioPlayerModel.shared.MainPlayerVC = nil
        userDefault.setValue(nil, forKey: "isLogin")
        
        isselectFB = false
        isselectGoogle = false
        
        AudioPlayerModel.shared.pauseAudio()
        AudioPlayerModel.shared.currentPlayingAlbumID = nil
        
        skipStartDate = nil
        dateLastSkipped = nil
        skipCount = 0
        
        
        if let viewControllers = self.navigationController?.viewControllers {
            if viewControllers.count > 0 {
                for vc in viewControllers {
                    if vc.isKind(of:JWelcomeVC.self) {
                        self.navigationController?.popToViewController(vc, animated: false)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isFB ? (vc as! SocialLoginDelegate).executeFacebookLogin() : (vc as! SocialLoginDelegate).executeGoogleLogin()
                        }
                        break
                    }
                }
            }
        }
        
    }
    
    func logout(isFBLoginAfterLogout isFB:Bool) {
        
        let strFunctionName =  Constants().kLogOutURL
        
        let perameteres:NSMutableDictionary = NSMutableDictionary();
        print(perameteres)
        
        WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { [unowned self] (responseObject, operation) -> Void in
            self.removeSavedPrefs(isFB)
        }) { [unowned self] (error, operation) -> Void in
            self.removeSavedPrefs(isFB)
        }
    }
    
    @IBAction func signInWithFBButtonTouched(_ sender: UIButton) {
        if loginType != .Facebook {
            self.presentLogoutAlert(LoginType(rawValue: "Facebook")!)
        }
    }
    
    @IBAction func signInWithGoogleButtonTouched(_ sender: UIButton) {
        if loginType != .Google {
            self.presentLogoutAlert(LoginType(rawValue: "Google")!)
        }
    }
    
    @IBAction func originalCountryButtonTouched(_ sender: UIButton) {
        self.clickedCountryButton = sender
        self.cityListVC.countryPlaceholder = "where are you from?"
        CitySelectClick()
    }
    
    @IBAction func currentCountryButtonTouched(_ sender: UIButton) {
        self.clickedCountryButton = sender
        self.cityListVC.countryPlaceholder = "where are you located?"
        CitySelectClick()
    }
    
    @IBAction func understandAfricanLanguageButtonTouched(_ sender: UIButton) {
        self.dropdown.show()
    }
    
    func CitySelectClick() {
        DispatchQueue.main.async {
            self.present(self.cityListVC, animated: true)
        }
    }
    
    func selectedCity(city: String) {
        UIView.performWithoutAnimation {
            self.clickedCountryButton?.setTitle(city, for: .normal)
            self.clickedCountryButton?.layoutIfNeeded()
            self.clickedCountryButton = nil
        }
    }
    
    func EnableAllField() {
        
        self.saveButton.isEnabled = true
        self.emailTextField.isUserInteractionEnabled = true
        self.passwordTextField.isUserInteractionEnabled = true
        self.dobTextField.isUserInteractionEnabled = true
        self.firstnameTextField.isUserInteractionEnabled = true
        self.lastnameTextField.isUserInteractionEnabled = true
        self.genderTextField.isUserInteractionEnabled = true
        
        self.whereAreYouFromButton.isUserInteractionEnabled = true
        self.whereAreYouLocatedButton.isUserInteractionEnabled = true
        self.understandAnAfricanLanguageButton.isUserInteractionEnabled = true
        
        
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
    
    
    func savebuttonTapped(_ sender:UIButton) {
        
        if loginType == .Normal ? (self.emailTextField.text?.isEmpty)! : false {
            self.alertViewFromApp(messageString:"Email Cannot Be Blank.")
            return
        } else if loginType == .Normal ? (self.passwordTextField.text?.isEmpty)! : false {
            self.alertViewFromApp(messageString:"Password Cannot Be Blank.")
            return
        } else if (self.firstnameTextField.text?.isEmpty)! {
            self.alertViewFromApp(messageString:"First Name Cannot Be Blank.")
            return
        } else if (self.lastnameTextField?.text?.isEmpty)! {
            self.alertViewFromApp(messageString:"Last Name Cannot Be Blank.")
            return
        } else if self.whereAreYouLocatedButton.titleLabel?.text == "None" {
            self.alertViewFromApp(messageString:"Current Country Name Cannot Be Blank.")
            return
        } else if self.whereAreYouFromButton.titleLabel?.text == "None" {
            self.alertViewFromApp(messageString:"Country Name Cannot Be Blank.")
            return
        } else if (dobTextField.text?.isEmpty)! || dobTextField.text == "0000-00-00" || dobTextField.text == "YYYY-MM-DD" || dobTextField.text == "MM/DD/YYYY" || dobTextField.text == nil {
            self.alertViewFromApp(messageString:"DOB Cannot Be Blank.")
            return
        }
        
        let perameteres: NSMutableDictionary
        
        let strDob = self.dobTextField.text!
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "MM/dd/yyyy"
        
        let inputDate = inputDateFormatter.date(from: strDob)
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let finalDobToSend = outputDateFormatter.string(from: inputDate!)
        
        perameteres = NSMutableDictionary(objects: [self.emailTextField.text!, loginType == .Normal ? (self.passwordTextField.text == self.savedPassword ? (userDefault.object(forKey: "password") as? String) ?? "" : self.passwordTextField.text!) : ("password"), finalDobToSend, self.firstnameTextField.text!, self.lastnameTextField.text!, self.genderTextField.text!, (self.whereAreYouLocatedButton.titleLabel?.text)!, (self.whereAreYouFromButton.titleLabel?.text)!, (self.understandAnAfricanLanguageButton.titleLabel?.text)!], forKeys: ["email" as NSCopying,"password" as NSCopying, "dob" as NSCopying, "first_name" as NSCopying, "last_name" as NSCopying, "gender" as NSCopying, "currentcountry" as NSCopying, "originalcountry" as NSCopying, "language" as NSCopying])
        
        
        let strFunctionName = "api/account_setting"
        
        WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { [unowned self, perameteres] (responseObject, operation) -> Void in
            
            let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
            
            if isOk {
                
                let message  = responseObject.object(forKey: "message") as! String;
                self.alertViewFromApp(messageString:message);
                
                userDefault.setValue(perameteres["first_name"], forKey: "first_name")
                userDefault.setValue(perameteres["last_name"], forKey: "last_name")
                userDefault.setValue(self.emailTextField.text!, forKey: "USER_EMAIL")
                userDefault.setValue(perameteres["password"], forKey: "password")
                userDefault.setValue(self.passwordTextField.text, forKey: "UserPassword")
                userDefault.setValue(perameteres["language"], forKey: "LANGUAGE")
                userDefault.setValue(perameteres["gender"], forKey: "GENDER")
                userDefault.setValue(perameteres["currentcountry"], forKey: "currentCountry")
                userDefault.setValue(perameteres["originalcountry"], forKey: "country")
                userDefault.setValue(perameteres["dob"], forKey: "DOB")
                userDefault.setValue(perameteres["first_name"], forKey: "USER_NAME")
                
                
                if loginType != .Facebook && loginType != .Google {
                    if self.passwordTextField.text != self.savedPassword {
                        self.login(with: self.emailTextField.text!, password: self.passwordTextField.text!)
                    }
                }
                
                self.popToSplashboard()
                
            } else {
                let message  = responseObject.object(forKey: "message") as! String;
                self.alertViewFromApp(messageString:message)
            }
            
            
        }) { (error, operation) -> Void in
            let message  = "Something wrong happning , Please wait for proper response of server";
            self.alertViewFromApp(messageString:message );
        }
    }
    
    fileprivate func popToSplashboard() {
        var hasVC = false
        weak var homeVC:UIViewController? = nil
        for vc in (self.navigationController?.viewControllers)! {
            if vc.isKind(of: JHomeVC.self) {
                hasVC = true
                homeVC = vc
                break
            }
        }
        
        if hasVC {
            self.navigationController?.popToViewController(homeVC!, animated: true)
        } else {
            let obj_Home = JHomeVC(nibName: "JHomeVC", bundle: nil)
            self.navigationController?.pushViewController(obj_Home, animated: true)
        }
    }
    
    func cancelbuttonTapped(_ sender : UIButton) {
        popToSplashboard()
    }
    
    func respondToSwipeRight(_ gesture : UIGestureRecognizer){
        SideView.sharedInstance().vController = self
        SideView.sharedInstance().setSideView()
        SideView.sharedInstance().openView()
    }
    
    func respondToSwipeLeft(_ gesture : UIGestureRecognizer){
        SideView.sharedInstance().closeView()
    }
    
    
    func doneTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dobTextField.text = dateFormatter.string(from: datePicker.date)
        dobTextField.resignFirstResponder()
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dobTextField.text = dateFormatter.string(from: sender.date)
    }
    
    
    
    
    func SideViewTapped(_ sender:UIButton){
        SideView.sharedInstance().vController = self
        SideView.sharedInstance().setSideView()
        SideView.sharedInstance().openView()
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
            let scrollPoint:CGPoint = CGPoint(x: 0.0, y: self.text_field.frame.origin.y - (rect.size.height - self.text_field.frame.size.height)+5);
            self.scrollView.setContentOffset(scrollPoint, animated: false)
        }
    }
    
    func keyboardWillHide(_ sender: Notification) {
        
        let contentInsets:UIEdgeInsets = UIEdgeInsets.zero;
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }
    
}

extension JAccountVC: UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        text_field = textField
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.genderTextField {
            textField.text = textField.text == "Male" ? "Female" : "Male"
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        text_field = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTag:NSInteger = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}

extension JAccountVC {
    
    func login(with username:String, password: String) {
        
        let password = password == "" ? "password" : password
        
        let trimmedString = (username).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [trimmedString,password], forKeys: ["email" as NSCopying,"password" as NSCopying]);
        
        // URL  http://demosite4u.com/dev/jwompa/public/api/login
        
        let strFunctionName = Constants().kLoginURL
        
        WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
            
            NSLog(" %@",  responseObject as NSMutableDictionary);
            let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
            
            if isOk == true {
                
                let accessToken = responseObject.object(forKey: "access_token") as! String
                let userData:NSDictionary = responseObject.value(forKey: "user_data") as! NSDictionary
                let userId:String = "\(userData.object(forKey: "id") as! NSNumber)"
                
                let firstName: String = userData.object(forKey: "first_name") as! String
                let lastName: String = userData.object(forKey: "last_name") as! String
                
                let user_Name: String = firstName + " " + lastName
                let userEmailID : String = userData.object(forKey: "email") as! String
                let userOriginalCountry:String? = userData.object(forKey: "country") as? String
                let userCurrentCountry:String? = userData.object(forKey: "currentcountry") as? String
                
                let userDOB:String? = userData.object(forKey: "dob") as? String
                let userLanguage:String? = userData.object(forKey: "language") as? String
                let gender = userData.object(forKey: "gender") as? Int
                let password = userData.object(forKey: "password") as? String                                
                
                print(accessToken)
                
                userDefault.set(accessToken, forKey: "ACCESS_TOKEN")
                userDefault.setValue(userId, forKey: "USER_ID")
                userDefault.setValue(user_Name, forKey: "USER_NAME")
                userDefault.setValue(firstName, forKey: "first_name")
                userDefault.setValue(lastName, forKey: "last_name")
                userDefault.setValue(userEmailID, forKey: "USER_EMAIL")
                userDefault.setValue("yes", forKey: "isLogin")
                
                userDefault.setValue(userOriginalCountry, forKey: "country")
                userDefault.setValue(userCurrentCountry, forKey: "currentCountry")
                
                userDefault.setValue(userDOB, forKey: "DOB")
                userDefault.setValue(userLanguage, forKey: "LANGUAGE")
                userDefault.setValue(gender, forKey: "GENDER")
                userDefault.set(password, forKey: "password")
                
                
                strUSerID = userDefault.value(forKey: "USER_ID") as! String?
                userName = userDefault.value(forKey: "USER_NAME") as! String
                userEmail = userDefault.value(forKey: "USER_EMAIL") as! String
                
                
            } else {
                let message  = responseObject.object(forKey: "message") as! String;
                self.alertViewFromApp(messageString:message);
            }
            
            
        }) { (error, operation) -> Void in
            
            let message  = "Something wrong happning , Please wait for proper response of server";
            self.alertViewFromApp(messageString:message );
        }
    }
    
}

extension JAccountVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func presentLogoutAlert(_ type: LoginType) {
        
        let alert = UIAlertController.init(title: "Are you sure you want to login with \(type.rawValue)? Your current session will be logged out.", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in }
        
        let logoutAction = UIAlertAction.init(title: "Yes", style: .destructive) { (action) in
            self.logout(isFBLoginAfterLogout: type == .Facebook)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}

