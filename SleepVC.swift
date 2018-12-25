//
//  SleepVC.swift
//  JWOMPA
//
//  Created by Umesh palshikar on 3/28/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class SleepVC: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    var tblView:UITableView!
    var arrTime:NSMutableArray!
    var selected_Index:Int!
    
    var eq:Equelizer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tblView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "sleepTimerTicking"), object: nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBar()
        
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin    = statusBarHeight + navBarHeight
        
        JImage.shareInstance().setUpperView(CGRect(x: 0, y: 0, width: screenWidth, height: topMargin), viewController: self)
        JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: 60, y: 25, width: screenWidth - 120, height: 30), nameOfString: "SLEEP TIMER")
        
        
        JImage.shareInstance().setBackButton(CGRect(x: 15, y: 30, width: 20, height: 20))
        buttonBack.addTarget(self, action: #selector(SleepVC.BackButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        arrTime = NSMutableArray(objects: "30 MINS","45 MINS","60 MINS","120 MINS")
        
        
        let tableHeight = screenHeight - (topMargin + 50)
        
        tblView = UITableView(frame: CGRect(x: 0, y: topMargin , width: screenWidth, height: tableHeight), style: .plain);
        tblView.isScrollEnabled = false
        tblView.dataSource = self
        tblView.delegate   = self;
        tblView.separatorColor = UIColor.lightGray
        tblView.sectionIndexBackgroundColor = UIColor.lightGray
        tblView.allowsSelection = true
        
        //assigning the data source of the table view
        
        tblView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tblView)
        
        
        
        eq = Equelizer(frame: CGRect(x: screenWidth - 30, y: 20, width: 25, height: 30))
        eq.tapBtn.addTarget(self, action: #selector(self.imageTapped), for: UIControlEvents.touchUpInside)
        upperView.addSubview(eq)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(JHomeVC.imageTapped))
        eq.isUserInteractionEnabled = true
        eq.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(sleepTimerTicking(notification:)), name: NSNotification.Name(rawValue: "sleepTimerTicking"), object: nil)
        
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
    
    
    func setNavBar()
    {
        self.navigationController?.isNavigationBarHidden=true
        self.automaticallyAdjustsScrollViewInsets=false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Tableview Delegate.......
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.frame.size.height = CGFloat(arrTime.count) * screenHeight*0.10
        
        return arrTime.count
    }
    
    
    func BackButtonTapped(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell :UITableViewCell  = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        
        if self.selected_Index != nil {
            if indexPath.row == self.selected_Index {
                if SleepTimer.shared.sleepDuration != 0.0 {
                    cell.textLabel?.text = "\(arrTime[indexPath.row]) \(self.getTimeRemainingForSeconds(SleepTimer.shared.sleepDuration))"
                } else {
                    cell.textLabel?.text = arrTime.object(at: (indexPath as NSIndexPath).row) as? String
                }
            } else {
                cell.textLabel?.text = arrTime.object(at: (indexPath as NSIndexPath).row) as? String
            }
        } else {
            cell.textLabel?.text = arrTime.object(at: (indexPath as NSIndexPath).row) as? String
        }
        
        cell.backgroundColor = UIColor.white
        
        var index_path:IndexPath!
        
        if(SleepTimer.shared.isSleepEnable){
            
            switch SleepTimer.shared.originalSleepDuration {
                
            case 30:
                index_path = IndexPath(row: 0, section: 0)
                
                break
            case 45:
                index_path = IndexPath(row: 1, section: 0)
                
                break
            case 60:
                index_path = IndexPath(row: 2, section: 0)
                
                break
            case 120:
                index_path = IndexPath(row: 3, section: 0)
                
                break
            default:
                break
            }
            
        }
        
        if(index_path != nil){
            if(index_path == indexPath){
                cell.accessoryView = UIImageView(image: UIImage(named: "right"))
                cell.accessoryView?.frame = CGRect(x:0, y:0, width:20, height:20)
            }else{
                cell.accessoryView = UIImageView()
                cell.accessoryView?.frame = CGRect(x:0, y:0, width:20, height:20)
            }
        }else{
            cell.accessoryView = UIImageView()
            cell.accessoryView?.frame = CGRect(x:0, y:0, width:20, height:20)
        }
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.showSleepAlert(indexPath: indexPath)
        
        print("index selected")
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight*0.10
    }
    
    
    func showSleepAlert(indexPath:IndexPath){
        
        var titleString:String = ""
        if(self.selected_Index != nil && (indexPath as NSIndexPath).row == self.selected_Index){
            titleString = "Do you want to remove sleep timer ?"
        }else{
            titleString = "Do you want to set sleep timer ?"
        }
        
        
        
        let alertController = UIAlertController(title: nil, message: titleString, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            let cellSleep = self.tblView.cellForRow(at: indexPath)
            
            for i in 0...3{
                let row:Int = i
                
                let index_path:IndexPath = IndexPath(row: row, section: 0)
                let cell_temp = self.tblView.cellForRow(at: index_path)
                
                cell_temp?.accessoryView = UIImageView()
                cell_temp?.accessoryView?.frame = CGRect(x:0, y:0, width:20, height:20)
            }
            
            
            
            
            if((indexPath as NSIndexPath).row == 0){
                
                if(self.selected_Index != nil && (indexPath as NSIndexPath).row == self.selected_Index){
                    SleepTimer.shared.invalidTimer()
                    self.selected_Index = nil
                    SleepTimer.shared.sleepDuration = 0.0
                    
                }else{
                    self.selected_Index = (indexPath as NSIndexPath).row
                    SleepTimer.shared.invalidTimer()
                    SleepTimer.shared.setTimer(timeDuration: 30)
                    
                    cellSleep?.accessoryView = UIImageView(image: UIImage(named: "right"))
                    cellSleep?.accessoryView?.frame = CGRect(x:0, y:0, width:20, height:20)
                }
                
            }else if((indexPath as NSIndexPath).row == 1){
                
                if(self.selected_Index != nil && (indexPath as NSIndexPath).row == self.selected_Index){
                    SleepTimer.shared.invalidTimer()
                    self.selected_Index = nil
                    SleepTimer.shared.sleepDuration = 0.0
                    
                }else{
                    self.selected_Index = (indexPath as NSIndexPath).row
                    SleepTimer.shared.invalidTimer()
                    SleepTimer.shared.setTimer(timeDuration: 45)
                    
                    cellSleep?.accessoryView = UIImageView(image: UIImage(named: "right"))
                    cellSleep?.accessoryView?.frame = CGRect(x:0, y:0, width:20, height:20)
                }
                
            }else if((indexPath as NSIndexPath).row == 2){
                
                if(self.selected_Index != nil && (indexPath as NSIndexPath).row == self.selected_Index){
                    SleepTimer.shared.invalidTimer()
                    self.selected_Index = nil
                    SleepTimer.shared.sleepDuration = 0.0
                }else{
                    self.selected_Index = (indexPath as NSIndexPath).row
                    SleepTimer.shared.invalidTimer()
                    SleepTimer.shared.setTimer(timeDuration: 60)
                    
                    cellSleep?.accessoryView = UIImageView(image: UIImage(named: "right"))
                    cellSleep?.accessoryView?.frame = CGRect(x:0, y:0, width:20, height:20)
                }
                
            }else if((indexPath as NSIndexPath).row == 3){
                
                if(self.selected_Index != nil && (indexPath as NSIndexPath).row == self.selected_Index){
                    SleepTimer.shared.invalidTimer()
                    self.selected_Index = nil
                    SleepTimer.shared.sleepDuration = 0.0
                }else{
                    self.selected_Index = (indexPath as NSIndexPath).row
                    SleepTimer.shared.invalidTimer()
                    SleepTimer.shared.setTimer(timeDuration: 120)
                    
                    cellSleep?.accessoryView = UIImageView(image: UIImage(named: "right"))
                    cellSleep?.accessoryView?.frame = CGRect(x:0, y:0, width:20, height:20)
                }
            }
            
            UserDefaults.standard.set(self.selected_Index, forKey: "SleepTimerSelectedIndex")
            self.tblView.reloadData()
            
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            
        }
        
    }
    
    
    func sleepTimerTicking(notification: Notification) {
        if let dic = notification.userInfo {
            if let seconds = dic["seconds"] as? Float {
                DispatchQueue.main.async {
                    let indexFromUserDefaults = UserDefaults.standard.integer(forKey: "SleepTimerSelectedIndex")
                    
                    self.selected_Index = self.selected_Index == nil ? indexFromUserDefaults : self.selected_Index
                    
                    let cell = self.tblView.cellForRow(at: IndexPath.init(row: self.selected_Index, section: 0))
                    
                    cell?.textLabel?.text = "\(self.arrTime[self.selected_Index ?? 0]) \(self.getTimeRemainingForSeconds(seconds))"
                    cell?.layoutIfNeeded()
                }
            }
        }
    }
    
    
    func getTimeRemainingForSeconds(_ originalSeconds: Float) -> String {
        let minutes = Int(originalSeconds) / 60
        let seconds = Int(originalSeconds) % 60
        if originalSeconds >= 6000 {
            return String(format:"(%03i:%02i)", minutes, seconds)
        } else {
            return String(format:"(%02i:%02i)", minutes, seconds)
        }
        
    }
}
