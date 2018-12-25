//
//  SleepTimer.swift
//  JWOMPA
//
//  Created by Ranjeet Singh on 30/11/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class SleepTimer: NSObject {

    static let shared : SleepTimer = {
        let instance = SleepTimer()
        return instance
    }()
    
    var sleep_timer:Timer!
    var isSleepEnable:Bool = false
    var sleepDuration:Float = 0.0 //In minutes
    var originalSleepDuration: Float! = 0.0
    var selectedIndex:IndexPath!
    
    func addTimerToRunLoop() {
        RunLoop.main.add(self.sleep_timer, forMode: .commonModes)
    }
    
    func setTimer(timeDuration:Float) {
        
        if(sleep_timer != nil) {
            sleep_timer.invalidate()
            sleep_timer = nil
            sleepDuration = 0.0
        }
        
        sleepDuration = timeDuration * 60
        originalSleepDuration = sleepDuration / 60
        
        let sleepInterval = timeDuration * 60
        if(sleep_timer == nil) {
            sleep_timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.sleepTimerTicking(timer:)), userInfo: nil, repeats: true)
            addTimerToRunLoop()
            isSleepEnable = true
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SleepTimerStarted"), object: nil, userInfo:["sleepInterval": Double(sleepInterval)])
        
    }
    
    func sleepTimerTicking(timer: Timer) {
        if sleepDuration > 0 {
            sleepDuration -= 1
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sleepTimerTicking"), object: nil, userInfo:["seconds": sleepDuration])
        } else {
            sleepDuration = 0.0
            self.updatePlayerTime(sleep_timer)
        }
    }
    
    func updatePlayerTime(_ timer:Timer){
        
        print("updatin sleep timer")
        
        AudioPlayerModel.shared.pauseAudio()
        isSleepEnable = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SleepTimerEnded"), object: nil, userInfo:nil)
        
        if(sleep_timer != nil){
            sleep_timer.invalidate()
            sleep_timer = nil
            sleepDuration = 0.0
        }
    }
    
    func invalidTimer(){
        if(sleep_timer != nil){
            sleep_timer.invalidate()
            sleep_timer = nil
            sleepDuration = 0.0
            isSleepEnable = false
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SleepTimerEnded"), object: nil, userInfo:nil)
        }
    }
    
}
