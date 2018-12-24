//
//  JWelcomeVC.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 18/02/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import FirebaseInstanceID

class JWelcomeVC: BaseViewController,UIScrollViewDelegate,UITextFieldDelegate,FBSDKLoginButtonDelegate,GIDSignInDelegate,GIDSignInUIDelegate {
    
    @IBOutlet var textFieldView: UIView!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPass: UITextField!
    @IBOutlet var signInBtn: UIButton!
    
    var btnFacebook: FBSDKLoginButton!
    var facebookBtn: UIButton = UIButton()
    var googleBtn: UIButton = UIButton()
    
    var googlePlusBtn: UIButton!
    var btnGoogle: GIDSignInButton = GIDSignInButton()
    var googleDict:NSMutableDictionary!
    var arrayNew : NSMutableArray = NSMutableArray()
    var userId : String = String()
    var name : String = String()
    var email : String = String()
    
    // User variables
    let fbLoginManager = LoginManager()
    
    //    let fbLoginManager = FBSDKLoginManager()
    
    var arrayForTextField : NSMutableArray!
    var openingPreference1VC:OpeningPreferencesViewController1!
    var clickedLoginButton: Any? = nil
    
    var usernameFromSignup:String = ""
    var passFromSignup:String = ""
    var isSignupSuccess:Bool = false
    
    init() {
        super.init(nibName: "JWelcomeVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // bannerView.removeFromSuperview()
        
        self.logoutFB()
        checkForSuccessfulSignup()
    }
    
    func checkForSuccessfulSignup() {
        if self.isSignupSuccess {
            self.txtEmail.text = self.usernameFromSignup
            self.txtPass.text = self.passFromSignup
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.isSignupSuccess {
            self.SignInTapped(self.signInBtn)
        }        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textFieldView.layer.cornerRadius = 5
        self.txtEmail.delegate = self
        self.txtPass.delegate = self
        
        self.signInBtn.layer.cornerRadius = 5
        self.setNavBar()
        
    }
    
    @IBAction func googleButtonAction(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func backButtonTouched(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func userSelectedPreferenceFromService(_ sender: UIButton) {
        
        let strFunctionName = "api/getuserpreference"
        WebService.callGetServicewithStringPerameters(StringPerameter: "", FunctionName: strFunctionName, succes: { [weak self] (responseDictionary, operation) in
            
            let preferencesArray = responseDictionary["preference_one"] as? [[String:Any]]
            if let preferencesArray = preferencesArray {
                if preferencesArray.count == 0 { //User has come for first time
                    print("User has logged in for the first time")
                    self?.openingPreference1VC = OpeningPreferencesViewController1()
                    self?.openingPreference1VC.delegate = self
                    let openingNavC = UINavigationController.init(rootViewController: (self?.openingPreference1VC)!)
                    openingNavC.setNavigationBarHidden(true, animated: false)
                    
                    self?.present(openingNavC, animated: true, completion: nil)
                } else {
                    let vcHOME:JHomeVC = JHomeVC()
                    self?.navigationController?.pushViewController(vcHOME, animated: true)
                }
            }
        }) { (error, operation) in
            self.alertViewFromApp(messageString: error.description)
        }
    }
    
    // MARK: Google Delegate.......
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        self.clickedLoginButton = self.btnGoogle
        
        obj_app.stopActivityIndicatorView()
        
        if (error == nil) {
            
            isselectGoogle = true
            
            userId = user.userID
            
            let idToken = user.authentication.idToken
            
            name = user.profile.name
            
            email = user.profile.email
            
            print( idToken, name, email, userId )
            let nameSplited = name.split(separator: " ")
            let firstName = nameSplited[0]
            let firstnameString = String(firstName)
            userDefault.setValue(firstnameString, forKey: "USER_NAME_Google")
            googleDict = NSMutableDictionary(objects: [firstnameString,userId,email], forKeys: ["full_name" as NSCopying,"gplus_id" as NSCopying,"email" as NSCopying]);
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ToggleAuthUINotification"),object: nil,userInfo: ["statusText": "Signed in Successfully\(userId)"])
            
            googleLogin()
            
        } else {
            
            print("\(error.localizedDescription)")
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            
        }
    }
    
    // [START toggle_auth]
    
    func toggleAuthUI() {
        
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            
            // Signed in
            
            btnGoogle.isHidden = false
            // signOutButton.hidden = false
            
            //  disconnectButton.hidden = false
            
        } else {
            
            btnGoogle.isHidden = false
            
        } }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: NSError!) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ToggleAuthUINotification"),object: nil,userInfo: ["statusText": "User has disconnected."])
        
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: Notification) {
        
        if (notification.name.rawValue == "ToggleAuthUINotification") {
            
            self.toggleAuthUI()
            
            if (notification as NSNotification).userInfo != nil {
                
                let userInfo:Dictionary<String,String?> =
                    
                    (notification as NSNotification).userInfo as! Dictionary<String,String?>
                
                
                // self.statusText.text = userInfo["statusText"]
                
            }
        }
        
    }
    
    
    //MARK: Google Login Service Call
    
