//
//  SubCatPlaylist.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 18/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SubCatPlaylist: BaseViewController,UITableViewDelegate, UITableViewDataSource {

    var tableViewSubCatPlaylist : UITableView    =   UITableView()
    var arraySubCatPlaylist     : NSMutableArray =   NSMutableArray()
    var arraySubCatPlaylistID     : NSMutableArray =   NSMutableArray()
    var PCatID : Int = Int()
    var subCatID : Int = Int()
    var subCatName : String = String()
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
                self.tableViewSubCatPlaylist.frame = CGRect(x: 0, y: topMargin , width: screenWidth, height: tableHeight)
                
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
        JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
        JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: 60, y: 25, width: screenWidth - 120, height: 30), nameOfString: subCatName)
        JImage.shareInstance().setBackButton(CGRect(x: 15,y: 30,width: 20,height: 20))
        
        buttonBack.addTarget(self, action: #selector(SubCatPlaylist.BackButtonTapped(_:)), for: UIControlEvents.touchUpInside)
    
        
        eq = Equelizer(frame: CGRect(x: screenWidth - 30, y: 20, width: 25, height: 30))
        eq.tapBtn.addTarget(self, action: #selector(self.imageTapped), for: UIControlEvents.touchUpInside)
        upperView.addSubview(eq)
        
        
        
        self.setMyView()
        self.getCategoryData()
    }
    
    
    func getCategoryData() {
    
        var strSubCatID : Int = Int()
        strSubCatID = subCatID
        
        print("subCatID ::: \(subCatID)")
        
        let strFunctionName = "api/category_playlists"
        
        
        WebService.callGetServicewithStringPerameters(StringPerameter: "?pcat_id=\(PCatID)&sub_cat_id=\(strSubCatID)", FunctionName: strFunctionName, succes: { (responseObject, operation) in
            
            let isOk =  responseObject.object(forKey: "status_code") as! NSNumber
            
            if(isOk == 1){
                
                self.arraySubCatPlaylist.removeAllObjects()
                
                let arrayTemp:NSMutableArray = (responseObject.object(forKey: "playlists") as? NSArray)?.mutableCopy() as! NSMutableArray
                
                for data_Dict in arrayTemp {
                    
                    if(data_Dict is NSNull || data_Dict == nil){
                        continue
                    }
                    self.arraySubCatPlaylist.add(data_Dict)
                }
                self.tableViewSubCatPlaylist.reloadData()
                
            }else{
                obj_app.getAlert("No data available")
            }
            
        }) { (error, operation) in
            let message  = "Something wrong happning , Please wait for proper response of server";
            // MARK: TEST
            //            self.alertViewFromApp(messageString:message );
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
    
    
    
    
    
    
    // Set Nav Bar
    func setNavBar(){
        self.navigationController?.isNavigationBarHidden=true
        self.automaticallyAdjustsScrollViewInsets=false
    }
    
    
    
    
    func setMyView(){
        
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin    = statusBarHeight + navBarHeight
        
        let tableHeight = screenHeight - (topMargin + 50)
        
        
        tableViewSubCatPlaylist =  UITableView(frame: CGRect(x: 0, y: topMargin, width: screenWidth, height: tableHeight), style: .plain)
        tableViewSubCatPlaylist.delegate   =   self
        tableViewSubCatPlaylist.dataSource =   self
        tableViewSubCatPlaylist.backgroundColor = UIColor.clear
        tableViewSubCatPlaylist.separatorInset = UIEdgeInsets.zero
        tableViewSubCatPlaylist.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        //tableViewRecent.bounces = false
        tableViewSubCatPlaylist.layoutMargins = UIEdgeInsets.zero
        tableViewSubCatPlaylist.tableFooterView = UIView(frame: CGRect.zero)
        tableViewSubCatPlaylist.separatorColor = UIColor.gray
        tableViewSubCatPlaylist.separatorStyle = .singleLine
        if #available(iOS 9.0, *) {
            tableViewSubCatPlaylist.cellLayoutMarginsFollowReadableWidth = false
        } else {
            // Fallback on earlier versions
        }
        tableViewSubCatPlaylist.tableFooterView = UIView(frame: CGRect.zero)
        tableViewSubCatPlaylist.register(UINib.init(nibName: "JSubCatPlaylistCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.view.addSubview(tableViewSubCatPlaylist)
    
    }
    
    func BackButtonTapped(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
//
//    func SideViewTapped(sender:UIButton)
//    {
//        SideDrawer.sharedInstance().deleteObject();
//        SideDrawer.sharedInstance().vcController = self;
//        SideDrawer.sharedInstance().setView();
//        SideDrawer.sharedInstance().openView();
//    }
    
    
    /// for Table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arraySubCatPlaylist.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : JSubCatPlaylistCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! JSubCatPlaylistCell
        if (cell == nil){
            cell = JSubCatPlaylistCell(style:UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        }
        
        let dictInfo : NSDictionary = arraySubCatPlaylist.object(at: indexPath.row) as! NSDictionary
        let titleStr:String = dictInfo.object(forKey: "name") as! String
        
        cell.lblName.text = titleStr
        
        
        var playlist_avatar:String = (dictInfo.object(forKey: "cover_img_link") == nil || dictInfo.object(forKey: "cover_img_link") is NSNull) ? "http://ec2-52-91-211-72.compute-1.amazonaws.com/library/album_art/art.png" : dictInfo.object(forKey: "cover_img_link") as! String
        if(playlist_avatar == ""){
            playlist_avatar = (dictInfo.object(forKey: "artwork_url") == nil || dictInfo.object(forKey: "artwork_url") is NSNull) ? "http://ec2-52-91-211-72.compute-1.amazonaws.com/library/album_art/art.png" : dictInfo.object(forKey: "artwork_url") as! String
            
        }
        
        playlist_avatar = playlist_avatar.replacingOccurrences(of: "-large.", with: "-t500x500.")
        
        
        ImageLoader.sharedLoader.imageForUrl(playlist_avatar, completionHandler:{(image: UIImage?, url: String) in
            cell.imageViewSubCat.image = UIImage(named: "")
            if(image != nil){
                cell.imageViewSubCat.image = image
            }
        })
        
        
        
        if (dictInfo.object(forKey: "description") == nil) {
            cell.lblDescr.text = "No Description is Available"
        }else{
            cell.lblDescr.text = dictInfo.object(forKey: "description") as? String
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dictData = self.arraySubCatPlaylist.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        let playlistId = dictData.object(forKey: "id") as! Int
        
        let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [strUSerID!.intValue,playlistId], forKeys: ["user_id" as NSCopying,"playlist_id" as NSCopying]);
        let strFunctionName = "api/add_playlist_recent"
        
        WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
            
            let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
            
            if(isOk == true){
                AudioPlayerModel.shared.MainPlayerVC = JPlayerVC()
                AudioPlayerModel.shared.MainPlayerVC.playlistIDPlayer = playlistId
                AudioPlayerModel.shared.currentPlayingAlbumID = playlistId
                AudioPlayerModel.shared.listenSongAPI()
                self.navigationController?.pushViewController(AudioPlayerModel.shared.MainPlayerVC, animated: true)
            }
            
            }) { (error, operation) -> Void in
                
                obj_app.getAlert("Server Error. Please try again!")
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

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


