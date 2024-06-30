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
    @State private var showProgressiveView: Bool = true
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if showProgressiveView {
                    Text("Loading Campfire")
                        .padding()
                    ProgressView()
                        .progressViewStyle(DefaultProgressViewStyle())
                        .scaleEffect(3)
                } else {
                    if authVm.userLoggedIn {
                        MainScreenView(authVm: authVm)
                            .environmentObject(authVm)
                    } else {
                        LoginView()
                            .environmentObject(authVm)
                    }
                }
            }
            .environment(\.locale, .init(identifier: "de"))
            .modelContainer(for: [LogBookAtivity.self])
            .onAppear{
                isStartScreenLoading()
            }
        }
    }
    
    func isStartScreenLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showProgressiveView = false
        }
    }
}
