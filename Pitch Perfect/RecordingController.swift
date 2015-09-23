//
//  RecordingController.swift
//  Pitch Perfect
//
//  Created by Arkaprava De on 19/09/15.
//  Copyright © 2015 Arkaprava De. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var recorderButton: UIButton!
    @IBOutlet weak var resumePauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    //flag to keep check on whether audio is paused or resumed
    var isPaused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //configuration for recording audio done once
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let recordingName = GlobalConstants.fileName
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
            
            audioRecorder = try AVAudioRecorder(URL: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            
        } catch {
            alertLabel.text = GlobalConstants.microphoneError
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //setting resume, pause and stop button to hidden
        resumePauseButton.hidden = true
        stopButton.hidden = true
        
        recorderButton.enabled = true
        alertLabel.text = GlobalConstants.beforeRecordingStarts
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "playAudioSegue") {
            let playSoundsVC:PlayingAudioController = segue.destinationViewController as! PlayingAudioController
            let data = sender as! RecordedAudioModel
            playSoundsVC.receivedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            let recordedAudio = RecordedAudioModel(url: recorder.url, lastComponent: recorder.url.lastPathComponent)
            
            //Performing Segue
            performSegueWithIdentifier("playAudioSegue", sender: recordedAudio);
        } else {
            alertLabel.text = GlobalConstants.errorRecording
        }
    }

    //to record audio when record button is clicked
    @IBAction func recordAudio(sender: UIButton) {
        
        alertLabel.text = GlobalConstants.afterRecordingStarts
        recorderButton.enabled = false
        
        //setting resume, pause and stop button to show
        resumePauseButton.hidden = false
        stopButton.hidden = false
        
        audioRecorder.record()
    }
    
    @IBAction func stopRecordingAudio(sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func resumePauseAudio(sender: UIButton) {
        
        //logic based on whether the recording is paused or resumed
        if(isPaused) {
            isPaused = false;
            let image = UIImage(named: "PauseIcon")
            resumePauseButton.setImage(image, forState: UIControlState.Normal)
            
            alertLabel.text = GlobalConstants.audioRecordingResumed
            audioRecorder.record()
        }else {
            isPaused = true
            let image = UIImage(named: "ResumeIcon")
            resumePauseButton.setImage(image, forState: UIControlState.Normal)
            
            alertLabel.text = GlobalConstants.audioRecordingPaused
            audioRecorder.pause()
        }
    }
}

