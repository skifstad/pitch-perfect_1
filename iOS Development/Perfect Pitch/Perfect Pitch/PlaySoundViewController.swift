//
//  PlaySoundViewController.swift
//  Perfect Pitch
//
//  Created by Nathan Skifstad on 3/13/15.
//  Copyright (c) 2015 skifstad.com. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        //this bit of code ensures that the AudioEngine output node is the speaker by default
        let session = AVAudioSession.sharedInstance()
        var error: NSError?
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error)
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: &error)
        session.setActive(true, error: &error)
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlow(sender: UIButton) {
        prepareAudio()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
   
    @IBAction func playFast(sender: UIButton) {
        prepareAudio()
        audioPlayer.rate = 2.0
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    
    @IBAction func playChipmonk(sender: UIButton) {
        PlayAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func playDarthvader(sender: UIButton) {
        prepareAudio()
        PlayAudioWithVariablePitch(-1000)
    }
    

    
    @IBAction func stopAudio(sender: UIButton) {
        prepareAudio()
    }
    
    
    
    func PlayAudioWithVariablePitch (pitch: Float){ //Creates new AudioEngine with mixer nodes to play chimpmonk and darhvader pitches
        
        prepareAudio()
        
        var chimpMonkAudioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(chimpMonkAudioPlayerNode)
        
        var changePitchToChimpMonkEffect = AVAudioUnitTimePitch()
        changePitchToChimpMonkEffect.pitch = pitch
        audioEngine.attachNode(changePitchToChimpMonkEffect)
        
        audioEngine.connect(chimpMonkAudioPlayerNode, to: changePitchToChimpMonkEffect, format: nil)
        audioEngine.connect(changePitchToChimpMonkEffect, to: audioEngine.outputNode, format: nil)
        
        chimpMonkAudioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        chimpMonkAudioPlayerNode.play()
    }
    
    func prepareAudio (){ //Stops audio being played and prepares the audiio players to be played again
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
}
