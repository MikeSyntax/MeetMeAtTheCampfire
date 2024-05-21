//
//  BlockedUserSheet.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 17.05.24.
//

import SwiftUI

struct BlockedUserSheet: View {
    
    @StateObject private var chatManager = ChatManager.shared
    @Environment (\.dismiss) private var dismiss
    @Binding var showBlockedUserSheet: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                List {
                    if chatManager.excludedUserIds.isEmpty {
                        Text("Du hast keine User blockiert")
                    } else {
                        ForEach(chatManager.excludedUserIds.indices, id: \.self) { index in
                            VStack {
                                Text("User: \(chatManager.excludedUserIds[index])")
                                    .font(.system(size: 12))
                                    .bold()
                                Spacer()
                                Text("swipen zum Rückgängigmachen")
                                    .font(.system(size: 10))
                            }
                            .padding(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
                        }
                        .onDelete { indexes in
                            for index in indexes {
                                chatManager.removeExcludedUserId(chatManager.excludedUserIds[index])
                            }
                        }
                    }
                }
                .padding(.top, -30)
                .background(Color.clear)
                .scrollContentBackground(.hidden)
            }
            .padding()
            .navigationBarTitle("Meine blockierten User")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Zurück") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear{
            chatManager.readExcludedUserList()
        }
        .onDisappear{
            chatManager.removeListener()
        }
    }
}


#Preview {
    BlockedUserSheet(showBlockedUserSheet: .constant(false))
}
