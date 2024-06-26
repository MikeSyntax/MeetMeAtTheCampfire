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
    
    private init() {}
    //Permission for sending notifications
    func allowNotifications(){
        UNUserNotificationCenter.current()
            .requestAuthorization (
                options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("Permission accepted")
                        self.notificationContent()
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
            "Kategorie Camper erstellen",
            "Wie ist die Planung für den Urlaub",
            "Frage im Campfire nach schönen Plätzen",
            "Schöne Erlebnisse müssen ins Logbuch"
        
        ]
        let randomSubtitleText: String = subtitleText.randomElement() ?? "No subtitle"
        
        let titleText: [String] = [
            "Campfire vermisst dich",
            "Öffne Campfire",
            "Beschreibe Deine Erlebnisse",
            "Neues im Campfire",
            "Heute wichtig"
        ]
        let randomTitleText: String = titleText.randomElement() ?? "No title"
        
        let hour: [Int] = [8,9,10,11,12,13,14,15,16,17,18,19,20]
        let randomHour: Int = hour.randomElement() ?? 0
        let minute = 34
        let isDaily = true
        
        let content = UNMutableNotificationContent()
        content.title = randomTitleText
        content.subtitle = randomSubtitleText
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.hour = randomHour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
//      let request = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        self.removeAllPendingNotifications()
        
        UNUserNotificationCenter.current().add(request)
    }
    
    //Remove all Notifications
    func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
