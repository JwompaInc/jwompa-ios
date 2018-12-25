//
//  PlayerModel.swift
//  JWOMPA
//
//  Created by Ranjeet Singh on 26/09/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer

/*protocol PlayerDelegates {
    func progressSong(currentTine:Float,timeScale:Float,totalDuration:Float)
    func playNext(songData:NSMutableDictionary)
}*/

class PlayerModel: NSObject {
    
    static let shared : PlayerModel = {
        let instance = PlayerModel()
        return instance
    }()
    
    //var delegate:PlayerDelegates?
    /*
    var lastSongIndex:Int = -1
    
    var currentSongIndex:Int = -1
    
    var playlistName:String = ""
    
    var playerItem : AVPlayerItem?
    var musicPlayer : AVPlayer?
    
    var playlistID:Int!
    var songID:String = ""
    
    var playListSongArray:NSMutableArray = NSMutableArray()
    
    var MianPlayerVC:JPlayerVC!
    var nowPlayingInfo: [String: AnyObject] = [ : ]
    
    var isPlaying:Bool = true
    
    
    func intializePlaylistData(_ playListResponce:NSMutableDictionary){
    
        if ((playListResponce.object(forKey: "tracks") as! NSArray).mutableCopy() as? NSMutableArray != nil){
            
            let arraySongs = (playListResponce.object(forKey: "tracks") as! NSArray).mutableCopy() as? NSMutableArray
            let strClientID = "/?client_id=38be6f938ab09a49c85fac7dc31cb37a"
            
            PlayerModel.shared.playListSongArray.removeAllObjects()
            
            for track_Object in arraySongs! {
                
                let trackObject:NSDictionary = track_Object as! NSDictionary
                
                if (trackObject.object(forKey: "streamable") as? Bool == true){
                    
                    let songUrl_1:String =  trackObject.object(forKey: "stream_url") as! String
                    let songUrl = songUrl_1+strClientID
                    let trackID = trackObject.object(forKey: "id") as! Int
                    let user = trackObject.object(forKey: "user") as! NSDictionary
                    let titleValue = trackObject.object(forKey: "title") as! String
                    let genric = trackObject.object(forKey: "genre") == nil ? "" : trackObject.object(forKey: "genre") as! String
                    let artist = (trackObject.object(forKey: "label_name") == nil || trackObject.object(forKey: "label_name") is NSNull ) ? "" : trackObject.object(forKey: "label_name") as! String
                    
                    
                    var urlImage:String = (trackObject.object(forKey: "artwork_url") == nil || trackObject.object(forKey: "artwork_url") is NSNull) ? "" : trackObject.object(forKey: "artwork_url") as! String
                    
                    if(urlImage == ""){
                        urlImage = (user.object(forKey: "avatar_url") == nil || user.object(forKey: "avatar_url") is NSNull) ? "" : user.object(forKey: "avatar_url") as! String
                    }
                    

                    
                    urlImage = urlImage.replacingOccurrences(of: "-large.", with: "-t500x500.")
                    
                    
                    let songDict:NSMutableDictionary = ["track_id":"\(trackID)","track_url":"\(songUrl)","track_image":"\(urlImage)","track_title":"\(titleValue)","generic":genric,"artist":artist]
                    PlayerModel.shared.playListSongArray.add(songDict)
                }
            }
            currentSongIndex = -1
            print("PlayListSongArray before shuffle  ::::  \(PlayerModel.shared.playListSongArray)")
            
            PlayerModel.shared.playListSongArray.shuffle()
            
            print("PlayListSongArray after shuffle  ::::  \(PlayerModel.shared.playListSongArray)")
            
            self.configurePlayer()
        }else{
            
        }
    }
    
    
    
    
    
    func configurePlayer(){
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PlayerModel.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.onAudioSessionEvent), name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        
        if(playListSongArray.count > 0){
        
            let index = getNextIndex()
            let songDict = playListSongArray.object(at: index) as! NSMutableDictionary
            let songURL = songDict.object(forKey: "track_url") as! String
            
            let url = URL(string:songURL)
            playerItem = AVPlayerItem(url: url!)
            musicPlayer = AVPlayer(playerItem: playerItem)
            
            let seekTime : CMTime = CMTimeMake(0, 1)
            musicPlayer?.seek(to: seekTime )
            musicPlayer!.volume = 1
            musicPlayer?.rate = 1
            
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updatePlayerTime(_:)), userInfo: nil, repeats: true)
        }
    }
    
    func getNextIndex() -> Int {
    
        if(currentSongIndex < 0){
            currentSongIndex = 0
        }else{
            
            if(currentSongIndex < PlayerModel.shared.playListSongArray.count - 1){
                currentSongIndex += 1
                
                self.setOutAppData()
                
                return currentSongIndex
            }else{
                
                currentSongIndex = PlayerModel.shared.playListSongArray.count - 1
                
                self.setOutAppData()
                
                return currentSongIndex
            }
        }
        
        self.setOutAppData()
        return currentSongIndex
    }
    
    func setOutAppData(){
    
        let dictData:NSMutableDictionary = PlayerModel.shared.getCurentIndexData()
        
        if(dictData.object(forKey: "status") as! String == "success"){
            
            let songData = dictData.object(forKey: "data") as! NSMutableDictionary
            let trackImage:String = songData.object(forKey: "track_image") as! String
            let trackTitle:String = songData.object(forKey: "track_title") as! String
            
            let mpic = MPNowPlayingInfoCenter.default()
            
            mpic.nowPlayingInfo = [
                MPMediaItemPropertyAlbumTitle:"\(self.playlistName)",
                MPMediaItemPropertyTitle:"\(trackTitle)"
            ]
            
            
            if(self.musicPlayer != nil){
                if(self.musicPlayer?.currentItem?.asset.duration != nil){
                    
                    let duration = CMTimeGetSeconds((self.musicPlayer?.currentItem?.asset.duration)!)
                    let totalDuration = Float(duration)
                    
                    if(totalDuration.isNaN){
                        
                    }else{
                        let c_time = CMTimeGetSeconds((self.musicPlayer?.currentItem?.currentTime())!)
                        let currentTime = Float(c_time)
                        
                        mpic.nowPlayingInfo = [
                            MPMediaItemPropertyAlbumTitle:"\(self.playlistName)",
                            MPMediaItemPropertyTitle:"\(trackTitle)",
                            MPMediaItemPropertyPlaybackDuration:totalDuration,
                            MPNowPlayingInfoPropertyElapsedPlaybackTime:currentTime
                        ]
                    }
                }
            }
            
            
            
            
            ImageLoader.sharedLoader.imageForUrl(trackImage, completionHandler: { (image, url) in
                if(image != nil){
                    
                    if(self.musicPlayer != nil){
                        if(self.musicPlayer?.currentItem?.asset.duration != nil){
                            
                            let duration = CMTimeGetSeconds((self.musicPlayer?.currentItem?.asset.duration)!)
                            let totalDuration = Float(duration)
                            
                            print("totalDuration ::::: \(totalDuration)")
                            
                            if(totalDuration.isNaN){
                                
                            }else{
                                let c_time = CMTimeGetSeconds((self.musicPlayer?.currentItem?.currentTime())!)
                                let currentTime = Float(c_time)
                                
                                let albumArt:MPMediaItemArtwork = MPMediaItemArtwork.init(image: image!)
                                
                                mpic.nowPlayingInfo = [
                                    MPMediaItemPropertyAlbumTitle:"\(self.playlistName)",
                                    MPMediaItemPropertyTitle:"\(trackTitle)",
                                    //MPNowPlayingInfoPropertyPlaybackRate:1,
                                    MPMediaItemPropertyArtwork:albumArt,
                                    MPMediaItemPropertyPlaybackDuration:totalDuration,
                                    MPNowPlayingInfoPropertyElapsedPlaybackTime:currentTime
                                    
                                ]
                            }
                        }
                    }
                }
            })
        }
        
        self.setImageForScreenOf()
        
    }
    
    
    func setImageForScreenOf(){
    
        if(self.lastSongIndex != self.currentSongIndex){
            self.lastSongIndex = self.currentSongIndex
            
            let dictData:NSMutableDictionary = PlayerModel.shared.getCurentIndexData()
            
            if(dictData.object(forKey: "status") as! String == "success"){
                
                let songData = dictData.object(forKey: "data") as! NSMutableDictionary
                let trackImage:String = songData.object(forKey: "track_image") as! String
                let trackTitle:String = songData.object(forKey: "track_title") as! String
                
                let mpic = MPNowPlayingInfoCenter.default()
                
                ImageLoader.sharedLoader.imageForUrl(trackImage, completionHandler: { (image, url) in
                    if(image != nil){
                        
                        if(self.musicPlayer != nil){
                            if(self.musicPlayer?.currentItem?.asset.duration != nil){
                                
                                let duration = CMTimeGetSeconds((self.musicPlayer?.currentItem?.asset.duration)!)
                                let totalDuration = Float(duration)
                                
                                if(totalDuration.isNaN){
                                    
                                }else{
                                    let c_time = CMTimeGetSeconds((self.musicPlayer?.currentItem?.currentTime())!)
                                    let currentTime = Float(c_time)
                                    
                                    let albumArt:MPMediaItemArtwork = MPMediaItemArtwork.init(image: image!)
                                    
                                    mpic.nowPlayingInfo = [
                                        MPMediaItemPropertyAlbumTitle:"\(self.playlistName)",
                                        MPMediaItemPropertyTitle:"\(trackTitle)",
                                        MPMediaItemPropertyArtwork:albumArt,
                                        MPMediaItemPropertyPlaybackDuration:totalDuration,
                                        MPNowPlayingInfoPropertyElapsedPlaybackTime:currentTime
                                        
                                    ]
                                }
                            }
                        }
                    }
                })
            }
        }
        
    }
    
    
    
    
    func clearSongArray(){
        currentSongIndex = -1
        PlayerModel.shared.playListSongArray = NSMutableArray()
    }
    
    
    func getCurrentIndex() -> Int{
        return currentSongIndex
    }
    
    
    func getCurentIndexData() -> NSMutableDictionary {
    
        if(playListSongArray.count > 0 && self.currentSongIndex != -1){
            let playlistData:NSMutableDictionary = playListSongArray.object(at: getCurrentIndex()) as! NSMutableDictionary
            return ["status":"success","data":playlistData]
        }else{
            return ["status":"fail"]
        }
    }
    
    
    func updatePlayerTime(_ timer:Timer){
        
        print("time handler ...... ")
        
        self.setOutAppData()
        
        let nc:NotificationCenter = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: "songProgress"), object: self, userInfo: nil)
        
        
        let dictData:NSMutableDictionary = PlayerModel.shared.getCurentIndexData()
        
        if(dictData.object(forKey: "status") as! String == "success"){
            
            if(self.playerItem != nil){
                if(self.playerItem?.duration != nil){
                    
                    let CurrentDuration = CMTimeGetSeconds((self.playerItem?.currentTime())!)
                    
                    if(Float(CurrentDuration) != nil){
                        let C_Duration = Float(CurrentDuration)
                        
                        if(C_Duration.isNaN){
                            return
                        }
                        
                        if(C_Duration > 10.0 && C_Duration < 11){
                            self.listenSongAPI()
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    func playNextSong(){
        
        
        if(PlayerModel.shared.playerItem != nil && PlayerModel.shared.playerItem?.duration != nil){
            
            if(CMTimeGetSeconds((PlayerModel.shared.playerItem!.duration)) != nil) {
                let duration = CMTimeGetSeconds((PlayerModel.shared.playerItem!.currentTime()))
                
                if(Float(duration) != nil){
                    let totalDuration = Float(duration)
                    
                    if(totalDuration.isNaN){
                        self.skipSongAPI()
                    }else{
                        if(totalDuration < 10){
                            self.skipSongAPI()
                        }
                    }
                }else{
                    self.skipSongAPI()
                }
            }else{
                self.skipSongAPI()
            }
        }
        
        
        
        
        let index = PlayerModel.shared.getNextIndex()
        
        
        if(currentSongIndex >= PlayerModel.shared.playListSongArray.count - 1){
            
            if(currentSongIndex != 0){
                self.repeatePlaylist()
                return
            }
        }
        
        
        let songDict = playListSongArray.object(at: index) as! NSMutableDictionary
        let songURL = songDict.object(forKey: "track_url") as! String
        
        let url = URL(string:songURL)
        playerItem = AVPlayerItem(url: url!)
        musicPlayer = AVPlayer(playerItem: playerItem)
        
        let seekTime : CMTime = CMTimeMake(0, 1)
        musicPlayer?.seek(to: seekTime )
        
        musicPlayer?.play()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch{
        
        }
        
        let nc:NotificationCenter = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: "nextSong"), object: self, userInfo: nil)
        
    }
    
    func repeatePlaylist(){
        currentSongIndex = -1
        PlayerModel.shared.playListSongArray.shuffle()
        self.playNextSong()
    }
        
        
        
    func skipSongAPI(){
    
        let dictData:NSMutableDictionary = PlayerModel.shared.getCurentIndexData()
        
        if(dictData.object(forKey: "status") as! String == "success"){
            
            let songData = dictData.object(forKey: "data") as! NSMutableDictionary
            let track_id:String = songData.object(forKey: "track_id") as! String
            
            let strFunctionName = "skip_track"
            let perameteres : NSMutableDictionary = NSMutableDictionary(objects: [strUSerID!.intValue,track_id.intValue,self.playlistID], forKeys: ["user_id" as NSCopying ,"track_id" as NSCopying,"playlist_id" as NSCopying]);
            
            print("perameteres ::: \(perameteres)")
            
            WebServiceSilent.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
                
                print("responseObject get skip_track ::: \(responseObject)")
                
                let dict = responseObject as NSDictionary
                let isOk =  dict.object(forKey: "status_code") as! NSNumber
                
                if(isOk == 1){
                }
            }) { (error, operation) -> Void in
                
                NSLog("Failed to get Avg Rating")
            }
        }
    }
    
    
    func listenSongAPI(){
        
        let dictData:NSMutableDictionary = PlayerModel.shared.getCurentIndexData()
        
        if(dictData.object(forKey: "status") as! String == "success"){
            
            let songData = dictData.object(forKey: "data") as! NSMutableDictionary
            let track_id:String = songData.object(forKey: "track_id") as! String
            
            let strFunctionName = "track_listen"
            let perameteres : NSMutableDictionary = NSMutableDictionary(objects: [strUSerID!.intValue,track_id.intValue,self.playlistID], forKeys: ["user_id" as NSCopying ,"track_id" as NSCopying,"playlist_id" as NSCopying]);
            
            print("perameteres ::: \(perameteres)")
            
            WebServiceSilent.callPostServicewithDict(dictionaryObject: perameteres, withData: Data(), withFunctionName: strFunctionName, withImgName: "", succes:  { (responseObject, operation) -> Void in
                
                print("responseObject get track_listen ::: \(responseObject)")
                
                let dict = responseObject as NSDictionary
                let isOk =  dict.object(forKey: "status_code") as! NSNumber
                
                if(isOk == 1){
                }
            }) { (error, operation) -> Void in
                
                NSLog("Failed to get Avg Rating")
            }
        }
    }
    
    
    
    func finishedPlaying(_ myNotification: Notification){
        if(currentSongIndex < PlayerModel.shared.playListSongArray.count - 1){
            self.playNextSong()
        }
    }*/
}
