//
//  JRecentVC.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 14/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SDWebImage

class JRecentVC: BaseViewController,UITableViewDelegate, UITableViewDataSource {

    var tableViewRecent : UITableView    =   UITableView()
    var arrayRecent: NSMutableArray =   NSMutableArray()
    var buttonPP: UIButton = UIButton()
    var buttonNext: UIButton = UIButton()
    var tagGlobal = 0
    var lblTitleHome: UILabel = UILabel()
    var imageViewHome: UIImageView = UIImageView()
    var lblPlaylistHome: UILabel = UILabel()
    var localTrackId: Int = Int()
    
    var eq:Equelizer!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setYelloPlayer()
    }
    
    var playerView:PlayerView = PlayerView(frame: CGRect(x: 0, y: screenHeight + 60, width: screenWidth, height: 55))
    func setYelloPlayer(){
        
        if(AudioPlayerModel.shared.playListSongArray.count > 0) {
            
            self.playerView.removeFromSuperview()
            self.view.addSubview(self.playerView)
            
            self.playerView.checkTrack()
            
            
            let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
            let topMargin    = statusBarHeight + navBarHeight
            
            let tableHeight = screenHeight - (topMargin  + 55)
            
            
            UIView.animate(withDuration: 0.7, animations: { [unowned self] () -> Void in
                
                self.playerView.frame = CGRect(x: 0, y: screenHeight-55, width: screenWidth, height: 55)
                self.tableViewRecent.frame = CGRect(x: 0, y: topMargin , width: screenWidth, height: tableHeight)
                
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped))
                self.playerView.isUserInteractionEnabled = true
                self.playerView.addGestureRecognizer(tapGestureRecognizer)
            })
        }else{
            self.playerView.removeFromSuperview()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBar()
        JImage.shareInstance().destroy()
        self.view.backgroundColor = UIColor(red: 254/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin    = statusBarHeight + navBarHeight
        
        _ = JImage.shareInstance().setStatusBarDarkView(CGRect.init(x: 0, y: 0, width: screenWidth, height: 20), viewController: self)
        _ = JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
        _ = JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: 60, y: 25, width: screenWidth - 120, height: 30), nameOfString: "RECENTS")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playSongObserver(_:)), name: NSNotification.Name(rawValue: "PlaySong"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseSongObserver(_:)), name: NSNotification.Name(rawValue: "PauseSong"), object: nil)
        
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
        
        self.setMyView()
        self.getRecentData()
    }
    func homeBtnTapped()  {
        SideView.sharedInstance().vController = self
        SideView.sharedInstance().setSideView()
        SideView.sharedInstance().openView()
    }
    
    func getRecentData(){
        let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [strUSerID!.intValue], forKeys: ["user_id" as NSCopying]);
        let strFunctionName = "api/view_recent_playlist"
        WebService.callGetServicewithStringPerameters(StringPerameter: "", FunctionName: strFunctionName, succes: { [unowned self] (responseObject, operation) -> Void in
            
            print("responseObject :::::: \(responseObject)")
            
            let status = responseObject.object(forKey: "status_code") as! Int
            
            if(status == 1){
                
                self.arrayRecent.removeAllObjects()
                
                let arrayTemp:NSMutableArray = (responseObject.object(forKey: "playlists") as? NSArray)?.mutableCopy() as! NSMutableArray
                
                for data_Dict in arrayTemp {
                    
                    if(data_Dict is NSNull || data_Dict == nil){
                        continue
                    }
                    self.arrayRecent.add(data_Dict)
                }
                self.tableViewRecent.reloadData()
                
            }else{
                self.alertViewFromApp(messageString: "No Recent Playlists are available")
            }
            
        }) { (error, operation) -> Void in
            
            let message  = "Something wrong happning , Please wait for proper response of server";
            // MARK: TEST
            //            self.alertViewFromApp(messageString:message);
        }
//        WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
//
//            print("responseObject :::::: \(responseObject)")
//
//            let status = responseObject.object(forKey: "status_code") as! Int
//
//            if(status == 1){
//
//                self.arrayRecent.removeAllObjects()
//
//                let arrayTemp:NSMutableArray = (responseObject.object(forKey: "playlists") as? NSArray)?.mutableCopy() as! NSMutableArray
//
//                for data_Dict in arrayTemp {
//
//                    if(data_Dict is NSNull || data_Dict == nil){
//                        continue
//                    }
//                    self.arrayRecent.add(data_Dict)
//                }
//                self.tableViewRecent.reloadData()
//
//            }else{
//                obj_app.getAlert("No Recent Playlists are available")
//            }
//
//        }) { (error, operation) -> Void in
//
//            let message  = "Something wrong happning , Please wait for proper response of server";
//            // MARK: TEST
////            self.alertViewFromApp(messageString:message);
//        }
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
    
    func hideKeyBoard(_ sender:UITapGestureRecognizer){
        SideView.sharedInstance().closeView()
    }
    
    // Set Nav Bar
    
    func setNavBar(){
        self.navigationController?.isNavigationBarHidden=true
        self.automaticallyAdjustsScrollViewInsets=false
    }
    
    
    
    func setMyView(){
        
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin    = statusBarHeight + navBarHeight
        
        let tableHeight = screenHeight - (topMargin + 5)
        
        tableViewRecent =  UITableView(frame: CGRect(x: 0, y: topMargin , width: screenWidth, height: tableHeight), style: .plain)
        tableViewRecent.delegate   =   self
        tableViewRecent.dataSource =   self
        tableViewRecent.backgroundColor = UIColor.clear
        tableViewRecent.separatorInset = UIEdgeInsets.zero
        tableViewRecent.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        //tableViewRecent.bounces = false
        tableViewRecent.layoutMargins = UIEdgeInsets.zero
        tableViewRecent.tableFooterView = UIView(frame: CGRect.zero)
        tableViewRecent.separatorColor = UIColor.gray
        tableViewRecent.separatorStyle = .singleLine
        if #available(iOS 9.0, *) {
            tableViewRecent.cellLayoutMarginsFollowReadableWidth = false
        } else {
            // Fallback on earlier versions
        }
        tableViewRecent.tableFooterView = UIView(frame: CGRect.zero)
        tableViewRecent.register(UINib.init(nibName: "JRecentCell", bundle: nil), forCellReuseIdentifier: "cell")        
        self.view.addSubview(tableViewRecent)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeLeft(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)

    }
    
    func SideViewTapped(_ sender:UIButton){
        SideView.sharedInstance().vController = self
        SideView.sharedInstance().setSideView()
        SideView.sharedInstance().openView()
    }
    
    func respondToSwipeRight(_ gesture : UIGestureRecognizer){
        SideView.sharedInstance().vController = self
        SideView.sharedInstance().setSideView()
        SideView.sharedInstance().openView()
    }
    
    func respondToSwipeLeft(_ gesture : UIGestureRecognizer){
        SideView.sharedInstance().closeView()
    }
        
    /// for Table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayRecent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dictData = self.arrayRecent.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
