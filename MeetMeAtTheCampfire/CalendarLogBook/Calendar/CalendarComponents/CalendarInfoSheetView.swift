//
//  CalendarInfoSheetView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 23.04.24.
//

import SwiftUI

struct CalendarInfoSheetView: View {
    
    @Binding var showInfoSheet: Bool
    @Binding var infoButtonIsActive: Bool
    
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
                        Image(.infoSheet)
                            .resizable()
                            .scaledToFit()
                            .opacity(0.6)
                            .cornerRadius(5)
                            .frame(width: 300)
                    }
                    VStack{
                        ButtonTextAction(iconName: "arrow.down.right.and.arrow.up.left", text: "Nicht mehr anzeigen"){
                            infoButtonIsActive.toggle()
                            showInfoSheet.toggle()
                        }
                        .padding(20)
                    }
                }
                .toolbar(content: {
                    Button("Zurück") {
                        showInfoSheet.toggle()
                    }
                })
            }
        }
    }
}

#Preview {
    CalendarInfoSheetView(showInfoSheet: .constant(false), infoButtonIsActive: .constant(true))
}
