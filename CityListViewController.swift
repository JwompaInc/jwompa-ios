//
//  CityListViewController.swift
//  Whooop
//
//  Created by Ranjeet Singh on 04/02/16.
//  Copyright © 2016 JBIT. All rights reserved.
//

import UIKit


protocol CityListDelegate: class {
    func selectedCity(city:String)
}

typealias CountryDictionary = Dictionary<String, String>

class CityListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    weak var delegate: CityListDelegate?
    
    var screenW:CGFloat!
    var screenH:CGFloat!
    
    var backImage:UIImageView!
    
    var topNavView:UIView!
    var allButton:UIButton!
    var searchStringText:UITextField!
    var cancelButton:UIButton!
    var cityTable:UITableView!
    var bottomPix:CGFloat = 60
    
    var contryArray:[CountryDictionary] = [[:]]
    
    var collectionView: UICollectionView!
    var flowLayout: UICollectionViewFlowLayout!
    
    var countryPlaceholder: String = "Search Country"
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchStringText.text = ""
        contryArray = getCirtArray()
        cityTable.reloadData()
        searchStringText.becomeFirstResponder()
        
        DispatchQueue.main.async {
            _ = JImage.shareInstance().setStatusBarDarkView(CGRect.init(x: 0, y: 0, width: screenWidth, height: 20), viewController: self)
        }
    }
    
    
    fileprivate func configureCollectionView() {
        //Collection View Config
        self.flowLayout = UICollectionViewFlowLayout.init()
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0.0, y: 64.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 64.0), collectionViewLayout: flowLayout)
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(CountryCollectionViewCell.self, forCellWithReuseIdentifier: "CountryCollectionCell")
        
        self.view.addSubview(self.collectionView)
        self.flowLayout.itemSize = CGSize.init(width: 35, height: 25)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configureCollectionView()
        
        screenW = self.view.frame.size.width
        screenH = self.view.frame.size.height
        
        self.view.backgroundColor = UIColor.white
        
        contryArray = getCirtArray()
        
        backImage = UIImageView(frame: CGRect(x:0, y:0, width:screenW, height:screenH))
        backImage.image = UIImage(named: "inner_screen_bg")
        self.view.addSubview(backImage)
        
        
        topNavView = UIView()
        topNavView.frame = CGRect(x:0, y:0, width:screenW, height:60)
        topNavView.backgroundColor = UIColor(red: 253/255.0, green: 217/255.0, blue: 88/255.0, alpha: 1)
        self.view.addSubview(topNavView)
        
        allButton = UIButton()
        allButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        allButton.frame = CGRect(x:0, y:18, width:screenW*(20/100), height:40)
        allButton.backgroundColor = UIColor.clear
        allButton.setTitle("All City", for: UIControlState.normal)
        allButton.setTitleColor(UIColor(hex: 0xffffff, alpha: 1.0), for: UIControlState.normal)
        allButton.addTarget(self, action: #selector(CityListViewController.selectAllCity), for: UIControlEvents.touchUpInside)
        //topNavView.addSubview(allButton)
        
        
        searchStringText = TextField()
        searchStringText.font = UIFont.systemFont(ofSize: 12)
        searchStringText.frame = CGRect(x:screenW*(20/100), y:25, width:screenW*(60/100), height:26)
        searchStringText.placeholder = self.countryPlaceholder
        searchStringText.textColor = UIColor.gray
        searchStringText.backgroundColor = UIColor.white
        searchStringText.layer.cornerRadius = 4
        searchStringText.delegate = self
        searchStringText.textAlignment = NSTextAlignment.center
        searchStringText.addTarget(self, action: #selector(self.text_Field_Did_Change(textField:)), for: UIControlEvents.editingChanged)
        topNavView.addSubview(searchStringText)
        
        cancelButton = UIButton()
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelButton.frame = CGRect(x:screenW*(80/100), y:18, width:screenW*(20/100), height:40)
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.setTitle("Cancel", for: UIControlState.normal)
        cancelButton.setTitleColor(UIColor(hex: 0x000000, alpha: 1.0), for: UIControlState.normal)
        cancelButton.addTarget(self, action: #selector(CityListViewController.dismissCityView), for: UIControlEvents.touchUpInside)
        topNavView.addSubview(cancelButton)
        
        
         cityTable = UITableView()
         cityTable.frame = CGRect(x:0, y:60, width:screenW, height:screenH-bottomPix)
         cityTable.delegate = self
         cityTable.dataSource = self
         //eventTable.separatorStyle = UITableViewCellSeparatorStyle.None
         //eventTable.allowsSelection = false
         cityTable.backgroundColor = UIColor.clear
         self.view.addSubview(cityTable)
        
        
    }
    
    func text_Field_Did_Change(textField:UITextField){
        self.searchTextEnter()
    }
    
    func searchTextEnter(){
        
        let searchText:String = searchStringText.text!
        print("searchText  :::: \(searchText)")
        
        self.contryArray.removeAll()
        var tempArray:[CountryDictionary] = [[:]]
        
        let filteredArray = getCirtArray().filter { ($0["name"]?.lowercased().contains(searchText.lowercased()))! }
        
        if filteredArray.count > 0 {
            tempArray = filteredArray
        }
        
        if(searchText == ""){
            self.contryArray = getCirtArray()
        }else{
            self.contryArray = tempArray
        }
        
        //self.collectionView.reloadData()
        cityTable.reloadData()
    }
    
    
    
    
    
    func dismissCityView(){
        
        self.dismiss(animated: true) { () -> Void in
            
        }
    }
    
    func selectAllCity(){
        
        self.delegate?.selectedCity(city: "")
        self.dismissCityView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeTableViewCell") as? CountryCodeTableViewCell
        
        if cell == nil {
            cell = (Bundle.main.loadNibNamed("CountryCodeTableViewCell", owner: self, options: nil))?.first as? CountryCodeTableViewCell
        }
        
        if self.contryArray.count > 0 {
            
            let country = self.contryArray[indexPath.row]
            let countryName = country["name"] ?? ""
            let code = country["code"]
            
            cell?.countryName.text = countryName
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    let filteredArray = self.contryArray.filter { $0["code"] == code }
                    
                    if filteredArray.count == 1 {
                        cell?.countryEmoji.text = filteredArray.first?["emoji"]
                    }
                }
            }
            
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height*(8/100)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
        
        let country = self.contryArray[indexPath.row]
        let countryName = country["name"] ?? ""
        self.delegate?.selectedCity(city: countryName )
        self.dismissCityView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCirtArray() -> [CountryDictionary] {
        
        let filepath = Bundle.main.path(forResource: "countrydata", ofType: "json")
        guard let fp = filepath else {
            return []
        }
        do {
            let data = try Data.init(contentsOf: URL.init(fileURLWithPath:fp))
            let jsonObject = try [JSONSerialization.jsonObject(with: data, options: .mutableContainers)]
            return ((jsonObject as NSArray).firstObject as! [CountryDictionary]).sorted(by: { (dic1, dic2) -> Bool in
                return dic1["name"] ?? "" < dic2["name"] ?? ""
            })
        } catch {
            print("Error caught while loading countries json from bundle :::::: \(error.localizedDescription)")
        }
        return []
        
    }
    
}

extension CityListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryCollectionCell", for: indexPath) as? CountryCollectionViewCell
        
        if cell == nil {
            cell = CountryCollectionViewCell.init(frame: .zero)
        }
        
        if self.contryArray.count > 0 {
            DispatchQueue.global(qos: .userInteractive).async {
                DispatchQueue.main.async {
                    //cell?.countryName.text = countryName ?? "Country Name"
                    let country = self.contryArray[indexPath.row]
                }
            }
        }
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let country = self.contryArray[indexPath.row]
        let countryName = country["name"]
        self.delegate?.selectedCity(city: countryName ?? "")
        self.dismissCityView()
    }
    
}

class CountryCollectionViewCell: UICollectionViewCell {
    
    var flagImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        flagImageView = UIImageView()
        flagImageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(flagImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        flagImageView.frame = self.contentView.frame
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.flagImageView.image = nil
    }
    
}


extension CityListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}


