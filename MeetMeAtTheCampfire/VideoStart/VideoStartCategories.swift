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
        //update the ViewController if needed
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


//#Preview {
//    VideoStartCategories()
//}


//import SwiftUI
//import AVFoundation
//import AVKit
//import UIKit
//
//struct VideoStartCategoriesView: UIViewControllerRepresentable {
//    var shouldPlay: Bool
//
//    func makeUIViewController(context: Context) -> VideoStartCategories {
//        return VideoStartCategories(shouldPlay: shouldPlay)
//    }
//
//    func updateUIViewController(_ uiViewController: VideoStartCategories, context: Context) {
//        uiViewController.shouldPlay = shouldPlay
//    }
//}
//
//class VideoStartCategories: UIViewController {
//    private var player: AVPlayer?
//    var shouldPlay: Bool = true {
//        didSet {
//            if shouldPlay {
//                player?.play()
//            } else {
//                player?.pause()
//            }
//        }
//    }
//
//    init(shouldPlay: Bool) {
//        self.shouldPlay = shouldPlay
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        guard let url = Bundle.main.url(forResource: "Cat", withExtension: "MP4") else {
//            return
//        }
//
//        player = AVPlayer(url: url)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.videoGravity = .resizeAspect
//        playerLayer.frame = view.bounds
//        view.layer.addSublayer(playerLayer)
//        player?.volume = 0
//
//        if shouldPlay {
//            player?.play()
//        }
//
//        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
//    }
//
//    @objc func playerItemDidReachEnd(notification: Notification) {
//        if let playerItem = notification.object as? AVPlayerItem {
//            playerItem.seek(to: .zero, completionHandler: nil)
//            player?.play()
//        }
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//}
