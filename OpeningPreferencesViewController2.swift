//
//  OpeningPreferencesViewController2.swift
//  JWOMPA
//
//  Created by BadhanGanesh on 22/02/18.
//  Copyright © 2018 Relienttekk. All rights reserved.
//

import UIKit

struct MusicGenrePreference {
    var id: Int?
    var name: String?
    var isSelected: Bool = false
}

protocol PreferenceCompletionDelegate:class {
    func didFinishChoosingPreference()
}

class OpeningPreferencesViewController2: BaseViewController {
    
    
    ////////////////////////////////////////////////////////////////
    //MARK:-
    //MARK:Outlets & Properties
    //MARK:-
    ////////////////////////////////////////////////////////////////
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var noPreferenceButton: UIButton!
    
//    fileprivate var dropdown = DropDown()
    fileprivate var selectedIndexPath: IndexPath? = nil
    fileprivate var genreDatasource: [MusicGenrePreference] = []
    fileprivate var selectedGenreDatasource: [MusicGenrePreference] = []
    fileprivate var selectionDatasource: [MusicGenrePreference] = [MusicGenrePreference.init(id: -11, name: "First Choice", isSelected: false), MusicGenrePreference.init(id: -11, name: "Second Choice", isSelected: false), MusicGenrePreference.init(id: -11, name: "Third Choice", isSelected: false)]
    fileprivate var dictionaryOfPreferenceSelection:[String:[[String:Int]]] = ["preference":[ ["id": -11], ["id": -11], ["id": -11]]] //To send to service
    
    public weak var delegate: PreferenceCompletionDelegate? = nil
    
    
    ////////////////////////////////////////////////////////////////
    //MARK:-
    //MARK:Methods
    //MARK:-
    ////////////////////////////////////////////////////////////////
    
    init() {
        super.init(nibName: "OpeningPreferencesViewController2", bundle: nil)
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
//        configureDropdown()
        getPreferencesTwoFromService()
    }
    
    fileprivate func initViewController() {
        
        let navBarHeight : CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let topMargin    = statusBarHeight + navBarHeight
        
        _ = JImage.shareInstance().setStatusBarDarkView(CGRect.init(x: 0, y: 0, width: screenWidth, height: 20), viewController: self)
        _ = JImage.shareInstance().setUpperView(CGRect(x: 0, y: 20, width: screenWidth, height: topMargin), viewController: self)
        _ = JImage.shareInstance().SetLabelOnUpperViewWithNormalFont(CGRect(x: 60, y: 18, width: screenWidth - 120, height: 30), nameOfString: "MUSIC PROFILE")
        
        self.tableView.register(UINib.init(nibName: "OpeningPreferencesTwoTableViewCell", bundle: nil), forCellReuseIdentifier: "OpeningPreferencesTwoTableCell")
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 95
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.finishButton.setCornerRadius(3.0, withBorderWidth: 0, andBorderColor: .clear)
    }
    
