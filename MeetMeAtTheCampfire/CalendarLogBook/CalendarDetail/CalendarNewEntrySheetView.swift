//
//  CalendarNewEntrySheetView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 26.04.24.
//

import SwiftUI

struct CalendarNewEntrySheetView: View {
    @Binding var showToDoSheet: Bool
    @AppStorage("entryButton") private var entryButtonIsActive: Bool = true
   
    var body: some View {
        NavigationStack{
            ZStack{
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all)
                VStack{
                    VStack{
                        Image(.noProject)
                            .resizable()
                            .scaledToFit()
                            .opacity(0.6)
                            .cornerRadius(5)
                            .frame(width: 300)
                    }
                    VStack{
                        ButtonTextAction(iconName: "arrow.down.right.and.arrow.up.left", text: "Nicht mehr anzeigen"){
                            entryButtonIsActive = false
                            showToDoSheet.toggle()
                        }
                        .padding(20)
                    }
                }
                .toolbar(content: {
                    Button("Zurück") {
                        showToDoSheet.toggle()
                    }
                })
            }
        }
        .background(Color(UIColor.systemBackground))
    }
}


#Preview {
    CalendarNewEntrySheetView(showToDoSheet: .constant(false))
}
