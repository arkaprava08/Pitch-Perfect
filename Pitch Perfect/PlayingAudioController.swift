//
//  PlayingAudioController.swift
//  Pitch Perfect
//
//  Created by Arkaprava De on 19/09/15.
//  Copyright © 2015 Arkaprava De. All rights reserved.
//

import UIKit
import AVFoundation

class PlayingAudioController: UIViewController {
    
    var receivedAudio:RecordedAudioModel!
    var audioPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayback)
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
        audioPlayer.enableRate = true
        audioPlayer.volume = 1.0
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL)
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        self.stopAudio()
        
        audioPlayer.rate = 0.5;
        audioPlayer.currentTime = 0;
        audioPlayer.play()
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        self.stopAudio()
        
        audioPlayer.rate = 1.5;
        audioPlayer.currentTime = 0;
        audioPlayer.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        self.stopAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = 1000
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        self.stopAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = -1000
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        self.stopAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let echoNode = AVAudioUnitDelay()
        echoNode.delayTime = NSTimeInterval(0.3)
        
        audioEngine.attachNode(echoNode)
        
        audioEngine.connect(audioPlayerNode, to: echoNode, format: nil)
        audioEngine.connect(echoNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        self.stopAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset( AVAudioUnitReverbPreset.Cathedral)
        reverbNode.wetDryMix = 60
        
        audioEngine.attachNode(reverbNode)
        
        audioEngine.connect(audioPlayerNode, to: reverbNode, format: nil)
        audioEngine.connect(reverbNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()

    }
    
    @IBAction func stopAudio(sender: UIButton) {
        self.stopAudio()
    }
    
    func stopAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

}
