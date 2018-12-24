//
//  JPlayerVC.swift
//  JWOMPA
//
//  Created by Umesh Palshikar on 04/03/16.
//  Copyright © 2016 Relienttekk. All rights reserved.

import UIKit
import AVKit
import AVFoundation
import AFNetworking
import SDWebImage
//import MTCircularSlider

var total : String = String()
var data:Data!
var currentTime:Float!
var isPaused = true
//var timer = Timer()
var time = 0
var startSeconds : Int!
var pauseTime : Double!
var totalSec : Double!
var date:Date!
var imageViewTrans : UIImageView = UIImageView()
//var isTrue : Bool = Bool()
var arrayJPlayer : NSMutableArray = NSMutableArray()
var arrayForStream : NSMutableArray = NSMutableArray()
var TrackID : Int?
var arrayNew : NSMutableArray = NSMutableArray()
var arrayTrackID : NSMutableArray = NSMutableArray()
var dictinfo : NSMutableDictionary = NSMutableDictionary()


class JPlayerVC: BaseViewController, FloatRatingViewDelegate, UIGestureRecognizerDelegate {
    
//    @IBOutlet weak var imageView: UIImageView!
    var currentSeconds : Float!
    var currentTime :TimeInterval = TimeInterval()
    var tm : CMTime = CMTime()
    
    var playlistIDPlayer : Int!
    
    
    var lbl : UILabel = UILabel()
    var strURL : String?
    var strWhole : String?
    var strTrackIDFirst : String?
    var strTrackIDWhole : Int?
    var buttonDemo : UIButton = UIButton()
    var buttonNext : UIButton = UIButton()
    var stopMusic : UIButton = UIButton()
    var trackTitle : UILabel = UILabel()
    var playedTime : UILabel = UILabel()
    var timer:Timer!
    var imageViewPlayer : UIImageView = UIImageView()
    var imageViewTrans : UIImageView = UIImageView()
    var artistLbl:UILabel = UILabel()
    var lblTitle : UILabel = UILabel()
    var genricLbl:UILabel = UILabel()
    var lblTimer : UILabel = UILabel()
    var lblCurrentTime : UILabel = UILabel()
    var lblSkipCount: UILabel = UILabel()
    
    var slider: UISlider?
    var buttonStar : UIButton = UIButton()
    var Favtag : Int = Int()
    var LikeNDislikeTag : Int = Int()
    var buttonDislike : UIButton = UIButton()
    var buttonlike : UIButton = UIButton()
    var buttonImageViewBack : UIButton = UIButton()
    var buttonSideView = UIButton()
    var lblCount : UILabel = UILabel()
    var strAvgRating : Double?
    var obj:BWCircularSliderView!
    var viewTrans : UIView = UIView()
    var viewMid : UIView = UIView()
    
    let diskLayer = CALayer()
    var totalTime:String = ""
    
    var totalsecmint:String = String()
    var totalmintsec :String = String()
    
    var floatRatingView: FloatRatingView = FloatRatingView()
    var diskImage:UIImageView = UIImageView()
    
