//
//  CustomActionSheet.swift
//  IMLoyal
//
//  Created by Ranjeet Singh on 14/12/15.
//  Copyright © 2015 Ranjeet Singh. All rights reserved.
//

import UIKit

protocol CustomActionSheetDelegate{
    func indexSelected(index:Int)
}


class CustomActionSheet: UIView,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate {
    
    var width:CGFloat!
    var height:CGFloat!
    
    var as_delegate: CustomActionSheetDelegate?
    
    var backView:UIView!
    var backWhiteVw:UIView!
    
    var dataTitle:UILabel!
    var errOkBtn:UIButton!
    
    var titleTag:String = ""
    
    var dataTable:UITableView!
    var dataArray:NSMutableArray = NSMutableArray()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
        
        width = frame.size.width
        height = frame.size.height
        
        backView = UIView()
        backView.frame = CGRect(x:0, y:0, width: width, height: height)
        backView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
        self.addSubview(backView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleGesture(gestureRecognizer:)))
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.cancelsTouchesInView = false
        backView.addGestureRecognizer(tapGestureRecognizer)
        
        backWhiteVw = UIView()
        backWhiteVw.frame = CGRect(x:width/2-140, y:height/2-75, width:280, height:150)
        backWhiteVw.backgroundColor = UIColor.white
        backWhiteVw.layer.borderColor = UIColor.gray.cgColor
        backWhiteVw.layer.borderWidth = 1.0
        backWhiteVw.layer.cornerRadius = 5
        self.addSubview(backWhiteVw)
        
        dataTitle = UILabel()
        dataTitle.font = UIFont.systemFont(ofSize: 20)
        dataTitle.numberOfLines = 2
        dataTitle.frame = CGRect(x:10, y:10, width:260, height:60)
        dataTitle.textAlignment = NSTextAlignment.center
        backWhiteVw.addSubview(dataTitle)
        
        
        dataTable = UITableView()
        dataTable.frame = CGRect(x:5, y:70, width:270 , height:80)
        dataTable.delegate = self
        dataTable.dataSource = self
        dataTable.separatorStyle = UITableViewCellSeparatorStyle.none
        backWhiteVw.addSubview(dataTable)
        
    }
    
    func setServices(services:NSMutableArray){
        self.dataArray = services
        dataTable.reloadData()
    }
    
    
    func handleGesture(gestureRecognizer:UIGestureRecognizer) {
        self.removeFromSuperview()
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "CellId")
        
        if(dataArray.count > 0)
        {
            let dictData:NSDictionary = dataArray.object(at: indexPath.row) as! NSDictionary
            let titleText:String = dictData.object(forKey: titleTag) as! String
            
            cell.textLabel?.text = titleText
        }
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height*(8/100)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sh:CGFloat = CGFloat(dataArray.count) * UIScreen.main.bounds.height*(8/100)
        
        if(sh <= (height*(70/100))){
            dataTable.frame.size.height = sh
        }else{
            dataTable.frame.size.height = height*(70/100)
        }
        
        let TH:CGFloat = dataTable.frame.size.height + 80
        
        backWhiteVw.frame = CGRect(x:width/2-140, y:height/2 - TH/2, width:280, height:TH)
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.removeFromSuperview()
        self.as_delegate?.indexSelected(index: indexPath.row)
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
