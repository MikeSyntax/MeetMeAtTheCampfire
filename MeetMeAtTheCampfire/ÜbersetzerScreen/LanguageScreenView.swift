//
//  LanguageScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 09.03.24.
//

import SwiftUI

struct LanguageScreenView: View {
    
    @ObservedObject var languageVm: LanguageScreenViewModel
    @State private var selectionLanguage: Language = Language(code: "af", name: "Afrikaans")
    @State private var selectionSourceLanguage: Language = Language(code: "de", name: "Deutsch")
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                ZStack{
                    Form {
                        Section(header: Text("Wähle hier Deine Zielsprache aus").foregroundStyle(.black)){
                            Picker("Übersetze nach", selection: $selectionLanguage) {
                                ForEach(languageVm.languages, id: \.code) { language in
                                    Text(language.name)
                                        .tag(language)
                                }
                            }
                            .pickerStyle(.menu)
                            .onChange(of: selectionLanguage) { languageVm.languageChoice = selectionLanguage }
                        }
                        Section(header: Text("Text eingeben").foregroundStyle(.black)){
                            TextField("Texteingabe für die Übersetzung", text: $languageVm.textToTranslate, axis: .vertical)
                                .shadow(color: .cyan, radius: 2)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .lineLimit(1...5)
                                .scaleEffect(x: 80, y: 80)
                                .textFieldStyle(.roundedBorder)
                                .frame(minHeight: 40)
                                .scrollContentBackground(.hidden)
                        }
                        Section(header: Text("Es wird übersetzt von").foregroundStyle(.black)){
                            HStack{
                                Text("\(selectionSourceLanguage.name)")
                                Spacer()
                                ButtonTextAction(iconName: "network", text: "Übersetzen ->"){
                                    languageVm.translateLanguage()
                                }
                                Spacer()
                                Text("\(selectionLanguage.name)")
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        Section(header: Text("Übersetzung").foregroundStyle(.black)){
                            TextField("Übersetzung", text: $languageVm.translatedText, axis: .vertical)
                                .shadow(color: .green, radius: 2)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .lineLimit(1...5)
                                .textFieldStyle(.roundedBorder)
                                .frame(minHeight: 40)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea())
            
            .navigationTitle("Übersetzer")
        }
        .onAppear {
            languageVm.loadLanguages()
        }
        .onDisappear{
            languageVm.clearTextFields()
            selectionLanguage = Language(code: "af", name: "Afrikaans")
        }
    }
}

#Preview {
    LanguageScreenView(languageVm: LanguageScreenViewModel(languageChoice: Language(code: "de", name: "Deutsch"), languageSource: Language(code: "af", name: "Afrikaans")))
}
