//
//  Validator.swift
//  Ted Fred
//
//  Created by Umesh on 13/09/15.
//  Copyright (c) 2015 Relianttekk. All rights reserved.
//

import Foundation


class Validator: NSObject
{
    
   class  func didTakePicture(_ picture: UIImage) -> UIImage {
        let flippedImage = UIImage(cgImage: picture.cgImage!, scale: picture.scale, orientation:.leftMirrored)
    return flippedImage;
    }
    
    class func checkStringIsBlankOrNot(_ str:String)->String
    {
        var str = str
    
        if(str.characters.count == 0 || str.isEmpty )
        {
            str = "";
            
        }
        return str;
       
    
    
    }
    
    
    
    //MARK :- Global Method
    class  func getAllTxtFields(arrtxtFieldsIs arr:NSArray!, placHoldrEmail email:String ,placePhoneNumber num:String)->NSDictionary
    {
        var tag:Int = -1;
        var flag:Int = 0;
        
        
        for i in 0 ..< arr.count
        {
            let txtField:UITextField! = arr.object(at: i) as! UITextField;
            
            if(txtField.text?.isEmptyOrWhitespace() == true && txtField.placeholder! != email) {
                flag = 0;
                tag  = txtField.tag;
                
                let str: NSString = txtField.placeholder! as NSString;
                obj_app.alertViewFromApp(messageString: NSString(format: "Please Enter %@", str) as String);
                txtField.becomeFirstResponder();
                break
            }else if((txtField.placeholder! as NSString).isEqual(to: email)) {
                // check email
                let tempString:String = txtField.text!
                
                let trimmedString = tempString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                print("trimmedEmailString    :::::  \(trimmedString)")
                
                if Validator.validateEmailAddress(trimmedString as NSString) == false{
                    obj_app.alertViewFromApp(messageString: "Please enter a Valid Email Address.");
                    flag = 0;
                    tag  = txtField.tag;
                    txtField.becomeFirstResponder();
                    break;
                }else{
                    flag = 1;
                }
            }else if((txtField.placeholder! as NSString).isEqual(to: num)) {
                // check phone number
                if Validator.validatePhone(txtField.text! as NSString) == false{
                    obj_app.alertViewFromApp(messageString: "Please enter a Valid Phone Number.");
                    flag = 0
                    tag  = txtField.tag
                    txtField.becomeFirstResponder()
                    break;
                }else{
                    flag = 1;
                }
            }else{
                flag = 1;
            }
        }//for closed
        
        let  strTag:String = String(tag);
        let  strFlag:String = String(flag);
        let dict :NSDictionary = NSDictionary.init(objects:[strTag,strFlag],forKeys:["tag" as NSCopying,"flag" as NSCopying]);
        
        return dict;
    }

    
    //MARK: email validator
    class func validateEmailAddress(_ yourEmail:NSString)->Bool{
        
        let emailRegex:String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        let email:NSPredicate = NSPredicate(format: "SELF MATCHES %@",emailRegex);
        return email.evaluate(with: yourEmail);
    }
    
    
    class func setAnimationOn(viewType view:UIButton!)->CABasicAnimation{
        
        let animation :CABasicAnimation = CABasicAnimation(keyPath: "position");
        animation.duration     =   0.3;
        animation.repeatCount  = 3;
        animation.fromValue    =  NSValue(cgPoint: view.center);
        animation.toValue      =  NSValue(cgPoint: CGPoint(x: view.center.x, y: view.center.y-30));
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut);
        animation.autoreverses = true;
        animation.isRemovedOnCompletion = false;
        view.layer.add(animation, forKey:"position");
        
        
        return  animation;
    }

    
    //MARK: Phone number  validator
    class func validatePhone(_ yourNumber:NSString)->Bool
    {
        NSLog("%@",yourNumber);
        
        //        let PHONE_REGEX = "[()-][0-9]{6,14}$"
        //
        //        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        //
        //        let result =  phoneTest.evaluateWithObject(yourNumber)
        
        
        let invalidCharacters:CharacterSet = CharacterSet(charactersIn: "0123456789()-").inverted
        
        
        let string = String(yourNumber);
        
        
        if((string.rangeOfCharacter(from: invalidCharacters)) != nil)
        {
            return false;
        }
            
        else
        {
            return true;
            
            
        }
        
        
        
    }

    
    
    
  }







