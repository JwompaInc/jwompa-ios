
import Foundation
import UIKit

class ManagerClass {
    
    
    class func getVal(param:AnyObject!) -> AnyObject {
        
        //println("getVal = \(param)")
        
        if param == nil {
            return "" as AnyObject
        }
        else if param is NSNull {
            return "" as AnyObject
        }
            /*else if param.isEqualToString("") {
             return ""
             }*/
        else if param is NSNumber {
            return "\(param)" as AnyObject
        }
        else {
            return param
        }
    }
}
