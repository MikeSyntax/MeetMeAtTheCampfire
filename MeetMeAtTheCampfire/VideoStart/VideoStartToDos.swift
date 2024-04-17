//
//  VideoStartToDos.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 17.04.24.
//

import SwiftUI
import AVFoundation
import AVKit
import UIKit

class VideoStartToDos: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "startToDo", ofType: "MP4")!))
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        player.volume = 0
        player.play()
    }
}

//#Preview {
//    VideoStartToDos()
//}
