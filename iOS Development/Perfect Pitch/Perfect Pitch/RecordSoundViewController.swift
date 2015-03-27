//
//  RecordSoundViewController.swift
//  Perfect Pitch
//
//  Created by Nathan Skifstad on 3/10/15.
//  Copyright (c) 2015 skifstad.com. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate{

    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var recording: UIButton!
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = "tap to record"
        stopRecording.hidden = true
        statusLabel.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func record(sender: UIButton) {
        statusLabel.text = "recording"
        stopRecording.hidden = false
        recording.hidden = true
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            
            recordedAudio = RecordAudio(url: recorder.url, title: recorder.url.lastPathComponent)
            
            self.performSegueWithIdentifier("stopRecord", sender:recordedAudio)
        }else{
            println("Recording Failed")
            recording.hidden = true
            stopRecording.hidden = true
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if (segue.identifier == "stopRecord"){
                let playSoundsVC:PlaySoundViewController = segue.destinationViewController as PlaySoundViewController
                let data = sender as RecordAudio
                playSoundsVC.receivedAudio = data
                
            }
        
            }
    
    
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        recording.hidden = false
        statusLabel.text = "tap to record"
        stopRecording.hidden = true
    }
    
    }
 


