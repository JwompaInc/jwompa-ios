//
//  UserDetailsModel.swift
//  MarkyMomos
//
//  Created by Ranjeet Singh on 19/08/15.
//  Copyright (c) 2015 Ranjeet Singh. All rights reserved.
//


import UIKit

public class SearchModel: NSObject {
    
    //********************* Search Array *********************//
    var searchArray:NSMutableArray = UserDefaultsModel.shared.getUserDefaultArray(key: "SearchArray").mutableCopy() as! NSMutableArray
    
    
    //********************* Add Search Text *********************//
    func checkAndAdd(search_text:String)
    {
        if(SearchModel.shared.searchArray.count > 0){
            var flag:String = "0"
            
            for dict_Data in SearchModel.shared.searchArray {
                
                let dictData = dict_Data as! NSDictionary
                let search_string:String = dictData.object(forKey: "searchText") as! String
                
                if(search_text == search_string){
                    flag = "1"
                    break
                }
            }
            if(flag == "0"){
                let dictA:NSDictionary = ["searchText": search_text]
                SearchModel.shared.searchArray.add(dictA)
            }
        }else{
            let dictA:NSDictionary = ["searchText": search_text]
            SearchModel.shared.searchArray.add(dictA)
        }
        
        
        UserDefaultsModel.shared.setUserDefaultArray(value:SearchModel.shared.searchArray ,key: "SearchArray")
        SearchModel.shared.searchArray = UserDefaultsModel.shared.getUserDefaultArray(key: "SearchArray").mutableCopy() as! NSMutableArray
        
        print("SearchModel.shared.searchArray   :::::   \(SearchModel.shared.searchArray)")
        
        
    }
    
    func removeAll(){
        SearchModel.shared.searchArray = NSMutableArray()
        UserDefaultsModel.shared.setUserDefaultArray(value:SearchModel.shared.searchArray ,key: "SearchArray")
    }
    
    func getTrandingArray() -> NSMutableArray {
    
        let search_Array:NSMutableArray = NSMutableArray()
        
        if(SearchModel.shared.searchArray.count > 0){
        
            var i:Int = 0
            
            for item in SearchModel.shared.searchArray.reversed() {
                print("JWOMPA: search item \(item)")
                if(i < 10){
                    search_Array.add(item)
                    i += 1
                }
            }
            
            return search_Array
            
        }else{
            return search_Array
        }
    }
    
    
    static let shared : SearchModel = {
        let instance = SearchModel()
        return instance
    }()
}
