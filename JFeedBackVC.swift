//
//  JFeedBackVC.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 04/04/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class JFeedBackVC: BaseViewController , UITextFieldDelegate ,UITextViewDelegate {
    
    var txtFieldSubject : TextField = TextField()
    var txtFieldSelectOne : TextField = TextField()
    var messageText:UITextView = UITextView()
    var arrayFeedBack : NSMutableArray = NSMutableArray()
    var buttonFeedBack : UIButton = UIButton()
    
    var scrollView:UIScrollView!
    
    var subjectLbl:UILabel!
    var categoryLbl:UILabel!
    var messageLbl:UILabel!
    
    var eq:Equelizer!
    
    var text_field:UITextField!
    var text_view:UITextView!
    
    var feedback_catId:Int!
    
    let dropdown = DropDown()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        DispatchQueue.main.async {
            self.setMyView()
            self.configureDropdown()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JImage.shareInstance().destroy()
        self.view.backgroundColor = UIColor(red: 254/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        //scrollView.delegate = self
        
        DispatchQueue.main.async {
            self.setNavBar()
            self.getCategoryData()
        }
    }
    
    func setNavBar(){
        self.navigationController?.isNavigationBarHidden=true
        self.automaticallyAdjustsScrollViewInsets=false
    }
    
    func configureDropdown() {
        
        dropdown.anchorView = self.txtFieldSelectOne
        dropdown.width = self.txtFieldSelectOne.frame.size.width
        dropdown.height = self.txtFieldSelectOne.frame.size.height + self.messageText.frame.size.height + 50
        dropdown.direction = .bottom
        dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)
        dropdown.backgroundColor = messageText.backgroundColor
        dropdown.shadowColor = .clear
        dropdown.selectionBackgroundColor = .clear
        dropdown.setBorderWidth(0.2, and: UIColor.black.withAlphaComponent(0.1))
        
        //Dropdown selection config
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtFieldSelectOne.text = item
            self.view.endEditing(true)
            
            let dict:NSDictionary = self.arrayFeedBack.object(at: index) as! NSDictionary
            let catString:String = dict.object(forKey: "cat_name") as! String
            self.feedback_catId = dict.object(forKey: "id") as! Int
            
            self.txtFieldSelectOne.text = catString
            print("dict: \(dict)")
            
        }
    }
    
    func setMyView() {
        
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin    = statusBarHeight + navBarHeight
        
        JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
        JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: 60, y: 25, width: screenWidth - 120, height: 30), nameOfString: "FEEDBACK")
        JImage.shareInstance().setBackButton(CGRect(x: 15,y: 30,width: 20,height: 20))
        
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: topMargin, width: screenWidth, height: screenHeight-topMargin))
        self.view.addSubview(scrollView)
        
        
        
        let imageViewWidth : CGFloat = screenWidth * 0.30
        let imageViewHeight : CGFloat = screenHeight * 0.20
        let imageViewLeft : CGFloat = screenWidth/2 - imageViewWidth/2
        let imageViewTop : CGFloat = scrollView.bounds.size.height * 0.01
        
        let imageView = UIImageView(frame: CGRect(x: imageViewLeft, y: imageViewTop, width: imageViewWidth, height: imageViewHeight))
        imageView.image = UIImage.init(named: "logo-504")
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.backgroundColor = UIColor.clear
        self.scrollView.addSubview(imageView)
        
        
        buttonBack.addTarget(self, action: #selector(JFeedBackVC.BackButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        let lblSetWidth = screenWidth * 0.80
        let lblSetHeight = screenHeight * 0.05
        let lblSetLeft = screenWidth/2 - lblSetWidth/2
        let lblSetTop = imageViewTop + imageViewHeight
        
        let lblLet : UILabel = UILabel()
        lblLet.frame = CGRect(x: lblSetLeft, y: lblSetTop, width: lblSetWidth, height: lblSetHeight)
        lblLet.backgroundColor = UIColor.clear
        lblLet.text = "Let us know what you think about this app."
        lblLet.textColor = UIColor.black
        lblLet.font = UIFont(name:"OpenSans-Italic", size: screenHeight * 0.020)
        lblLet.textAlignment = NSTextAlignment.center
        self.scrollView.addSubview(lblLet)
        
        
        subjectLbl = UILabel()
        subjectLbl.frame = CGRect(x: screenWidth*(15/100), y: lblLet.frame.origin.y + lblLet.frame.size.height, width: screenWidth*(28/100), height: screenHeight*(4.5/100))
        subjectLbl.backgroundColor = UIColor.clear
        subjectLbl.text = "Subject"
        subjectLbl.textColor = UIColor(hex: 0xB2B1B1, alpha: 1)
        subjectLbl.font = UIFont.systemFont(ofSize: screenHeight*(1.8/100))
        subjectLbl.textAlignment = NSTextAlignment.left
        subjectLbl.layer.borderWidth = 0.2
        subjectLbl.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        self.scrollView.addSubview(subjectLbl)
        
        let subStarLbl = UILabel.init(frame: CGRect.init(x: subjectLbl.frame.width, y: subjectLbl.frame.origin.y, width: 10, height: subjectLbl.frame.height))
        subStarLbl.text = "*"
        subStarLbl.backgroundColor = UIColor.clear
        subStarLbl.textColor = .red
        subStarLbl.font = UIFont.systemFont(ofSize: screenHeight*(1.8/100))
        subStarLbl.textAlignment = NSTextAlignment.left
        self.scrollView.addSubview(subStarLbl)
        
        
        txtFieldSubject.frame = CGRect(x: screenWidth*(15/100), y:  subjectLbl.frame.origin.y + subjectLbl.frame.size.height, width: screenWidth*(70/100), height: screenHeight*(5.5/100))
        txtFieldSubject.placeholder = ""
        txtFieldSubject.layer.cornerRadius = 4
        txtFieldSubject.clipsToBounds = true
        txtFieldSubject.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
        txtFieldSubject.delegate = self
        txtFieldSubject.font = UIFont.systemFont(ofSize: screenHeight*(2/100))
        self.scrollView.addSubview(txtFieldSubject)
        
        
        
        categoryLbl = UILabel()
        categoryLbl.frame = CGRect(x: screenWidth*(15/100), y: txtFieldSubject.frame.origin.y + txtFieldSubject.frame.size.height + 10, width: screenWidth*(44/100), height: screenHeight*(4.5/100))
        categoryLbl.backgroundColor = UIColor.clear
        categoryLbl.text = "Type of Feedback"
        categoryLbl.textColor = UIColor(hex: 0xB2B1B1, alpha: 1)
        categoryLbl.font = UIFont.systemFont(ofSize: screenHeight*(1.8/100))
        categoryLbl.textAlignment = NSTextAlignment.left
        self.scrollView.addSubview(categoryLbl)
        
        let categoryStarLbl = UILabel.init(frame: CGRect.init(x: categoryLbl.frame.width, y: categoryLbl.frame.origin.y, width: 10, height: categoryLbl.frame.height))
        categoryStarLbl.text = "*"
        categoryStarLbl.backgroundColor = UIColor.clear
        categoryStarLbl.textColor = .red
        categoryStarLbl.font = UIFont.systemFont(ofSize: screenHeight*(1.8/100))
        categoryStarLbl.textAlignment = NSTextAlignment.left
        self.scrollView.addSubview(categoryStarLbl)
        
        
        txtFieldSelectOne.frame = CGRect(x: screenWidth*(15/100), y:  categoryLbl.frame.origin.y + categoryLbl.frame.size.height, width: screenWidth*(70/100), height: screenHeight*(5.5/100))
        txtFieldSelectOne.placeholder = "Select One..."
        txtFieldSelectOne.layer.cornerRadius = 4
        txtFieldSelectOne.clipsToBounds = true
        txtFieldSelectOne.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
        txtFieldSelectOne.delegate = self
        txtFieldSelectOne.isUserInteractionEnabled = true
        txtFieldSelectOne.font = UIFont.systemFont(ofSize: screenHeight*(2/100))
        txtFieldSelectOne.layer.borderWidth = 0.2
        txtFieldSelectOne.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        txtFieldSelectOne.clipsToBounds = true
        txtFieldSelectOne.layer.masksToBounds = true
        self.scrollView.addSubview(txtFieldSelectOne)
        
        
        let downArrowImageView = UIImageView.init(frame: CGRect.init(x: (screenWidth*(15/100) + screenWidth*(70/100)) - 35, y: txtFieldSelectOne.frame.origin.y + 2.5, width: 30, height: 30))
        downArrowImageView.image = #imageLiteral(resourceName: "arrowImage")
        let degrees = 90.0
        let radians = CGFloat(degrees * Double.pi / 180)
        downArrowImageView.layer.transform = CATransform3DMakeRotation(radians, 0, 0, 1)
        downArrowImageView.contentMode = .scaleAspectFit
        self.scrollView.addSubview(downArrowImageView)
        
        messageLbl = UILabel()
        messageLbl.frame = CGRect(x: screenWidth*(15/100), y: txtFieldSelectOne.frame.origin.y + txtFieldSelectOne.frame.size.height + 10, width: screenWidth*(30/100), height: screenHeight*(4.5/100))
        messageLbl.backgroundColor = UIColor.clear
        messageLbl.text = "Message"
        messageLbl.textColor = UIColor(hex: 0xB2B1B1, alpha: 1)
        messageLbl.font = UIFont.systemFont(ofSize: screenHeight*(1.8/100))
        messageLbl.textAlignment = NSTextAlignment.left
        self.scrollView.addSubview(messageLbl)
        
        
        let messageStarLbl = UILabel.init(frame: CGRect.init(x: messageLbl.frame.width, y: messageLbl.frame.origin.y, width: 10, height: messageLbl.frame.height))
        messageStarLbl.text = "*"
        messageStarLbl.backgroundColor = UIColor.clear
        messageStarLbl.textColor = .red
        messageStarLbl.font = UIFont.systemFont(ofSize: screenHeight*(1.8/100))
        messageStarLbl.textAlignment = NSTextAlignment.left
        self.scrollView.addSubview(messageStarLbl)
        
        
        messageText.frame = CGRect(x: screenWidth*(15/100), y:  messageLbl.frame.origin.y + messageLbl.frame.size.height, width: screenWidth*(70/100), height: screenHeight*(12/100))
        messageText.layer.cornerRadius = 4
        messageText.clipsToBounds = true
        messageText.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 227/255.0, alpha: 1)
        messageText.delegate = self
        messageText.font = UIFont.systemFont(ofSize: screenHeight*(2/100))
        messageText.layer.borderWidth = 0.2
        messageText.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        self.scrollView.addSubview(messageText)
        
        let button = UIButton(frame: CGRect(x: screenWidth*(15/100), y: messageText.frame.origin.y + messageText.frame.size.height + 25, width: screenWidth*(70/100), height: screenHeight*(6.5/100)))
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = textButton
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.backgroundColor = UIColor(red: 61/255.0, green: 156/255.0, blue: 147/255.0, alpha: 1)
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.showsTouchWhenHighlighted = true
        button.setTitle("SEND", for: UIControlState())
        button.addTarget(self, action: #selector(self.sendBtnClicked), for: UIControlEvents.touchUpInside)
        self.scrollView.addSubview(button)
        
        
        eq = Equelizer(frame: CGRect(x: screenWidth - 30, y: 20, width: 25, height: 30))
        eq.tapBtn.addTarget(self, action: #selector(self.imageTapped), for: UIControlEvents.touchUpInside)
        upperView.addSubview(eq)
        
        
        self.scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight - 60)
    }
    
    
    func sendBtnClicked(){
        
        if(txtFieldSubject.text!.isEmpty){
            obj_app.getAlert("Please Enter Subject")
            return
        }else if(txtFieldSelectOne.text!.isEmpty){
            obj_app.getAlert("Please Select Feedback Type")
            return
        }else if(messageText.text!.isEmpty){
            obj_app.getAlert("Please Enter Feedback Message")
            return
        }
        
        
        
        let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [strUSerID!.intValue,txtFieldSubject.text!,feedback_catId,messageText.text!], forKeys: ["user_id" as NSCopying,"subject" as NSCopying,"feedback_cat" as NSCopying,"message" as NSCopying]);
        let strFunctionName = "api/feedback"
        
        
        WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
            
            print("responseObject :::: \(responseObject)")
            
            let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
            
            if(isOk == true){
                let message = responseObject.object(forKey: "message") as! String
                obj_app.getAlert(message)
                
                self.txtFieldSubject.text = ""
                self.txtFieldSelectOne.text = ""
                self.messageText.text = ""
                
            }else{
                let message = responseObject.object(forKey: "message") as! String
                obj_app.getAlert(message)
            }
            
        }) { (error, operation) -> Void in
            obj_app.getAlert("Server Error. Please try again!")
        }
        
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
    
    
    func getCategoryData(){
        
        let strFunctionName = "api/feedback_category"
        
        WebService.callGetServicewithStringPerameters(StringPerameter: "", FunctionName: strFunctionName, succes: { (responseObject, operation) in
            
            print("responseObject :::: \(responseObject)")
            
            let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
            
            if isOk == true {
                self.arrayFeedBack = ((responseObject.object(forKey: "feedback_category") as! NSArray).mutableCopy() as? NSMutableArray)!
                self.dropdown.dataSource = (responseObject.object(forKey: "feedback_category") as! [[String:Any]]).map { $0["cat_name"] } as! [String]
                print(self.dropdown.dataSource)
            }
            
        }) { (error, operation) in
            obj_app.getAlert("Server Error. Please try again!")
        }
        
    }
    
    
    //----------------------------------------------
    
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtFieldSelectOne {
            self.dropdown.show()
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        text_view = textView
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        text_view = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        text_view = textView
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    
    
    
    func keyboardWillShow(_ notification: Notification) {
        
        var info = notification.userInfo!
        let keyboardSize: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let contentInsets:UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
        
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        var rect:CGRect = self.view.frame
        rect.size.height -= keyboardSize.height;
        
        if((text_field) != nil){
            
            if(text_field.isFirstResponder){
                if(self.text_field.frame.origin.y < rect.size.height){
                    return
                }
                if (!rect.contains(self.text_field.frame.origin)){
                    let scrollPoint:CGPoint = CGPoint(x:0.0,y: self.text_field.frame.origin.y - (rect.size.height - self.text_field.frame.size.height)+10);
                    self.scrollView.setContentOffset(scrollPoint, animated: false)
                }
            }else if(text_view != nil && text_view.isFirstResponder){
                let scrollPoint:CGPoint = CGPoint(x:0.0,y: self.text_view.frame.origin.y - (rect.size.height - self.text_view.frame.size.height)+10);
                self.scrollView.setContentOffset(scrollPoint, animated: false)
            }
            
        }else{
            
            if(text_view != nil){
                let scrollPoint:CGPoint = CGPoint(x:0.0,y: self.text_view.frame.origin.y - (rect.size.height - self.text_view.frame.size.height)+10);
                self.scrollView.setContentOffset(scrollPoint, animated: false)
            }
        }
        
    }
    
    func keyboardWillHide(_ sender: Notification) {
        let contentInsets:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }
    
    func BackButtonTapped(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DropDown {
    
    func setBorderWidth(_ width: CGFloat, and color: UIColor) {
        self.tableViewContainer.layer.borderColor = color.cgColor
        self.tableViewContainer.layer.borderWidth = width
        
        self.tableView.layer.borderColor = color.cgColor
        self.tableView.layer.borderWidth = width
    }
}
