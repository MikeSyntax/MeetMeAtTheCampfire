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
                        Section(header: Text("Wähle hier Deine Zielsprache aus").foregroundStyle(.primary)){
                            Picker("Übersetze nach", selection: $selectionLanguage) {
                                ForEach(languageVm.languages, id: \.code) { language in
                                    Text(language.name)
                                        .tag(language)
                                }
                            }
                            .pickerStyle(.menu)
                            .onChange(of: selectionLanguage) { languageVm.languageChoice = selectionLanguage }
                        }
                        Section(header: Text("Text eingeben").foregroundStyle(.primary)){
                            TextField("Texteingabe für die Übersetzung", text: $languageVm.textToTranslate, axis: .vertical)
                                .overlay(
                                    GeometryReader { proxy in
                                        Color.clear
                                            .onTapGesture {
                                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                            }
                                    }
                                )
                                .onChange(of: languageVm.textToTranslate) { newValue, _ in
                                    if newValue.count > 300 {
                                        languageVm.textToTranslate = String(newValue.prefix(300))
                                    }
                                }
                                
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .lineLimit(1...5)
                                .textFieldStyle(.roundedBorder)
                                .frame(minHeight: 40)
                        }
                        Section(header: Text("Es wird übersetzt von").foregroundStyle(.primary)){
                            HStack{
                                Text("\(selectionSourceLanguage.name)")
                                    .font(.system(size: 14))
                                Spacer()
                                ButtonTextAction(iconName: "network", text: "Übersetzen"){
                                    languageVm.translateLanguage()
                                    languageVm.textToTranslate = ""
                                onCommit: do {
                                   UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                               }
                                }
                                Spacer()
                                Text("\(selectionLanguage.name)")
                                    .font(.system(size: 14))
                            }
                            .frame(maxWidth: .infinity, minHeight: 70, alignment: .center)
                        }
                        Section(header: Text("Übersetzung").foregroundStyle(.primary)){
                            TextField("Übersetzung", text: $languageVm.translatedText, axis: .vertical)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .lineLimit(1...5)
                                .textFieldStyle(.roundedBorder)
                                .frame(minHeight: 40)
                        }
                    }
                }
                Divider()
            }
            .scrollContentBackground(.hidden)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
            .navigationBarTitle("Mein Übersetzer", displayMode: .inline)
        }
        .onAppear {
            languageVm.loadLanguages()
        }
        .onDisappear{
            languageVm.clearTextFields()
            selectionLanguage = Language(code: "af", name: "Afrikaans")
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    let languageVm = LanguageScreenViewModel(languageChoice: Language(code: "de", name: "Deutsch"), languageSource: Language(code: "af", name: "Afrikaans"))
    return LanguageScreenView(languageVm: languageVm)
}
