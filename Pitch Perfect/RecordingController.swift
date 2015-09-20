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
    var isPaused:Bool!
    
    struct GlobalConstants {
        static let afterRecordingStarts = "Recording..."
        static let beforeRecordingStarts = "Tap to start recording";
        static let recordingPermissionFailed = "Failed to fetch recording permission"
        static let audioRecordingPaused = "Recording paused !"
        static let audioRecordingResumed = "Recording continues..."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isPaused = false
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //setting resume, pause and stop button to hidden
        resumePauseButton.hidden = true
        stopButton.hidden = true
        
        recorderButton.enabled = true
        alertLabel.text = GlobalConstants.beforeRecordingStarts
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "playAudioSegue") {
            print("pass data")
            
            let playSoundsVC:PlayingAudioController = segue.destinationViewController as! PlayingAudioController
            let data = sender as! RecordedAudioModel
            playSoundsVC.receivedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        print("did finish recording")
        
        print(recorder.url);
        let recordedAudio = RecordedAudioModel(url: recorder.url, lastComponent: recorder.url.lastPathComponent)
        
        //Performing Segue
        self.performSegueWithIdentifier("playAudioSegue", sender: recordedAudio);
    }

    //to record audio when record button is clicked
    @IBAction func recordAudio(sender: UIButton) {
        alertLabel.text = GlobalConstants.afterRecordingStarts
        recorderButton.enabled = false
        
        //setting resume, pause and stop button to show
        resumePauseButton.hidden = false
        stopButton.hidden = false
        
        //record audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let recordingName = "sample.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        audioRecorder = try? AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
        
        
        print("still recording")
    }
    
    @IBAction func stopRecordingAudio(sender: UIButton) {
        print("stop")
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func resumePauseAudio(sender: UIButton) {
        
        if(isPaused!) {
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