//        let userData = dictData.object(forKey: "user") as! NSDictionary
        let titleStr:String = dictData.object(forKey: "title") as! String
        let playListID = dictData.object(forKey: "id") as! Int
//        let strUrl = userData.object(forKey: "avatar_url") as! String
        
        var cell : JRecentCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! JRecentCell
        
        if (cell == nil){
            cell = JRecentCell(style:UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        }
//        cell.lblName.text = "Test label"
//        cell.lblDescr.text = "OMG..!!! Another problem."
//        cell.imageViewRecent.image = #imageLiteral(resourceName: "YellowPlay")
                cell.lblName.text = titleStr
        
        if let currentPlayingListID = AudioPlayerModel.shared.currentPlayingAlbumID {
            if playListID == currentPlayingListID {
                cell.nowPlayingLbl.isHidden = false
                self.localTrackId = playListID
            }
            
            if playListID != currentPlayingListID {
                cell.nowPlayingLbl.isHidden = true
            }
        }
        
        
        if (dictData.object(forKey: "description") == nil) {
            cell.lblDescr.text = "No Description is available"
        }else{
            cell.lblDescr.text = dictData.object(forKey: "description") as? String
        }
        
        
        var playlist_avatar:String = (dictData.object(forKey: "artwork_url") == nil || dictData.object(forKey: "artwork_url") is NSNull) ? "http://ec2-52-91-211-72.compute-1.amazonaws.com/library/album_art/art.png" : dictData.object(forKey: "artwork_url") as! String
        if(playlist_avatar == ""){
//            playlist_avatar = (userData.object(forKey: "avatar_url") == nil || userData.object(forKey: "avatar_url") is NSNull) ? "" : userData.object(forKey: "avatar_url") as! String

        }
        
        playlist_avatar = playlist_avatar.replacingOccurrences(of: "-large.", with: "-t500x500.")
        
        cell.imageViewRecent.sd_setImage(with: URL(string: playlist_avatar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), placeholderImage: #imageLiteral(resourceName: "Play"))
//        ImageLoader.sharedLoader.imageForUrl(playlist_avatar, completionHandler:{(image: UIImage?, url: String) in
//            cell.imageViewRecent.image = UIImage(named: "")
//            if(image != nil){
//                cell.imageViewRecent.image = image
//            }
//        })
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let dictData = self.arrayRecent.object(at: (indexPath as NSIndexPath).row) as! NSDictionary

        let strIdentifier : String = "cell"
        var cell : JRecentCell?

        cell = tableView.dequeueReusableCell(withIdentifier: strIdentifier) as? JRecentCell

        cell!.selectionStyle = UITableViewCellSelectionStyle.none

        cell!.backgroundColor             = UIColor.clear
        cell!.contentView.backgroundColor = UIColor.clear

        let playlistId = dictData.object(forKey: "id") as! Int
        let track_count = dictData.object(forKey: "track_count") as! Int
        
        AudioPlayerModel.shared.currentPlayingAlbumID = playlistId
        self.tableViewRecent.reloadData()
        
        if(track_count > 0){

            let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [strUSerID!.intValue,playlistId], forKeys: ["user_id" as NSCopying,"playlist_id" as NSCopying]);

            let strFunctionName = "api/add_playlist_recent"

            WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { [unowned self](responseObject, operation) -> Void in

                let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool

                if(isOk == true){
                    AudioPlayerModel.shared.MainPlayerVC = JPlayerVC()
                    AudioPlayerModel.shared.MainPlayerVC.playlistIDPlayer = playlistId
                    AudioPlayerModel.shared.listenSongAPI()
                    self.navigationController?.pushViewController(AudioPlayerModel.shared.MainPlayerVC, animated: true)
                }


            }) { (error, operation) -> Void in
                obj_app.getAlert("Server Error. Please try again!")
            }

        }else{
            obj_app.getAlert("Playlist is empty.")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor             = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playSongObserver(_ notification: Notification) {
        print("JRecent: play song")
        //AudioPlayerModel.shared.currentPlayingAlbumID = self.localTrackId
        //self.tableViewRecent.reloadData()
    }
    
    func pauseSongObserver(_ notification: Notification) {
//        AudioPlayerModel.shared.currentPlayingAlbumID = 878989090
        //self.tableViewRecent.reloadData()
        print("JRecent: pause song")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PlaySong"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PauseSong"), object: nil)
    }
}


