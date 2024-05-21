//
//  ReactionPovover.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 21.05.24.
//

import Foundation
import SwiftUI

struct ReactionPopover: View {
    @Binding var selectedChatSenderViewModel: ChatItemViewModel?
    @ObservedObject var chatVm: ChatScreenViewModel
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    react(with: "")
                    dismiss()
                }) {
                    Text("")
                }
                Button(action: {
                    react(with: "👍")
                    dismiss()
                }) {
                    Text("👍")
                        .padding(20)
                }
                Button(action: {
                    react(with: "")
                    dismiss()
                }) {
                    Text("")
                }
            }
        }
        .padding()
    }
    
    private func react(with reaction: String) {
        guard let chatSenderViewModel = selectedChatSenderViewModel else { return }
        chatVm.addReaction(chatSenderVm: chatSenderViewModel, reaction: reaction)
        selectedChatSenderViewModel = nil
    }
}
