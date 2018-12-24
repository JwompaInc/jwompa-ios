//
//  JGenreVC.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 14/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class JGenreVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableViewGenre : UITableView    =   UITableView()
    var arrayGenre     : NSMutableArray =   NSMutableArray()

    var eq:Equelizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavBar()
        JImage.shareInstance().destroy()
        self.view.backgroundColor = UIColor(red: 254/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        self.setMyView()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        _ = JImage.shareInstance().setStatusBarDarkView(CGRect.init(x: 0, y: 0, width: screenWidth, height: 20), viewController: self)
        _ = JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
        _ = JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: 60, y: 25, width: screenWidth - 120, height: 30), nameOfString: "FAVI")
        
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
        
        tableViewGenre =  UITableView(frame: CGRect(x: 0, y: topMargin , width: screenWidth, height: tableHeight), style: .plain)
        tableViewGenre.delegate   =   self
        tableViewGenre.dataSource =   self
        tableViewGenre.allowsSelection = true
        tableViewGenre.backgroundColor = UIColor.white
        tableViewGenre.separatorInset = UIEdgeInsets.zero
        tableViewGenre.separatorColor = UIColor.clear
        tableViewGenre.separatorStyle = .none
        tableViewGenre.register(JGenreCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableViewGenre)
        
        
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
    
    
    /// for Table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayGenre.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let strIdentifier : String = "cell"
        
        var cell : JGenreCell?
        cell = tableView.dequeueReusableCell(withIdentifier: strIdentifier) as? JGenreCell
        
        if (cell == nil){
            cell = JGenreCell(style:UITableViewCellStyle.subtitle, reuseIdentifier: strIdentifier)
        }
        
        let dictInfo : NSDictionary = arrayGenre.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        cell!.getInfoDict(dictInfo, tag: (indexPath as NSIndexPath).row, cellHeight: screenHeight * 0.10, cellWidth: tableViewGenre.bounds.size.width)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\((indexPath as NSIndexPath).row)!")
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight * 0.10
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
