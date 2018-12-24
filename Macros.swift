//
//  Macros.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 18/02/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import Foundation
import UIKit


enum LoginType: String {
    case Normal
    case Facebook
    case Google
}

// App Delegatre Object

let obj_app = UIApplication.shared.delegate as! AppDelegate

let userDefault   = UserDefaults.standard

let userIdKey       = "userId"

var FPID    = ""

var strUSerID : String?

var strFBID : String?

var strUIDReg : String?

let userNameKey    = "full_name"

var userName       = ""

var userEmail      = ""

var dob      = ""

var language:String?      = ""

var userGender      = Int()

var firstname      = ""

var lastname      = ""

var originalCountry:String?      = ""

var currentCountry:String?      = ""

var isselectFB : Bool = Bool()

var isselectGoogle : Bool = Bool()

var FBChecking : Bool = Bool()

var loginType: LoginType = .Normal

// Screen Width & Screen Height

let screenWidth  = UIScreen.main.bounds.size.width

let screenHeight = UIScreen.main.bounds.size.height

let statusBarHeight  = UIApplication.shared.statusBarFrame.size.height

let textFieldWidth = screenWidth * 0.20
let textFieldHeight = screenHeight * 0.20

//let statusHeight        = UIApplication.sharedApplication().statusBarFrame.size.height


var textFont: UIFont  = UIFont(name: "Arial", size: screenHeight * 0.025)!

//var textFontTable = UIFont(name: "OPENSANS-REGULAR_1.TTF", size: screenHeight * 0.025)

var textFontTable = UIFont(name: "OpenSans", size: screenHeight * 0.025)
var textFontTableBold = UIFont(name: "OpenSans-SemiBold", size: screenHeight * 0.025)
var textFontTableBoldPlaylist = UIFont(name: "OpenSans-SemiBold", size: screenHeight * 0.027)
var textFontTableItalic = UIFont(name: "OpenSans-Italic", size: screenHeight * 0.025)

var textFontSplashboardBold = UIFont(name: "OpenSans-SemiBold", size: screenHeight * 0.015)

var textFontDescription = UIFont(name: "OpenSans", size: screenHeight * 0.018)

var textFontFav = UIFont(name: "OpenSans-Bold", size: screenHeight * 0.025)
var textFontFavItalic = UIFont(name: "OpenSans-Italic", size: screenHeight * 0.025)


//var textFontHeading = UIFont(name: "Arial", size: screenHeight * 0.035)

//var textFontFPAl  = UIFont(name: "Asap-Regular", size: screenHeight * 0.015)

var textFontFPAl : UIFont  = UIFont(name: "OpenSans", size: screenHeight * 0.015)!

//var textFont = UIFont(name: "SFUIDisplay-Heavy", size: screenHeight * 0.030)

var textFontHeader  = UIFont(name:"Futura-Medium", size: screenHeight * 0.033)

var textFontStandingCell = UIFont(name: "SFUIDisplay-Medium", size: screenHeight * 0.020)

//var textFontTextFields = UIFont(name: "Asap-Regular", size: screenHeight * 0.025)

var textFontTextFields : UIFont = UIFont(name: "OpenSans", size: screenHeight * 0.025)!

var textRateThisTrack = UIFont(name: "OpenSans", size: screenHeight * 0.020)

var textSplashBoardCell = UIFont(name: "Futura-Medium", size: screenHeight * 0.030)

var textSplashBoardCellInner = UIFont(name: "Futura-Medium", size: screenHeight * 0.025)

var firstName = UIFont(name: "Asap-Bold", size: screenHeight * 0.025)

var lastName = UIFont(name: "Asap-Regular", size: screenHeight * 0.020)

var lastNameMid = UIFont(name: "Asap-Medium", size: screenHeight * 0.025)


//var textButton = UIFont(name: "Asap-Medium", size: screenHeight * 0.030)

var textButton = UIFont(name: "Lato-Regular", size: screenHeight * 0.030)

//let color_app                           = UIColor(red: 0.0, green:0.0, blue: 0.0, alpha: 1.0)
// Global URL


//let mainURL = "http://192.168.1.251/public/api/"
//let mainURL = "http://50.57.127.125:9252/public/api/"
let mainURL = "http://34.235.210.58/jwompa/public/"
//let mainURL = "http://jwompa.net/public/api/"


// http://demosite4u.com/dev/jwompa/public/api/forgotpassword
// http://demosite4u.com/dev/jwompa/public/api/register
// http://demosite4u.com/dev/jwompa/public/api/login
// http://demosite4u.com/dev/jwompa/public/api/newpassword
// http://demosite4u.com/dev/jwompa/public/api/verifyotp
// http://demosite4u.com/dev/jwompa/public/api/playlists