    var dataFromSearch:NSDictionary!
    var comeFrom:String = ""
    var swipeValidate: Bool? = false

    
    var slider_image:MTCircularSlider!
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.PlayerHandler(_:)), name: NSNotification.Name(rawValue: "nextSong"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.PlayerHandler(_:)), name: NSNotification.Name(rawValue: "songProgress"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.PlayerHandler(_:)), name: NSNotification.Name(rawValue: "stateChanged"), object: nil)
        
        if(self.comeFrom == "search"){
            //self.getPlaylistFromSearch()
        }
        
        //self.checkIsFavorite()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBar()
        
        strUSerID = userDefault.value(forKey: "USER_ID") as? String
        
        self.setViews()
    }
    
    
    func PlayerHandler(_ notification: Notification){
        
        //print("notification.name.rawValue   :::::   \(notification.name.rawValue)")
        
        
        if (notification.name.rawValue  == "nextSong"){
            
            LikeNDislikeTag = 2
            self.likeDisLke_Favorite()
            
            lblCount.text = "\(AudioPlayerModel.shared.getCurrentIndex())"
            
            let song_Data = AudioPlayerModel.shared.getCurentIndexData()
            
            if (song_Data.object(forKey: "status") as! String != "success")  {
                return
            }
            
            let songData = song_Data.object(forKey: "data") as! NSMutableDictionary
            
            let _ = songData.object(forKey: "track_id") as! String
            let trackImage:String = songData.object(forKey: "track_image") as! String
            let trackTitle:String = songData.object(forKey: "track_title") as! String
            let _ = songData.object(forKey: "generic") as! Int
            let artist:String = songData.object(forKey: "artist") as! String
            
            self.lblTitle.text = artist.isEmpty == true ? "Unknown Artist" : artist
            
            let country:String? = songData.object(forKey: "country") as? String
            self.genricLbl.text = String(format: "%@",country ?? "")
            
            self.artistLbl.text = trackTitle
            
            self.slider_image.valueMaximum = 0.0
            self.slider_image.value = 0.0
            self.lblTimer.text = "0.00/0.00"
            
            
            self.diskImage.sd_setImage(with: URL(string: trackImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), placeholderImage: #imageLiteral(resourceName: "Play"))
//            ImageLoader.sharedLoader.imageForUrl(trackImage, completionHandler: { (image, url) in
//                if(image != nil){
//                    self.diskImage.image = image
//                }
//            })
            
            buttonDemo.setImage(UIImage(named: "Pause")!, for: UIControlState())
            
            self.getLikeDislike()
            self.getTerackRating()
            
        }else if(notification.name.rawValue  == "songProgress"){
            
            self.checkAudioStatus(button: buttonDemo)
            
            
            if let currentTime = AudioPlayerModel.shared.jukebox.currentItem?.currentTime, let duration = AudioPlayerModel.shared.jukebox.currentItem?.meta.duration {
                
                self.slider_image.valueMaximum = Float(duration)
                self.slider_image.value = Float(currentTime)

                let tottalTimeText:String = AudioPlayerModel.shared.getDuretionText(timeInterval: (AudioPlayerModel.shared.jukebox.currentItem?.meta.duration)!)
                let currentTimeText:String = AudioPlayerModel.shared.getDuretionText(timeInterval: (AudioPlayerModel.shared.jukebox.currentItem?.currentTime)!)
                
                //print("tottalTimeText  :::::   \(tottalTimeText)")
                //print("currentTimeText  :::::   \(currentTimeText)")
                
                self.lblTimer.text = currentTimeText+"/"+tottalTimeText
            }
            
            let song_Data = AudioPlayerModel.shared.getCurentIndexData()
            
            if (song_Data.object(forKey: "status") as! String == "success")  {
                let songData = song_Data.object(forKey: "data") as! NSMutableDictionary
                
//                let trackID:String = songData.object(forKey: "track_id") as! String
                let trackImage:String = songData.object(forKey: "track_image") as! String
                let trackTitle:String = songData.object(forKey: "track_title") as! String
//                let genric:Int = songData.object(forKey: "generic") as! Int
                let artist:String = songData.object(forKey: "artist") as! String
                
                let country:String? = songData.object(forKey: "country") as? String
                self.genricLbl.text = String(format: "%@",country ?? "")
                
                
                if(self.lblTitle.text != trackTitle){
                    //self.lblTitle.text = trackTitle
                    self.lblTitle.text = artist.isEmpty == true ? "Unknown Artist" : artist
                    self.artistLbl.text = trackTitle
                    
                    self.diskImage.sd_setImage(with: URL(string: trackImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), placeholderImage: #imageLiteral(resourceName: "Play"))
//                    ImageLoader.sharedLoader.imageForUrl(trackImage, completionHandler: { (image, url) in
//                        if(image != nil){
//                            self.diskImage.image = image
//                        }
//                    })
                }
            }
            
            
            
        }else{
            self.checkAudioStatus(button: buttonDemo)
        }
    
    }
    
    
    func checkAudioStatus(button:UIButton){
        if AudioPlayerModel.shared.jukebox.state == .ready {
            button.setImage(UIImage(named: "Play")!, for: UIControlState())
        } else if AudioPlayerModel.shared.jukebox.state == .loading  {
            button.setImage(UIImage(named: "Pause")!, for: UIControlState())
        } else {
            
            let imageName: String
            switch AudioPlayerModel.shared.jukebox.state {
            case .playing, .loading:
                imageName = "Pause"
            case .paused, .failed, .ready:
                imageName = "Play"
            }
            button.setImage(UIImage(named: imageName)!, for: UIControlState())
        }
    }
    
    
    
    func setViews(){
    
        _ = JImage.shareInstance().setStatusBarDarkView(CGRect.init(x: 0, y: 0, width: screenWidth, height: 20), viewController: self)
        
        let view : UIView = UIView(frame: CGRect(x: 0,y: 20,width: screenWidth,height: statusBarHeight))
        view.backgroundColor = UIColor(red: 253/255.0, green: 217/255.0, blue: 88/255.0, alpha: 1)
        self.view.addSubview(view)

        viewTrans = UIView(frame: CGRect(x: 0,y: 20,width: screenWidth,height: screenHeight))
        viewTrans.backgroundColor = UIColor(red: 253/255.0, green: 217/255.0, blue: 88/255.0, alpha: 0.8)
        self.view.addSubview(viewTrans)
        
        
        imageViewTrans.removeFromSuperview()
        imageViewTrans  = UIImageView(frame: CGRect(x: 0, y: statusBarHeight, width: screenWidth, height: screenHeight))
        //imageViewTrans.alpha = 0.5
        imageViewTrans.contentMode = UIViewContentMode.scaleAspectFill
        imageViewTrans.clipsToBounds = true
        imageViewTrans.backgroundColor = UIColor.clear
        imageViewTrans.image = UIImage(named: "image_bg")
        self.view.addSubview(imageViewTrans)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = imageViewTrans.bounds
        
        let color1 = UIColor(red: 253/255.0, green: 207/255.0, blue: 64/255.0, alpha: 0.4).cgColor as CGColor
        let color2 = UIColor(red: 253/255.0, green: 207/255.0, blue: 64/255.0, alpha: 0.4).cgColor as CGColor
        let color3 = UIColor(red: 253/255.0, green: 207/255.0, blue: 64/255.0, alpha: 0.4).cgColor as CGColor
        let color4 = UIColor(red: 253/255.0, green: 212/255.0, blue: 80/255.0, alpha: 1.0).cgColor as CGColor
        gradientLayer.colors = [color1, color2, color3, color4]
        
        gradientLayer.locations = [0.0, 0.25, 0.75, 1.0]
        //imageViewTrans.layer.addSublayer(gradientLayer)
        
        
        
        
        var playList:String = (dictinfo.object(forKey: "title") == nil) ? "" : dictinfo.object(forKey: "title") as! String
        playList = playList.uppercased()
        
        lbl.frame = CGRect(x: screenWidth*(10/100),y: 30,width: screenWidth*(80/100),height: 30)
        lbl.backgroundColor = UIColor.clear
        lbl.text = playList
        lbl.textColor = UIColor.black
        lbl.backgroundColor = UIColor.clear
        lbl.numberOfLines = 3
        lbl.font = textFontHeader
        lbl.textAlignment = NSTextAlignment.center
        self.view.addSubview(lbl)
        
        
        
        if(UIDevice.current.userInterfaceIdiom == .phone){
            
            //imageView.hidden = true
            //imgSong.hidden = false
            //imgSong.image = UIImage(data: data!)
            
        }else if (UIDevice.current.userInterfaceIdiom == .pad){
            
//            imgSong.isHidden = true
//            imageView.isHidden = false
//            imageView.layer.borderWidth = 1.0
//            imageView.layer.cornerRadius = imageView.frame.size.width/2
//            imageView.clipsToBounds = true
//            imageView.image = UIImage(data: data!)
        }
        
        let width = screenWidth * 0.15
//        _ = screenWidth * 0.15
        let left = screenWidth/2 - width/2
        let top = screenHeight * 0.72
        buttonDemo.removeFromSuperview()
        buttonDemo = UIButton(frame: CGRect(x: left,y: top,width: screenHeight*(7.5/100),height: screenHeight*(7.5/100)))
        buttonDemo.backgroundColor = UIColor.clear
        buttonDemo.titleLabel?.font = textFontFPAl
        buttonDemo.backgroundColor = UIColor.clear
        buttonDemo.setTitleColor(UIColor(red: 154/255.0, green: 155/255.0, blue: 156/255.0, alpha: 1), for: UIControlState())
        buttonDemo.showsTouchWhenHighlighted = true
        buttonDemo.setImage(UIImage(named: "Pause")!, for: UIControlState())
        self.viewMid.addSubview(buttonDemo)
        
        
        let leftNext = screenWidth * 0.75
        
        buttonNext.removeFromSuperview()
        
        buttonNext = UIButton(frame: CGRect(x: leftNext,y: top,width: screenHeight*(7.5/100),height: screenHeight*(7.5/100)))
        buttonNext.backgroundColor = UIColor.clear
        buttonNext.titleLabel?.font = textFontFPAl
        buttonNext.backgroundColor = UIColor.clear
        buttonNext.setTitleColor(UIColor(red: 154/255.0, green: 155/255.0, blue: 156/255.0, alpha: 1), for: UIControlState())
        buttonNext.showsTouchWhenHighlighted = true
        buttonNext.setImage(UIImage(named: "Next")!, for: UIControlState())
        self.viewMid.addSubview(buttonNext)
        
        
        lblSkipCount.removeFromSuperview()
        lblSkipCount = UILabel.init(frame: buttonNext.frame)
        
        var frame = lblSkipCount.frame
        frame.origin.x = lblSkipCount.frame.origin.x + 28.0
        lblSkipCount.frame = frame
                
        lblSkipCount.textAlignment = .center
        lblSkipCount.text = "0"
        lblSkipCount.font = textFontFPAl
        lblSkipCount.textColor = UIColor(red: 140/255.0, green: 125/255.0, blue: 62/255.0, alpha: 1)
        lblSkipCount.backgroundColor = .clear
        lblSkipCount.isHidden = true
        self.viewMid.addSubview(lblSkipCount)
        
        
        lblCount.frame = CGRect(x: leftNext + width, y: top, width: screenWidth * 0.10, height: screenWidth * 0.15)
        lblCount.backgroundColor = UIColor.clear
        lblCount.text = ""
        lblCount.textAlignment = .left
        //self.viewMid.addSubview(lblCount)
        
        
        
        let lblCurrentTimerWidth = screenWidth * 0.30
        let lblCurrentTimerHeight = screenWidth * 0.15
        let lblCurrentTimerLeft = screenWidth * 0.03
        let lblCurrentTimerTop = screenHeight * 0.72
        lblCurrentTime.removeFromSuperview()
        lblCurrentTime = UILabel(frame: CGRect(x: lblCurrentTimerLeft,y: lblCurrentTimerTop,width: lblCurrentTimerWidth,height: lblCurrentTimerHeight))
        lblCurrentTime.backgroundColor = UIColor.red
        lblCurrentTime.textColor = UIColor(red: 140/255.0, green: 125/255.0, blue: 62/255.0, alpha: 1)
        
        let lblTimerWidth = screenWidth * 0.30
        let lblTimerHeight = screenWidth * 0.15
        let lblTimerLeft = screenWidth * (5/100)
        let lblTimerTop = screenHeight * 0.72
        lblTimer.removeFromSuperview()
        lblTimer = UILabel(frame: CGRect(x: lblTimerLeft,y: lblTimerTop,width: lblTimerWidth,height: lblTimerHeight))
        lblTimer.backgroundColor = UIColor.clear
        lblTimer.textColor = UIColor(red: 140/255.0, green: 125/255.0, blue: 62/255.0, alpha: 1)
        lblTimer.font = textFontTable
        
        let str = 0//arrayNew.objectAtIndex(0).valueForKey("duration") as? Int
        let ti = str
        let seconds:Double = Double ((ti/1000) % 60)
        let minutes:Double = Double((ti/(1000*60))%60)
        totalSec = minutes*60 + seconds
        
        total = String(format: "%0.2d:%0.2d",minutes,seconds)
        lblTimer.text = total
        lblTimer.backgroundColor = UIColor.clear
        lblTimer.textAlignment = NSTextAlignment.center
        self.viewMid.addSubview(lblTimer)
        
        
        //lblTitle.removeFromSuperview()
        lblTitle  = UILabel(frame: CGRect(x: screenWidth*(10/100),y: screenHeight*(56/100),width: screenWidth*(80/100),height: screenHeight*(3.8/100)))
        lblTitle.backgroundColor = UIColor.clear
        lblTitle.text = "Song title"
        
        
        let stringSize = (lblTitle.text! as NSString).size(attributes: [NSFontAttributeName:lblTitle.font])
        var fram = lblTitle.frame
        fram.size.height = stringSize.height + 10
        lblTitle.frame = fram
        
        lblTitle.clipsToBounds = false
        //lblTitle.text = arrayNew.objectAtIndex(0).valueForKey("title") as? String
        lblTitle.textColor = UIColor.black
        lblTitle.backgroundColor = UIColor.clear
        lblTitle.font = UIFont(name: "OpenSans", size: screenHeight * 0.034)
        lblTitle.numberOfLines = 1
        lblTitle.textAlignment = NSTextAlignment.center
        self.viewMid.addSubview(lblTitle)
        
        
        //artistLbl.removeFromSuperview()
        artistLbl  = UILabel(frame: CGRect(x: screenWidth*(10/100),y: lblTitle.frame.origin.y + lblTitle.frame.size.height,width: screenWidth*(80/100) ,height: screenHeight*(3.8/100)))
        artistLbl.clipsToBounds = false
        artistLbl.backgroundColor = UIColor.clear
        artistLbl.text = "Unknown Artist"
        //lblTitle.text = arrayNew.objectAtIndex(0).valueForKey("title") as? String
        artistLbl.textColor = UIColor.black
        artistLbl.backgroundColor = UIColor.clear
        artistLbl.font = UIFont(name: "OpenSans-Bold", size: screenHeight * 0.028)
        artistLbl.numberOfLines = 1
        artistLbl.textAlignment = NSTextAlignment.center
        self.viewMid.addSubview(artistLbl)
        
        
        
        //genricLbl.removeFromSuperview()
        genricLbl  = UILabel(frame: CGRect(x: screenWidth*(10/100),y: artistLbl.frame.origin.y + artistLbl.frame.size.height , width: screenWidth*(80/100), height: screenHeight*(3.8/100)))
        genricLbl.backgroundColor = UIColor.clear
        genricLbl.text = "Country"
        genricLbl.textColor = UIColor.black
        genricLbl.backgroundColor = UIColor.clear
        genricLbl.font = UIFont(name: "OpenSans", size: screenHeight * 0.028)
        genricLbl.numberOfLines = 1
        genricLbl.textAlignment = NSTextAlignment.center
        self.viewMid.addSubview(genricLbl)
        
        
        
        
        buttonDislike = UIButton(frame: CGRect(x: screenWidth*(17/100),y: screenHeight*(49/100),width: screenHeight*(4.5/100),height: screenHeight*(4.5/100)))
        buttonDislike.backgroundColor = UIColor.clear
        buttonDislike.titleLabel?.font = textFontFPAl
        buttonDislike.setTitleColor(UIColor(red: 154/255.0, green: 155/255.0, blue: 156/255.0, alpha: 1), for: UIControlState())
        buttonDislike.backgroundColor = UIColor.clear
        // buttonStar.tag = 0
        buttonDislike.showsTouchWhenHighlighted = true
        buttonDislike.setImage(UIImage(named: "DislikeUnfill")!, for: UIControlState())
        buttonDislike.addTarget(self, action: #selector(JPlayerVC.buttonDislikeTapped(_:)), for: UIControlEvents.touchUpInside)
        self.viewMid.addSubview(buttonDislike)
        
        
        
        buttonlike = UIButton(frame: CGRect(x: screenWidth*(83/100) - screenHeight*(4.5/100), y: screenHeight*(49/100),width: screenHeight*(4.5/100),height: screenHeight*(4.5/100)))
        buttonlike.backgroundColor = UIColor.clear
        buttonlike.titleLabel?.font = textFontFPAl
        buttonlike.setImage(UIImage(named: "LikeUnfill")!, for: UIControlState())
        buttonlike.setTitleColor(UIColor(red: 154/255.0, green: 155/255.0, blue: 156/255.0, alpha: 1), for: UIControlState())
        buttonlike.backgroundColor = UIColor.clear
        buttonlike.showsTouchWhenHighlighted = true
        
        
        
        buttonlike.addTarget(self, action: #selector(JPlayerVC.buttonlikeTapped(_:)), for: UIControlEvents.touchUpInside)
        self.viewMid.addSubview(buttonlike)
        
        
        buttonStar = UIButton(frame: CGRect(x: screenWidth - screenHeight*(3.5/100) - 15,y: 30,width: screenHeight*(3.5/100),height: screenHeight*(3.5/100)))
        buttonStar.backgroundColor = UIColor.clear
        buttonStar.titleLabel?.font = textFontFPAl
        buttonStar.setTitleColor(UIColor(red: 154/255.0, green: 155/255.0, blue: 156/255.0, alpha: 1), for: UIControlState())
        buttonStar.backgroundColor = UIColor.clear
        buttonStar.showsTouchWhenHighlighted = true
        
        if(Favtag == 0){
            var imageStar : UIImage = UIImage()
            imageStar = UIImage(named: "starUnfill")!
            buttonStar.setImage(imageStar, for: UIControlState.normal)
            buttonStar.tag = 0
            
        }else if(Favtag == 1){
            var imageStar : UIImage = UIImage()
            imageStar = UIImage(named: "Starfill")!
            buttonStar.setImage(imageStar, for: UIControlState.normal)
            buttonStar.tag = 1
        }
        
        self.viewMid.addSubview(buttonStar)
        
        buttonStar.addTarget(self, action: #selector(JPlayerVC.StarViewTapped(_:)), for: UIControlEvents.touchUpInside)
        buttonDemo.addTarget(self, action: #selector(JPlayerVC.playerButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        buttonNext.addTarget(self, action: #selector(JPlayerVC.NextButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(JPlayerVC.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeRight.numberOfTouchesRequired = 1
        swipeRight.delegate = self
        self.view.addGestureRecognizer(swipeRight)
        
//        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(JPlayerVC.respondToSwipeGesture(_:)))
//        swipeDown.direction = UISwipeGestureRecognizerDirection.left
//        swipeDown.delegate = self
//        self.view.addGestureRecognizer(swipeDown)
        
        let lblRate : UILabel = UILabel()
        let lblRateWidth = screenWidth * 0.30
        let lblRateHeight = screenHeight * 0.05
        let lblRateLeft = screenWidth/2 - lblRateWidth/2
        let lblRateTop = screenHeight * 0.70 + screenWidth * 0.15 + screenHeight * 0.02
        
        lblRate.frame = CGRect(x: lblRateLeft, y: lblRateTop, width: lblRateWidth, height: lblRateHeight)
        lblRate.backgroundColor = UIColor.clear
        lblRate.text = "Rate This Track"
        lblRate.textAlignment = .center
        lblRate.font = textRateThisTrack
        lblRate.textColor = UIColor.black
        self.viewMid.addSubview(lblRate)
        
        
        floatRatingView.frame = CGRect(x: screenWidth/2 - screenWidth*(14/100) , y: lblRateTop + lblRateHeight, width: screenWidth*(28/100), height: screenWidth*(5.5/100))
        floatRatingView.emptyImage = UIImage(named: "starUnfillGreen")
        floatRatingView.fullImage = UIImage(named: "Starfill")
        floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        floatRatingView.maxRating = 5
        floatRatingView.minRating = 0
        floatRatingView.rating = 0.0
        floatRatingView.editable = true
        floatRatingView.halfRatings = false
        floatRatingView.floatRatings = false
        floatRatingView.delegate = self
        self.viewMid.addSubview(floatRatingView)
        
        let shareWidth = screenWidth * 0.08
        let shareHeight = screenWidth * 0.08
        let shareLeft = screenWidth * 0.88
        let buttonShare : UIButton = UIButton(frame: CGRect(x: shareLeft,y: lblRateTop + lblRateHeight/2,width: shareWidth,height: shareHeight))
        var imageShare : UIImage = UIImage()
        imageShare = UIImage(named: "Share")!
        buttonShare.setImage(imageShare, for: UIControlState())
        buttonShare.addTarget(self, action: #selector(JPlayerVC.buttonShareTapped(_:)), for: UIControlEvents.touchUpInside)
        self.viewMid.addSubview(buttonShare)
        
        
        viewMid.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.view.addSubview(viewMid)
        
        
        
        diskImage.frame = CGRect(x: screenWidth/2 - screenHeight*(15/100), y: screenHeight*(15/100), width: screenHeight*(30/100), height: screenHeight*(30/100))
        diskImage.backgroundColor = UIColor.gray
        diskImage.layer.cornerRadius = diskImage.frame.size.height/2
        diskImage.clipsToBounds = true
        self.view.addSubview(diskImage)
        
        
        let sliderImageFrame:CGRect = CGRect(x: screenWidth/2 - screenHeight*(15/100) - 5, y: screenHeight*(15/100) - 5, width: screenHeight*(30/100) + 10, height: screenHeight*(30/100) + 10)
        
        
        let slide_V:UIView = UIView()
        slide_V.frame = sliderImageFrame
        self.view.addSubview(slide_V)
        
        
        let attributes = [
            /* Track */
            Attributes.minTrackTint(UIColor(hex : 0x379187 , alpha : 1)),
            Attributes.maxTrackTint(UIColor(hex : 0xFFE58E , alpha : 1)),
            Attributes.trackWidth(5),
            Attributes.trackShadowRadius(0),
            Attributes.trackShadowDepth(0),
            Attributes.trackMinAngle(0),
            Attributes.trackMaxAngle(360),
            
            /* Thumb */
            Attributes.hasThumb(true),
            Attributes.thumbTint(UIColor(hex : 0x46D8C6, alpha : 1)),
            Attributes.thumbRadius(5),
            Attributes.thumbShadowRadius(2),
            Attributes.thumbShadowDepth(3.5)
        ]
        
        self.slider_image = MTCircularSlider(frame: slide_V.bounds)
        self.slider_image.value = 0
        self.slider_image.valueMaximum = 1
        self.slider_image.configure(attributes)
        //self.slider_image.isContinuous = true
        self.slider_image.isUserInteractionEnabled = false
        slide_V.addSubview(self.slider_image)
        slide_V.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        
        diskLayer.frame = CGRect(x: screenWidth/2 - screenHeight*(4.5/100), y: screenHeight*(25.5/100), width: screenHeight*(9/100), height: screenHeight*(9/100))
        diskLayer.backgroundColor = UIColor.clear.cgColor
        diskLayer.borderColor = UIColor(hex: 0xFFFFFF, alpha: 0.45).cgColor
        diskLayer.borderWidth = screenHeight*(2.5/100)
        diskLayer.cornerRadius = diskLayer.frame.size.width/2
        self.view.layer.addSublayer(diskLayer)
        
        
        //buttonSideView = UIButton(frame: CGRect(x: 15,y: 30,width: screenHeight*(3.5/100),height: screenHeight*(3.5/100)))
        buttonSideView = UIButton(frame: CGRect(x: 15,y: 30,width:25,height: 25))
        buttonSideView.backgroundColor = UIColor.clear
        buttonSideView.titleLabel?.font = textFontFPAl
        buttonSideView.setTitleColor(UIColor(red: 154/255.0, green: 155/255.0, blue: 156/255.0, alpha: 1), for: UIControlState())
        buttonSideView.backgroundColor = UIColor.clear
        buttonSideView.showsTouchWhenHighlighted = true
        buttonSideView.setImage(UIImage(named: "SideButton")!, for: UIControlState())
        buttonSideView.addTarget(self, action: #selector(self.homeBtnTapped), for: UIControlEvents.touchUpInside)
        self.view.addSubview(buttonSideView)
        
        self.checkIsFavorite()
        
        if self.comeFrom == "search" {
            getPlaylistFromSearch()
        } else if self.comeFrom == "playlistnotification" {
            getPlaylistById()
        } else if self.comeFrom == "tracknotification" {
            getTrackById()
        } else {
            getPlayListSongs()
        }
    }
    
    func homeBtnTapped()  {
        SideView.sharedInstance().vController = self
        SideView.sharedInstance().setSideView()
        SideView.sharedInstance().openView()
    }
    
    func checkIsFavorite(){
    
        let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [playlistIDPlayer], forKeys: ["playlist_id" as NSCopying]);
        
        let strFunctionName = Constants().kCheckFavorite
        
        WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
            
            print("responseObject :::: \(responseObject)")
            
            
            let isOk:Bool =  responseObject.object(forKey: "is_favourite") as! Bool
            
            if(isOk == true){
                var imageStar : UIImage = UIImage()
                imageStar = UIImage(named: "Starfill")!
                self.buttonStar.setImage(imageStar, for: UIControlState.normal)
                self.buttonStar.tag = 1
                
            }else{
                var imageStar : UIImage = UIImage()
                imageStar = UIImage(named: "starUnfill")!
                self.buttonStar.setImage(imageStar, for: UIControlState.normal)
                self.buttonStar.tag = 0
            }
            
            
        }) { (error, operation) -> Void in
            
        }
        
    }
    
    
    
    func likeDisLke_Favorite(){
        
        
        if(LikeNDislikeTag == 0){
            // LikeFill , LikeUnfill , DislikeUnfill , DislikeFill
            var imagelike : UIImage = UIImage()
            imagelike = UIImage(named: "LikeFill")!
            buttonlike.setImage(imagelike, for: UIControlState())
            
            var imageDislike : UIImage = UIImage()
            imageDislike = UIImage(named: "DislikeUnfill")!
            buttonDislike.setImage(imageDislike, for: UIControlState())
            
            buttonlike.tag = 1
            buttonDislike.tag = 0
            
        }else if(LikeNDislikeTag == 1){
            // LikeFill , LikeUnfill , DislikeUnfill , DislikeFill
            buttonlike.setImage(UIImage(named: "LikeUnfill")!, for: UIControlState())
            buttonDislike.setImage(UIImage(named: "DislikeFill")!, for: UIControlState())
            
            buttonlike.tag = 0
            buttonDislike.tag = 1
        }else if(LikeNDislikeTag == 2){
            // LikeFill , LikeUnfill , DislikeUnfill , DislikeFill
            buttonlike.setImage(UIImage(named: "LikeUnfill")!, for: UIControlState())
            buttonDislike.setImage(UIImage(named: "DislikeUnfill")!, for: UIControlState())
            
            buttonlike.tag = 0
            buttonDislike.tag = 0
        }
    }
    
    
    func getPlaylistFromSearch() {
    
        if(dataFromSearch != nil){
            
            let playlistData:NSMutableDictionary = dataFromSearch.mutableCopy() as! NSMutableDictionary
            
            dictinfo = playlistData
            
            AudioPlayerModel.shared.intializePlaylistData(playlistData)
            
            var playList:String = dictinfo.object(forKey: "title") as! String
            playList = playList.uppercased()
            
            AudioPlayerModel.shared.playlistName = playList
            AudioPlayerModel.shared.playlistID = self.playlistIDPlayer
            
            let dictData:NSMutableDictionary = AudioPlayerModel.shared.getCurentIndexData()
            
            print("dictData dictData dictData  :::::   \(dictData)")
            
            
            if(dictData.object(forKey: "status") as! String == "success"){
                
                let songData = dictData.object(forKey: "data") as! NSMutableDictionary
//                let _:String = songData.object(forKey: "track_id") as! String
                let trackImage:String = songData.object(forKey: "track_image") as! String
//                let _:  Int = songData.object(forKey: "generic") as! String
                let artist:String = songData.object(forKey: "artist") as! String
                let trackTitle:String = songData.object(forKey: "track_title") as! String
                
                if let trackTitle:String = songData.object(forKey: "track_title") as? String{
                    print("trackTitle :::: \(trackTitle)")
                    self.lblTitle.text = artist.isEmpty == true ? "Unknown Artist" : artist
                }
                
                let country:String? = songData.object(forKey: "country") as? String
                self.genricLbl.text = String(format: "%@",country ?? "")
                
                self.lbl.text = playList
                self.artistLbl.text = trackTitle
                
                self.diskImage.sd_setImage(with: URL(string: trackImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), placeholderImage: #imageLiteral(resourceName: "Play"))
                
                AudioPlayerModel.shared.listenSongAPI()
                self.getLikeDislike()
                self.getTerackRating()
            }
            
        } else {
            obj_app.getAlert("Playlist is empty!")
        }
    }
    
    func getTrackById() {
        
        let strFunctionName = "api/gettracksbyid"
        
        if(AudioPlayerModel.shared.jukebox != nil){
            AudioPlayerModel.shared.pauseAudio()
        }
        
        AudioPlayerModel.shared.playlistID = self.playlistIDPlayer
        WebService.callGetServicewithStringPerameters(StringPerameter: "?track_id=\(self.playlistIDPlayer ?? 0)", FunctionName: strFunctionName, succes: { (responseData, operation) in
            
            AudioPlayerModel.shared.playListSongArray.removeAllObjects()
            
            if responseData.object(forKey: "status_text") as! String == "Success" {
                
                let trackObject:NSDictionary = responseData.object(forKey: "track") as! NSDictionary
                
                if (trackObject.object(forKey: "streamable") as? Bool == true){
                    
                    let songUrl_1:String =  trackObject.object(forKey: "stream_url") as! String
                    let songUrl = songUrl_1
                    
                    let trackID = trackObject.object(forKey: "id") as! Int
                    
                    let titleValue = trackObject.object(forKey: "title") as! String
                    let country:String? = (trackObject.object(forKey: "country") ?? "Country") as? String
                    let genric = trackObject.object(forKey: "genre") == nil ? "" : trackObject.object(forKey: "genre") as Any
                    let artist = (trackObject.object(forKey: "artist") == nil || trackObject.object(forKey: "artist") is NSNull ) ? "" : trackObject.object(forKey: "artist") as! String
                    
                    var urlImage:String = (trackObject.object(forKey: "artwork_url") == nil || trackObject.object(forKey: "artwork_url") is NSNull) ? "http://ec2-52-91-211-72.compute-1.amazonaws.com/library/album_art/art.png" : trackObject.object(forKey: "artwork_url") as! String
                    let playlistName:String? = (trackObject.object(forKey: "playlist_name") ?? "Unknown Playlist") as? String
                    
                    self.artistLbl.text = artist
                    self.genricLbl.text = String(format: "%@",country ?? "")
                    self.lbl.text = playlistName?.uppercased()
                    self.lblTitle.text = titleValue
                    self.diskImage.sd_setImage(with: URL(string: urlImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), placeholderImage: #imageLiteral(resourceName: "Play"))
                    
                    urlImage = urlImage.replacingOccurrences(of: "-large.", with: "-t500x500.")
                    
                    let songDict:NSMutableDictionary = ["track_id":"\(trackID)","track_url":"\(songUrl)","track_image":"\(urlImage)","track_title":"\(titleValue)","generic":genric,"artist":artist, "country": country ?? "Country", "playlist_name": playlistName ?? "Unknown Playlist"]
                    
                    AudioPlayerModel.shared.playlistName = playlistName ?? "Unknown Playlist"
                    AudioPlayerModel.shared.playListSongArray.add(songDict)
                    
                    print("PlayListSongArray before shuffle  ::::  \(AudioPlayerModel.shared.playListSongArray)")
                    
                    AudioPlayerModel.shared.playListSongArray.shuffle()
                    AudioPlayerModel.shared.listenSongAPI()
                    
                    print("PlayListSongArray after shuffle  ::::  \(AudioPlayerModel.shared.playListSongArray)")
                    AudioPlayerModel.shared.addItemsToJuckbox()
                    
                }
            } else {
                self.navigationController?.popViewController(animated: true)
                self.alertViewFromApp(messageString: "Track not found!")
            }
            
        }) { (error, operation) in
            
        }
    }
    
    func getPlaylistById() {
        
        let strFunctionName = "api/getplaylistbyid"
        
        if(AudioPlayerModel.shared.jukebox != nil){
            AudioPlayerModel.shared.pauseAudio()
        }
        
        AudioPlayerModel.shared.playlistID = self.playlistIDPlayer
        WebService.callGetServicewithStringPerameters(StringPerameter: "?playlist_id=\(self.playlistIDPlayer ?? 0)", FunctionName: strFunctionName, succes: { (responseObject, operation) in
            
            print("playlist Object :::: \(responseObject)")
            AudioPlayerModel.shared.playListSongArray.removeAllObjects()
            
            if responseObject.object(forKey: "status_text") as! String == "Success" {
                
                let x: AnyObject = NSNull()
                
                if(responseObject.object(forKey: "playlist") != nil && responseObject.object(forKey: "playlist") != x as! _OptionalNilComparisonType ){
                    
                    let pl_data:NSDictionary = responseObject.object(forKey: "playlist") as! NSDictionary
                    
                    let playlistData:NSMutableDictionary = pl_data.mutableCopy() as! NSMutableDictionary
                    
                    dictinfo = playlistData
                    
                    AudioPlayerModel.shared.intializePlaylistData(playlistData)
                    
                    if ((dictinfo.object(forKey: "tracks") as? NSArray)?.count) ?? 0 == 0 {
                        obj_app.alertViewFromApp(messageString: "Playlist is empty!")
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        
                        var playList:String = dictinfo.object(forKey: "name") as! String
                        playList = playList.uppercased()
                        
                        self.lbl.text = playList
                        AudioPlayerModel.shared.playlistName = playList
                        
                        var strTrackCount : Int = Int()
                        strTrackCount = (dictinfo.object(forKey: "track_count") as? Int)!
                        
                        
                        if(strTrackCount == 0){
                            obj_app.getAlert("Playlist is empty. Please choose another playlist!")
                        }else{
                            
                            let dictData:NSMutableDictionary = AudioPlayerModel.shared.getCurentIndexData()
                            
                            print("dictData dictData dictData  :::::   \(dictData)")
                            
                            
                            if(dictData.object(forKey: "status") as! String == "success") {
                                
                                let songData = dictData.object(forKey: "data") as! NSMutableDictionary
                                let trackID:String = songData.object(forKey: "track_id") as! String
                                let trackImage:String = songData.object(forKey: "track_image") as! String
//                                let _ = songData.object(forKey: "generic") as! String
                                let artist:String = songData.object(forKey: "artist") as! String
                                let trackTitle:String = songData.object(forKey: "track_title") as! String
                                
                                AudioPlayerModel.shared.songID = trackID
                                AudioPlayerModel.shared.listenSongAPI()
                                
                                if let _:String = songData.object(forKey: "track_title") as? String {
                                    
                                    //print("trackTitle :::: \(trackTitle)")
                                    self.lblTitle.text = artist.isEmpty == true ? "Unknown Artist" : artist
                                }
                                
                                let country:String? = songData.object(forKey: "country") as? String
                                self.genricLbl.text = String(format: "%@",country ?? "")
                                
                                self.artistLbl.text = trackTitle
                                
                                self.diskImage.sd_setImage(with: URL(string: trackImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), placeholderImage: #imageLiteral(resourceName: "Play"))
                                
                                self.getLikeDislike()
                                self.getTerackRating()
                            }
                        }
                        
                    }
                    
                }else{
                    obj_app.alertViewFromApp(messageString: "Playlist is empty!")
                    self.navigationController?.popViewController(animated: true)
                }
                
            } else {
                obj_app.alertViewFromApp(messageString: "Playlist is empty!")
                self.navigationController?.popViewController(animated: true)
            }
            
        }) { (error, operation) in
            obj_app.alertViewFromApp(messageString: error.localizedDescription)
        }
       
        
    }
    
    func getPlayListSongs(){
    
        let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [playlistIDPlayer,strUSerID!.intValue], forKeys: ["playlist_id" as NSCopying,"user_id" as NSCopying]);
        let strFunctionName = "api/getplaylisttracks"
//        "playlist_songs"
        
        if(AudioPlayerModel.shared.jukebox != nil){
            AudioPlayerModel.shared.pauseAudio()
        }
        
        
        
        WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
            
            print("playlist Object :::: \(responseObject)")
            
            //self.Favtag = (responseObject.object(forKey: "favorite") as? Int)!
            //self.LikeNDislikeTag = (responseObject.object(forKey: "like") as? Int)!
            
            //self.likeDisLke_Favorite()
            
            let x: AnyObject = NSNull()
            
            if(responseObject.object(forKey: "playlist") != nil && responseObject.object(forKey: "playlist") != x as! _OptionalNilComparisonType ){
            
                let pl_data:NSDictionary = responseObject.object(forKey: "playlist") as! NSDictionary
                
                let playlistData:NSMutableDictionary = pl_data.mutableCopy() as! NSMutableDictionary
                
                dictinfo = playlistData
                
                AudioPlayerModel.shared.intializePlaylistData(playlistData)
                
                var playList:String = dictinfo.object(forKey: "title") as! String
                playList = playList.uppercased()
                
                self.lbl.text = playList
                AudioPlayerModel.shared.playlistName = playList
                AudioPlayerModel.shared.playlistID = self.playlistIDPlayer
                
                var strTrackCount : Int = Int()
                strTrackCount = (dictinfo.object(forKey: "track_count") as? Int)!
                
                
                if(strTrackCount == 0){
                    obj_app.getAlert("Playlist is empty. Please choose another playlist!")
                }else{
                    
                    let dictData:NSMutableDictionary = AudioPlayerModel.shared.getCurentIndexData()
                    
                    print("dictData dictData dictData  :::::   \(dictData)")
                    
                    
                    if(dictData.object(forKey: "status") as! String == "success"){
                        
                        let songData = dictData.object(forKey: "data") as! NSMutableDictionary
                        let trackID:String = songData.object(forKey: "track_id") as! String
                        let trackImage:String = songData.object(forKey: "track_image") as! String
//                        let genric:Int = songData.object(forKey: "generic") as! Int
                        let artist:String = songData.object(forKey: "artist") as! String
                        let trackTitle:String = songData.object(forKey: "track_title") as! String
                        let country:String? = songData.object(forKey: "country") as? String
                        
                        AudioPlayerModel.shared.songID = trackID
                        
                        if let _:String = songData.object(forKey: "track_title") as? String{
                            
                            //print("trackTitle :::: \(trackTitle)")
                            self.lblTitle.text = artist.isEmpty == true ? "Unknown Artist" : artist
                        }
                        
                        self.genricLbl.text = String(format: "%@",country ?? "")
                        self.artistLbl.text = trackTitle
                        
                        self.diskImage.sd_setImage(with: URL(string: trackImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), placeholderImage: #imageLiteral(resourceName: "Play"))
//                        ImageLoader.sharedLoader.imageForUrl(trackImage, completionHandler: { (image, url) in
//                            if(image != nil){
//                                self.diskImage.image = image
//                            }
//                        })
                        
                        self.getLikeDislike()
                        self.getTerackRating()
                    }
                }
                
                
            }else{
                obj_app.getAlert("Playlist is empty!")
            }
            
        }) { (error, operation) -> Void in
            
            //player?.pause()
            NSLog("Error.. No Tracks in playlist")
            obj_app.getAlert("Playlist is empty!")
        }
    }
    
    func getLikeDislike(){
    
        let current_Data:NSDictionary = AudioPlayerModel.shared.getCurentIndexData()
        
        print("current_Data  :::  \(current_Data)")
        
        
        if((current_Data.object(forKey: "status") as! String) == "success"){
            
            let songData = current_Data.object(forKey: "data") as! NSMutableDictionary
            let trackID:String = songData.object(forKey: "track_id") as! String
            
            let strFunctionName = "api/like_dislike_data" // like_dislike_data
            let perameteres : NSMutableDictionary = NSMutableDictionary(objects: [strUSerID!.intValue,trackID.intValue], forKeys: ["user_id" as NSCopying ,"track_id" as NSCopying]);
            
            print("perameteres ::: \(perameteres)")
            
            WebServiceSilent.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
                
                print("responseObject get rating ::: \(responseObject)")
                
                let dict = responseObject as NSDictionary
                let isOk =  dict.object(forKey: "status_code") as! NSNumber
                
                if(isOk == 1){
                    if(dict.object(forKey: "like") != nil){
                        let isLike = (dict.object(forKey: "like") as? Int)!
                        let isDisLike = (dict.object(forKey: "dislike") as? Int)!
                        
                        if(isLike == 1 && isDisLike == 0){
                            var imagelike : UIImage = UIImage()
                            imagelike = UIImage(named: "LikeFill")!
                            self.buttonlike.setImage(imagelike, for: UIControlState())
                            
                            var imageDislike : UIImage = UIImage()
                            imageDislike = UIImage(named: "DislikeUnfill")!
                            self.buttonDislike.setImage(imageDislike, for: UIControlState())
                            
                            self.buttonlike.tag = 1
                            self.buttonDislike.tag = 0
                        }else if(isLike == 0 && isDisLike == 1){
                            var imagelike : UIImage = UIImage()
                            imagelike = UIImage(named: "LikeUnfill")!
                            self.buttonlike.setImage(imagelike, for: UIControlState())
                            
                            var imageDislike : UIImage = UIImage()
                            imageDislike = UIImage(named: "DislikeFill")!
                            self.buttonDislike.setImage(imageDislike, for: UIControlState())
                            
                            self.buttonlike.tag = 0
                            self.buttonDislike.tag = 1
                        }else{
                            var imagelike : UIImage = UIImage()
                            imagelike = UIImage(named: "LikeUnfill")!
                            self.buttonlike.setImage(imagelike, for: UIControlState())
                            
                            
                            var imageDislike : UIImage = UIImage()
                            imageDislike = UIImage(named: "DislikeUnfill")!
                            self.buttonDislike.setImage(imageDislike, for: UIControlState())
                            
                            self.buttonlike.tag = 0
                            self.buttonDislike.tag = 0
                        }
                    }
                    
                }
            }) { (error, operation) -> Void in
                
                NSLog("Failed to get Avg Rating")
            }
        }
    }
    
    
    
    func getTerackRating(){
    
        let current_Data:NSDictionary = AudioPlayerModel.shared.getCurentIndexData()
        
        print("current_Data  :::  \(current_Data)")
        
        
        if((current_Data.object(forKey: "status") as! String) == "success"){
        
            let songData = current_Data.object(forKey: "data") as! NSMutableDictionary
            let trackID:String = songData.object(forKey: "track_id") as! String
            
            let strFunctionName = "api/view_rate_track"
            let perameteres : NSMutableDictionary = NSMutableDictionary(objects: [strUSerID!.intValue,trackID.intValue], forKeys: ["user_id" as NSCopying ,"track_id" as NSCopying]);
            
            print("perameteres ::: \(perameteres)")
            
            WebServiceSilent.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
                
                print("responseObject get rating ::: \(responseObject)")
                
                
                let dict = responseObject as NSDictionary
                let isOk =  dict.object(forKey: "status_code") as! NSNumber
                
                if(isOk == 1){
                    if(dict.object(forKey: "avg_rating") != nil){
                        self.strAvgRating = (dict.object(forKey: "user_rating") as? Double)!
                        self.floatRatingView.rating = "\(self.strAvgRating!)".floatValue
                    }
                }
            }) { (error, operation) -> Void in
                
                NSLog("Failed to get Avg Rating")
            }
        }
    }
    
    
    
    
    func SideViewTapped(_ sender:UIButton){
        
        SideView.sharedInstance().vController = self
        SideView.sharedInstance().setSideView()
        SideView.sharedInstance().openView()
    }
    
    
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        let curentReting:Float = floatRatingView.rating
        
        let current_Data:NSDictionary = AudioPlayerModel.shared.getCurentIndexData()
        
        print("current_Data  :::  \(current_Data)")
        
        
        if((current_Data.object(forKey: "status") as! String) == "success"){
            
            let currentData:NSDictionary = current_Data.object(forKey: "data") as! NSDictionary
            let track_id : Int = (currentData.object(forKey: "track_id") as! String).intValue
            
            let strFunctionName = "api/rate_track"
            let perameteres : NSMutableDictionary! = NSMutableDictionary(objects: [strUSerID!.intValue,track_id,curentReting], forKeys: ["user_id" as NSCopying,"track_id" as NSCopying,"rating" as NSCopying]);
            
            print("perameteres ::::::  \(String(describing: perameteres))")
            
            
            WebServiceSilent.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes: { (responseObject:NSMutableDictionary, operation:AFHTTPRequestOperation) in
                
                print("responseObject for rating  :::::   \(responseObject)")
                
                
                let dict = responseObject as NSDictionary
                let isOk =  dict.object(forKey: "status_code") as! NSNumber
                
                if(isOk == 1){
                    if(dict.object(forKey: "avg_rating") != nil){
                        //self.strAvgRating = (dict.object(forKey: "avg_rating") as? Double)!
                        //self.floatRatingView.rating = "\(self.strAvgRating!)".floatValue
                    }
                }
                
                
                }, orError: { (error:NSError, operation:AFHTTPRequestOperation) in
                    
                    NSLog("Failed to get Avg Rating ::::   \(error)")
            })
        }
    }
    
    
    
    
    func buttonShareTapped(_ sender: UIButton){
        
        var share : NSString = NSString()
        share = "https://itunes.apple.com/us/app/jwompa/id1169485576?ls=1&mt=8"
        
        let objectsToShare :NSArray = NSArray(object: share)
        let controller :UIActivityViewController = UIActivityViewController(activityItems: objectsToShare as [AnyObject], applicationActivities: nil)
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
            self.present(controller, animated: true, completion: nil)
        } else { //if iPad
            // Change Rect to position Popover
            let popoverCntlr = UIPopoverController(contentViewController: controller)
            popoverCntlr.present(from: CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/4, width: 0, height: 0), in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            
        }
    }
        
    
    func buttonlikeTapped(_ sender:UIButton){
        
        let current_Data:NSDictionary = AudioPlayerModel.shared.getCurentIndexData()
        
        print("current_Data  :::  \(current_Data)")
        
        
        if((current_Data.object(forKey: "status") as! String) == "success"){
            
            let songData = current_Data.object(forKey: "data") as! NSMutableDictionary
            let trackID:String = songData.object(forKey: "track_id") as! String
            
            let strFunctionName = "api/like_dislike"
            let perameteres : NSMutableDictionary = NSMutableDictionary(objects: [strUSerID!.intValue,trackID.intValue,1], forKeys: ["user_id" as NSCopying ,"track_id" as NSCopying,"type" as NSCopying]);
            
            print("perameteres ::: \(perameteres)")
            
            WebServiceSilent.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
                
                let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
                
                if(isOk == true){
                    var imagelike : UIImage = UIImage()
                    imagelike = UIImage(named: "LikeFill")!
                    self.buttonlike.setImage(imagelike, for: UIControlState())
                    
                    var imageDislike : UIImage = UIImage()
                    imageDislike = UIImage(named: "DislikeUnfill")!
                    self.buttonDislike.setImage(imageDislike, for: UIControlState())
                    
                    self.buttonlike.tag = 1
                    self.buttonDislike.tag = 0
                    
                }
            }) { (error, operation) -> Void in
                
                NSLog("Failed to get Avg Rating")
            }
        }
    }
    
    
    
    func buttonDislikeTapped(_ sender:UIButton)
    {
        let current_Data:NSDictionary = AudioPlayerModel.shared.getCurentIndexData()
        
        print("current_Data  :::  \(current_Data)")
        
        
        if((current_Data.object(forKey: "status") as! String) == "success"){
            
            let songData = current_Data.object(forKey: "data") as! NSMutableDictionary
            let trackID:String = songData.object(forKey: "track_id") as! String
            
            let strFunctionName = "api/like_dislike"
            let perameteres : NSMutableDictionary = NSMutableDictionary(objects: [strUSerID!.intValue,trackID.intValue,0], forKeys: ["user_id" as NSCopying ,"track_id" as NSCopying,"type" as NSCopying]);
            
            print("perameteres ::: \(perameteres)")
            
            WebServiceSilent.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
                
                let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
                
                if(isOk == true){
                    var imagelike : UIImage = UIImage()
                    imagelike = UIImage(named: "LikeUnfill")!
                    self.buttonlike.setImage(imagelike, for: UIControlState())
                    
                    var imageDislike : UIImage = UIImage()
                    imageDislike = UIImage(named: "DislikeFill")!
                    self.buttonDislike.setImage(imageDislike, for: UIControlState())
                    
                    self.buttonlike.tag = 0
                    self.buttonDislike.tag = 1
                    
                }
            }) { (error, operation) -> Void in
                
                NSLog("Failed to get Avg Rating")
            }
        }
    }
    
    func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                //player?.pause()
                if self.swipeValidate == false {
                    self.swipeValidate = true
                    self.buttonSideView.isUserInteractionEnabled = false
                    self.navigationController?.popViewController(animated: true)
                }
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                
            default:
                break
            }
        }
    }
   
    
    
    func getCurrentDate()->Date{
        let date = Date()
        return  date
            
    }
    
    func timeDifference(_ startT:Int, pauseT: Int)->Int{
        let diffTime = pauseT - startT
        return diffTime
    }
    
    
    
    func StarViewTapped(_ sender:UIButton){
        
        if(buttonStar.tag == 0){
            
            let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [playlistIDPlayer], forKeys: ["playlist_id" as NSCopying]);
            
            let strFunctionName = Constants().kAddFavorite
            
            WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
                
                print("responseObject :::: \(responseObject)")
                
                let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
                
                if(isOk == true){
                    var imageStar : UIImage = UIImage()
                    imageStar = UIImage(named: "Starfill")!
                    self.buttonStar.setImage(imageStar, for: UIControlState.normal)
                    self.buttonStar.tag = 1
                    
                }else{
                    var imageStar : UIImage = UIImage()
                    imageStar = UIImage(named: "starUnfill")!
                    self.buttonStar.setImage(imageStar, for: UIControlState.normal)
                    self.buttonStar.tag = 0
                }
                
                
            }) { (error, operation) -> Void in
                
            }
            
        }else if(buttonStar.tag == 1){
            
            let perameteres:NSMutableDictionary! = NSMutableDictionary(objects: [playlistIDPlayer], forKeys: ["playlist_id" as NSCopying]);
            
            let strFunctionName = Constants().kRemoveFavorite
            
            WebService.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
                
                NSLog("%@",  responseObject as NSMutableDictionary);
                let isOk:Bool =  responseObject.object(forKey: "status_code") as! Bool
                
                if(isOk == true){
                    var imageStar : UIImage = UIImage()
                    imageStar = UIImage(named: "starUnfill")!
                    self.buttonStar.setImage(imageStar, for: UIControlState.normal)
                    self.buttonStar.tag = 0
                    
                }else{
                    var imageStar : UIImage = UIImage()
                    imageStar = UIImage(named: "Starfill")!
                    self.buttonStar.setImage(imageStar, for: UIControlState.normal)
                    self.buttonStar.tag = 1
                }
            }) { (error, operation) -> Void in
                
            }
        }
    }
    
    func NextButtonTapped(_ sender:UIButton) {
        AudioPlayerModel.shared.handleSkipCountAndPlayNextSong()               
    }
    
    func playerButtonTapped(_ sender:UIButton) {
        
        guard let _ = AudioPlayerModel.shared.jukebox else { return }
        if(AudioPlayerModel.shared.jukebox.state == Jukebox.State.playing || AudioPlayerModel.shared.jukebox.state == Jukebox.State.loading){
            AudioPlayerModel.shared.pauseAudio()
            buttonDemo.setImage(UIImage(named: "Play")!, for: UIControlState())
        }else{
            AudioPlayerModel.shared.playAudio()
            buttonDemo.setImage(UIImage(named: "Pause")!, for: UIControlState())
        }
    }
    
    
    func setNavBar(){
        self.navigationController?.isNavigationBarHidden=true
        self.automaticallyAdjustsScrollViewInsets=false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("Player VC is being deinited")
    }
}

extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}

extension TimeInterval {
    var minuteSecondMS: String {
        return String(format:"%d:%02d", minute, second)
    }
    var minute: Int {
        return Int((self/60.0).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(self.truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000) )
    }
}

