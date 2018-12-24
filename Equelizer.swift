//
//  Quelizer.swift
//  JWOMPA
//
//  Created by Ranjeet Singh on 14/11/16.
//  Copyright © 2016 Relienttekk. All rights reserved.
//

import UIKit

class Equelizer: UIView {
    
    var height:CGFloat = 0
    var width:CGFloat = 0
    var isSongPlaying: Bool = false
    
    //var eq : PCSEQVisualizer = PCSEQVisualizer(numberOfBars: 4)
    var tapBtn:UIButton = UIButton()
    var eq:EQView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        NotificationCenter.default.addObserver(self, selector: #selector(self.PlayerHandler(_:)), name: NSNotification.Name(rawValue: "nextSong"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.PlayerHandler(_:)), name: NSNotification.Name(rawValue: "songProgress"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.PlayerHandler(_:)), name: NSNotification.Name(rawValue: "stateChanged"), object: nil)
        
        width = self.frame.width
        height = self.frame.height
        
        eq = EQView(frame: CGRect(x: 5, y: 5, width: width - 10, height: height - 10))
        eq.isHidden = true
        self.addSubview(eq)
        
        tapBtn.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.addSubview(tapBtn)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func PlayerHandler(_ notification: Notification){
        
        if notification.name.rawValue  == "nextSong" {
            eq.isHidden = true
            eq.stopEq()
            isSongPlaying = false
        } else {
            
            if AudioPlayerModel.shared.jukebox.state == Jukebox.State.playing {
                if(eq.isHidden == true){
                    eq.startEq()
                    eq.isHidden = false
                    isSongPlaying = true
                }
            } else {
                eq.isHidden = true
                eq.stopEq()
                isSongPlaying = false
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
