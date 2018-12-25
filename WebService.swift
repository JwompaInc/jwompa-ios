//
//  WebService.swift
//  Swift_FirstDemo
//
//  Created by Umesh Palshikar on 03/02/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit
import AFNetworking

class WebService: NSObject {
    
    
    class func callGetServicewithStringPerameters(StringPerameter strPerametres:String,FunctionName strFunctionName:String ,succes:@escaping (_ responseObject:NSMutableDictionary,_ operation:AFHTTPRequestOperation) ->Void,orError:@escaping (_ error:NSError,_ operation:AFHTTPRequestOperation)->Void)
    {
        let remoteHostStatus : Bool  = obj_app.checkNetworkStatus()
        // var reachWifi : Reachability = Reachability.reachabilityForLocalWiFi()
        // let wifiStatus : Bool        = reachWifi.currentReachabilityStatus()
        
        if (remoteHostStatus == true)
        {
            obj_app.startActivityIndicatorView()
            var strGlobalURL : String = mainURL + strFunctionName + strPerametres
            print("JWOMPA: \(strGlobalURL)")
            
            let manager = AFHTTPRequestOperationManager()
            if strFunctionName == Constants().kLogOutURL || strFunctionName == Constants().kGetPlayListsURL || strFunctionName == "api/view_recent_playlist" || strFunctionName == "api/feedback_category" || strFunctionName == "api/getpreferencetwo" || strFunctionName == "api/getpreferenceone" || strFunctionName == "api/getuserpreference" || strFunctionName == "api/cms?type=about_us" || strFunctionName == "api/cms?type=terms_condition" || strFunctionName == "api/cms?type=privacy_policy" || strFunctionName == "api/view_playlist_favorites" || strFunctionName == "api/getplaylistbyid" || strFunctionName == "api/gettracksbyid" || strFunctionName == "api/trendy_search" || strFunctionName == "api/recent_search" || strFunctionName == "api/parent_categories" || strFunctionName == "api/categories" || strFunctionName == "api/add_playlist_recent" || strFunctionName == "api/category_playlists" {
                
                let accessToken = userDefault.value(forKey: "ACCESS_TOKEN") as? String
                print("Access Token ----------------> " + (accessToken ?? "No access_token") + " <----------------")
                manager.requestSerializer.setValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
            }
            manager.requestSerializer.timeoutInterval   = 120;
            
            
            strGlobalURL = strGlobalURL.removingPercentEncoding!       //replacingPercentEscapes(using: String.Encoding.utf8)!
            
            manager.get(strGlobalURL, parameters: nil, success: { (operation:AFHTTPRequestOperation?, responseObject:Any?) in
                obj_app.stopActivityIndicatorView()
                succes((responseObject as! NSDictionary).mutableCopy() as! NSMutableDictionary, operation!)
                
            }, failure: { (operation:AFHTTPRequestOperation?, error:Error?) in
                obj_app.stopActivityIndicatorView()
                orError(error! as NSError, operation!)
            })
        }
        else {
            obj_app.getAlert("Internet connection is not available")
        }
    }
    
    class func callPostServicewithDict( dictionaryObject  perameters:NSMutableDictionary, withData dataObject:Data ,withFunctionName strFuncionName:String ,withImgName strImgName:String,succes:@escaping (_ responseObject:NSMutableDictionary,_ operation:AFHTTPRequestOperation)->Void, orError:@escaping (_ error:NSError,_ operation:AFHTTPRequestOperation )->Void)
        
    {
        //post method
        var strGlobal :String     = mainURL + strFuncionName
        print("JWOMPA: \(strGlobal)")
        print("JWOMPA: \(perameters)")
        
        
        let remoteHostStatusIntrnet:Bool   = obj_app.checkNetworkStatus();
        // let reechWifi:Reachability         = Reachability.reachabilityForLocalWiFi();
        // let   status:NetworkStatus         = reechWifi.currentReachabilityStatus();
        
        
        
