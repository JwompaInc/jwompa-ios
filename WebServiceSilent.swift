//
//  WebServiceSilent.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 17/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit
import AFNetworking

class WebServiceSilent: NSObject {
    
    class func callGetServicewithStringPerameters(StringPerameter strPerametres:String,FunctionName strFunctionName:String ,succes:@escaping (_ responseObject:NSMutableDictionary,_ operation:AFHTTPRequestOperation) ->Void,orError:@escaping (_ error:NSError,_ operation:AFHTTPRequestOperation)->Void)
    {
        let remoteHostStatus : Bool  = obj_app.checkNetworkStatus()
        // var reachWifi : Reachability = Reachability.reachabilityForLocalWiFi()
        // let wifiStatus : Bool        = reachWifi.currentReachabilityStatus()
        
        if (remoteHostStatus == true)
        {
            let manager = AFHTTPRequestOperationManager()
            manager.requestSerializer.timeoutInterval   = 120;
            
            if strFunctionName == Constants().kLogOutURL || strFunctionName == Constants().kGetPlayListsURL || strFunctionName == "api/add_playlist_recent" || strFunctionName == "api/searchsong" || strFunctionName == "api/getplaylisttracks" || strFunctionName == "api/view_recent_playlist" || strFunctionName == "api/account_setting" || strFunctionName == "api/registeruserdevice" || strFunctionName == "api/feedback" || strFunctionName == "like_dislike" || strFunctionName == "like_dislike_data" || strFunctionName == "rate_track" || strFunctionName == "view_rate_track" {
                let accessToken = userDefault.value(forKey: "ACCESS_TOKEN") as? String
                manager.requestSerializer.setValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
            }
            
            //obj_app.startActivityIndicatorView()
            var strGlobalURL : String = mainURL + strFunctionName + strPerametres
            print(strGlobalURL)
            
            
            
            //            let ACCESS_TOKEN : String = "b72ba836-888c-4653-bfbc-2d706bdc7251"
            //            let USER_AGENT_NAME : String = "relianttest2015@gmail.com"
            //            let AUTHORIZATION : String = "Authorization"
            //            let BEARER : String = String(format:"Bearer %@" , ACCESS_TOKEN)
            //            let USER_AGENT : String = "User-agent"
            //            let ACCEPT_ENCODING : String = "Accept-encoding"
            //            let GZIP : String = "gzip"
            //
            //            let request : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: strGlobalURL)!)
            //            request.HTTPMethod = "GET"
            //            request.setValue("text/xml", forHTTPHeaderField: "Content-Type")
            //            request.setValue("text/xml", forHTTPHeaderField: "Accept")
            //            request.setValue(BEARER, forHTTPHeaderField:AUTHORIZATION)
            //            request.setValue(USER_AGENT_NAME, forHTTPHeaderField:USER_AGENT)
            //            request.setValue(GZIP, forHTTPHeaderField: ACCEPT_ENCODING)
            
            strGlobalURL = strGlobalURL.replacingPercentEscapes(using: String.Encoding.utf8)!
            
            manager.get(strGlobalURL, parameters: nil,   success: { (operation: AFHTTPRequestOperation?, responseObject: Any?) in
                
                
                //succes(responseObject:responseObject,operation:operation);
                succes(responseObject as! NSMutableDictionary,operation!);
                print("YES YES YES... SUCCESS");
                //obj_app.stopActivityIndicatorView()
                // self.delegate.SuccessWithOperation(operation: operation, responseObject: responseObject);
                },
                failure: { (operation: AFHTTPRequestOperation?, error: Error?) in
                  //  obj_app.stopActivityIndicatorView()
                    //self.delegate.ErrorWithOperation(operation: operation, andError: error);
                    print("NO NO NO... FAILED")
                    orError(error as! NSError, operation! );
            })
        }
            
        else
        {
            //obj_app.getAlert("Internet connection is not available")
        }
    }
    
    
    class func callPostServicewithDict( dictionaryObject  perameters:NSMutableDictionary, withData dataObject:Data ,withFunctionName strFuncionName:String ,withImgName strImgName:String,succes:@escaping (_ responseObject:NSMutableDictionary,_ operation:AFHTTPRequestOperation)->Void, orError:@escaping (_ error:NSError,_ operation:AFHTTPRequestOperation )->Void)
        
