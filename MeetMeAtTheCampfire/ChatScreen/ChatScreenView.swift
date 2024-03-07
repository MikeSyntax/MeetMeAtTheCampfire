//
//  ChatScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//

import SwiftUI

struct ChatScreenView: View {
    
    @ObservedObject var chatVm = ChatScreenViewModel()
    @State private var newMessage: String = ""
    
    var body: some View {
        NavigationStack{
            VStack{
              
                ScrollView{
                    ForEach(chatVm.chatSenderViewModels) {
                        chatSenderViewModel in
                        ChatSenderView(chatSenderVm: chatSenderViewModel)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                Spacer()
                HStack{
                    TextField("Neue Nachricht", text: $newMessage)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .padding()
                    ButtonTextAction(iconName: "plus", text: "Neu"){
                        //todo AddNewMessage
                    }
                }
                .padding(.leading)
                .padding(.trailing)
            }
            .toolbar {
                Button{
                    //todo Search
                } label: {
                    Text("Suche")
                    Image(systemName: "magnifyingglass")
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
    ChatScreenView(chatVm: ChatScreenViewModel())
}
