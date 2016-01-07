//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Shriyansh Agnihotri on 06/01/16.
//  Copyright © 2016 Shriyansh Agnihotri. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var aFile: AVAudioFile!
    var engine: AVAudioEngine!
    var rData: RecordedAudio!
    
    @IBOutlet weak var stopAll: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let coinSound = rData.filePathUrl
        do{
            engine = AVAudioEngine()
            aFile = try AVAudioFile(forReading: coinSound)
            audioPlayer = try AVAudioPlayer(contentsOfURL:coinSound)
            audioPlayer.enableRate = true
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord,
                withOptions:AVAudioSessionCategoryOptions.DefaultToSpeaker)
        }catch {
            print("Error getting the audio file")
        }// Do any additional setup after loading the view.
    }
    
    func playWithPitch(pitch: Float) {
        let audioPlayerNode = AVAudioPlayerNode()
        audioPlayerNode.stop()
        engine.stop()
        engine.reset()
        engine.attachNode(audioPlayerNode)
        let changeAudioUnitTime = AVAudioUnitTimePitch()
        changeAudioUnitTime.pitch = pitch
        engine.attachNode(changeAudioUnitTime)
        engine.connect(audioPlayerNode, to: changeAudioUnitTime, format: nil)
        engine.connect(changeAudioUnitTime, to: engine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(aFile, atTime: nil, completionHandler: nil)
        try! engine.start()
        audioPlayerNode.play()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        stopAll.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopAction(sender: UIButton) {
        audioPlayer.stop()
        engine.stop()
        engine.reset()
    }

    @IBAction func fastAction(sender: UIButton) {
        playWithSpeed(2.0)
    }
    
    @IBAction func slowAction(sender: UIButton) {
        playWithSpeed(0.5)
        
    }
    
    @IBAction func chipmunk(sender: UIButton) {
        playWithPitch(1000)
    }
    
    @IBAction func vader(sender: UIButton) {
        playWithPitch(-1000)
    }
    
    func playWithSpeed(speed: Float) {
        audioPlayer.stop()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