    {
        //post method
        var strGlobal :String     = mainURL + strFuncionName
        print(strGlobal)
        print(perameters)
        
        
        let remoteHostStatusIntrnet:Bool   = obj_app.checkNetworkStatus();
        // let reechWifi:Reachability         = Reachability.reachabilityForLocalWiFi();
        // let   status:NetworkStatus         = reechWifi.currentReachabilityStatus();
        
        
        
        if remoteHostStatusIntrnet == true
        {
            let manager               = AFHTTPRequestOperationManager()
            manager.requestSerializer.timeoutInterval   = 200;
           // obj_app.startActivityIndicatorView()
            
            if strFuncionName == Constants().kLogOutURL || strFuncionName == Constants().kGetPlayListsURL || strFuncionName == "api/add_playlist_recent" || strFuncionName == "api/searchsong" || strFuncionName == "api/getplaylisttracks" || strFuncionName == "api/view_recent_playlist" || strFuncionName == "api/account_setting" || strFuncionName == "api/registeruserdevice" || strFuncionName == "api/feedback" || strFuncionName == "api/like_dislike" || strFuncionName == "api/like_dislike_data" || strFuncionName == "api/rate_track" || strFuncionName == "api/view_rate_track" || strFuncionName == "api/track_listen" {
                let accessToken = userDefault.value(forKey: "ACCESS_TOKEN") as? String
                manager.requestSerializer.setValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
            }
            
            //            let ACCESS_TOKEN : String = "b72ba836-888c-4653-bfbc-2d706bdc7251"
            //            let USER_AGENT_NAME : String = "relianttest2015@gmail.com"
            //            let AUTHORIZATION : String = "Authorization"
            //            let BEARER : String = String(format:"Bearer %@" , ACCESS_TOKEN)
            //            let USER_AGENT : String = "User-agent"
            //            let ACCEPT_ENCODING : String = "Accept-encoding"
            //            let GZIP : String = "gzip"
            //
            //            let request : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: strGlobal)!)
            //            request.HTTPMethod = "GET"
            //            request.setValue("text/xml", forHTTPHeaderField: "Content-Type")
            //            request.setValue("text/xml", forHTTPHeaderField: "Accept")
            //            request.setValue(BEARER, forHTTPHeaderField:AUTHORIZATION)
            //            request.setValue(USER_AGENT_NAME, forHTTPHeaderField:USER_AGENT)
            //            request.setValue(GZIP, forHTTPHeaderField: ACCEPT_ENCODING)
            
            strGlobal = strGlobal.replacingPercentEscapes(using: String.Encoding.utf8)!
            
            manager.post(strGlobal, parameters: perameters, constructingBodyWith: { (formData:AFMultipartFormData?) -> Void in
                
                // NSLog("%@", dataObject);
                if(dataObject.count>1)
                {
                    
                    // formData.appendPartWithFileData(data, name: strImgName, fileName:"photo.jpeg", mimeType: "image/jpeg");
                    formData?.appendPart(withFileData: dataObject,name:strImgName,fileName:"photo.jpeg",mimeType: "image/jpeg");
                }
                
                
                }, success: {
                    (operation: AFHTTPRequestOperation?, responseObject: Any?) in
                  //  obj_app.stopActivityIndicatorView()
                    print("Yes this was a success")
                    succes((responseObject as! NSDictionary).mutableCopy() as! NSMutableDictionary,operation!);
                },
                failure: { (operation: AFHTTPRequestOperation?, error: Error?) in
                  //  obj_app.stopActivityIndicatorView()
                    orError(error as! NSError, operation! );
                    print("We got an error here.. \(error?.localizedDescription)")
                    //self.alertViewFromApp(messageString:NSString(format: "Error %@","Server is not ready to response you , Please wait and retry.") as String);
            })
        }
        else
        {
            // MARK: TEST
//            self.alertViewFromApp(messageString: "No Netowrk available in device ,please try to connect with internet!");
        }
    }
    //    var strPeramater:String = "storeid=6&language=English";
    //
    //    var strFName:String = "/shopdetail.php?";
    //
    //
    //
    //
    //
    //    //http://www.huskynet.it/webservice/shopdetail.php?storeid=6&language=English
    //    WebService.callGetServicewithStringPerameters(StringPerameter:strPeramater, FunctionName:strFName, succes:
    //    { (responseObject, operation) -> Void in
    //
    //    NSLog(" %@",  responseObject as NSMutableDictionary);
    //
    //
    //    }) { (error, operation) -> Void in
    //    
    //    }
    //    
    //    
    //    


}
