//
//  PlayerView.swift
//  JWOMPA
//
//  Created by Ranjeet Singh on 28/09/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerView: UIView {

    var audioImage:UIImageView = UIImageView()
    var playListLBL:UILabel = UILabel()
    var trackNameLBL:MarqueeLabel = MarqueeLabel()
    var playBTN:UIButton = UIButton()
    var nextBTN:UIButton = UIButton()
    
    var slider:UISlider = UISlider()
    
    var height:CGFloat = 0
    var width:CGFloat = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 253/255, green: 217/255, blue: 88/255, alpha: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(self.PlayerHandler(_:)), name: NSNotification.Name(rawValue: "nextSong"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.PlayerHandler(_:)), name: NSNotification.Name(rawValue: "songProgress"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.PlayerHandler(_:)), name: NSNotification.Name(rawValue: "stateChanged"), object: nil)
        
        
        width = self.frame.width
        height = self.frame.height
        
        
        audioImage.frame = CGRect(x: height*(20/100), y: height*(10/100), width: height*(80/100), height: height*(80/100))
        self.addSubview(audioImage)
        
        let x = (audioImage.frame.size.height + audioImage.frame.origin.x) + 15
        trackNameLBL.frame = CGRect(x: x, y: height*(5/100), width: width - height*3, height: height*(45/100))
        trackNameLBL.textColor = UIColor.black
        trackNameLBL.type = .continuous
        trackNameLBL.unpauseLabel()
        trackNameLBL.speed = .duration(20)
        trackNameLBL.trailingBuffer = 30.0
        trackNameLBL.font = UIFont(name: "OpenSansLight-Italic", size: height*(25/100))
        self.addSubview(trackNameLBL)
        
        
        playListLBL.frame = CGRect(x: x, y: height*(50/100), width: width - height*3, height: height*(45/100))
        playListLBL.textColor = UIColor.black
        playListLBL.numberOfLines = 2
        playListLBL.font = UIFont(name: "OpenSans", size: screenHeight * 0.015)
        self.addSubview(playListLBL)
        
        
        playBTN.frame = CGRect(x: width - height*(190/100), y: height*(10/100), width: height*(80/100), height: height*(80/100))
        playBTN.addTarget(self, action: #selector(self.playTrack), for: UIControlEvents.touchUpInside)
        self.addSubview(playBTN)
        
        nextBTN.frame = CGRect(x: width - height*(90/100), y: height*(10/100), width: height*(80/100), height: height*(80/100))
        nextBTN.setImage(UIImage(named: "Next")!, for: UIControlState())
        nextBTN.addTarget(self, action: #selector(self.playNextTrack), for: UIControlEvents.touchUpInside)
        self.addSubview(nextBTN)
        
        
        slider.frame = CGRect(x: -2, y: -2, width: width+2, height: 4)
//        slider.tintColor = UIColor(hex: 0x409b92, alpha: 1)
        slider.thumbTintColor = UIColor.clear
        slider.maximumTrackTintColor = UIColor(hex: 0x107068, alpha: 1)
        slider.minimumTrackTintColor = UIColor(hex: 0x409b92, alpha: 1)
        slider.maximumValue = 0
        slider.minimumValue = 0
        slider.isContinuous = true
        slider.isUserInteractionEnabled = false
        self.addSubview(slider)
        
        self.checkTrack()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func checkTrack(){
    
        self.checkAudioStatus(button: playBTN)
        
        
        self.playListLBL.text = AudioPlayerModel.shared.playlistName.uppercased()
        let dictData:NSMutableDictionary = AudioPlayerModel.shared.getCurentIndexData()
        
        if(dictData.object(forKey: "status") as! String == "success"){
            
            let songData = dictData.object(forKey: "data") as! NSMutableDictionary
            let trackImage:String = songData.object(forKey: "track_image") as! String
            let trackTitle:String = songData.object(forKey: "track_title") as! String
            let artist:String = songData.object(forKey: "artist") as! String
            
            self.trackNameLBL.text = artist + " - \(trackTitle)"
            
            ImageLoader.sharedLoader.imageForUrl(trackImage, completionHandler: { (image, url) in
                if(image != nil){
                    self.audioImage.image = image
                }
            })
        }
    }
    
    
    func playTrack(){
        
        if(AudioPlayerModel.shared.jukebox == nil){
            return
        }
        
        if(AudioPlayerModel.shared.jukebox.state == Jukebox.State.playing || AudioPlayerModel.shared.jukebox.state == Jukebox.State.loading){
            AudioPlayerModel.shared.pauseAudio()
            playBTN.setImage(UIImage(named: "Play")!, for: UIControlState())
        }else{
            AudioPlayerModel.shared.playAudio()
            playBTN.setImage(UIImage(named: "Pause")!, for: UIControlState())
        }
    }
    
    func playNextTrack(){
        AudioPlayerModel.shared.handleSkipCountAndPlayNextSong()
    }
    
    
    
    func PlayerHandler(_ notification: Notification){
        
        if(AudioPlayerModel.shared.jukebox == nil){
            return
        }
        
        if (notification.name.rawValue  == "nextSong"){
            
            let songData = AudioPlayerModel.shared.getCurentIndexData()
            
            if(songData.object(forKey: "status") as! String == "success"){
                
                let song_Data = songData.object(forKey: "data") as! NSMutableDictionary
                let trackImage:String = song_Data.object(forKey: "track_image") as! String
                let trackTitle:String = song_Data.object(forKey: "track_title") as! String
                let data = songData.object(forKey: "data") as! [String:Any]
                let artist = data["artist"] as? String
                
                self.trackNameLBL.text = artist ?? "Unknown Artist" + " - \(trackTitle)"
                
                ImageLoader.sharedLoader.imageForUrl(trackImage, completionHandler: { (image, url) in
                    if(image != nil){
                        self.audioImage.image = image
                    }
                })
            }
            
        }else if(notification.name.rawValue  == "songProgress"){
            
            self.checkAudioStatus(button: playBTN)
            
            if let currentTime = AudioPlayerModel.shared.jukebox.currentItem?.currentTime, let duration = AudioPlayerModel.shared.jukebox.currentItem?.meta.duration {
                
                slider.maximumValue = Float(duration)
                slider.value = Float(currentTime)
            }
            
            let songData = AudioPlayerModel.shared.getCurentIndexData()
            
            if(songData.object(forKey: "status") as! String == "success"){
                
                let song_Data = songData.object(forKey: "data") as! NSMutableDictionary
                let trackImage:String = song_Data.object(forKey: "track_image") as! String
                let trackTitle:String = song_Data.object(forKey: "track_title") as! String
                let artist:String = song_Data.object(forKey: "artist") as! String
                
                self.trackNameLBL.text = artist + " - \(trackTitle)"
                
                ImageLoader.sharedLoader.imageForUrl(trackImage, completionHandler: { (image, url) in
                    if(image != nil){
                        self.audioImage.image = image
                    }
                })
            }
            
        }else{
            self.checkAudioStatus(button: playBTN)
        }
    }
    
    func checkAudioStatus(button:UIButton){
        
        if(AudioPlayerModel.shared.jukebox == nil){
            return
        }
        
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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
