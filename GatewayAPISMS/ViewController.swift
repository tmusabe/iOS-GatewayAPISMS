//
//  ViewController.swift
//  GatewayAPISMS
//
//  Created by Taif Al Musabe on 1/8/19.
//  Copyright © 2019 Taif Al Musabe. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var sender: UITextField!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var video: UIView!
    
    
    func setupAVPlayer() {
        
        let videoURL = Bundle.main.url(forResource: "GatewayAPIVideo", withExtension: "mp4") // Get video url
        let avAssets = AVAsset(url: videoURL!) // Create assets to get duration of video.
        let avPlayer = AVPlayer(url: videoURL!) // Create avPlayer instance
        let avPlayerLayer = AVPlayerLayer(player: avPlayer) // Create avPlayerLayer instance
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayerLayer.frame =  video.frame// Set bounds of avPlayerLayer
        video.layer.addSublayer(avPlayerLayer) // Add avPlayerLayer to view's layer.
        avPlayer.play() // Play video
        
        // Add observer for every second to check video completed or not,
        // If video play is completed then redirect to desire view controller.
        avPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1) , queue: .main) { [weak self] time in
            if time == avAssets.duration {
                self?.video.isHidden = true
            }
        }
    }
    
    //------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //------------------------------------------------------------------------------
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupAVPlayer()  // Call method to setup AVPlayer & AVPlayerLayer to play video
    }

    @IBAction func sendSMS(_ sender: Any) {
        let gatewayApi = GatewayAPIWrapper.init(token: "Insert Your Token")
        gatewayApi.sender = self.sender.text
        gatewayApi.recipients = [self.number.text] as? Array<String>
        gatewayApi.message = message.text
        gatewayApi.sendSMS()
    }

}

extension ViewController: GatewayAPIWrapperDelegate {
    func sendSMSResponse(result: [String : Any]) {
        print(result)
    }
    
    func sendSMSError(error: String) {
        print(error.description)
    }
    
    
}

