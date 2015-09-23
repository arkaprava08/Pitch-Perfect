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
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting category of AVAudioSession for playback in speakers
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayback)
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL)
    }
    
    func playAudioAtGivenRateAndPitch(rate: Float!, pitch: Float!) {
        stopAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changeRateAndPitchNode = AVAudioUnitTimePitch()

        //set rate and pitch based on data if available
        if rate != nil {
            changeRateAndPitchNode.rate = rate
        }
        if pitch != nil {
            changeRateAndPitchNode.pitch = pitch
        }

        audioEngine.attachNode(changeRateAndPitchNode)
        
        audioEngine.connect(audioPlayerNode, to: changeRateAndPitchNode, format: nil)
        audioEngine.connect(changeRateAndPitchNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func stopAudio() {
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioAtGivenRateAndPitch(0.5, pitch: nil)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioAtGivenRateAndPitch(1.5, pitch: nil)    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioAtGivenRateAndPitch(nil, pitch: 1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioAtGivenRateAndPitch(nil, pitch: -1000)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        stopAudio()
        
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
        stopAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbNode.wetDryMix = 60
        
        audioEngine.attachNode(reverbNode)
        
        audioEngine.connect(audioPlayerNode, to: reverbNode, format: nil)
        audioEngine.connect(reverbNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()

    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAudio()
    }

}
