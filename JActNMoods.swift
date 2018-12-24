//
//  JActNMoods.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 14/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

var mydelegate : JActNMoods!

class JActNMoods: BaseViewController , UITableViewDelegate , UITableViewDataSource {
    
    var tableViewActNMoods : UITableView    =   UITableView()
    var arrayActNMoods     : NSMutableArray =   NSMutableArray()
    var arraySubCatID : NSMutableArray = NSMutableArray()
    var strCatName : String = String()
    var strCatID : Int = Int()
    var buttonPP : UIButton = UIButton()
    var buttonNext : UIButton = UIButton()
    var tagGlobal = 0
    var lblTitleHome : UILabel = UILabel()
    let playerYellow : UIView = UIView()
    var imageViewHome  : UIImageView = UIImageView()
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
            let tableHeight = screenHeight - (statusBarHeight + navBarHeight + 50 + 55)
            
            UIView.animate(withDuration: 0.7, animations: { () -> Void in
                
                self.playerView.frame = CGRect(x: 0, y: screenHeight-55, width: screenWidth, height: 55)
                self.tableViewActNMoods.frame = CGRect(x: 0, y: statusBarHeight + navBarHeight + 20, width: screenWidth, height: tableHeight)
                
                
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
        
        self.setMyView()
        self.setMyTable()
        self.getCategorydata()
        
    }
    
    
    func getCategorydata() {
        let strFunctionName = "api/categories"
        
        WebService.callGetServicewithStringPerameters(StringPerameter: "?pcat_id=\(strCatID)", FunctionName: strFunctionName, succes: { (responseObject, operation) in
            print("responseObject :::: \(responseObject)")
            
            let isOk =  responseObject.object(forKey: "status_code") as! NSNumber
            
            if(isOk == 1){
                
                self.arrayActNMoods.removeAllObjects()
                
                let arrayTemp:NSMutableArray = (responseObject.object(forKey: "categoty_data") as? NSArray)?.mutableCopy() as! NSMutableArray
                
                for data_Dict in arrayTemp {
                    
                    if(data_Dict is NSNull || data_Dict == nil){
                        continue
                    }
                    self.arrayActNMoods.add(data_Dict)
                }
                self.tableViewActNMoods.reloadData()
                
            }else{
                obj_app.getAlert("No Data available")
            }
            
        }) { (error, operation) in
            _  = "Something wrong happning , Please wait for proper response of server";
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
        
        let navBarHeight: CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin = statusBarHeight + navBarHeight
        
        _ = JImage.shareInstance().setStatusBarDarkView(CGRect.init(x: 0, y: 0, width: screenWidth, height: 20), viewController: self)
        _ = JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
        _ = JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: 60, y: 25, width: screenWidth - 120, height: 30), nameOfString: strCatName)
        
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
    }
    
    
    func setMyTable()
    {
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let tableHeight = screenHeight - (statusBarHeight + navBarHeight + 50)
        
        tableViewActNMoods =  UITableView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight + 20, width: screenWidth, height: tableHeight), style: .plain)
        tableViewActNMoods.delegate   =   self
        tableViewActNMoods.dataSource =   self
        tableViewActNMoods.backgroundColor = UIColor.clear
        tableViewActNMoods.separatorInset = UIEdgeInsets.zero
        tableViewActNMoods.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        //tableViewRecent.bounces = false
        tableViewActNMoods.layoutMargins = UIEdgeInsets.zero
        tableViewActNMoods.tableFooterView = UIView(frame: CGRect.zero)
        tableViewActNMoods.separatorColor = UIColor.gray
        tableViewActNMoods.separatorStyle = .singleLine
        if #available(iOS 9.0, *) {
            tableViewActNMoods.cellLayoutMarginsFollowReadableWidth = false
        } else {
            // Fallback on earlier versions
        }
        tableViewActNMoods.tableFooterView = UIView(frame: CGRect.zero)
        tableViewActNMoods.register(JActNMoodsCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableViewActNMoods)
    }
    func homeBtnTapped()  {
        SideView.sharedInstance().vController = self
        SideView.sharedInstance().setSideView()
        SideView.sharedInstance().openView()
    }
    
    func SideViewTapped(_ sender:UIButton)
    {
        SideView.sharedInstance().vController = self
        SideView.sharedInstance().setSideView()
        SideView.sharedInstance().openView()
    }
    
    /// for Table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayActNMoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let strIdentifier : String = "cell"
        
        var cell : JActNMoodsCell?
        
        cell = tableView.dequeueReusableCell(withIdentifier: strIdentifier) as? JActNMoodsCell
        
        if (cell == nil)
        {
            cell = JActNMoodsCell(style:UITableViewCellStyle.subtitle, reuseIdentifier: strIdentifier)
        }
        
                
        cell!.layoutMargins = UIEdgeInsets.zero;
        cell!.preservesSuperviewLayoutMargins = false;

        print((indexPath as NSIndexPath).row)
        
        var cellWidth = screenWidth
        
        let dictInfo : NSDictionary = arrayActNMoods.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        cell!.getInfoDict(dictInfo, tag: (indexPath as NSIndexPath).row, cellHeight: screenHeight * 0.08, cellWidth: tableViewActNMoods.bounds.size.width)
        
      //  cell?.buttonCell.addTarget(self, action: "CellButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell!
    }
    
//    func CellButtonTapped(sender:UIButton)
//    {
//        NSLog("you tapped %d",sender.tag)
//    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dictData = arrayActNMoods.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        
        var SubCatName : String = String()
        var SubCatID : Int = Int()
        SubCatName = dictData.object(forKey: "name") as! String
        SubCatID = dictData.object(forKey: "id") as! Int
        
        var subCatNameUpper : String = String()
        subCatNameUpper = SubCatName.uppercased()
        
        let subCatPlist : SubCatPlaylist = SubCatPlaylist(nibName: "SubCatPlaylist", bundle: nil)
        
        subCatPlist.subCatName = subCatNameUpper
        subCatPlist.subCatID = SubCatID
        subCatPlist.PCatID = strCatID
        
        self.navigationController?.pushViewController(subCatPlist, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight * 0.08
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
