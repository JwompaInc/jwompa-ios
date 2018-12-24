//
//  JSettingsVC.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 09/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class JSettingsVC: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    var tableViewSetting : UITableView    =   UITableView()
    var arraySetting     : NSMutableArray =   NSMutableArray(objects: "Sleep Timer","Send Feedback","Tell a Friend","Rate this App","Terms & Conditions","Privacy Policies","About Jwompa")
    var btnFacebook: FBSDKLoginButton!
    
    var eq:Equelizer!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(sleepTimerTicking(notification:)), name: NSNotification.Name(rawValue: "sleepTimerTicking"), object: nil)
        (self.tableViewSetting.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? JSettingCell)?.timeRemainingLabel.text = SleepTimer.shared.sleepDuration != 0 ? self.getTimeRemainingForSeconds(SleepTimer.shared.sleepDuration) : ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "sleepTimerTicking"), object: nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setNavBar()
        JImage.shareInstance().destroy()
        self.view.backgroundColor = UIColor(red: 254/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        self.setView()
    }
    
    func setNavBar(){
        self.navigationController?.isNavigationBarHidden=true
        self.automaticallyAdjustsScrollViewInsets=false
    }
    
    func hideKeyBoard(_ sender:UITapGestureRecognizer){
        SideView.sharedInstance().closeView()
    }
    
    func setView(){
        
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin    = statusBarHeight + navBarHeight
        
        _ = JImage.shareInstance().setStatusBarDarkView(CGRect.init(x: 0, y: 0, width: screenWidth, height: 20), viewController: self)
        _ = JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
        _ = JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: 60, y: 25, width: screenWidth - 120, height: 30), nameOfString: "SETTINGS")
        
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
        
        let tableHeight = screenHeight - (topMargin + 50)
        
        tableViewSetting =  UITableView(frame: CGRect(x: 0, y: topMargin, width: screenWidth, height: tableHeight), style: .plain)
        tableViewSetting.delegate   =   self
        tableViewSetting.dataSource =   self
        tableViewSetting.allowsSelection = true
        tableViewSetting.backgroundColor = UIColor.clear
        tableViewSetting.separatorInset = UIEdgeInsets.zero
        tableViewSetting.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableViewSetting.bounces = false
        tableViewSetting.layoutMargins = UIEdgeInsets.zero
        tableViewSetting.tableFooterView = UIView(frame: CGRect.zero)
        tableViewSetting.separatorColor = UIColor.gray
        tableViewSetting.separatorStyle = .singleLine
        if #available(iOS 9.0, *) {
            tableViewSetting.cellLayoutMarginsFollowReadableWidth = false
        } else {
            // Fallback on earlier versions
        }
        tableViewSetting.tableFooterView = UIView(frame: CGRect.zero)
        tableViewSetting.register(JSettingCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableViewSetting)
        
        let btnSignoutWidth = screenWidth * 0.75
        let btnSignOutHeight = screenHeight * 0.08
        let btnSignOutLeft = screenWidth/2 - btnSignoutWidth/2
        let btnSignOutTop = screenHeight*(90/100) - 100
        
        
        //            btnFacebook  = FBSDKLoginButton(frame: CGRectMake(btnSignOutLeft,btnSignOutTop,btnSignoutWidth,btnSignOutHeight))
        //            //        buttonWelcome1.titleLabel?.font = textFontFPAl
        //            //        buttonWelcome1.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        //            //        buttonWelcome1.setTitle("Sign in with Facebook", forState: .Normal)
        //            btnFacebook.delegate = self
        //            btnFacebook.addTarget(self, action:"btnLoginFb" , forControlEvents: UIControlEvents.TouchUpInside)
        //            self.view.addSubview(btnFacebook)
        
        
        let buttonSignOut = UIButton(frame: CGRect(x: btnSignOutLeft,y: btnSignOutTop,width: btnSignoutWidth,height: btnSignOutHeight))
        buttonSignOut.backgroundColor = UIColor(red: 228/255.0, green: 63/255.0, blue: 71/255.0, alpha: 1)
        buttonSignOut.titleLabel?.font = textButton
        buttonSignOut.layer.cornerRadius = 4.0
        buttonSignOut.clipsToBounds = true
        buttonSignOut.setTitleColor(UIColor.white, for: UIControlState())
        buttonSignOut.showsTouchWhenHighlighted = true
        buttonSignOut.setTitle("SIGN OUT", for: UIControlState())
        self.view.addSubview(buttonSignOut)
        
        buttonSignOut.addTarget(self, action: #selector(JSettingsVC.SgnOutTapped(_:)), for: UIControlEvents.touchUpInside)
        
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(JSettingsVC.respondToSwipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(JSettingsVC.respondToSwipeLeft(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeLeft)
        
        
        eq = Equelizer(frame: CGRect(x: screenWidth - 30, y: 20, width: 25, height: 30))
        eq.tapBtn.addTarget(self, action: #selector(self.imageTapped), for: UIControlEvents.touchUpInside)
        upperView.addSubview(eq)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(JHomeVC.imageTapped))
        eq.isUserInteractionEnabled = true
        eq.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    func homeBtnTapped()  {
        SideView.sharedInstance().vController = self
        SideView.sharedInstance().setSideView()
        SideView.sharedInstance().openView()
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(tableView.responds(to: #selector(setter: UIView.layoutMargins))){
            tableView.layoutMargins = UIEdgeInsets.zero;
        }
        if tableView.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            tableView.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func respondToSwipeRight(_ gesture : UIGestureRecognizer){
        SideView.sharedInstance().vController = self
        SideView.sharedInstance().setSideView()
        SideView.sharedInstance().openView()
    }
    
    func SideViewTapped(_ sender:UIButton){
        SideView.sharedInstance().vController = self
        SideView.sharedInstance().setSideView()
        SideView.sharedInstance().openView()
    }
    
    func respondToSwipeLeft(_ gesture : UIGestureRecognizer){
        SideView.sharedInstance().closeView()
    }
    
    func removeSavedPrefs() {
        strUSerID = userDefault.value(forKey: "") as? String
        userDefault.setValue("no", forKey: "isLogin")
        
        userDefault.setValue(nil, forKey: "country")
        userDefault.setValue(nil, forKey: "currentCountry")
        userDefault.setValue(nil, forKey: "language")
        userDefault.removeObject(forKey: "USER_NAME_Google")
        userDefault.removeObject(forKey: "USER_NAME_FB")
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        GIDSignIn.sharedInstance().signOut()
        
        self.navigationController?.popToRootViewController(animated: true)
        
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
    }
    
    func SgnOutTapped(_ sender:UIButton) {
        
        if(AudioPlayerModel.shared.jukebox != nil){
            AudioPlayerModel.shared.pauseAudio()
        }
        
        let strFunctionName =  Constants().kLogOutURL

        let perameteres:NSMutableDictionary = NSMutableDictionary();
        print(perameteres)
        WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { [unowned self] (responseObject, operation) -> Void in
            self.removeSavedPrefs()
        }) { [unowned self] (error, operation) -> Void in
            self.removeSavedPrefs()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arraySetting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let strIdentifier : String = "cell"
        
        var cell : JSettingCell?
        cell = tableView.dequeueReusableCell(withIdentifier: strIdentifier) as? JSettingCell
        cell!.layoutMargins = UIEdgeInsets.zero;
        cell!.preservesSuperviewLayoutMargins = false;
        
        
        if (cell == nil){
            cell = JSettingCell(style:UITableViewCellStyle.subtitle, reuseIdentifier: strIdentifier)
        }
        
        cell?.lblName.text = arraySetting.object(at: (indexPath as NSIndexPath).row) as? String
        cell?.lblName.textColor = UIColor.black
        cell?.timeRemainingLabel.isHidden = indexPath.row != 0
        
        cell?.timeRemainingLabel.text = indexPath.row == 0 ? SleepTimer.shared.sleepDuration != 0 ? self.getTimeRemainingForSeconds(SleepTimer.shared.sleepDuration) : "" : ""
        
        let cellHeight = screenHeight * 0.08
        let cellWidth = tableViewSetting.bounds.size.width
        
        cell!.lblLine.frame = CGRect(x: 0, y: cellHeight * 0.95 , width: cellWidth, height: cellHeight * 0.002)
        cell!.lblLine.backgroundColor = UIColor(red: 190/255.0, green: 191/255.0, blue: 191/255.0, alpha: 1)
        
        let widthImageView = cellWidth * 0.05
        let heightImageView = cellWidth * 0.05
        let leftMarginImageView = cellWidth * 0.90
        let topMarginImageView = cellHeight/2 - heightImageView/2
        
        cell!.imageViewArrow.frame = CGRect(x: leftMarginImageView, y: topMarginImageView, width: widthImageView, height: heightImageView)
        cell!.imageViewArrow.image = UIImage(named: "arrowImage")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if((indexPath as NSIndexPath).row == 0){
            let obj_Fav = SleepVC(nibName: "SleepVC", bundle: nil)
            self.navigationController?.pushViewController(obj_Fav, animated: true)
        }else if((indexPath as NSIndexPath).row == 1){
            let FeedBack = JFeedBackVC(nibName:"JFeedBackVC", bundle: nil)
            self.navigationController?.pushViewController(FeedBack, animated: true)            
        }else if((indexPath as NSIndexPath).row == 2){
            let Tell = JTellAFriend(nibName:"JTellAFriend", bundle: nil)
            self.navigationController?.pushViewController(Tell, animated: true)
        }else if((indexPath as NSIndexPath).row == 3){
            RateMyApp.sharedInstance.showRatingAlert()
        }else if((indexPath as NSIndexPath).row == 4){
            let Jtc = JTNC(nibName:"JTNC", bundle: nil)
            self.navigationController?.pushViewController(Jtc, animated: true)
        }else if((indexPath as NSIndexPath).row == 5){
            let JPP = JPPVC(nibName:"JPPVC", bundle: nil)
            self.navigationController?.pushViewController(JPP, animated: true)
        }else if ((indexPath as NSIndexPath).row == 6){
            let AJ = JABoutJwompa(nibName:"JABoutJwompa", bundle: nil)
            self.navigationController?.pushViewController(AJ, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight * 0.08
    }
    
    
    func getTimeRemainingForSeconds(_ originalSeconds: Float) -> String {
        let minutes = Int(originalSeconds) / 60
        let seconds = Int(originalSeconds) % 60
        if originalSeconds >= 6000 {
            return String(format:"%03i:%02i", minutes, seconds)
        } else {
            return String(format:"%02i:%02i", minutes, seconds)
        }
        
    }
    
    
    func sleepTimerTicking(notification: Notification) {
        if let dic = notification.userInfo {
            if let seconds = dic["seconds"] as? Float {
                DispatchQueue.main.async {
                    let cell = self.tableViewSetting.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? JSettingCell// Sleep Timer cell
                    cell?.timeRemainingLabel.text = self.getTimeRemainingForSeconds(seconds)
                    cell?.layoutIfNeeded()
                }
            }
        }
    }
}
