//
//  MeetMeAtTheCampfireApp.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 28.02.24.
//

import SwiftUI
import Firebase
import SwiftData

@main
struct MeetMeAtTheCampfireApp: App {
    
    @StateObject var authVm = AuthViewModel()
    
    init(){
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if authVm.userLoggedIn {
                MainScreenView(authVm: authVm)
                    .environmentObject(authVm)
            } else {
                LoginView()
                    .environmentObject(authVm)
            }
        }
        .modelContainer(for: LogBookAtivity.self)
        .environment(\.locale, .init(identifier: "de"))
    }
}

