//
//  AudioPlayerModel.swift
//  Jwompa
//
//  Created by Ranjeet Singh on 27/04/17.
//  Copyright © 2017 Relienttekk. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit


////////////////////////////////////////////////////////////////////////
//Skip Count Section - START
////////////////////////////////////////////////////////////////////////


var skipDurationLimit: Int = 2400 //60 //Seconds
var maxSkipCount: Int = 5 //Seconds

var skipStartDate: Date? {
    get {
        return UserDefaults.standard.object(forKey: "SkipStartDate") as? Date
    }
    set {
        UserDefaults.standard.setValue(newValue, forKey: "SkipStartDate")
    }
}

var dateLastSkipped: Date? {
    get {
        return UserDefaults.standard.object(forKey: "DateLastSkipped") as? Date
    }
    set {
        UserDefaults.standard.setValue(newValue, forKey: "DateLastSkipped")
    }
}

var skipCount: Int {
    get {
        return (UserDefaults.standard.object(forKey: "SkipCount") as? Int) ?? 0
    }
    set {
        UserDefaults.standard.setValue(newValue, forKey: "SkipCount")
    }
}


////////////////////////////////////////////////////////////////////////
//Skip Count Section - END
////////////////////////////////////////////////////////////////////////


class AudioPlayerModel: NSObject,AVAudioPlayerDelegate,JukeboxDelegate {
    
    static let shared : AudioPlayerModel = {
        let instance = AudioPlayerModel()
        return instance
    }()
    
    
    var jukebox:Jukebox!
    //var audioPlayer:AVAudioPlayer!
    var playlistName:String = ""
    
    var playlistID:Int!
    var songID:String = ""
    
    var playListSongArray:NSMutableArray = NSMutableArray()
    
    var MainPlayerVC:JPlayerVC!
    var urlArray = [JukeboxItem]()
    
    // Equaliser value
    var currentPlayingAlbumName = ""
    var currentPlayingAlbumID: Int?
    
    // search song
    var singleSongDic = NSDictionary()
    
    func intializePlaylistData(_ playListResponce:NSMutableDictionary){
        
        if(playListResponce.object(forKey: "tracks")) == nil {
            
            AudioPlayerModel.shared.playListSongArray.removeAllObjects()
            
            let songUrl_1:String =  singleSongDic.object(forKey: "stream_url") as! String
            let songUrl = songUrl_1
            let trackID = singleSongDic.object(forKey: "id") as! Int
            let titleValue = singleSongDic.object(forKey: "title") as! String
            let genric = singleSongDic.object(forKey: "genre") == nil ? "" : singleSongDic.object(forKey: "genre") as Any
            let artist = (singleSongDic.object(forKey: "label_name") == nil || singleSongDic.object(forKey: "label_name") is NSNull ) ? "" : singleSongDic.object(forKey: "label_name") as! String
            
            var urlImage:String = (singleSongDic.object(forKey: "artwork_url") == nil || singleSongDic.object(forKey: "artwork_url") is NSNull) ? "http://ec2-52-91-211-72.compute-1.amazonaws.com/library/album_art/art.png" : singleSongDic.object(forKey: "artwork_url") as! String
            
            urlImage = urlImage.replacingOccurrences(of: "-large.", with: "-t500x500.")
            let country = singleSongDic.object(forKey: "country") as? String
            
            let songDict:NSMutableDictionary = ["track_id":"\(trackID)","track_url":"\(songUrl)","track_image":"\(urlImage)","track_title":"\(titleValue)","generic":genric,"artist":artist, "country": country ?? "(Country)"]
            AudioPlayerModel.shared.playListSongArray.add(songDict)
            print("PlayListSongArray before shuffle  ::::  \(AudioPlayerModel.shared.playListSongArray)")
            
            AudioPlayerModel.shared.playListSongArray.shuffle()
            
            print("PlayListSongArray after shuffle  ::::  \(AudioPlayerModel.shared.playListSongArray)")
            
            self.addItemsToJuckbox()
            
            return
        }
        
        if ((playListResponce.object(forKey: "tracks") as! NSArray).mutableCopy() as? NSMutableArray != nil){
            
            let arraySongs = (playListResponce.object(forKey: "tracks") as! NSArray).mutableCopy() as? NSMutableArray
            //            let strClientID = "/?client_id=38be6f938ab09a49c85fac7dc31cb37a"
            
            AudioPlayerModel.shared.playListSongArray.removeAllObjects()
            
            for track_Object in arraySongs! {
                
                let trackObject:NSDictionary = track_Object as! NSDictionary
                
                if (trackObject.object(forKey: "streamable") as? Bool == true){
                    
                    let songUrl_1:String =  trackObject.object(forKey: "stream_url") as! String
                    let country =  trackObject.object(forKey: "country") as? String
                    let songUrl = songUrl_1
                    //                    +strClientID
                    let trackID = trackObject.object(forKey: "id") as! Int
                    //                    let user = trackObject.object(forKey: "user") as! NSDictionary
                    let titleValue = trackObject.object(forKey: "title") as! String
                    let genric = trackObject.object(forKey: "genre") == nil ? 0 : trackObject.object(forKey: "genre") as Any
                    let artist = (trackObject.object(forKey: "label_name") == nil || trackObject.object(forKey: "label_name") is NSNull ) ? "" : trackObject.object(forKey: "label_name") as! String
                    
                    var urlImage:String = (trackObject.object(forKey: "artwork_url") == nil || trackObject.object(forKey: "artwork_url") is NSNull) ? "http://ec2-52-91-211-72.compute-1.amazonaws.com/library/album_art/art.png" : trackObject.object(forKey: "artwork_url") as! String
                    
                    if urlImage == "" {
                        //                        urlImage = (user.object(forKey: "avatar_url") == nil || user.object(forKey: "avatar_url") is NSNull) ? "" : user.object(forKey: "avatar_url") as! String
                    }
                    
                    urlImage = urlImage.replacingOccurrences(of: "-large.", with: "-t500x500.")
                    
                    let songDict:NSMutableDictionary = ["track_id":"\(trackID)","track_url":"\(songUrl)","track_image":"\(urlImage)","track_title":"\(titleValue)","generic":genric,"artist":artist, "country": country ?? "(Country)"]
                    AudioPlayerModel.shared.playListSongArray.add(songDict)
                }
            }
            print("PlayListSongArray before shuffle  ::::  \(AudioPlayerModel.shared.playListSongArray)")
            
            AudioPlayerModel.shared.playListSongArray.shuffle()
            
            print("PlayListSongArray after shuffle  ::::  \(AudioPlayerModel.shared.playListSongArray)")
            
            self.addItemsToJuckbox()
        }else{
            print("error")
        }
    }
    
