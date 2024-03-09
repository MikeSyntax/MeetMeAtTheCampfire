//
//  TranslatorScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 08.03.24.
//

import SwiftUI

struct TranslatorScreenView: View {
    @StateObject var translatorVm: TranslatorScreenViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Text eingeben")){
                        TextField("Texteingabe für die Übersetzung", text: $translatorVm.textToTranslate)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .lineLimit(5, reservesSpace: true)
                            .textFieldStyle(.roundedBorder)
                           
                    }
                    Section(header: Text("Es wird übersetzt von")){
                        HStack{
                            Text("Deutsch")
                            Spacer()
                            ButtonTextAction(iconName: "network", text: "Übersetzen"){
                                translatorVm.translate()
                            }
                            Spacer()
                            Text("\(translatorVm.languageChoice.name)")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    Section(header: Text("Übersetzung")){
                        TextField("Übersetzung", text: $translatorVm.translatedText)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .lineLimit(5, reservesSpace: true)
                            .textFieldStyle(.roundedBorder)
                    }
                }
            }
            .navigationTitle(Text("Übersetzer"))

        }
    }
}

#Preview {
    TranslatorScreenView(translatorVm: TranslatorScreenViewModel(languageChoice: Language(code: "en", name: "Englisch")))
}
