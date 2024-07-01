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
                    ZStack{
                        Image("background")
                            .resizable()
                            .scaledToFill()
                            .opacity(0.2)
                            .ignoresSafeArea(.all)
                        Text("Loading Campfire")
                            .foregroundColor(.primary)
                            .padding(EdgeInsets(top: -60, leading: 0, bottom: 0, trailing: 0))
                        ProgressView()
                            .progressViewStyle(DefaultProgressViewStyle())
                            .scaleEffect(3)
                    }
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
                authVm.checkLogStatus()
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
