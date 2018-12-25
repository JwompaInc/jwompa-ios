//
//  UserDefaultsModel.swift
//  MarkyMomos
//
//  Created by Ranjeet Singh on 07/03/16.
//  Copyright © 2016 JBIT. All rights reserved.
//

import UIKit

class UserDefaultsModel: NSObject {

    var user_Default: UserDefaults = UserDefaults.standard
    
    
    //********************************************************//
    static let shared : UserDefaultsModel = {
        let instance = UserDefaultsModel()
        return instance
    }()
    //********************************************************//
    
    
    func setUserDefaultsValues(value:String,key:String) {
        user_Default.set(value, forKey: key)
        user_Default.synchronize()
    }
    
    
    func getUserDefaults(key:String) -> String {
        return user_Default.object(forKey: key) as! String
    }
    
    func setUserDefaultArray(value:NSMutableArray,key:String){
        user_Default.set(value, forKey: key)
        user_Default.synchronize()
    }
    
    func getUserDefaultArray(key:String) -> NSMutableArray {
        
        if(user_Default.object(forKey: key) == nil){
            return NSMutableArray()
        }else{
            
            print("UserDefaults.objectForKey(key)  :::  \(user_Default.object(forKey: key))")
            
            return (user_Default.object(forKey: key) as! NSArray).mutableCopy() as! NSMutableArray
        }
    }
    
    func clearAllUserDefaults() {
        for key in user_Default.dictionaryRepresentation().keys {
            user_Default.removeObject(forKey: key)
        }
        user_Default.synchronize()
    }
}
