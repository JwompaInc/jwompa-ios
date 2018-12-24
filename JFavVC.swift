//
//  JFavVC.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 14/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import AFNetworking
import SDWebImage

class JFavVC: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    var tableViewFav : UITableView    =   UITableView()
    var arrayFav     : NSMutableArray =   NSMutableArray()
    var buttonPP : UIButton = UIButton()
    var buttonNext : UIButton = UIButton()
    var tagGlobal = 0
    var lblTitleHome : UILabel = UILabel()
    
    var imageViewHome : UIImageView = UIImageView()
    var lblPlaylistHome : UILabel = UILabel()

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
            
            let tableHeight = screenHeight - (topMargin + 50 + 55)
            
            
            UIView.animate(withDuration: 0.7, animations: { () -> Void in
                
                self.playerView.frame = CGRect(x: 0, y: screenHeight-55, width: screenWidth, height: 55)
                self.tableViewFav.frame = CGRect(x: 0, y: topMargin , width: screenWidth, height: tableHeight)
                
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
        _ = JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: 60, y: 25, width: screenWidth - 120, height: 30), nameOfString: "FAVORITES")
        
        
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
        
        self.getFavList()
    }
    
    func getFavList(){
    
        //let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [strUSerID!.intValue], forKeys: ["user_id" as NSCopying]);
        let strFunctionName = Constants().kFavoriteList
        
        WebService.callGetServicewithStringPerameters(StringPerameter: "", FunctionName: strFunctionName, succes: { (responseObject:NSMutableDictionary, operation:AFHTTPRequestOperation) in
            
            let isOk =  responseObject.object(forKey: "status_code") as! NSNumber
            
            if(isOk == 1){
                
                self.arrayFav.removeAllObjects()
                
                let arrayTemp:NSMutableArray = (responseObject.object(forKey: "playlist") as? NSArray)?.mutableCopy() as! NSMutableArray
                
                for data_Dict in arrayTemp {
                    
                    if(data_Dict is NSNull || data_Dict == nil){
                        continue
                    }
                    self.arrayFav.add(data_Dict)
                }
                self.tableViewFav.reloadData()
                
            }else{
                obj_app.getAlert("No Data available")
            }

            
        }) { (error, operation) in
            self.alertViewFromApp(messageString: error.description)
        }

        
//        WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
//
//            print("responseObject ::::   \(responseObject)")
//
//
//            let isOk =  responseObject.object(forKey: "status_code") as! NSNumber
//
//            if(isOk == 1){
//
//                self.arrayFav.removeAllObjects()
//
//                let arrayTemp:NSMutableArray = (responseObject.object(forKey: "playlist") as? NSArray)?.mutableCopy() as! NSMutableArray
//
//                for data_Dict in arrayTemp {
//
//                    if(data_Dict is NSNull || data_Dict == nil){
//                        continue
//                    }
//                    self.arrayFav.add(data_Dict)
//                }
//                self.tableViewFav.reloadData()
//
//            }else{
//                obj_app.getAlert("No Data are available")
//            }
//
//        }) { (error, operation) -> Void in
//
//            let message  = "Something wrong happning , Please wait for proper response of server";
//            // MARK: TEST
////            self.alertViewFromApp(messageString:message);
//        }
    
    }
    
    func homeBtnTapped()  {
        SideView.sharedInstance().vController = self
        SideView.sharedInstance().setSideView()
        SideView.sharedInstance().openView()
    }
    func imageTapped(){
        
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
        
        let tableHeight = screenHeight - (topMargin + 50)
        
        tableViewFav =  UITableView(frame: CGRect(x: 0, y: topMargin, width: screenWidth, height: tableHeight), style: .plain)
        tableViewFav.delegate   =   self
        tableViewFav.dataSource =   self
        tableViewFav.allowsSelection = true
        tableViewFav.backgroundColor = UIColor.clear
        tableViewFav.separatorInset = UIEdgeInsets.zero
        tableViewFav.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        //tableViewFav.bounces = false
        tableViewFav.layoutMargins = UIEdgeInsets.zero
        tableViewFav.tableFooterView = UIView(frame: CGRect.zero)
        tableViewFav.separatorColor = UIColor.gray
        tableViewFav.separatorStyle = .singleLine
        if #available(iOS 9.0, *) {
            tableViewFav.cellLayoutMarginsFollowReadableWidth = false
        } else {
            // Fallback on earlier versions
        }
        
       // self.navigationController?.view.addSubview(bannerView)
        tableViewFav.tableFooterView = UIView(frame: CGRect.zero)
        tableViewFav.register(UINib.init(nibName: "JFavTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.view.addSubview(tableViewFav)
        
      
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeLeft(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeLeft)
        
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
    
    /// for Table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayFav.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dictData = self.arrayFav.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        let titleStr:String = dictData.object(forKey: "title") as! String
        let playListID = dictData.object(forKey: "id") as! Int

        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? JFavTableViewCell
        
        if (cell == nil){
            cell = JFavTableViewCell(style:UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        }
        
        cell?.imageViewFav.layer.masksToBounds = true
        cell?.imageViewFav.clipsToBounds = true
        cell?.lblName.text = titleStr
        
        if (dictData.object(forKey: "description") == nil) {
            cell?.lblDescr.text = "No Description is Available"
        }else{
            cell?.lblDescr.text = dictData.object(forKey: "description") as? String
        }
        
        print(AudioPlayerModel.shared.currentPlayingAlbumID)
        
        if let currentPlayingListID = AudioPlayerModel.shared.currentPlayingAlbumID {
            if playListID == currentPlayingListID {
                cell?.nowPlayingLbl.isHidden = false
                //self.localTrackId = playListID
            }
            
            if playListID != currentPlayingListID {
                cell?.nowPlayingLbl.isHidden = true
            }
        }
        
        
        var playlist_avatar:String = (dictData.object(forKey: "artwork_url") == nil || dictData.object(forKey: "artwork_url") is NSNull) ? "http://ec2-52-91-211-72.compute-1.amazonaws.com/library/album_art/art.png" : dictData.object(forKey: "artwork_url") as! String
        playlist_avatar = playlist_avatar.replacingOccurrences(of: "-large.", with: "-t500x500.")
        
        cell?.imageViewFav.sd_setImage(with: URL(string: playlist_avatar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), placeholderImage:#imageLiteral(resourceName: "Play"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
        })
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dictData = self.arrayFav.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        let playlistId = dictData.value(forKey: "id") as! Int
        
        let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [strUSerID!.intValue,playlistId], forKeys: ["user_id" as NSCopying,"playlist_id" as NSCopying]);
        AudioPlayerModel.shared.currentPlayingAlbumID = playlistId

        let strFunctionName = "api/add_playlist_recent"
        
        WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
            
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
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
