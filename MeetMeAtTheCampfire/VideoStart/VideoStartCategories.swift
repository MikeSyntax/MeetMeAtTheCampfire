//
//  VideoStartCategories.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 17.04.24.
//

import SwiftUI
import AVFoundation
import AVKit
import UIKit

struct VideoStartCategoriesView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> VideoStartCategories {
        return VideoStartCategories()
    }
    
    func updateUIViewController(_ uiViewController: VideoStartCategories, context: Context) {
    }
}

class VideoStartCategories: UIViewController {
    private var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let url = Bundle.main.url(forResource: "Cat", withExtension: "MP4") else {
            return
        }
        
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
        player?.volume = 0
        player?.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
            player?.play()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
