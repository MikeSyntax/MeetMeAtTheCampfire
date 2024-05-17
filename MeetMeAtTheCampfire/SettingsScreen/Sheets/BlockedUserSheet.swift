//
//  BlockedUserSheet.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 17.05.24.
//

import SwiftUI
import SwiftData

struct BlockedUserSheet: View {
    
    @Environment(\.modelContext) private var context
    @Query private var blockedUsers: [BlockedUser]
    @Environment (\.dismiss) private var dismiss
    @Binding var showBlockedUserSheet: Bool
    
    var body: some View {
        NavigationStack{
            VStack{
                Divider()
                List{
                    if blockedUsers.isEmpty {
                        Text("Du hast keine User blockiert")
                    } else {
                        ForEach (blockedUsers){ item in
                            HStack{
                                Text("User: \(item.userName)")
                                    .font(.system(size: 12))
                                    .bold()
                                Spacer()
                                Text("swipen zum Rückgängigmachen")
                                    .font(.system(size: 10))
                            }
                        }
                        .onDelete{ indexes in
                            for index in indexes {
                                deleteItem(blockedUsers[index])
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
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Zurück"){
                        dismiss()
                    }
                }
            }
        }
    }
    //BlockedUser delete from SwiftData
    func deleteItem(_ blockedUser: BlockedUser){
        context.delete(blockedUser)
    }
}

#Preview {
    BlockedUserSheet(showBlockedUserSheet: .constant(false))
        .modelContainer(for: [LogBookAtivity.self, BlockedUser.self])
}
