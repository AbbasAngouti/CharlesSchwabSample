//
//  VideoPlayer.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 12/3/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class VideoPlayer: AVPlayerViewController, AVPlayerViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func playVideo(urlString: String) {
        
        player = AVPlayer(URL: NSURL(string: urlString)!)
        player?.play()
    }
}
