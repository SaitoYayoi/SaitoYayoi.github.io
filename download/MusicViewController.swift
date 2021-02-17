//
//  MusicViewController.swift
//  My Planet
//
//  Created by SaitoYayoi on 2020/4/4.
//  Copyright © 2020 KanoYuta. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import MediaPlayer

enum state {
    case playing
    case notPlaying
}

class MusicViewController: UIViewController, STKAudioPlayerDelegate {
    
    var randomNumber = Int(arc4random()%5)+1
    var timer:Timer!
    var bgm:Timer!
    let audioPlayer = STKAudioPlayer()
    var duration = 0.0
    var progess = 0.0
    var bufferingStatus = 2
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject) {

    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishBufferingSourceWithQueueItemId queueItemId: NSObject) {
        var NumC:Int
        NumC = randomNumber
        randomNumber = Int(arc4random()%5)+1
        while true {
            if NumC == randomNumber {
                 randomNumber = Int(arc4random()%5)+1
            }
            else {
                break
            }
        }
        bufferingStatus = 2
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState) {
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, with stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double) {
        if bufferingStatus != 2 {
            var NumC:Int
            NumC = randomNumber
            randomNumber = Int(arc4random()%5)+1
            while true {
                if NumC == randomNumber {
                     randomNumber = Int(arc4random()%5)+1
                }
                else {
                    break
                }
            }
            bufferingStatus = 2
        }
        audioPlayer.stop()
        bgm = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.bgm(_:)), userInfo: nil, repeats: true)
        audioPlayer.unmute()
        audioPlayer.play("http://47.115.141.93/songs/\(randomNumber).mp3")
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode) {
        print(errorCode)
    }
    
    @objc func tick(_ timer:Timer) {
        duration = audioPlayer.duration
        progess = audioPlayer.progress
        if audioPlayer.state != STKAudioPlayerState.buffering {
            self.bufferingStatus = 0
        }
    }
    
    @objc func bgm(_ timer:Timer) {
        if bufferingStatus == 0 {
            setLockScreenDisplay()
            bgm.invalidate()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(self.tick(_:)), userInfo: nil, repeats: true)
        bgm = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.bgm(_:)), userInfo: nil, repeats: true)
        
        
        audioPlayer.play("http://47.115.141.93/songs/\(randomNumber).mp3")
        audioPlayer.delegate = self
        
        background()
        backgroundMusic()
        creatRemoteCommandCenter()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        becomeFirstResponder()
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resignFirstResponder()
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
        
    
    func creatRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [] event in
            self.resumeAndPauseWhtherPause(false)
            return .success
        }
        commandCenter.pauseCommand.addTarget { [] event in
            self.resumeAndPauseWhtherPause(true)
            return .success
        }
        commandCenter.nextTrackCommand.addTarget { [] event in
            self.next()
            return .success
        }
        commandCenter.previousTrackCommand.addTarget { [] event in
            self.next()
            return .success
        }
        commandCenter.changePlaybackPositionCommand.addTarget{ [] event in
            let playbackPositionEvent = event as? MPChangePlaybackPositionCommandEvent
            self.audioPlayer.seek(toTime: playbackPositionEvent!.positionTime)
            return .success
        }
    }
    
    func next() {
        var info = MPNowPlayingInfoCenter.default().nowPlayingInfo
        audioPlayer.mute()
        audioPlayer.pause()
        var NumC:Int
        NumC = randomNumber
        randomNumber = Int(arc4random()%5)+1
        while true {
            if NumC == randomNumber {
                 randomNumber = Int(arc4random()%5)+1
            }
            else {
                break
            }
        }
        bufferingStatus = 2
        audioPlayer.seek(toTime: duration-0.001)
        info![MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.progress
        audioPlayer.resume()
    }
    
    func resumeAndPauseWhtherPause(_ status: Bool) {
        var info = MPNowPlayingInfoCenter.default().nowPlayingInfo
        if status {
            audioPlayer.pause()
            info![MPNowPlayingInfoPropertyPlaybackRate] = 0.00001
            info![MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.progress
        }else {
            audioPlayer.resume()
            info![MPNowPlayingInfoPropertyPlaybackRate] = 1.0
            info![MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.progress
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
    
    func setLockScreenDisplay() {
        var info = Dictionary<String, Any>()
        info[MPMediaItemPropertyTitle] = randomNumber
        info[MPMediaItemPropertyPlaybackDuration] = TimeInterval(duration)
        info[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
    
    func background() {
        var background = [UIImage]()
               for i in 1 ... 4 {
                   background.append(UIImage(named: "bg\(i)")!)
               }
        let imageView = UIImageView()
        imageView.animationImages = background
        imageView.animationDuration = 5
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints {(bg) in
            bg.top.bottom.left.right.equalTo(0)
            bg.center.equalToSuperview()
        }
    }
    
    func backgroundMusic() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(AVAudioSession.Category.playback)
        print(AVAudioSession.Category.playback)
        try? session.setActive(true)
    }
    

}

