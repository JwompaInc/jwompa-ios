//
//  OpeningPreferencesViewController1.swift
//  JWOMPA
//
//  Created by BadhanGanesh on 23/02/18.
//  Copyright © 2018 Relienttekk. All rights reserved.
//

import UIKit

class OpeningPreferencesViewController1: BaseViewController {

    
    ////////////////////////////////////////////////////////////////
    //MARK:-
    //MARK:Outlets & Properties
    //MARK:-
    ////////////////////////////////////////////////////////////////
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    fileprivate var selectedIndexPath: IndexPath? = nil
    fileprivate var genreDatasource: [MusicGenrePreference] = []
    fileprivate var selectionDatasource: [MusicGenrePreference] = []
    fileprivate var dictionaryOfPreferenceSelection:[String:[[String:Int]]] = [:]
    
    public weak var delegate: PreferenceCompletionDelegate? = nil
    
    
    ////////////////////////////////////////////////////////////////
    //MARK:-
    //MARK:Methods
    //MARK:-
    ////////////////////////////////////////////////////////////////
    
    
    init() {
        super.init(nibName: "OpeningPreferencesViewController1", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPreferencesOneFromService()
    }
    
    fileprivate func initViewController() {
        
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin    = statusBarHeight + navBarHeight
        
        _ = JImage.shareInstance().setStatusBarDarkView(CGRect.init(x: 0, y: 0, width: screenWidth, height: 20), viewController: self)
        _ = JImage.shareInstance().setUpperView(CGRect(x: 0, y: 20, width: screenWidth, height: topMargin), viewController: self)
        _ = JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: 60, y: 18, width: screenWidth - 120, height: 30), nameOfString: "MUSIC PROFILE")
        
        self.nextButton.setCornerRadius(3.0, withBorderWidth: 0, andBorderColor: .clear)
        self.tableView.bounces = false
        self.tableView.allowsMultipleSelection = false
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none
        self.tableView.contentInset = UIEdgeInsets.init(top: 20, left: 0, bottom: 20, right: 0)
        
        self.tableView.register(UINib.init(nibName: "OpeningPreferencesOneTableViewCell", bundle: nil), forCellReuseIdentifier: "OpeningPreferencesOneTableCellLeft")
        self.tableView.register(UINib.init(nibName: "OpeningPreferencesOneTableViewCellRight", bundle: nil), forCellReuseIdentifier: "OpeningPreferencesOneTableCellRight")
    }
    
    
    func getPreferencesOneFromService() {        
        let strFunctionName = "api/getpreferenceone"
        WebService.callGetServicewithStringPerameters(StringPerameter: "", FunctionName: strFunctionName, succes: { (responseDictionary, operation) in
            
            let preferencesArray = responseDictionary["preference_one"] as? [[String:Any]]
            if let preferencesArray = preferencesArray {
                self.genreDatasource.removeAll()
                for item in preferencesArray {
                    self.genreDatasource.append(MusicGenrePreference.init(id: item["id"] as? Int, name: item["name"] as? String, isSelected: false))
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.flashScrollIndicators()
                }
            }
        }) { (error, operation) in
            self.alertViewFromApp(messageString: error.description)
        }
    }
    
    func updatePreference() {
        
        let strFunctionName = "api/updateuserpreferenceone"
        var preference:[String:[[String:Int]]] = ["preference": []]
        
        for selectedPref in self.selectionDatasource {
            preference["preference"]?.append(["id": selectedPref.id!])
        }
        
        WebService.callPostServicewithDict(dictionaryObject: NSMutableDictionary(dictionary: preference), withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes: { (response, operation) in
            
            if (response["status_text"] as? String) == "Success" {
                let nextVC = OpeningPreferencesViewController2()
                nextVC.delegate = self.delegate
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            
        }) { (error, operation) in
            self.alertViewFromApp(messageString: error.description)
        }
        
    }
    
    @IBAction func nextButtonTouched(_ sender: UIButton) {
        
        if self.selectionDatasource.count != 0 {
            self.updatePreference()
        } else {
            self.alertViewFromApp(messageString: "Select at least one choice!")
        }
        
    }
}


