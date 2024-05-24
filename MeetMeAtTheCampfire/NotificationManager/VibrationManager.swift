//
//  VibrationManager.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 24.05.24.
//

import Foundation
import SwiftUI

@MainActor
final class VibrationManager {
    static let shared = VibrationManager()
    
    func triggerSuccessVibration() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
}

