//
//  ChatScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//

import SwiftUI

struct ChatScreenView: View {
    var body: some View {
        NavigationStack{
            VStack{
                Text("Chat Ansicht!")
                Spacer()
            }
            .toolbar {
                Button{
                    //todo
                } label: {
                    Text("New")
                    Image(systemName: "plus.circle")
                }
            }
            .navigationTitle("Chat")
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea())
        }
    }
}

#Preview {
    ChatScreenView()
}
