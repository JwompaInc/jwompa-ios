//
//  JSearch.swift
//  JWOMPA
//
//  Created by Reliant Tekk on 06/04/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SDWebImage

class JSearch: BaseViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    // Currently using content
    @IBOutlet var searchTblView: UITableView!
    @IBOutlet var playlistTrackSegController: UISegmentedControl!
    var searchSongTblView: UITableView = UITableView()
    var searchPlayListArray = NSMutableArray()
    var searchSongListArray = NSMutableArray()
    var searchBar:TextField = TextField()
    var searchImage: UIImageView = UIImageView()
    
    var isSearchPlaylist = false
    var isSearchSongs = false
    var isFirstTime = true
    //    var trandSearchTopView:UIView = UIView()
    var searchHLable:UILabel = UILabel()
    
    var noDataLbl:UILabel = UILabel()
    
    var sectionCount = 3
    
    var eq:Equelizer!
    var playerView:PlayerView = PlayerView(frame: CGRect(x: 0, y: screenHeight + 60, width: screenWidth, height: 55))
    
    @IBOutlet weak var recentSearchesTableView:UITableView!
    var recentSearchDatasource:[[String:String]] = []
    var trendingSearchDatasource:[[String:String]] = []
    let searchApisDispatchGroup = DispatchGroup()
    var searchDatasource:[[String:[[String:Any]]]] = [["Recent Searches": []], ["Trending Searches": []]]
    @IBOutlet weak var noResultsFoundLabel:UILabel!
    
    typealias SearchResultsDatasource = [[String:Any]]
    var isFirstSearchDone = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateYellowBar()
    }
    
    
    func animateYellowBar(){
        
        if(AudioPlayerModel.shared.playListSongArray.count > 0) {
            
            if isFirstTime {
                
                isFirstTime = false
                self.playerView.removeFromSuperview()
                self.view.addSubview(self.playerView)
                
                self.playerView.checkTrack()
                
                let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
                let _ = statusBarHeight + navBarHeight
                
                UIView.animate(withDuration: 0.7, animations: { () -> Void in
                    
                    self.playerView.frame = CGRect(x: 0, y: screenHeight-55, width: screenWidth, height: 55)
                    
                    let frame = self.recentSearchesTableView.frame
                    
                    self.recentSearchesTableView.translatesAutoresizingMaskIntoConstraints = true
                    self.searchTblView.translatesAutoresizingMaskIntoConstraints = true
                    
                    self.recentSearchesTableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height - (105))
                    
                    let sframe = self.searchTblView.frame
                    self.searchTblView.frame = CGRect(x: sframe.origin.x, y: sframe.origin.y, width: sframe.size.width, height: sframe.size.height - (105))
                    
                    if self.playlistTrackSegController.selectedSegmentIndex == 0 {
                        self.searchSongTblView.reloadData()
                    }
                    
                    if self.playlistTrackSegController.selectedSegmentIndex == 1 {
                        self.searchSongTblView.reloadData()
                    }
                    
                    let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped))
                    self.playerView.isUserInteractionEnabled = true
                    self.playerView.addGestureRecognizer(tapGestureRecognizer)
                    
                    self.view.layoutIfNeeded()
                })

            }
        } else {
            self.playerView.removeFromSuperview()
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
    
    
    fileprivate func getRecentAndTrendingSearchFromWebService() {
        self.getRecentSearchFromService()
        self.getTrendingSearchFromService()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.recentSearchesTableView.isHidden = true
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin    = statusBarHeight + navBarHeight
        
        _ = JImage.shareInstance().setStatusBarDarkView(CGRect.init(x: 0, y: 0, width: screenWidth, height: 20), viewController: self)
        _ = JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
        
        searchBar.placeholder = ""
        searchBar.frame = CGRect(x: 50, y: 25, width: screenWidth*(85/100) - 70, height: 30)
        searchBar.delegate = self
        searchBar.layer.cornerRadius = 4
        searchBar.font = UIFont.systemFont(ofSize: 13)
        searchBar.clipsToBounds = true
        searchBar.backgroundColor = UIColor(hex: 0xFFFFFF, alpha: 0.4)
        searchBar.returnKeyType = UIReturnKeyType.search
        searchBar.autocorrectionType = UITextAutocorrectionType.no
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        searchBar.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)

        self.view.addSubview(searchBar)
        
        searchImage.frame = CGRect(x: screenWidth*(85/100) - 50, y: 30, width: 20, height: 20)
        searchImage.image = #imageLiteral(resourceName: "Search-1")
        self.view.addSubview(searchImage)
        
        self.setNavBar()
        self.setMyView()
        
        self.searchTblView.register(CellSearch.self, forCellReuseIdentifier: "searchCell")
        
        self.searchTblView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        
        playlistTrackSegController.tintColor = UIColor(red: 253/255.0, green: 217/255.0, blue: 88/255.0, alpha: 1)
        playlistTrackSegController.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Lato-Italic", size: 12.0)!], for: UIControlState.normal)
        playlistTrackSegController.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Lato-Italic", size: 12.0)!], for: UIControlState.selected)
        playlistTrackSegController.selectedSegmentIndex = 0
        playlistTrackSegController.addTarget(self, action: #selector(playListSegContAction(sender:)), for: .valueChanged)
        
        self.playlistTrackSegController.isHidden = true
        self.searchTblView.tableFooterView = UIView()
        
        getRecentAndTrendingSearchFromWebService()
        
        self.searchApisDispatchGroup.notify(queue: .main) {
            self.recentSearchesTableView.isHidden = false
            self.recentSearchesTableView.reloadData()
        }
    }
    
    // MARK: Search api call
    
    @objc func textFieldDidChange(textField: UITextField){
        print("Text changed")
        if (textField.text?.count)! > 2 {
            self.searchPlaylist(keyWord: textField.text!)
        }
        else {
            self.searchSongListArray.removeAllObjects()
            self.searchPlayListArray.removeAllObjects()
            
            self.searchTblView.reloadData()
            self.searchSongTblView.reloadData()
            self.recentSearchesTableView.reloadData()
        }
    }
    
    func searchPlaylist(keyWord: String) {
        let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [searchBar.text!, ""], forKeys: ["keyword" as NSCopying,"update" as NSCopying]);
        perameteres.setValue(false, forKeyPath: "update")
        print("JWOMPA: \(String(describing: perameteres))")
        
        WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: "api/searchsong", withImgName: "", succes: { (responseObject, operation) -> Void in
            
            if(responseObject.object(forKey: "playlists")  != nil){
                
                let dictRsult =  responseObject as NSMutableDictionary;
                let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
                
                if(isOk == true) {
                    
                    self.isFirstSearchDone = true
                    self.searchTblView.isHidden = false
                    self.recentSearchesTableView.isHidden = true
                    self.playlistTrackSegController.isHidden = false
                    self.searchSongListArray.removeAllObjects()
                    self.searchPlayListArray.removeAllObjects()
                    
                    self.searchPlayListArray = NSMutableArray.init(array: dictRsult.object(forKey: "playlists") as! NSArray )
                    self.searchSongListArray = NSMutableArray.init(array: dictRsult.object(forKey: "tracks") as! NSArray )
                    
                    if self.playlistTrackSegController.selectedSegmentIndex == 0 {
                        //  search playlist
                        self.isSearchPlaylist = true
                        self.isSearchSongs = false
                        DispatchQueue.main.async {
                            self.searchTblView.reloadData()
                        }
                        if self.searchPlayListArray.count == 0 {
                            self.noResultsFoundLabel.isHidden = false
                        } else {
                            self.noResultsFoundLabel.isHidden = true
                        }
                    }
                    
                    if self.playlistTrackSegController.selectedSegmentIndex == 1 {
                        // search songs
                        self.isSearchPlaylist = false
                        self.isSearchSongs = true
                        DispatchQueue.main.async {
                            self.searchTblView.reloadData()
                        }
                        
                        if self.searchSongListArray.count == 0 {
                            self.noResultsFoundLabel.isHidden = false
                        } else {
                            self.noResultsFoundLabel.isHidden = true
                        }
                    }
                    
                } else {
                    let message  = responseObject.object(forKey: "message") as! String;
                    self.alertViewFromApp(messageString:message);
                }
            }
        }) { (error, operation) -> Void in
            _  = "Something wrong happning , Please wait for proper response of server"
            // MARK: TEST
            //            self.alertViewFromApp(messageString:message )
        }
    }
    
    
    func getRecentSearchFromService() {
        
        self.searchApisDispatchGroup.enter()
        
        let strFunctionName = "api/recent_search"
        WebService.callGetServicewithStringPerameters(StringPerameter: "", FunctionName: strFunctionName, succes: { [unowned self] (responseData, operation) in
            
            if responseData["status_text"] as! String == "Success" {
                if let recentSearchArray = responseData["recent_search"] as? [[String:String]]{
                    if recentSearchArray.count > 0 {
                        self.searchDatasource[0]["Recent Searches"] = recentSearchArray
                    }
                }
            }
            
            self.searchApisDispatchGroup.leave()
        }) { (error, operation) in
            self.searchApisDispatchGroup.leave()
        }
    }
    
    func getTrendingSearchFromService() {
        
        self.searchApisDispatchGroup.enter()
        
        let strFunctionName = "api/trendy_search"
        WebService.callGetServicewithStringPerameters(StringPerameter: "", FunctionName: strFunctionName, succes: { [unowned self] (responseData, operation) in
            
            if responseData["status_text"] as! String == "Success" {
                if let trendingSearchArray = responseData["trendy_search"] as? SearchResultsDatasource {
                    if trendingSearchArray.count > 0 {
                        self.searchDatasource[1]["Trending Searches"] = trendingSearchArray
                    }
                }
            }
            self.searchApisDispatchGroup.leave()
        }) { (error, operation) in
            self.searchApisDispatchGroup.leave()
            self.alertViewFromApp(messageString: error.localizedDescription)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchSongListArray.removeAllObjects()
        self.searchPlayListArray.removeAllObjects()
        
        self.searchTblView.reloadData()
        self.searchSongTblView.reloadData()
        self.recentSearchesTableView.reloadData()

        if textField.text?.count == 0 {
            self.isSearchSongs = false
            self.isSearchPlaylist = false
        } else {
            self.searchPlaylist(keyWord: textField.text!)
        }
        
        searchBar.resignFirstResponder()
        return true
    }
    
    
    // Back Button
    func BackButtonTapped(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - SetNavBar 
    func setNavBar(){
        self.navigationController?.isNavigationBarHidden=true
        self.automaticallyAdjustsScrollViewInsets=false
    }
    
    // MARK: - View for Yellow header
    func playListSegContAction(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0 {
            //            self.searchTextEnter()
            print("segment controll 0 index")
            self.isSearchPlaylist = true
            self.isSearchSongs = false
            self.searchTblView.reloadData()
            
            if isFirstSearchDone {
                if self.searchPlayListArray.count == 0 {
                    self.noResultsFoundLabel.isHidden = false
                } else {
                    self.noResultsFoundLabel.isHidden = true
                }
            }
            
            
        }
        if sender.selectedSegmentIndex == 1 {
            print("segment controll 1 index")
            //            self.trackSearch()
            self.isSearchPlaylist = false
            self.isSearchSongs = true
            self.searchTblView.reloadData()
            
            if isFirstSearchDone {
                if self.searchSongListArray.count == 0 {
                    self.noResultsFoundLabel.isHidden = false
                } else {
                    self.noResultsFoundLabel.isHidden = true
                }
            }
        }
    }
    
    func setMyView(){
        
        // button cancel
        
        let btncancel                           = UIButton(type: UIButtonType.system) as UIButton
        btncancel.frame                         = CGRect(x: screenWidth*0.82, y: 28, width: screenWidth*0.15, height: 25)
        btncancel.backgroundColor               = UIColor.clear;
        
        btncancel.setTitleColor(UIColor.white, for: UIControlState())
        btncancel.addTarget(self, action: #selector(JSearch.btnCancelTaped(_:)), for:.touchUpInside)
        btncancel.setTitle("Cancel", for: UIControlState())
        
        btncancel.titleLabel!.font              = textFont
        btncancel.setTitleColor(UIColor.black, for: UIControlState())
        
        self.view.addSubview(btncancel)
        
        // upperView
        let btnLeft = screenWidth  * 0.005
        _ =  upperView.bounds.size.height/2 - 12 + statusBarHeight/2
        _ = JImage.shareInstance().setBackButton(CGRect(x: btnLeft, y: 26, width: 25, height: 25))
        buttonBack.addTarget(self, action: #selector(JSearch.BackButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        
        noDataLbl.frame = CGRect(x: 20, y: screenHeight*(20/100), width: screenWidth - 40, height: 50)
        noDataLbl.text = "No Results Found"
        noDataLbl.textColor = UIColor.gray
        noDataLbl.textAlignment = NSTextAlignment.center
        noDataLbl.isHidden = true
        self.view.addSubview(noDataLbl)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.playlistTrackSegController.isHidden {
            self.playlistTrackSegController.isHidden = false
        }
        if !self.recentSearchesTableView.isHidden {
            self.recentSearchesTableView.isHidden = true
        }
    }
    
    
    func setTableView(){
        
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        _    = statusBarHeight + navBarHeight + 50
        
        searchHLable.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 30)
        searchHLable.text = "Search History"
        searchHLable.textColor = UIColor.black
        searchHLable.textAlignment = NSTextAlignment.center
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.recentSearchesTableView {
            return self.searchDatasource.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView == self.recentSearchesTableView {
            return 50
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == self.recentSearchesTableView {
            let titleString = Array(self.searchDatasource[section].keys)[0]
            
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width:tableView.bounds.width, height: 50))
            
            let titleLabel = UILabel.init(frame: headerView.frame)
            titleLabel.textAlignment = .center
            titleLabel.text = titleString
            titleLabel.font = UIFont(name: "OpenSans-SemiBold", size: 26)
            titleLabel.backgroundColor = .white
            
            headerView.addSubview(titleLabel)
            
            return headerView
        }
        
        return nil
    }       
    
    // MARK: Tble View method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.recentSearchesTableView {
            return screenHeight*(6/100)
        } else {
            return screenHeight*(16/100)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.recentSearchesTableView {
            let dicObject = self.searchDatasource[section]
            let key = Array(dicObject.keys)[0]
            return (self.searchDatasource[section][key]?.count)!
        } else {
            if self.playlistTrackSegController.selectedSegmentIndex == 0 {
                return self.searchPlayListArray.count
            }
            if self.playlistTrackSegController.selectedSegmentIndex == 1 {
                return self.searchSongListArray.count
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.recentSearchesTableView {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            
            if cell == nil {
                cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
            }
            
            cell?.textLabel?.textAlignment = .center
            cell?.backgroundColor = .white
            cell?.contentView.backgroundColor = .white
            
            let dicObject = self.searchDatasource[indexPath.section]
            let key = Array(dicObject.keys)[0]
            
            if indexPath.row < (self.searchDatasource[indexPath.section][key]?.count)! {
                cell?.textLabel?.text = self.searchDatasource[indexPath.section][key]?[indexPath.row]["keyword"] as? String
            }
            
            
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! CellSearch
            
            if self.isSearchPlaylist {
                print("Return cell for playlsist table view")
                let playListData:NSDictionary = self.searchPlayListArray.object(at: indexPath.row) as! NSDictionary
                cell.titleText.text = playListData.object(forKey: "title") as? String
               // cell.descText.text = playListData.object(forKey: "description") as? String
                if let imageUrl = playListData.object(forKey: "artwork_url") as? String {
                    cell.imageIcon.sd_setImage(with: URL(string: imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))

                }else{
                    cell.imageIcon.sd_setImage(with: URL(string: "http://ec2-52-91-211-72.compute-1.amazonaws.com/library/album_art/art.png"))
                }
            }
            
            if self.isSearchSongs {
                print("Return cell for playlsist table view")
                let songsData:NSDictionary = self.searchSongListArray.object(at: indexPath.row) as! NSDictionary
                cell.titleText.text = songsData.object(forKey: "label_name") as? String
              //  cell.descText.text = songsData.object(forKey: "note") as? String
                if let imageUrl = songsData.object(forKey: "artwork_url") as? String {
                    cell.imageIcon.sd_setImage(with: URL(string: imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
                    
                }else{
                    cell.imageIcon.sd_setImage(with: URL(string: "http://ec2-52-91-211-72.compute-1.amazonaws.com/library/album_art/art.png"))
                }
            }
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.resignFirstResponder()
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == self.recentSearchesTableView {
            let dicObject = self.searchDatasource[indexPath.section]
            let key = Array(dicObject.keys)[0]
            
            let searchKeyword = self.searchDatasource[indexPath.section][key]?[indexPath.row]["keyword"] as? String
            self.searchBar.text = searchKeyword ?? ""
            
            self.searchSongListArray.removeAllObjects()
            self.searchPlayListArray.removeAllObjects()
            
            self.searchTblView.reloadData()
            self.searchSongTblView.reloadData()
            self.recentSearchesTableView.reloadData()
            
            self.searchPlaylist(keyWord:self.searchBar.text!)
        }
        else {
            AudioPlayerModel.shared.pauseAudio()
            if isSearchSongs {
                if searchSongListArray.count > indexPath.row {
                    let songsData:NSDictionary = searchSongListArray.object(at: indexPath.row) as! NSDictionary
                    
                    let playlistId = songsData.value(forKey: "id") as! Int
                    AudioPlayerModel.shared.currentPlayingAlbumID = playlistId
                    let strTitle :String = songsData.object(forKey: "title") as! String
                    
                    //Update playlist
                    let perameteresupdate: NSMutableDictionary! = NSMutableDictionary(objects: [strTitle, ""], forKeys: ["keyword" as NSCopying,"update" as NSCopying]);
                    perameteresupdate.setValue(true, forKeyPath: "update")
                    print("JWOMPA: \(String(describing: perameteresupdate))")
                    
                    WebService.callPostServicewithDict(dictionaryObject: perameteresupdate, withData: Data(), withFunctionName: "api/searchsong", withImgName: "", succes: { (responseObject, operation) -> Void in
                        print("Song added in recent search list")
                        
                    }) { (error, operation) -> Void in
                        print("Something wrong happning , Please wait for proper response of server")
                    }
                    
                    
                    let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [strUSerID!.intValue,playlistId], forKeys: ["user_id" as NSCopying,"playlist_id" as NSCopying]);
                    let strFunctionName = "api/add_playlist_recent"
                    
                    WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
                        
                        print("responseObject :::: \(responseObject)")
                        
                        let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
                        
                        if(isOk == true){                                                        
                            AudioPlayerModel.shared.MainPlayerVC = JPlayerVC()
                            AudioPlayerModel.shared.MainPlayerVC.playlistIDPlayer = playlistId
                            AudioPlayerModel.shared.MainPlayerVC.comeFrom = "search"
                            AudioPlayerModel.shared.MainPlayerVC.dataFromSearch = songsData
                            AudioPlayerModel.shared.singleSongDic = songsData
                            dictinfo = songsData.mutableCopy() as! NSMutableDictionary
                            AudioPlayerModel.shared.listenSongAPI()
                            self.navigationController?.pushViewController(AudioPlayerModel.shared.MainPlayerVC, animated: true)
                        }
                        
                    }) { (error, operation) -> Void in
                        obj_app.getAlert("Server Error. Please try again!")
                    }
                }
            }
            
            if isSearchPlaylist {
                
                let playlist_data = self.searchPlayListArray.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
                let tracksArray:NSArray = playlist_data.object(forKey: "tracks") as! NSArray
                //let tracksDic: NSDictionary = tracksArray[indexPath.row] as! NSDictionary
                let tracksDic: NSDictionary = tracksArray[indexPath.row] as! NSDictionary
                let track_count = playlist_data.object(forKey: "track_count") as! Int
                
                
                if(track_count > 0){
                    AudioPlayerModel.shared.currentPlayingAlbumID = nil
                    if (playlist_data.object(forKey: "id") as? Int != nil){
                        let playlist_id = playlist_data.object(forKey: "id") as! Int
                        AudioPlayerModel.shared.currentPlayingAlbumID = playlist_id
                        dictinfo = playlist_data.mutableCopy() as! NSMutableDictionary
                        let playlist_Id = playlist_data.object(forKey: "id") as! Int
                        
                        if(AudioPlayerModel.shared.jukebox != nil){
                            if(playlist_Id == AudioPlayerModel.shared.playlistID){
                                obj_app.getAlert("Already playing this station.")
                                return
                            }
                        }
                        
                        
                        let strTitle: String = playlist_data.object(forKey: "title") as! String

                        //Update playlist
                        let perameteresupdate: NSMutableDictionary! = NSMutableDictionary(objects: [strTitle, ""], forKeys: ["keyword" as NSCopying,"update" as NSCopying]);
                        perameteresupdate.setValue(true, forKeyPath: "update")
                        print("JWOMPA: \(String(describing: perameteresupdate))")
                        
                        WebService.callPostServicewithDict(dictionaryObject: perameteresupdate, withData: Data(), withFunctionName: "api/searchsong", withImgName: "", succes: { (responseObject, operation) -> Void in
                            print("Song added in recent search list")
                            
                        }) { (error, operation) -> Void in
                            print("Something wrong happning , Please wait for proper response of server")
                        }
                        
                        UserDefaults.standard.setValue(playlist_Id, forKey: "playlist_id")
                        
                        let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [playlist_Id], forKeys: ["playlist_id" as NSCopying]);
                        let strFunctionName = "api/add_playlist_recent"
                        
                        WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
                            
                            print("responseObject :::: \(responseObject)")
                            
                            let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
                            
                            if(isOk == true){
                                //let message  = responseObject.objectForKey("message") as! String;
                                AudioPlayerModel.shared.MainPlayerVC = JPlayerVC()
                                AudioPlayerModel.shared.MainPlayerVC.playlistIDPlayer = playlist_Id
                                AudioPlayerModel.shared.MainPlayerVC.dataFromSearch = tracksDic
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
    }
    
    
    
    func btnCancelTaped(_ sender : UIButton!) {
        self.playlistTrackSegController.selectedSegmentIndex = 0
        self.noResultsFoundLabel.isHidden = true
        self.isFirstSearchDone = false
        if self.recentSearchesTableView.isHidden {
            getRecentAndTrendingSearchFromWebService()
            self.searchApisDispatchGroup.notify(queue: .main) {
                self.recentSearchesTableView.isHidden = false
                self.recentSearchesTableView.reloadData()
            }
        }
        
        playlistTrackSegController.isHidden = true
        searchBar.text = "" ;
        
        noDataLbl.isHidden = true
        
        searchBar.resignFirstResponder()
        self.recentSearchesTableView.isHidden = false
        
        searchBar.resignFirstResponder()
        
        self.searchSongListArray.removeAllObjects()
        self.searchPlayListArray.removeAllObjects()
        
        if self.playlistTrackSegController.selectedSegmentIndex == 0 {
            self.searchTblView.reloadData()
        }
        
        if self.playlistTrackSegController.selectedSegmentIndex == 1 {
            self.searchTblView.reloadData()
        }
    }
    
    
}
