//
//  JHomeVC.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 29/02/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import GoogleMobileAds
import AFNetworking
import SDWebImage


var playlistId :Int = Int ()
//var bannerView: GADBannerView = GADBannerView()
var hasCompletedPreferencesSelection:Bool = false

class JHomeVC: BaseViewController,UIScrollViewDelegate, UICollectionViewDelegateFlowLayout , UICollectionViewDataSource , UICollectionViewDelegate {
    
    var refreshControl: UIRefreshControl!
    var collectionView: UICollectionView!
    var arrayCollView : NSMutableArray = NSMutableArray()
    var buttonPP : UIButton = UIButton()
    var buttonNext : UIButton = UIButton()
    var tagGlobal = 0
    var lblTitleHome : UILabel = UILabel()
    
    let lblPlaylistHome : UILabel = UILabel()
    var imageViewHome : UIImageView = UIImageView()
    
    var collectionTop:CGFloat = 0
    
    var playerView:PlayerView = PlayerView(frame: CGRect(x: 0, y: screenHeight + 60, width: screenWidth, height: 55))
    
    var eq:Equelizer!
    var nowPlayingIndexPath: IndexPath? = nil
    var lastPlayedIndexPath: IndexPath? = nil
    
    fileprivate var songProgressObserver: NSObjectProtocol!
    fileprivate var stateChangeObserver: NSObjectProtocol!
    fileprivate var playObserver: NSObjectProtocol!
    fileprivate var pauseObserver: NSObjectProtocol!
    fileprivate var nextSongObserver: NSObjectProtocol!
    
