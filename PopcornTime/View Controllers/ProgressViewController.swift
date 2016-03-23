//
//  ProgressViewController.swift
//  PopcornTime
//
//  Created by Yogi Bear on 3/18/16.
//  Copyright © 2016 PopcornTime. All rights reserved.
//

import UIKit
import PopcornTorrent
import AVKit
import TVMLKitchen
import Kingfisher

class ProgressViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var magnet: String!
    var movieName: String!
    var imageAddress: String!
    
    var downloading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = magnet, let _ = movieName, let _ = imageAddress {
            nameLabel.text = "Downloading " + movieName + "..."
            imageView.kf_setImageWithURL(NSURL(string: "https:" + imageAddress)!)
            
            if downloading {
                return
            }
            
            PTTorrentStreamer.sharedStreamer().startStreamingFromFileOrMagnetLink(magnet, progress: { status in
                self.downloading = true
                self.progressView.progress = status.bufferingProgress
            }, readyToPlay: { url in
                
                let playerController = ACPlayerViewController()
                playerController.player = AVPlayer(URL: url)
                playerController.player?.play()
                Kitchen.appController.navigationController.pushViewController(playerController, animated: true)
            }) { error in
                print(error)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        PTTorrentStreamer.sharedStreamer().cancelStreaming()
    }


}
