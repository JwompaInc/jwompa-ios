//
//  SideDrawer.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 03/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

var side_View: SideView!

class SideView: UIView,UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var sideMenuTable:STCollapseTableView = STCollapseTableView()
    var sideMenuArray:NSMutableArray = ["SPLASHBOARD","RECENTS","FAVORITES","BROWSE","PROFILE","SETTINGS"]
    var imageArray:NSMutableArray  = ["splsh","Recent","Fav","Browse","Account","Setting"]
    var tempSubCat = ["GENRES", "ACTIVITES & MOODS", "FEATURED"] // Remove this array once we get value from service.
    
    var logoImage:UIImageView = UIImageView()
    var searchBtn:UIButton = UIButton()
    var usernameLbl = UILabel()
    
    var addressLbl = UIButton()
    
    var screenW:CGFloat = 0.0
    var screenH:CGFloat = 0.0
    
    weak var vController:UIViewController!
    var subCatArray:NSMutableArray = NSMutableArray()
    
    
    class func  sharedInstance()-> SideView {
        if (side_View == nil){
            side_View =  SideView();
            
            side_View.frame = CGRect(x: -screenWidth, y: 0, width: screenWidth,height: screenHeight);
            side_View.backgroundColor = UIColor.clear
            
            side_View.setSideView()
        }
        
        if(side_View.subCatArray.count == 0){
            side_View.getSubcatArray()
        }
        
        return side_View!;
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: sideMenuTable))! {
            return false
        }
        return true
    }
    
    func setSideView(){
        
        screenW = screenWidth*(80/100)
        screenH = screenHeight
        
        self.sideMenuTable.register(SubCatCell.self, forCellReuseIdentifier: "CellId")
        self.sideMenuTable.clipsToBounds = true
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeLeft(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.left
        self.addGestureRecognizer(swipeDown)
        
        let  viewLeft:UIView =  UIView();
        viewLeft.frame = CGRect(x: 0,y: 0,width: screenWidth * 0.80,height: screenHeight);
        viewLeft.clipsToBounds = true
        viewLeft.layer.masksToBounds = true
        viewLeft.backgroundColor = UIColor(hex: 0x409b92, alpha: 1)
        side_View!.addSubview(viewLeft);
        
        let  viewRight:UIView =  UIView()
        viewRight.frame = CGRect(x: screenWidth * 0.10,y: 0,width: screenWidth * 0.15,height: screenHeight);
        side_View!.addSubview(viewRight);
        
        UIApplication.shared.keyWindow?.addSubview(side_View);
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapPerformed(_:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        logoImage.frame = CGRect(x : screenH*(12.5/100), y : screenH*(3.2/100) + 20, width : screenW - screenH*(23/100), height : screenH*(4/100))
        logoImage.image = UIImage(named:"newsidemenu") //JWOMPA-1
        logoImage.clipsToBounds = true
        logoImage.contentMode = UIViewContentMode.scaleAspectFill
        viewLeft.addSubview(logoImage)
        
        searchBtn.frame = CGRect(x: screenW - screenH*(8/100),y: screenH*(3/100) + 20,width: screenH*(4/100),height: screenH*(4/100))
        searchBtn.backgroundColor = UIColor.clear
        searchBtn.setImage(UIImage(named: "Search"), for: UIControlState())
        searchBtn.addTarget(self, action: #selector(self.btnSearchTaped(_:)), for:.touchUpInside)
        viewLeft.addSubview(searchBtn)
        
        usernameLbl.frame = CGRect(x: 50, y: screenH*(12/100) + 20, width: screenW*(90/100), height: screenH*(3.5/100))
        usernameLbl.textColor = UIColor.white
        usernameLbl.backgroundColor = UIColor.clear
        usernameLbl.textAlignment = .left
        usernameLbl.numberOfLines = 0
        viewLeft.addSubview(usernameLbl)
        
        
        var str : String = String()
        if loginType == .Facebook {
            let name = (userDefault.value(forKey: "USER_NAME_FB") as? String)!
            let nameValue = name.split(separator: " ")
            let firstName = nameValue[0]
            let na = String(firstName)
            str = na
        } else if loginType == .Google {
            str = (userDefault.value(forKey: "USER_NAME_Google") as? String)!
        } else {
            str = (userDefault.value(forKey: "USER_NAME") as? String)!
        }
        
        
        let myString: String = (str + "!")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        let myMutableString = NSMutableAttributedString(string: myString as String,attributes: [NSParagraphStyleAttributeName: paragraphStyle,
                                                                                                NSBaselineOffsetAttributeName: NSNumber(value: 0)])
        
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato", size: screenHeight*(2.2/100))!, range: NSRange(location:0,length:myString.count))
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor(hex: 0xFFFFFF,alpha: 1), range: NSRange(location:0 , length:myString.count))
        
        
        let hiMutableString = NSMutableAttributedString(string: "Hello " as String,attributes: [NSParagraphStyleAttributeName: paragraphStyle,
                                                                                                NSBaselineOffsetAttributeName: NSNumber(value: 0)])
        hiMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato", size: screenHeight*(2.2/100))!, range: NSRange(location:0,length:5))
        hiMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor(hex: 0xFFFFFF,alpha: 0.9), range: NSRange(location:0,length:5))
        
        hiMutableString.append(myMutableString)
        
        usernameLbl.attributedText = hiMutableString
        
        var locationHeight:CGFloat = 0
        
        let userCountry = userDefault.value(forKey: "country") == nil ? "" : userDefault.value(forKey: "country") as! String
        
        
        let emojiLabel: UILabel = UILabel()
        emojiLabel.frame = CGRect(x: 47, y: usernameLbl.frame.origin.y + usernameLbl.frame.size.height + screenH*(1/100), width: 25, height: screenH*(1.8/100))
        emojiLabel.backgroundColor = UIColor.clear
        emojiLabel.text = ""
        emojiLabel.textAlignment = .center
        emojiLabel.textColor = .white
        emojiLabel.tag = 567
        viewLeft.addSubview(emojiLabel)
        
        print(usernameLbl.frame.origin.y)
        print(usernameLbl.frame.size.height)
        print(screenH)
        print(usernameLbl.frame.origin.y + usernameLbl.frame.size.height + screenH*(0.24/100))
        addressLbl.frame =  CGRect(x: emojiLabel.frame.size.width + 45.0,y: usernameLbl.frame.origin.y - 3 + usernameLbl.frame.size.height + screenH*(0.238/100),width: screenW*(90/100) - screenH*(6/100),height: screenH*(4/100))
        addressLbl.addTarget(self, action: #selector(SideView.addressLblButtonTouched(_:)), for: .touchUpInside)
        addressLbl.titleLabel?.textColor = UIColor.white
        addressLbl.titleLabel?.font = UIFont.init(name: "Lato-Italic", size: screenHeight*(1.9/100)) // .systemFont(ofSize: screenHeight*(1.9/100))
        addressLbl.setTitle(userCountry, for: .normal) // User Country
        addressLbl.backgroundColor = UIColor.clear
        addressLbl.contentHorizontalAlignment = .left
        addressLbl.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        addressLbl.titleLabel?.numberOfLines = 0
        viewLeft.addSubview(addressLbl)
        
        
        //Load countries json from our main bundle and load respective country icon of user.
        if userCountry != "" {
            let filepath = Bundle.main.path(forResource: "countrydata", ofType: "json")
            if let fp = filepath {
                do {
                    let data = try Data.init(contentsOf: URL.init(fileURLWithPath:fp))
                    let jsonObject = try [JSONSerialization.jsonObject(with: data, options: .mutableContainers)]
                    let phoneCodeArray = (jsonObject as NSArray).firstObject as! [CountryDictionary]
                    
                    let array = phoneCodeArray.filter { $0["name"] == userCountry }
                    if array.count > 0 {
                        emojiLabel.text = array[0]["emoji"]
                    } else {
                        // Do what's needed
                    }
                } catch {
                    print("Error caught while loading countries json from bundle :::::: \(error.localizedDescription)")
                }
            }
            addressLbl.setTitle(userCountry, for: .normal) //User Country
        } else {
            addressLbl.setTitle("Add Country", for: .normal) //User Country
        }
        
        
        locationHeight = screenH*(5/100)
        let tableHeight = screenH*(80/100) - locationHeight
        let tableTop = screenH*(20/100) + locationHeight
        
        sideMenuTable.frame = CGRect(x:0,y:tableTop, width:screenW, height:tableHeight)
        sideMenuTable.delegate = self
        sideMenuTable.dataSource = self
        sideMenuTable.separatorStyle = UITableViewCellSeparatorStyle.none
        sideMenuTable.backgroundColor = UIColor.clear
        self.addSubview(sideMenuTable)
        
    }
    
    func addressLblButtonTouched(_ sender: UIButton) {
        SideView.sharedInstance().closeView()
        let jAccountVC = JAccountVC()
        jAccountVC.isFromAddLocation = sender.titleLabel?.text == "Add Country"
        vController.navigationController?.pushViewController(jAccountVC, animated: true)
    }
    
    func getSubcatArray() {
        
        let perameteres:NSMutableDictionary! = ["":""]
        let strFunctionName = "api/parent_categories"
        
        WebService.callGetServicewithStringPerameters(StringPerameter: "", FunctionName: strFunctionName, succes: { (responseObject, operation) in
            self.subCatArray = (responseObject.object(forKey: "categoty_data") as? NSArray)?.mutableCopy() as! NSMutableArray
            self.sideMenuTable.reloadData()
        }) { (error, operation) in
            
        }
    }
    
    
    func btnSearchTaped(_ sender : UIButton!){
        vController.navigationController?.pushViewController(JSearch(), animated: true);
        self.closeView()
    }
    
    func closeView(){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            side_View.frame = CGRect(x: -screenWidth  ,y: 0,width: screenWidth,height: screenHeight);
        })
        
        if self.sideMenuTable.isOpenSection(UInt(3)) {
            self.sideMenuTable.closeSection(3, animated: true)
        }
    }
    
    func openView(){
        if self.tempSubCat.count == 0 {
            self.tempSubCat = ["GENRES", "ACTIVITIES & MOODS", "FEATURES"]
        }
        sideMenuTable.reloadData()
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            side_View.frame = CGRect(x: 0  ,y: 0,width: screenWidth,height: screenHeight)
        })
    }
    
    func tapPerformed(_ gesture :UITapGestureRecognizer){
        self.closeView()
    }
    
    func respondToSwipeLeft(_ gesture : UIGestureRecognizer){
        SideView.sharedInstance().closeView();
    }
    
    func hideKeyBoard(_ sender:UITapGestureRecognizer){
        SideView.sharedInstance().closeView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sideMenuArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 3){
            if self.subCatArray.count > 0 {
                return self.subCatArray.count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight*(8/100)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return screenHeight*(8/100)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let tempLabelForSize = UILabel()
        tempLabelForSize.text = sideMenuArray.object(at: section) as? String
        let width = tempLabelForSize.intrinsicContentSize.width
        
        if section == 3 {
            let menuHeader = UITableViewHeaderFooterView()
            menuHeader.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH*(8/100))
            
            let customView = UIView.init(frame: menuHeader.frame)
            customView.backgroundColor = .clear
            menuHeader.backgroundView = customView
            
            let imgMenu:UIImage = UIImage(named: imageArray.object(at: section) as! String)!
            let menuName:String = sideMenuArray.object(at: section) as! String
            
            let imgIcon:UIImageView = UIImageView()
            imgIcon.frame = CGRect(x: screenW*(5/100), y: screenH*(2/100), width: screenH*(4/100), height: screenH*(4/100))
            imgIcon.image = imgMenu
            menuHeader.addSubview(imgIcon)
            
            let nameMenuLbl:FontStretchView = FontStretchView()
            
            if DeviceType.IS_IPHONE_SE {
                nameMenuLbl.frame = CGRect(x: screenW*(10/100) + screenH*(4/100), y: 0, width: width + 30, height: screenH*(8.0/100))
            } else if DeviceType.IS_IPHONE_7 {
                nameMenuLbl.frame = CGRect(x: screenW*(10/100) + screenH*(4/100), y: 0, width: width + 30, height: screenH*(7.5/100))
            } else if DeviceType.IS_IPHONE_7PLUS {
                nameMenuLbl.frame = CGRect(x: screenW*(10/100) + screenH*(4/100), y: 0, width: width + 30, height: screenH*(7.0/100))
            } else if DeviceType.IS_IPHONE_X {
                nameMenuLbl.frame = CGRect(x: screenW*(10/100) + screenH*(4/100), y: 0, width: width + 30, height: screenH*(6.5/100))
            }
            
            nameMenuLbl.text = menuName
            nameMenuLbl.backgroundColor = .clear
            menuHeader.addSubview(nameMenuLbl)
            
            let btn:UIButton = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH*(8/100))
            btn.tag = section
            btn.addTarget(self, action: #selector(self.btnClicked(sender:)), for: UIControlEvents.touchUpInside)
            menuHeader.addSubview(btn)
            
            let line:CALayer = CALayer()
            line.frame = CGRect(x: 0, y: 0, width: screenW, height: 1.0)
            line.backgroundColor = UIColor(hex: 0x30b5a8, alpha: 1).cgColor
            menuHeader.layer.addSublayer(line)
            
            return menuHeader
        } else {
            let menuHeader = UITableViewHeaderFooterView()
            menuHeader.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH*(8/100))
            
            let customView = UIView.init(frame: menuHeader.frame)
            customView.backgroundColor = .clear
            menuHeader.backgroundView = customView
            
            let imgMenu:UIImage = UIImage(named: imageArray.object(at: section) as! String)!
            let menuName:String = sideMenuArray.object(at: section) as! String
            
            let imgIcon:UIImageView = UIImageView()
            imgIcon.frame = CGRect(x: screenW*(5/100), y: screenH*(2/100), width: screenH*(4/100), height: screenH*(4/100))
            imgIcon.image = imgMenu
            menuHeader.addSubview(imgIcon)
            
            let nameMenuLbl:FontStretchView = FontStretchView()
            
            if DeviceType.IS_IPHONE_SE {
                nameMenuLbl.frame = CGRect(x: screenW*(10/100) + screenH*(4/100), y: 0, width: width + 30, height: screenH*(8.0/100))
            } else if DeviceType.IS_IPHONE_7 {
                nameMenuLbl.frame = CGRect(x: screenW*(10/100) + screenH*(4/100), y: 0, width: width + 30, height: screenH*(7.5/100))
            } else if DeviceType.IS_IPHONE_7PLUS {
                nameMenuLbl.frame = CGRect(x: screenW*(10/100) + screenH*(4/100), y: 0, width: width + 30, height: screenH*(7.0/100))
            } else if DeviceType.IS_IPHONE_X {
                nameMenuLbl.frame = CGRect(x: screenW*(10/100) + screenH*(4/100), y: 0, width: width + 30, height: screenH*(6.5/100))
            }
            
            nameMenuLbl.backgroundColor = .clear
            nameMenuLbl.text = menuName
            menuHeader.addSubview(nameMenuLbl)
            
            let btn:UIButton = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH*(8/100))
            btn.tag = section
            btn.addTarget(self, action: #selector(self.btnClicked(sender:)), for: UIControlEvents.touchUpInside)
            menuHeader.addSubview(btn)
            
            let line:CALayer = CALayer()
            line.frame = CGRect(x: 0, y: 0, width: screenW, height: 1.0)
            line.backgroundColor = UIColor(hex: 0x30b5a8, alpha: 1).cgColor
            menuHeader.layer.addSublayer(line)
            
            return menuHeader
        }
    }
    
    func btnClicked(sender:UIButton){            
        
        let tagVal:Int = sender.tag
        
        switch tagVal
        {
        case (0):
            var hasVC = false
            weak var homeVC: UIViewController? = nil
            for vc in (vController.navigationController?.viewControllers)! {
                if vc.isKind(of: JHomeVC.self) {
                    hasVC = true
                    homeVC = vc
                    break
                }
            }
            
            if hasVC {
                vController.navigationController?.popToViewController(homeVC!, animated: true)
            } else {
                let obj_Home = JHomeVC(nibName: "JHomeVC", bundle: nil)
                vController.navigationController?.pushViewController(obj_Home, animated: true)
            }
            
            self.sideMenuTable.reloadData()
            self.closeView()
            break
        case (1):
            let obj_Recent = JRecentVC(nibName: "JRecentVC", bundle: nil)
            vController.navigationController?.pushViewController(obj_Recent, animated: true)
            self.sideMenuTable.reloadData()
            self.closeView()
            break
        case (2):
            let obj_Fav = JFavVC(nibName: "JFavVC", bundle: nil)
            vController.navigationController?.pushViewController(obj_Fav, animated: true)
            self.sideMenuTable.reloadData()
            self.closeView()
            break
        case (3):
            if self.sideMenuTable.isOpenSection(UInt(tagVal)) {
                self.sideMenuTable.closeSection(UInt(tagVal), animated: true)
                self.sideMenuTable.headerView(forSection: tagVal)?.backgroundView?.backgroundColor = .clear
            } else {
                self.sideMenuTable.openSection(UInt(tagVal), animated: true)
                self.sideMenuTable.headerView(forSection: tagVal)?.backgroundView?.backgroundColor = UIColor(hex: 0x107068, alpha: 1)
            }
            break
        case (4):
            let obj_Account = JAccountVC()
            vController.navigationController?.pushViewController(obj_Account, animated: true)
            self.sideMenuTable.reloadData()
            self.closeView()
            break
        case (5):
            let obj_Setting = JSettingsVC(nibName: "JSettingsVC", bundle: nil)
            vController.navigationController?.pushViewController(obj_Setting, animated: true)
            self.sideMenuTable.reloadData()
            self.closeView()
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = SubCatCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CellId")
        
        if(indexPath.section == 3){
            if(subCatArray.count > 0){
                // MARK: Don't delete
                let dataDict:NSDictionary = subCatArray.object(at: indexPath.row) as! NSDictionary
                if let catName:String = dataDict.object(forKey: "pcat_name") as? String{
                    cell.cellTitle.text = catName.uppercased()
                }
                
                for layer in cell.layer.sublayers! {
                    if layer.value(forKey: "layertag") as? Int == 1123 {
                        layer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 1.0)
                        layer.backgroundColor = UIColor.init(hex: 0x409b92, alpha: 1.0).cgColor
                    }
                }
            }
        } else {
            for layer in cell.layer.sublayers! {
                if layer.value(forKey: "layertag") as? Int == 1123 {
                    layer.frame = CGRect(x: 0, y: 0, width: screenWidth, height:1.5)
                    layer.backgroundColor = UIColor.init(hex: 0x1abaae, alpha: 1.0).cgColor
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("**********didSelectRow called**********")
        self.closeView()
        if self.sideMenuTable.isOpenSection(UInt(indexPath.section)) {
            self.sideMenuTable.closeSection(UInt(indexPath.section), animated: true)
        }
        
        // MARK: Don't delete
        if(indexPath.section == 3){
            if(subCatArray.count > 0){
                let dataDict:NSDictionary = subCatArray.object(at: indexPath.row) as! NSDictionary
                let catName:String = dataDict.object(forKey: "pcat_name") as! String
                let c_id = dataDict.object(forKey: "id") as! Int
                
                let CatNameUpper : String = catName.uppercased()
                
                
                if(c_id == 65){
                    let subCatPlist : SubCatPlaylist = SubCatPlaylist(nibName: "SubCatPlaylist", bundle: nil)
                    
                    subCatPlist.subCatName = CatNameUpper
                    subCatPlist.subCatID = c_id
                    
                    vController!.navigationController?.pushViewController(subCatPlist, animated: true)
                }else{
                    let obj_Cat = JActNMoods(nibName: "JActNMoods", bundle: nil)
                    
                    obj_Cat.strCatName = CatNameUpper
                    obj_Cat.strCatID = c_id
                    
                    vController!.navigationController?.pushViewController(obj_Cat, animated: true)
                }
            }
        }
    }
}