    var songProgressNotificationClosure: ((Notification) -> Void)? = nil
    var playPauseNotifcationClosure: ((Notification) -> Void)? = nil
    var openingPreference1VC: OpeningPreferencesViewController1!
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self.playObserver)
        NotificationCenter.default.removeObserver(self.pauseObserver)
        NotificationCenter.default.removeObserver(self.stateChangeObserver)
        NotificationCenter.default.removeObserver(self.songProgressObserver)
        NotificationCenter.default.removeObserver(self.nextSongObserver)
        NotificationCenter.default.removeObserver(self)
        
        self.playObserver = nil
        self.pauseObserver = nil
        self.stateChangeObserver = nil
        self.songProgressObserver = nil
        self.nextSongObserver = nil
        
        self.playPauseNotifcationClosure = nil
        self.songProgressNotificationClosure = nil
    }
    
    func animateYellowBar(){
        
        if(AudioPlayerModel.shared.playListSongArray.count > 0) {
            
            self.playerView.removeFromSuperview()
            self.view.addSubview(self.playerView)
            
            self.playerView.checkTrack()
            
            UIView.animate(withDuration: 0.7, animations: { [unowned self] () -> Void in
                
                self.playerView.frame = CGRect(x: 0, y: screenHeight-55, width: screenWidth, height: 55)
                self.collectionView.frame = CGRect(x: 0, y: self.collectionTop, width: screenWidth, height: screenHeight - (self.collectionTop + 60 + 5))
                
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(JHomeVC.imageTapped))
                self.playerView.isUserInteractionEnabled = true
                self.playerView.addGestureRecognizer(tapGestureRecognizer)
            })
        }else{
            self.playerView.removeFromSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        bannerView.rootViewController = self
//        bannerView.frame = CGRect(x: 0, y: screenHeight - 50, width: screenWidth, height: 50)
//        self.navigationController?.view.addSubview(bannerView)
//        bannerView.load(GADRequest())
        
        self.animateYellowBar()
        self.setNavBar()
        
        ////////////////////////////////////////////////////////////////////////////////////
        //Closures
        ////////////////////////////////////////////////////////////////////////////////////
        
        songProgressNotificationClosure = { [unowned self]
            (notification: Notification) -> Void in
            DispatchQueue.main.async {
                if let indexPath = self.nowPlayingIndexPath {
                    if let cell: JHomeCollectionViewCell = (self.collectionView.cellForItem(at: indexPath) as? JHomeCollectionViewCell) {
                        if cell.eqView.subviews.count == 0 {
                            self.setEQForPlayingAlbum(cell: cell)
                        }
                    }
                }
            }
        }
        
        playPauseNotifcationClosure = { [unowned self]
            (notification: Notification) -> Void in
            DispatchQueue.main.async {
                if let indexPath = self.nowPlayingIndexPath {
                    if let cell: JHomeCollectionViewCell = (self.collectionView.cellForItem(at: indexPath) as? JHomeCollectionViewCell) {
                        if cell.eqView.subviews.count == 0 {
                            self.setEQForPlayingAlbum(cell: cell)
                        }
                    }
                    
                } else {
                    self.collectionView.reloadData()
                }
            }
        }
        
        ////////////////////////////////////////////////////////////////////////////////////
        //Observers
        ////////////////////////////////////////////////////////////////////////////////////
        
        
        nextSongObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "nextSong"), object: nil, queue: nil, using: { [unowned self] notification in
            if let handler = self.songProgressNotificationClosure {
                handler(notification)
            }
        })
        
        songProgressObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "songProgress"), object: nil, queue: nil, using: { [unowned self] notification in
            if let handler = self.songProgressNotificationClosure {
                handler(notification)
            }
        })
        
        stateChangeObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "stateChanged"), object: nil, queue: nil, using: { notification in
            if let handler = self.songProgressNotificationClosure {
                handler(notification)
            }
        })
        
        
        playObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "PlaySong"), object: nil, queue: nil, using: { [unowned self] notification in
            if let handler = self.playPauseNotifcationClosure {
                handler(notification)
            }
        })
        
        
        pauseObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "PauseSong"), object: nil, queue: nil, using: { [unowned self] notification in
            if let handler = self.playPauseNotifcationClosure {
                handler(notification)
            }
        })
        
    }
    
    
    fileprivate func getPlaylists() {
        let strFunctionName = Constants().kGetPlayListsURL
        
        WebService.callGetServicewithStringPerameters(StringPerameter: "", FunctionName: strFunctionName, succes: { [unowned self] (responseObject:NSMutableDictionary, operation:AFHTTPRequestOperation) in
            
            self.refreshControl.endRefreshing()
            print("responseObject  :::  \(responseObject)")
            
            self.arrayCollView.removeAllObjects()
            
            let arrayTemp:NSMutableArray = (responseObject.object(forKey: "playlists") as? NSArray)?.mutableCopy() as! NSMutableArray
            
            for data_Dict in arrayTemp {
                print(data_Dict)
                if(data_Dict is NSNull) {
                    continue
                }
                self.arrayCollView.add(data_Dict)
            }
            self.collectionView.reloadData()
            
        }) { (error:NSError, operation:AFHTTPRequestOperation) in
            self.refreshControl.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(JHomeVC.imageTapped))
        eq.isUserInteractionEnabled = true
        eq.addGestureRecognizer(tapGestureRecognizer)
        
        JImage.shareInstance().destroy()
        
        getPlaylists()
    }
    
    func setNavBar(){
        self.navigationController?.isNavigationBarHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func setOriginalView() {
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin    = statusBarHeight + navBarHeight
        
        UIView.animate(withDuration: 0.2) {
            _ = JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
            _ = JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: 60, y: 25, width: screenWidth - 120, height: 30), nameOfString: "SPLASHBOARD")
        }
    }
    
    func setEQForPlayingAlbum(cell: JHomeCollectionViewCell) {
        eq = Equelizer(frame: CGRect(x: 0, y: 0, width: cell.eqView.bounds.width, height: cell.eqView.bounds.height))
        eq.tapBtn.addTarget(self, action: #selector(self.imageTapped), for: UIControlEvents.touchUpInside)
        
        for subview in cell.eqView.subviews {
            subview.removeFromSuperview()
        }
        cell.eqView.addSubview(eq)
    }
    
    func removeEQForPlayingAlbum(cell: JHomeCollectionViewCell) {
        for subview in cell.eqView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func checkUserPreferences() {
        
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
                    hasCompletedPreferencesSelection = true
                }
            }
        }) { (error, operation) in
            let statuscode :  Int = operation.response?.statusCode ?? 400;
            if statuscode == 401 {
                let alert = UIAlertController(title: "OOPS", message: "Your session has been expired. Please login again.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
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
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
            self.alertViewFromApp(messageString: error.description)
          }
        }
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
    

    @objc func pullToRefreshTriggered(_ sender: UIRefreshControl) {
        getPlaylists()
    }
    
    func setView() {
        
        if !hasCompletedPreferencesSelection {
            self.checkUserPreferences()
        }
        
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin    = statusBarHeight + navBarHeight
        
        _ = JImage.shareInstance().setStatusBarDarkView(CGRect.init(x: 0, y: 0, width: screenWidth, height: 20), viewController: self)
        _ = JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
        _ = JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: 60, y: 25, width: screenWidth - 120, height: 30), nameOfString: "SPLASHBOARD")
        
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
        
        
        self.collectionTop = topMargin + 25 + screenHeight*(10/100)
        let heightCollView = screenHeight - (self.collectionTop + 5)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        self.collectionView = UICollectionView(frame: CGRect(x: 5, y: self.collectionTop + 10, width: screenWidth - 10, height: heightCollView), collectionViewLayout: layout)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib.init(nibName: "JHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.collectionView.backgroundColor = UIColor.clear
        
        refreshControl = UIRefreshControl()
        if #available(iOS 10.0, *) {
            self.collectionView.refreshControl = refreshControl
        } else {
            self.collectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(pullToRefreshTriggered(_:)), for: .valueChanged)
        
        let yourWidth = collectionView.bounds.width / 3.0
        let yourHeight = yourWidth
        layout.itemSize = CGSize.init(width: yourWidth, height: yourHeight)
        
        self.view.addSubview(self.collectionView)
        
        
        let collectionCellSize = CGSize.init(width: self.collectionView.bounds.width / 3, height: self.collectionView.bounds.width / 3)
        let imageViewSize = (collectionCellSize.width * 1/1.2)
        let finalXValue = (collectionCellSize.width - imageViewSize) - 4
        
        let lbl : UILabel = UILabel(frame: CGRect(x: finalXValue, y: topMargin + 25,width: screenWidth*(70/100),height: screenHeight*(10/100)))
        lbl.backgroundColor = UIColor.clear
        lbl.text = "We’ll play you some new music.\nJust pick a station!"
        lbl.textColor = UIColor.black
        lbl.numberOfLines = 2
        lbl.backgroundColor = UIColor.clear
        lbl.tintColor = UIColor(red: 130/255.0, green: 130/255.0, blue: 131/255.0, alpha: 1)
        lbl.font = UIFont(name: "OpenSans", size: screenHeight * 0.023)
        lbl.textAlignment = NSTextAlignment.left
        self.view.addSubview(lbl)
        

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(JHomeVC.respondToSwipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(JHomeVC.respondToSwipeLeft(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeDown)
    }
    
    func eqButtonTapped(){
        let jpl : JPlayerVC = JPlayerVC(nibName: "JPlayerVC", bundle: nil)
        self.navigationController?.pushViewController(jpl, animated: true)
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
    
    
    func searchButtonTapped(_ sender: UIButton) {
        self.navigationController?.pushViewController(JSearch(), animated: true);
    }
    
    
    func respondToSwipeLeft(_ gesture : UIGestureRecognizer){
        SideView.sharedInstance().closeView()
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Data Source Method  for Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return arrayCollView.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! JHomeCollectionViewCell
        cell.lbl.text = ""
        cell.lbl.font = UIFont(name: "OpenSans-SemiBold", size: screenHeight * 0.0175)
        cell.imageViewCollView.layer.borderWidth = 0.5
        cell.imageViewCollView.layer.borderColor = UIColor.black.withAlphaComponent(0.8).cgColor
        
        let playlist_data = self.arrayCollView.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        let playlist_title = playlist_data.object(forKey: "name") == nil ? "" : playlist_data.object(forKey: "name") as! String // title
        let playlist_id = playlist_data.object(forKey: "id") as! Int

        if let playlistStoredID = AudioPlayerModel.shared.currentPlayingAlbumID {
            if playlist_id == playlistStoredID {
                self.nowPlayingIndexPath = indexPath
                if cell.eqView.subviews.count == 0 {
                    
                    cell.eqView.translatesAutoresizingMaskIntoConstraints = true
                    self.setEQForPlayingAlbum(cell: cell)
                    
                    if DeviceType.IS_IPHONE_SE {
                        cell.eqTopConstraint.constant = -1.0
                    } else if DeviceType.IS_IPHONE_7 {
                        cell.eqTopConstraint.constant = -0.7
                    } else if DeviceType.IS_IPHONE_7PLUS {
                        cell.eqTopConstraint.constant = -0.7
                    } else if DeviceType.IS_IPHONE_X {
                        cell.eqTopConstraint.constant = -0.9
                    }
                    
                    cell.layoutIfNeeded()
                    cell.updateConstraintsIfNeeded()
                }
                if let handler = self.playPauseNotifcationClosure {
                    handler(Notification.init(name: Notification.Name(rawValue: "")))
                }
            }

            if playlist_id != playlistStoredID {
                // Hide equalizer if req
            }
        }
        if let playlistavatar: String = (playlist_data.object(forKey: "cover_img_link") as? String)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""{
            cell.imageViewCollView.sd_setImage(with: URL(string: playlistavatar), placeholderImage: #imageLiteral(resourceName: "Play"))

        }else{
            cell.imageViewCollView.sd_setImage(with: URL(string: "http://ec2-52-91-211-72.compute-1.amazonaws.com/library/album_art/art.png"), placeholderImage: #imageLiteral(resourceName: "Play"))
        }

//        let user_data:NSDictionary = playlist_data.object(forKey: "user") as! NSDictionary
//        var playlist_avatar:String = (playlist_data.object(forKey: "artwork_url") == nil || playlist_data.object(forKey: "artwork_url") is NSNull) ? "" : playlist_data.object(forKey: "artwork_url") as! String
        
        if(playlist_title != ""){
            
            var strTitle : String = String()
            strTitle = playlist_title
            cell.lbl.text = strTitle
        }
        
        
        
       // if(playlist_avatar == ""){
//            playlist_avatar = (user_data.object(forKey: "avatar_url") == nil || user_data.object(forKey: "avatar_url") is NSNull) ? "" : user_data.object(forKey: "avatar_url") as! String

       // }
        
//        playlist_avatar = playlist_avatar.replacingOccurrences(of: "-large.", with: "-t500x500.")
        
//        ImageLoader.sharedLoader.imageForUrl(playlist_avatar, completionHandler:{(image: UIImage?, url: String) in
//            cell.imageViewCollView.image = UIImage(named: "")
//            if(image != nil){
//                cell.imageViewCollView.image = image
//            }
//        })
        
        
        return cell    // Create UICollectionViewCell
    }
    
    
    // MARK:- Delegate Method for Collection View
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let yourWidth = collectionView.bounds.width / 3.0
        let yourHeight = yourWidth + 30.0

        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let playlist_data = self.arrayCollView.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        
        guard let trackcount = (playlist_data.object(forKey: "track_length") as? Int) else {
            obj_app.getAlert("Playlist is empty.")
            return
        }
        //let track_count : Int = Int(trackcount)!
        
        if trackcount > 0 {
            if (playlist_data.object(forKey: "id") as? Int != nil){
                dictinfo = playlist_data.mutableCopy() as! NSMutableDictionary
                let playlist_Id = playlist_data.object(forKey: "id") as! Int
                
                if AudioPlayerModel.shared.jukebox != nil {
                    if(playlist_Id == AudioPlayerModel.shared.currentPlayingAlbumID){
                        obj_app.getAlert("Already playing this station.")
                        return
                    } else {
                        AudioPlayerModel.shared.currentPlayingAlbumID = playlist_Id
                        lastPlayedIndexPath = nowPlayingIndexPath
                        nowPlayingIndexPath = indexPath
                        
                        if let removeIndexPath = self.lastPlayedIndexPath {
                            if let cell: JHomeCollectionViewCell = (self.collectionView.cellForItem(at: removeIndexPath) as? JHomeCollectionViewCell) {
                                self.removeEQForPlayingAlbum(cell: cell)
                            }
                        }
                    }
                } else {
                    AudioPlayerModel.shared.currentPlayingAlbumID = playlist_Id
                    lastPlayedIndexPath = nowPlayingIndexPath
                    nowPlayingIndexPath = indexPath
                    
                    if let removeIndexPath = self.lastPlayedIndexPath {
                        if let cell: JHomeCollectionViewCell = (self.collectionView.cellForItem(at: removeIndexPath) as? JHomeCollectionViewCell) {
                            self.removeEQForPlayingAlbum(cell: cell)
                        }
                    }
                }
                
                UserDefaults.standard.setValue(playlist_Id, forKey: "playlist_id")
                
                let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [playlist_Id], forKeys: ["playlist_id" as NSCopying]);
                let strFunctionName = "api/add_playlist_recent"
                
                WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { [unowned self] (responseObject, operation) -> Void in
                    
                    print("responseObject :::: \(responseObject)")
                    
                    let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
                    
                    if(isOk == true){
                        //let message  = responseObject.objectForKey("message") as! String;
                        AudioPlayerModel.shared.MainPlayerVC = JPlayerVC()
                        AudioPlayerModel.shared.MainPlayerVC.playlistIDPlayer = playlist_Id
                        AudioPlayerModel.shared.listenSongAPI()
                        UserDefaults.standard.setValue(0, forKey: "SkipCount")
                    self.navigationController?.pushViewController(AudioPlayerModel.shared.MainPlayerVC, animated: true)
                    }
                }) { (error, operation) -> Void in
                    obj_app.getAlert("Server Error. Please try again!")
                }
            }
            
        }else{
            obj_app.getAlert("Playlist is empty.")
        }
    }
}

extension JHomeVC: PreferenceCompletionDelegate {
    func didFinishChoosingPreference() {
        hasCompletedPreferencesSelection = true
        self.openingPreference1VC.dismiss(animated: true, completion: nil)
        self.openingPreference1VC = nil
    }
}