    func addItemsToJuckbox(){
        
        urlArray.removeAll()
        
        if(AudioPlayerModel.shared.playListSongArray.count > 0){
            
            for data in AudioPlayerModel.shared.playListSongArray {
                let dataDict:NSDictionary = data as! NSDictionary
                let songURL = dataDict.object(forKey: "track_url") as! String
                
                let item = JukeboxItem(URL: URL(string: songURL)!)
                urlArray.append(item)
            }
            
            self.jukebox = Jukebox(delegate: self, items: urlArray)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlaySong"), object: nil, userInfo: nil)
            self.playAudio()
        }
    }
    
    
    
    
    
    func jukeboxStateDidChange(_ jukebox : Jukebox){
        print("jukebox.state : \(jukebox.state)")
        
        let nc:NotificationCenter = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: "stateChanged"), object: self, userInfo: nil)
    }
    
    
    func jukeboxPlaybackProgressDidChange(_ jukebox : Jukebox){
        self.updatePlayerTime()
    }
    
    
    func jukeboxDidLoadItem(_ jukebox : Jukebox, item : JukeboxItem){
        print("Jukebox did load: \(item.URL.lastPathComponent)")
    }
    
    
    func jukeboxDidUpdateMetadata(_ jukebox : Jukebox, forItem: JukeboxItem){
        print("Item updated:\n\(forItem)")
    }
    
    
    func playAudio(){
        if(AudioPlayerModel.shared.jukebox != nil){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlaySong"), object: nil, userInfo: nil)
            jukebox.play()
        }
    }
    
    func pauseAudio(){
        if(AudioPlayerModel.shared.jukebox != nil){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PauseSong"), object: nil, userInfo: nil)
            jukebox.pause()
        }
    }
    
    fileprivate func resetDates() {
        skipStartDate = Date()
        dateLastSkipped = Date()
        skipCount = 0
    }
    
    fileprivate func setSkipCountAndDate() {
        skipCount += 1
        dateLastSkipped = Date()
    }
    
    fileprivate func hideSkipCountLabel(hide:Bool) {
        DispatchQueue.main.async {
            self.MainPlayerVC.lblSkipCount.text = "\(skipCount > maxSkipCount ? 0 : maxSkipCount - skipCount)"
            self.MainPlayerVC.lblSkipCount.isHidden = hide
        }
    }
    
    func handleSkipCountAndPlayNextSong() {
        if self.playListSongArray.count == 0 {
            obj_app.alertViewFromApp(messageString: "Cannot Skip. Playlist is empty.")
            return
        }
        DispatchQueue.main.async {
            if let _ = dateLastSkipped, let skipStartDate = skipStartDate {
                if Int(Date().timeIntervalSince(skipStartDate)) > skipDurationLimit {
                    self.resetDates()
                    self.handleSkipCountAndPlayNextSong() //Recursive calling
                } else {
                    self.setSkipCountAndDate()
                    if skipCount <= maxSkipCount {
                        self.hideSkipCountLabel(hide: true)
                        
                        if skipCount > 2 {
                            self.hideSkipCountLabel(hide: false)
                        }
                        self.playNextSong()
                    } else {
                        self.hideSkipCountLabel(hide: false)
                        obj_app.alertViewFromApp(messageString: "Too many skips, try again later")
                    }
                }
            } else {
                self.resetDates()
                self.handleSkipCountAndPlayNextSong() //Recursive calling
            }
            print("*********** \(skipCount) of \(maxSkipCount) skips done ***********")
            
        }
    }
    
    func playNextSong() {
        
        guard self.currentPlayingAlbumID != nil else { return }
        
        let current_Data:NSDictionary = AudioPlayerModel.shared.getCurentIndexData()
        var trackID = ""
        if current_Data.object(forKey: "status") as! String == "success" {
            let songData = current_Data.object(forKey: "data") as! NSMutableDictionary
            trackID = songData.object(forKey: "track_id") as! String
        }
        
        self.MainPlayerVC.buttonNext.isUserInteractionEnabled = false
        let dicToSend = ["playlist_id": self.currentPlayingAlbumID, "track_id": trackID.intValue] as! [String : Int]
        
        WebService.callPostServicewithDict(dictionaryObject: NSMutableDictionary.init(dictionary: dicToSend), withData: Data(), withFunctionName: "api/skip_track", withImgName: "", succes: { [unowned self] (response, operation) in
            
            self.MainPlayerVC.buttonNext.isUserInteractionEnabled = true
            
            if (response["status_text"] as? String) == "Success" {
                
                guard let _ = self.jukebox else { return }
                
                if let totalDuration = self.jukebox.currentItem?.currentTime {
                    print("totalDuration :::: \(totalDuration)")
                }
                
                print("jukebox.playIndex == self.playListSongArray.count - 1 ::::  \(self.jukebox.playIndex)   \(self.playListSongArray.count - 1)")
                
                if(self.jukebox.playIndex == self.playListSongArray.count - 1){
                    self.repeatePlaylist()
                }else if(self.jukebox.playIndex == 0 && self.jukebox.state == Jukebox.State.ready){
                    self.repeatePlaylist()
                }else{
                    self.jukebox.playNext()
                    self.listenSongAPI()
                    let nc:NotificationCenter = NotificationCenter.default
                    nc.post(name: Notification.Name(rawValue: "nextSong"), object: self, userInfo: nil)
                }
                
            }
        }) { (error, operation) in
            self.MainPlayerVC.buttonNext.isUserInteractionEnabled = true
            obj_app.alertViewFromApp(messageString: error.description)
        }
    }
    
    
    func repeatePlaylist(){
        
        print("Repeat Song .......")
        
        if(jukebox != nil){
            jukebox.stop()
            jukebox = nil
        }
        
        
        AudioPlayerModel.shared.playListSongArray.shuffle()
        self.addItemsToJuckbox()
    }
    
    func clearSongArray(){
        AudioPlayerModel.shared.playListSongArray = NSMutableArray()
    }
    
    
    func getCurrentIndex() -> Int{
        return jukebox.playIndex
    }
    
    
    func getCurentIndexData() -> NSMutableDictionary {
        
        if(playListSongArray.count > 0) && (AudioPlayerModel.shared.jukebox != nil) {
            let playlistData:NSMutableDictionary = playListSongArray.object(at: self.jukebox.playIndex)  as! NSMutableDictionary
            return ["status": "success", "data": playlistData]
        }else{
            return ["status":"fail"]
        }
    }
    
    
    func listenSongAPI(){
        
        guard self.playlistID != nil else { return }
        
        let dictData:NSMutableDictionary = AudioPlayerModel.shared.getCurentIndexData()
        
        if(dictData.object(forKey: "status") as! String == "success"){
            
            let songData = dictData.object(forKey: "data") as! NSMutableDictionary
            let track_id:String = songData.object(forKey: "track_id") as! String
            
            let strFunctionName = "api/track_listen"
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
    
    
    
    func updatePlayerTime() {
        let nc:NotificationCenter = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: "songProgress"), object: self, userInfo: nil)
        
        if let C_Duration = jukebox.currentItem?.currentTime {
            if(C_Duration.isNaN){
                return
            }
        }
    }
    
    
    func getDuretionText(timeInterval:TimeInterval) -> String{
        
        let hour_   = abs(Int(timeInterval)/3600)
        let minute_ = abs(Int((timeInterval/60).truncatingRemainder(dividingBy: 60)))
        let second_ = abs(Int(timeInterval.truncatingRemainder(dividingBy: 60)))
        
        let hour = hour_ > 9 ? "\(hour_)" : "\(hour_)"
        let minute = minute_ > 9 ? "\(minute_)" : "0\(minute_)"
        let second = second_ > 9 ? "\(second_)" : "0\(second_)"
        
        let duretionString = hour_ <= 0 ? "\(minute):\(second)" : "\(hour):\(minute):\(second)"
        
        return duretionString
    }
    
}
