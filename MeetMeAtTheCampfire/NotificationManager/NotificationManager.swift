//
//  NotificationManager.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 08.06.24.
//

import Foundation
import UserNotifications

@MainActor
final class NotificationManager {
    static let shared = NotificationManager()
    
    //Permission for sending notifications
    func allowNotifications(){
        UNUserNotificationCenter.current()
            .requestAuthorization (
                options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("Accepted")
                    } else if let error {
                        print("error: \(error.localizedDescription)")
                    }
                }
    }
    
    //User Notification with timeInterval
    func notificationContent() {
        let subtitleText: [String] = [
            "Schreibe etwas im Campfire",
            "Schreibe eine Nachricht",
            "Mache einen Logbuch Eintrag",
            "Füge ein neues Foto ins Logbuch ein",
            "Hast Du schon eine Kategorie Urlaub?",
            "Die Kategorie Einkaufen ist auch wichtig",
        
        ]
        let randomSubtitleText: String = subtitleText.randomElement() ?? "No subtitle"
        
        let titleText: [String] = [
            "Campfire vermisst dich",
            "Öffne Campfire",
            "Beschreibe Deine Erlebnisse",
            "Neues im Campfire",
        ]
        let randomTitleText: String = titleText.randomElement() ?? "No title"
        
        let content = UNMutableNotificationContent()
        content.title = randomTitleText
        content.subtitle = randomSubtitleText
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    //Remove all Notifications
    func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
