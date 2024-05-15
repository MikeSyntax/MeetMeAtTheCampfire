//
//  CalendarInfoSheetView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 23.04.24.
//

import SwiftUI

struct CalendarInfoSheetView: View {
    
    @Binding var showInfoSheet: Bool
    @AppStorage("infoButton") private var infoButtonIsActive: Bool = true
    
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
                            .opacity(0.7)
                            .cornerRadius(10)
                            .frame(width: 250)
                    }
                    VStack{
                        ButtonTextAction(
                            iconName: "arrow.down.right.and.arrow.up.left",
                            text: "Nicht mehr anzeigen"){
                            infoButtonIsActive = false
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
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    return CalendarInfoSheetView(showInfoSheet: .constant(false))
}
