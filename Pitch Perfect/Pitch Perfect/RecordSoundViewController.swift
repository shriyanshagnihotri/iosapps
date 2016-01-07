//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Shriyansh Agnihotri on 06/01/16.
//  Copyright © 2016 Shriyansh Agnihotri. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    

    @IBOutlet weak var recodingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    var audioRecorder:AVAudioRecorder!
    var recordedaudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        //TODO: record audio.
        print("recording")
        recodingInProgress.hidden = false
        stopButton.hidden = false
        recordSound()
        
    }
    
    func recordSound() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        //print(dirPath)
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        //print(filePath)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            recordedaudio = RecordedAudio()
            recordedaudio.filePathUrl = recorder.url
            recordedaudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier("showPlaySound", sender: recordedaudio)
        } else {
            print("Recording failed")
            recodingInProgress.text = "Recording failed"
            recodingInProgress.hidden = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showPlaySound") {
            let p: PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let data = sender as! RecordedAudio
            p.rData = data
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    @IBAction func StopRecording(sender: UIButton) {
        //TODO: stop recording.
        recodingInProgress.hidden = true
        stopRecording()
    }
}