extension OpeningPreferencesViewController1: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.genreDatasource.count
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            cell.alpha = 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0.0
        
        if indexPath.row == 0 { // Left cell
            (cell as! OpeningPreferencesOneTableViewCell).yellowView.addDiamondMask(startDirection: .left)
        } else if indexPath.row % 2 == 0 { //Left cell
            (cell as! OpeningPreferencesOneTableViewCell).yellowView.addDiamondMask(startDirection: .left)
        } else { //Right cell
            (cell as! OpeningPreferencesOneTableViewCellRight).yellowView.addDiamondMask(startDirection: .right)
        }
        
        UIView.animate(withDuration: 0.2) {
            cell.alpha = 1.0
        }
    }
    
    func yellowButtonTouched(_ sender: UIButton) {
        
        let indexPath = IndexPath.init(row: sender.tag, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath)
        
        if (cell?.isSelected)! {
            sender.isSelected = false
            cell?.setSelected(false, animated: true)
            self.genreDatasource[indexPath.row].isSelected = false
            
            if let index = self.selectionDatasource.index(where: { $0.id == self.genreDatasource[indexPath.row].id } ) {
                self.selectionDatasource.remove(at: index)
            }
        } else {
            sender.isSelected = true
            cell?.setSelected(true, animated: true)
            self.genreDatasource[indexPath.row].isSelected = true
            self.selectionDatasource.append(self.genreDatasource[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if indexPath.row == 0 { // Left cell
            
            cell = tableView.dequeueReusableCell(withIdentifier: "OpeningPreferencesOneTableCellLeft")
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("OpeningPreferencesOneTableViewCell", owner: self, options: nil)?.first as! OpeningPreferencesOneTableViewCell
            }
            
            (cell as! OpeningPreferencesOneTableViewCell).yellowButton.addTarget(self, action: #selector(yellowButtonTouched(_:)), for: .touchUpInside)
            (cell as! OpeningPreferencesOneTableViewCell).yellowButton.tag = indexPath.row
            
            (cell as! OpeningPreferencesOneTableViewCell).nameLabel.text = self.genreDatasource[indexPath.row].name
            
        } else if indexPath.row % 2 == 0 { //Left cell
            
            cell = tableView.dequeueReusableCell(withIdentifier: "OpeningPreferencesOneTableCellLeft")
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("OpeningPreferencesOneTableViewCell", owner: self, options: nil)?.first as! OpeningPreferencesOneTableViewCell
            }
            
            (cell as! OpeningPreferencesOneTableViewCell).yellowButton.addTarget(self, action: #selector(yellowButtonTouched(_:)), for: .touchUpInside)
            (cell as! OpeningPreferencesOneTableViewCell).yellowButton.tag = indexPath.row
            
            (cell as! OpeningPreferencesOneTableViewCell).nameLabel.text = self.genreDatasource[indexPath.row].name
            
        } else { //Right cell
            
            cell = tableView.dequeueReusableCell(withIdentifier: "OpeningPreferencesOneTableCellRight")
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("OpeningPreferencesOneTableViewCellRight", owner: self, options: nil)?.first as! OpeningPreferencesOneTableViewCellRight
            }
            
            (cell as! OpeningPreferencesOneTableViewCellRight).yellowButton.addTarget(self, action: #selector(yellowButtonTouched(_:)), for: .touchUpInside)
            (cell as! OpeningPreferencesOneTableViewCellRight).yellowButton.tag = indexPath.row
            
            (cell as! OpeningPreferencesOneTableViewCellRight).nameLabel.text = self.genreDatasource[indexPath.row].name
            
        }
        
        DispatchQueue.main.async {
            cell.setSelected(self.genreDatasource[indexPath.row].isSelected, animated: true)
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.bounds.size.height / 13)
    }
    
}