    func configureDropdown(_ dropdown: DropDown, _ cell: OpeningPreferencesTwoTableViewCell) {
        
        dropdown.dataSource = self.selectedGenreDatasource.map { $0.name! }
        
        dropdown.direction = .bottom
        dropdown.backgroundColor = UIColor.init(hex: 0xF9DA6D, alpha: 1.0)
        dropdown.shadowColor = .clear
        dropdown.selectionBackgroundColor = .clear
        dropdown.textFont = textFontTableBold!
        dropdown.tableView.flashScrollIndicators()
        dropdown.tableView.setCornerRadius(8.0, withBorderWidth: 0.0, andBorderColor: .clear)
        
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            let preference = self.selectedGenreDatasource[index]
            if let indexPath = self.selectedIndexPath {
                
                self.selectionDatasource[indexPath.row] = preference
                self.dictionaryOfPreferenceSelection["preference"]?[indexPath.row] = ["id": preference.id ?? -11]
                print(self.dictionaryOfPreferenceSelection)
                
                self.selectedGenreDatasource = self.genreDatasource
                
                for item in (self.dictionaryOfPreferenceSelection["preference"])! {
                    if item["id"] != -11 {
                        if let index = self.selectedGenreDatasource.index(where: { $0.id == item["id"] }) {
                            self.selectedGenreDatasource.remove(at: index)
                            //continue do: arrPickerData.append(...)
                        }
                    }
                }
                
//                dropdown.dataSource = self.selectedGenreDatasource.map { $0.name! }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        DispatchQueue.main.async { [unowned self] in
            dropdown.removeFromSuperview()
            dropdown.anchorView = cell.dropdownAnchorView
            dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)
            dropdown.width = dropdown.anchorView?.plainView.bounds.width
            dropdown.height = cell.bounds.size.height * 2.7
            dropdown.arrowIndicationX = (dropdown.anchorView?.plainView.bounds.width)! - 20.0
            dropdown.arrowIndicationY = dropdown.height! - 15.0
            dropdown.tableView.flashScrollIndicators()
            dropdown.show()
        }
    }
    
    func getPreferencesTwoFromService() {
        let strFunctionName = "api/getpreferencetwo"
        WebService.callGetServicewithStringPerameters(StringPerameter: "", FunctionName: strFunctionName, succes: { (responseDictionary, operation) in
            
            let preferencesArray = responseDictionary["preference_two"] as? [[String:Any]]
            if let preferencesArray = preferencesArray {
                self.genreDatasource.removeAll()
                self.selectedGenreDatasource.removeAll()
                for item in preferencesArray {
                    self.genreDatasource.append(MusicGenrePreference.init(id: item["id"] as? Int, name: item["name"] as? String, isSelected: false))
                }
                self.selectedGenreDatasource = self.genreDatasource
//                self.dropdown.dataSource = self.genreDatasource.map { $0.name! }
            }
        }) { (error, operation) in
            self.alertViewFromApp(messageString: error.localizedDescription)
        }
    }
    
    func updatePreference() {
        
        let strFunctionName = "api/updateuserpreferencetwo"
        let insideFinalarray = dictionaryOfPreferenceSelection["preference"]?.filter { $0["id"] != -11 }
        let finalDict:NSMutableDictionary = ["preference": insideFinalarray!]
        
        WebService.callPostServicewithDict(dictionaryObject: finalDict, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes: { [weak self] (response, operation) in
            
            if (response["status_text"] as! String) == "Success" {
                if let delegate = self?.delegate {
                    delegate.didFinishChoosingPreference()
                }
            }
            
        }) { (error, operation) in
            self.alertViewFromApp(messageString: error.localizedDescription)
        }
    }
    
    func isEmpty() -> Bool {
        var count = 0
        for item in (self.dictionaryOfPreferenceSelection["preference"])! {
            if item["id"] == -11 {
                count += 1
            }
        }
        return count == self.dictionaryOfPreferenceSelection["preference"]?.count
    }
    
    @IBAction func finishButtonTouched(_ sender: UIButton) {
        self.isEmpty() ? self.alertViewFromApp(messageString: "Select at least one choice!") : self.updatePreference()
    }
    
    @IBAction func noPreferenceButtonTouched(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didFinishChoosingPreference()
        }
    }
    
}

extension OpeningPreferencesViewController2: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectionDatasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "OpeningPreferencesTwoTableCell") as! OpeningPreferencesTwoTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.indexLabel.text = "\(indexPath.row + 1)st"
            break
        case 1:
            cell.indexLabel.text = "\(indexPath.row + 1)nd"
            break
        case 2:
            cell.indexLabel.text = "\(indexPath.row + 1)rd"
            break
        default:
            cell.indexLabel.text = ""
        }
        
        let genreName = self.selectionDatasource[indexPath.row].name
        cell.genreNameLabel.text = genreName ?? "Unknown Genre"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! OpeningPreferencesTwoTableViewCell
        self.selectedIndexPath = indexPath
        let dropDown = DropDown()
        self.configureDropdown(dropDown, cell)
//        self.configureDropdown(<#DropDown#>)
//        DispatchQueue.main.async { [unowned self] in
//            self.dropdown.removeFromSuperview()
//            self.dropdown.anchorView = cell.dropdownAnchorView
//            self.dropdown.bottomOffset = CGPoint(x: 0, y:(self.dropdown.anchorView?.plainView.bounds.height)!)
//            self.dropdown.width = self.dropdown.anchorView?.plainView.bounds.width
//            self.dropdown.height = cell.bounds.size.height * 2.7
//            self.dropdown.arrowIndicationX = (self.dropdown.anchorView?.plainView.bounds.width)! - 20.0
//            self.dropdown.arrowIndicationY = self.dropdown.height! - 15.0
//            self.dropdown.tableView.flashScrollIndicators()
//            self.dropdown.show()
//        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.size.height * (11/100)
    }
    
}