        if remoteHostStatusIntrnet == true
        {
            let manager               = AFHTTPRequestOperationManager()
            manager.requestSerializer.timeoutInterval   = 200;
            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if strFuncionName == Constants().kLogOutURL || strFuncionName == Constants().kGetPlayListsURL || strFuncionName == "api/add_playlist_recent" || strFuncionName == "api/searchsong" || strFuncionName == "api/getplaylisttracks" || strFuncionName == "api/view_recent_playlist" || strFuncionName == "api/account_setting" || strFuncionName == "api/registeruserdevice" || strFuncionName == "api/feedback" || strFuncionName == "like_dislike" || strFuncionName == "like_dislike_data" || strFuncionName == "rate_track" || strFuncionName == "view_rate_track" || strFuncionName == "api/updateuserpreferencetwo" || strFuncionName == "api/updateuserpreferenceone" || strFuncionName == "api/tell_a_friend" || strFuncionName == "api/forgotpassword" || strFuncionName == "auth/verifyotp" || strFuncionName == "auth/newpassword" || strFuncionName == "api/add_playlist_favorites" || strFuncionName == "api/remove_playlist_favorites" || strFuncionName == "api/check_favourite" || strFuncionName == "api/skip_track" || strFuncionName == "api/categories" {
                let accessToken = userDefault.value(forKey: "ACCESS_TOKEN") as? String
                print("Access Token ----------------> " + (accessToken ?? "No access_token") + " <----------------")
                manager.requestSerializer.setValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
            }
            obj_app.startActivityIndicatorView()
            
            
            strGlobal = strGlobal.replacingPercentEscapes(using: String.Encoding.utf8)!
            print(strGlobal)
            manager.post(strGlobal, parameters: perameters, constructingBodyWith: { (formData:AFMultipartFormData?) in
                
                if(dataObject.count>1)
                {
                    
                    // formData.appendPartWithFileData(data, name: strImgName, fileName:"photo.jpeg", mimeType: "image/jpeg");
                    formData?.appendPart(withFileData: dataObject,name:strImgName,fileName:"photo.jpeg",mimeType: "image/jpeg");
                }
                
            }, success: { (operation:AFHTTPRequestOperation?,  responseObject:Any?) in
                
                obj_app.stopActivityIndicatorView()
                print("JWOMPA: Yes this was a success")
                succes((responseObject as! NSDictionary).mutableCopy() as! NSMutableDictionary ,operation!);
                
            }, failure: { (operation:AFHTTPRequestOperation?, error:Error?) in
                
                obj_app.stopActivityIndicatorView()
                orError(error! as NSError, operation! );
                print("JWOMPA: We got an error here.. \(String(describing: error?.localizedDescription))")
                
                //obj_app.alertViewFromApp(messageString:error?.localizedDescription ?? "An Error Occured!")
                
                // MARK: TEST
                //                    self.alertViewFromApp(messageString:NSString(format: "Error %@","Server is not ready to response you , Please wait and retry.") as String);
                
            })
        }
        else
        {
            // MARK: TEST
            //            self.alertViewFromApp(messageString: "No Netowrk available in device ,please try to connect with internet!");
        }
    }
    
    class func callPostServicewithDictLogOut(accessToken: String, dictionaryObject  perameters:NSMutableDictionary, withData dataObject:Data ,withFunctionName strFuncionName:String ,withImgName strImgName:String,succes:@escaping (_ responseObject:NSMutableDictionary,_ operation:AFHTTPRequestOperation)->Void, orError:@escaping (_ error:NSError,_ operation:AFHTTPRequestOperation )->Void)
        
    {
        //post method
        var strGlobal :String     = mainURL + strFuncionName
        print("JWOMPA: \(strGlobal)")
        print("JWOMPA: \(perameters)")
        
        
        let remoteHostStatusIntrnet:Bool   = obj_app.checkNetworkStatus();
        // let reechWifi:Reachability         = Reachability.reachabilityForLocalWiFi();
        // let   status:NetworkStatus         = reechWifi.currentReachabilityStatus();
        
        
        
        if remoteHostStatusIntrnet == true
        {
            let manager               = AFHTTPRequestOperationManager()
            manager.requestSerializer.timeoutInterval   = 200;
            manager.requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            obj_app.startActivityIndicatorView()
            
            strGlobal = strGlobal.replacingPercentEscapes(using: String.Encoding.utf8)!
            print(strGlobal)
            manager.post(strGlobal, parameters: perameters, constructingBodyWith: { (formData:AFMultipartFormData?) in
                
                if(dataObject.count>1)
                {
                    
                    // formData.appendPartWithFileData(data, name: strImgName, fileName:"photo.jpeg", mimeType: "image/jpeg");
                    formData?.appendPart(withFileData: dataObject,name:strImgName,fileName:"photo.jpeg",mimeType: "image/jpeg");
                }
                
            }, success: { (operation:AFHTTPRequestOperation?,  responseObject:Any?) in
                
                obj_app.stopActivityIndicatorView()
                print("JWOMPA: Yes this was a success")
                succes((responseObject as! NSDictionary).mutableCopy() as! NSMutableDictionary ,operation!);
                
            }, failure: { (operation:AFHTTPRequestOperation?, error:Error?) in
                
                obj_app.stopActivityIndicatorView()
                orError(error as! NSError, operation! );
                print("JWOMPA: We got an error here.. \(error?.localizedDescription)")
                // MARK: TEST
                //                self.alertViewFromApp(messageString:NSString(format: "Error %@","Server is not ready to response you , Please wait and retry.") as String);
                
            })
        }
        else
        {
            // MARK: TEST
            //            self.alertViewFromApp(messageString: "No Netowrk available in device ,please try to connect with internet!");
        }
    }
    
}