    func googleLogin(){
        
        // URL  http://demosite4u.com/dev/jwompa/public/api/googleplus_register
        
        //        let strFunctionName = "googleplus_register"
        let strFunctionName = Constants().kGoogleLoginURL
        print(name)
        let splitedName = name.split(separator: " ")
        print(splitedName.count)
        var firstNameValue = ""
        var lastNameValue = ""
        if splitedName.count == 2 {
            firstNameValue = String(splitedName[0])
            lastNameValue = String(splitedName[1])
        }
        let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [email,userId,firstNameValue,lastNameValue], forKeys: ["email" as NSCopying,"gplus_id" as NSCopying,"first_name" as NSCopying,"last_name" as NSCopying]);
        print(perameteres)
        WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
            
            DispatchQueue.main.async {
                self.view.endEditing(true)
            }
            
            NSLog(" %@",  responseObject as NSMutableDictionary);
            let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
            
            if isOk == true {
                
                self.isSignupSuccess = false
                let accessToken = responseObject.object(forKey: "access_token") as! String
                let userData = responseObject.object(forKey: "user_data") as! NSDictionary
                
                let firstName: String = userData.object(forKey: "first_name") as! String
                let lastName: String = userData.object(forKey: "last_name") as! String
                
                let user_Name: String = firstName
                let userId:String = "\(userData.object(forKey: "id") as! NSNumber)"
                let email:String = userData.object(forKey: "email") as! String
                
                
                let userOriginalCountry:String? = userData.object(forKey: "country") as? String
                let userCurrentCountry:String? = userData.object(forKey: "currentcountry") as? String
                let userDOB:String? = userData.object(forKey: "dob") as? String
                let userLanguage:String? = userData.object(forKey: "language") as? String
                let gender = userData.object(forKey: "gender") as? Int
                let password = userData.object(forKey: "password") as? String
                
                loginType = .Google
                userDefault.set(loginType.rawValue, forKey: "LoginType")
                
                print(accessToken)
                userDefault.set(accessToken, forKey: "ACCESS_TOKEN")
                
                userDefault.setValue(userId, forKey: "USER_ID")
                userDefault.setValue(user_Name, forKey: "USER_NAME")
                userDefault.setValue(firstName, forKey: "first_name")
                userDefault.setValue(lastName, forKey: "last_name")
                userDefault.setValue(email, forKey: "USER_EMAIL")
                userDefault.setValue("yes", forKey: "isLogin")
                
                
                strUSerID = userDefault.value(forKey: "USER_ID") as! String?
                userName = userDefault.value(forKey: "USER_NAME") as! String
                userEmail = userDefault.value(forKey: "USER_EMAIL") as! String
                
                userDefault.setValue(userOriginalCountry, forKey: "country")
                userDefault.setValue(userCurrentCountry, forKey: "currentCountry")
                userDefault.setValue(userDOB, forKey: "DOB")
                userDefault.setValue(userLanguage, forKey: "LANGUAGE")
                userDefault.setValue(gender, forKey: "GENDER")
                userDefault.set(password, forKey: "password")
                
                self.userSelectedPreferenceFromService(UIButton())
                (UIApplication.shared.delegate as! AppDelegate).sendTokenToBackend(InstanceID.instanceID().token() ?? "")
                
            }
            else
            {
                let message  = responseObject.object(forKey: "message") as! String;
                self.alertViewFromApp(messageString:message);
            }
            
            
        }) { (error, operation) -> Void in
            if operation.response?.statusCode == 401 {
                self.alertViewFromApp(messageString:"Username or password incorrect.")
            } else {
                self.alertViewFromApp(messageString:error.localizedDescription)
            }
            //     let message  = "Something wrong happning , Please wait for proper response of server";
            //   self.alertViewFromApp(messageString:message );
        }
    }
    
    
    func hideKeyBoard(_ sender:UITapGestureRecognizer){
        self.txtPass.resignFirstResponder()
        self.txtEmail.resignFirstResponder()
    }
    
    func setView(){
        
        let imageViewWidth : CGFloat = screenWidth * 0.30
        let imageViewHeight : CGFloat = screenHeight * 0.25
        let imageViewLeft : CGFloat = screenWidth/2 - imageViewWidth/2
        let imageViewTop : CGFloat = scrollView.bounds.size.height * 0.01
        JImage.shareInstance().setMyImgView(CGRect(x: imageViewLeft, y: imageViewTop, width: imageViewWidth, height: imageViewHeight))
        
        //// For View of Reg
        
        let arrayForView : NSMutableArray = NSMutableArray()
        
        let viewWidth = screenWidth * 0.80
        let viewHeight = screenHeight * 0.08
        let viewLeftMargin = screenWidth/2 - viewWidth/2
        var viewTopMargin  = imageViewTop + imageViewHeight + screenHeight * 0.03
        
        //// For TextField
        
        arrayForTextField = NSMutableArray()
        let arrayForPlaceHolder : NSMutableArray = NSMutableArray(objects: "E-mail","Password")
        
        let tfRegWidth = screenWidth * 0.65
        let tfRegHeight = viewHeight * 0.70
        let tfRegLeft = screenWidth * 0.15
        let tfRegTop = viewHeight/2 - tfRegHeight/2
        
        // For Image View
        
        let arrayForImage : NSMutableArray = NSMutableArray(objects: UIImage(named: "Email")!,UIImage(named: "password")!)
        
        for iView in 0...1 {
            
            let  colorView = UIView(frame: CGRect(x: viewLeftMargin,y: viewTopMargin,width: viewWidth,height: viewHeight))
            colorView.layer.borderColor = UIColor(red: 218/255.0, green: 218/255.0, blue: 218/255.0, alpha: 1).cgColor
            colorView.layer.borderWidth = 1.0
            colorView.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
            colorView.tag = iView
            
            let textFieldWelcome:UITextField = UITextField(frame: CGRect(x: tfRegLeft,y: tfRegTop,width: tfRegWidth,height: tfRegHeight))
            textFieldWelcome.tag = iView
            textFieldWelcome.font = textFontTextFields
            textFieldWelcome.placeholder = arrayForPlaceHolder.object(at: iView) as? String
            textFieldWelcome.backgroundColor = UIColor.clear
            textFieldWelcome.delegate = self
            textFieldWelcome.autocorrectionType = UITextAutocorrectionType.no
            textFieldWelcome.autocapitalizationType = UITextAutocapitalizationType.none
            textFieldWelcome.clearButtonMode = UITextFieldViewMode.whileEditing
            textFieldWelcome.font = textFont
            
            if(iView == 0){
                textFieldWelcome.keyboardType = .emailAddress
                //                textFieldWelcome.text = "optisol@jwompa.com"//"narayan@gmail.com"
                textFieldWelcome.returnKeyType = .next
                
                let path = UIBezierPath(roundedRect:colorView.bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 4, height: 4))
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                colorView.layer.mask = maskLayer
            }else{
                
                textFieldWelcome.isSecureTextEntry = true
                //                textFieldWelcome.text = "123456"//"123456"
                textFieldWelcome.returnKeyType = .done
                
                let path = UIBezierPath(roundedRect:colorView.bounds, byRoundingCorners:[.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 4, height: 4))
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                colorView.layer.mask = maskLayer
            }
            
            arrayForView.add(colorView)
            arrayForTextField.add(textFieldWelcome)
            
            print(viewTopMargin)
            print(textFieldWelcome)
            
            scrollView.addSubview(arrayForView.object(at: iView) as! UIView)
            colorView.addSubview(arrayForTextField.object(at: iView) as! UITextField)
            
            viewTopMargin += viewHeight
            
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
        let buttonRegTop = viewTopMargin + screenHeight * 0.02
        
        JImage.shareInstance().setButton(CGRect(x: buttonRegLeft, y: buttonRegTop, width: buttonRegWidth, height: buttonRegHeight), nameOfTitle: "Sign In")
        
        button.addTarget(self, action: #selector(JWelcomeVC.SignInTapped(_:)), for: UIControlEvents.touchUpInside)
        
        let lineViewWidth = screenWidth * 0.50
        let lineViewHeight = screenHeight * 0.002
        let lineViewLeft = screenWidth/2 - lineViewWidth/2
        let lineViewTop = buttonRegTop + buttonRegHeight + screenHeight * 0.03
        
        let lineView = UIView()
        lineView.frame = CGRect(x: lineViewLeft, y: lineViewTop, width: lineViewWidth, height: lineViewHeight)
        lineView.backgroundColor = UIColor(red: 177/255.0, green: 178/255.0, blue: 179/255.0, alpha: 1)
        scrollView.addSubview(lineView)
        
        let arrayForButton : NSMutableArray = NSMutableArray()
        
        let buttonWidth = screenWidth * 0.80
        let buttonHeight = screenHeight * 0.07
        let buttonLeft =  screenWidth/2 - buttonWidth/2
        let buttonTop = lineViewTop + screenHeight * 0.03
        btnFacebook  = FBSDKLoginButton(frame: CGRect(x: buttonLeft,y: buttonTop,width: buttonWidth,height: buttonHeight))
        btnFacebook  = FBSDKLoginButton(frame: CGRect(x: buttonLeft,y: buttonTop,width: buttonWidth,height: buttonHeight))
        
        let buttonWidth2 = screenWidth * 0.80
        let buttonHeight2 = screenHeight * 0.10
        let buttonLeft2 =  screenWidth/2 - buttonWidth/2
        let buttonTop2 = buttonTop + buttonHeight + screenHeight * 0.02
        
        
        let buttonFPWidth = screenWidth * 0.28
        let buttonFPHeight = screenHeight * 0.05
        let buttonFPLeft = screenWidth * 0.10
        let buttonFPTop = screenHeight * 0.79
        
        let lbl1 : UILabel = UILabel(frame: CGRect(x: buttonFPLeft, y: buttonFPTop, width: buttonFPWidth, height: buttonFPHeight))
        lbl1.backgroundColor = UIColor.clear
        lbl1.text = "Forgot password?"
        lbl1.textColor = UIColor(red: 154/255.0, green: 155/255.0, blue: 156/255.0, alpha: 1)
        lbl1.font = UIFont(name: "OpenSans", size: screenHeight * 0.018)!
        lbl1.textAlignment = NSTextAlignment.left
        scrollView.addSubview(lbl1)
        
        
        let buttonFP : UIButton = UIButton()
        buttonFP.frame = CGRect(x: buttonFPLeft, y: buttonFPTop, width: buttonFPWidth, height: buttonFPHeight)
        //buttonAlreadyWelcome.setTitle("New here?Sign Up", forState: .Normal)
        buttonFP.titleLabel?.font = textFontFPAl
        buttonFP.setTitleColor(UIColor(red: 154/255.0, green: 155/255.0, blue: 156/255.0, alpha: 1), for: UIControlState())
        buttonFP.addTarget(self, action:#selector(JWelcomeVC.forgotPasswordClicked(_:)), for:UIControlEvents.touchUpInside)
        buttonFP.backgroundColor = UIColor.clear
        scrollView.addSubview(buttonFP)
        
    }
    
    @IBAction func gplusLoginAction(_ sender: UIButton) {
        
    }
    
    @IBAction func facebookLoginAction(_ sender: UIButton) {
        
        self.clickedLoginButton = sender
        fbLoginManager.logOut()
        fbLoginManager.logIn(readPermissions:[.publicProfile, .userLocation, .email, .userFriends], viewController: self) { facebookResponse in
            
            switch facebookResponse {
            case .failed(let error):
                print("Facebook login failuer - \(error)")
            case .cancelled:
                print("User cancelled facebook login")
            case .success(grantedPermissions: _, declinedPermissions: _, token: let accessToken):
                AccessToken(authenticationToken: accessToken.authenticationToken)
                let request = GraphRequest(graphPath: "me", parameters: ["fields":"email, name, location, first_name, last_name"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
                request.start({ (response, result) in
                    
                    switch result {
                    case .failed(let error): break
                    // Handle the result's error
                    print("Facebook login error: \(error)")
                    case .success(let graphResponse):
                        if let responseDictionary = graphResponse.dictionaryValue {
                            // Do something with your responseDictionary
                            
                            loginType = .Facebook
                            userDefault.set(loginType.rawValue, forKey: "LoginType")
                            
                            let strName: String = responseDictionary["name"] as! String
                            let strFirstName: String = responseDictionary["first_name"] as! String
                            
                            userDefault.setValue(strFirstName, forKey: "USER_NAME_FB")
                            let strLastName: String = responseDictionary["last_name"] as! String
                            let strFbId : String = responseDictionary["id"] as! String
                            var strEmail: String = String()
                            
                            if(responseDictionary["email"] != nil){
                                
                                strEmail = responseDictionary["email"] as! String
                                let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [strName,strFirstName,strLastName,strFbId,strEmail], forKeys: ["username" as NSCopying,"first_name" as NSCopying,"last_name" as NSCopying,"fb_id" as NSCopying,"email" as NSCopying]);
                                
                                let strFunctionName = Constants().kFbLoginURL
                                
                                WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
                                    
                                    print("responseObject ::::: \(responseObject)")
                                    
                                    
                                    let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
                                    
                                    if(isOk == true) {
                                        
                                        self.isSignupSuccess = false
                                        isselectFB = true
                                        let accessToken = responseObject.object(forKey: "access_token") as! String
                                        let userData = responseObject.object(forKey: "user_data") as! NSDictionary
                                        
                                        let userId:String = "\(userData.object(forKey: "id") as! NSNumber)"
                                        let email:String = userData.object(forKey: "email") as! String
                                        let firstName: String = userData.object(forKey: "first_name") as! String
                                        let lastName: String = userData.object(forKey: "last_name") as! String
                                        
                                        let user_Name: String = firstName
                                        
                                        let userOriginalCountry:String? = userData.object(forKey: "country") as? String
                                        let userCurrentCountry:String? = userData.object(forKey: "currentcountry") as? String
                                        let userDOB:String? = userData.object(forKey: "dob") as? String
                                        let userLanguage:String? = userData.object(forKey: "language") as? String
                                        let gender = userData.object(forKey: "gender") as? Int
                                        let password = userData.object(forKey: "password") as? String
                                        
                                        print(user_Name)
                                        
                                        userDefault.set(accessToken, forKey: "ACCESS_TOKEN")
                                        userDefault.setValue(userId, forKey: "USER_ID")
                                        userDefault.setValue(user_Name, forKey: "USER_NAME")
                                        userDefault.setValue(firstName, forKey: "first_name")
                                        userDefault.setValue(lastName, forKey: "last_name")
                                        userDefault.setValue(email, forKey: "USER_EMAIL")
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
                                        
                                        self.userSelectedPreferenceFromService(sender)
                                        (UIApplication.shared.delegate as! AppDelegate).sendTokenToBackend(InstanceID.instanceID().token() ?? "")
                                    } else {
                                        let message  = responseObject.object(forKey: "message") as! String;
                                        // MARK: TEST
                                        //                                self.alertViewFromApp(messageString:message);
                                    }
                                    
                                }) { (error, operation) -> Void in
                                    if operation.response?.statusCode == 401 {
                                        self.alertViewFromApp(messageString:"Username or password incorrect.")
                                    } else {
                                        self.alertViewFromApp(messageString:error.localizedDescription)
                                    }
                                    
                                }
                            } else {
                                obj_app.getAlert("Unable to fetch email address from Facebook. Please make a Registration first")
                                //                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                        break
                    }
                })
            }
        }
        
    }
    
    
    // Facebook Delegate Methods
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        print("User Logged Out")
    }
    
    func logoutFB(){
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        print("result :::::  \(result)")
        print("error :::::  \(error)")
        
        
        if ((error) != nil) {
            // Process error
        }else if result.isCancelled == true {
            // Handle cancellations
            NSLog("result is cancelled")
        }else{
            FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name,name, last_name,email,location"]).start(completionHandler: { (connection:FBSDKGraphRequestConnection?, result:Any?, error:Error?) in
                
                print("result :::::    \(result)")
                
                
                if(error == nil && result != nil) {
                    
                    let strName: String = (result as! NSDictionary).object(forKey: "name") as! String
                    let strFirstName: String = (result as! NSDictionary).object(forKey: "first_name") as! String
                    userDefault.setValue(strFirstName, forKey: "USER_NAME_FB")
                    
                    let strLastName: String = (result as! NSDictionary).object(forKey: "last_name") as! String
                    let strFbId : String = ((result as! NSDictionary).object(forKey: "id") as? String)!
                    
                    loginType = .Facebook
                    userDefault.set(loginType.rawValue, forKey: "LoginType")
                    
                    // userDefault.setValue(strFbId, forKey: "FB_ID")
                    //
                    // strFBID = (userDefault.valueForKey("FB_ID") as? String)!
                    var strEmail: String = String()
                    
                    if((result as! NSDictionary).object(forKey: "email") != nil){
                        
                        strEmail = ((result as! NSDictionary).object(forKey: "email") as? String)!
                        let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [strName,strFirstName,strLastName,strFbId,strEmail], forKeys: ["username" as NSCopying,"first_name" as NSCopying,"last_name" as NSCopying,"fb_id" as NSCopying,"email" as NSCopying]);
                        //                        let strFunctionName = "fb_register"
                        let strFunctionName = Constants().kFbLoginURL
                        
                        WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
                            
                            DispatchQueue.main.async {
                                self.view.endEditing(true)
                            }
                            
                            print("responseObject ::::: \(responseObject)")
                            
                            let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
                            
                            if(isOk == true) {
                                
                                self.isSignupSuccess = false
                                isselectFB = true
                                let accessToken = responseObject.object(forKey: "access_token") as! String
                                let userData = responseObject.object(forKey: "user_data") as! NSDictionary
                                
                                let userId:String = "\(userData.object(forKey: "id") as! NSNumber)"
                                let email:String = userData.object(forKey: "email") as! String
                                let firstName: String = userData.object(forKey: "first_name") as! String
                                let lastName: String = userData.object(forKey: "last_name") as! String
                                
                                let user_Name: String = firstName
                                
                                let userOriginalCountry:String? = userData.object(forKey: "country") as? String
                                let userCurrentCountry:String? = userData.object(forKey: "currentcountry") as? String
                                let userDOB:String? = userData.object(forKey: "dob") as? String
                                let userLanguage:String? = userData.object(forKey: "language") as? String
                                let gender = userData.object(forKey: "gender") as? Int
                                let password = userData.object(forKey: "password") as? String
                                
                                print(user_Name)
                                
                                userDefault.set(accessToken, forKey: "ACCESS_TOKEN")
                                userDefault.setValue(userId, forKey: "USER_ID")
                                userDefault.setValue(user_Name, forKey: "USER_NAME")
                                userDefault.setValue(firstName, forKey: "first_name")
                                userDefault.setValue(lastName, forKey: "last_name")
                                userDefault.setValue(email, forKey: "USER_EMAIL")
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
                                
                                
                                self.userSelectedPreferenceFromService(loginButton)
                                
                                let txtEmail : UITextField = self.txtEmail // self.arrayForTextField.object(at: 0) as! UITextField
                                let txtPass : UITextField = self.txtPass // self.arrayForTextField.object(at: 1) as! UITextField
                                txtEmail.text = ""
                                txtPass.text = ""
                                
                                (UIApplication.shared.delegate as! AppDelegate).sendTokenToBackend(InstanceID.instanceID().token() ?? "")
                            }else{
                                let message  = responseObject.object(forKey: "message") as! String;
                                // MARK: TEST
                                //                                self.alertViewFromApp(messageString:message);
                            }
                            
                        }) { (error, operation) -> Void in
                            if operation.response?.statusCode == 401 {
                                self.alertViewFromApp(messageString:"Username or password incorrect.")
                            } else {
                                self.alertViewFromApp(messageString:error.localizedDescription)
                            }
                            //     let message  = "Something wrong happning , Please wait for proper response of server";
                            //   self.alertViewFromApp(messageString:message );
                        }
                        
                    }else{
                        obj_app.getAlert("Unable to fetch email address from Facebook. Please make a Registration first")
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    
                    
                }
            })
            
        }
        
    }
    
    
    
    @IBAction func forgotPasswordClicked(_ sender:UIButton)
    {
        let obj_FP = JForgotPasswordVC(nibName: "JForgotPasswordVC", bundle: nil)
        self.navigationController?.pushViewController(obj_FP, animated: true)
    }
    
    @IBAction func AlredyClicked(_ sender:UIButton)
    {
        let obj_Reg = JRegistrationVC(nibName: "JRegistrationVC", bundle: nil)
        self.navigationController?.pushViewController(obj_Reg, animated: true)
    }
    
    
    func setNavBar()
    {
        self.navigationController?.isNavigationBarHidden=true
        self.automaticallyAdjustsScrollViewInsets=false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(JWelcomeVC.hideKeyBoard(_:)))
        self.view.addGestureRecognizer(tap)
        
        //        UIView.animate(withDuration: 0.4, animations: { () -> Void in
        //            scrollView.setContentOffset(CGPoint(x: 0, y: textField.bounds.size.height * 3), animated: true)
        //        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let txtEmail:UITextField! = self.txtEmail // arrayForTextField.object(at: 0) as! UITextField
        let txtPass:UITextField! = self.txtPass // arrayForTextField.object(at: 1) as! UITextField
        
        if(textField == txtEmail)
        {
            txtPass.becomeFirstResponder()
        }
        else
        {
            txtPass.resignFirstResponder()
        }
        
        //        UIView.animate(withDuration: 0.4, animations: { () -> Void in
        //            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        //        })
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        //        UIView.animate(withDuration: 0.4, animations: { () -> Void in
        //            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        //        })
    }
    
    @IBAction func SignInTapped(_ sender:UIButton)
    {
        
        self.clickedLoginButton = sender
        // get all textfields here..
        let txtFieldEmail:    UITextField!   = self.txtEmail // arrayForTextField.object(at: 0) as! UITextField;
        let txtFieldPassword :UITextField!   = self.txtPass  // arrayForTextField.object(at: 1) as! UITextField;
        
        let arr: NSArray! = NSArray(objects: txtFieldEmail,txtFieldPassword);
        
        //check everything...
        let dict :NSDictionary = Validator.getAllTxtFields(arrtxtFieldsIs: arr, placHoldrEmail: "E-mail", placePhoneNumber: "Mobile Number")
        
        NSLog("%@", dict);
        
        let flag  : String = (dict.object(forKey: "flag") as! String);
        
        if(flag == "1")
        {
            // get all textfields here..
            let txtFieldEmail :    UITextField!   = self.txtEmail
            let txtFieldPassword : UITextField!   = self.txtPass
            
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
                    
                    self.isSignupSuccess = false
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
                    
                    
                    let txtEmail : UITextField = self.txtEmail
                    let txtPass : UITextField = self.txtPass
                    txtEmail.text = ""
                    txtPass.text = ""
                    
                    self.userSelectedPreferenceFromService(sender)
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
                //     let message  = "Something wrong happning , Please wait for proper response of server";
                //   self.alertViewFromApp(messageString:message );
            }
        }
    }
}

extension JWelcomeVC: SocialLoginDelegate {
    
    func executeFacebookLogin() {
        print("*******FB Login executed from Account VC*******")
        self.facebookLoginAction(self.facebookBtn)
    }
    
    func executeGoogleLogin() {
        print("*******Google Login executed from Account VC*******")
        obj_app.startActivityIndicatorView()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
}


extension JWelcomeVC: PreferenceCompletionDelegate {
    func didFinishChoosingPreference() {
        self.openingPreference1VC.dismiss(animated: true) {
            let vcHOME:JHomeVC = JHomeVC()
            self.navigationController?.pushViewController(vcHOME, animated: true)
        }
        self.openingPreference1VC = nil
    }
}
