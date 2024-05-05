//
//  PrivacySheet.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 04.05.24.
//

import SwiftUI

struct PrivacySheet: View {
    
    @Binding var showPrivacySheet: Bool
    
    var body: some View {
        NavigationStack{
            VStack{
                Divider()
                ScrollView{
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Datenschutzerklärung".uppercased())
                            .bold()
                            .underline()
                            .font(.system(size: 15, design: .monospaced))
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        Text("Der Schutz Ihrer persönlichen Daten ist uns ein besonderes Anliegen. Wir verarbeiten Ihre Daten ausschließlich auf Grundlage der gesetzlichen Bestimmungen (DSGVO, TKG 2003). In dieser Datenschutzinformation informieren wir Sie über die wichtigsten Aspekte der Datenverarbeitung im Rahmen unserer App. Wir nutzen Firebase Analytics, um allgemeine Nutzungsstatistiken zu sammeln und unser Angebot zu verbessern. Diese Statistiken enthalten keine personenbezogenen Daten und sind vollständig anonymisiert.")
                        Divider()
                        Text("Datenschutzerklärung für die App - Meet me at the campfire")
                            .bold()
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        Text("1. Einleitung")
                            .bold()
                            .font(.system(size: 15, design: .monospaced))
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        Text("Diese Datenschutzerklärung gilt für die iOS-App „Meet me at the campfire“, im Folgenden „App“ genannt, die im Apple App Store veröffentlicht wurde und frei verfügbar ist. Entwickelt und veröffentlicht wurde die App von \(Adress.adressKey), im weiteren Verlauf „Entwickler“ genannt. Der Schutz Ihrer persönlichen Daten ist uns ein besonderes Anliegen. In dieser Datenschutzerklärung informieren wir Sie über die Verarbeitung Ihrer personenbezogenen Daten bei der Nutzung unserer App.")
                        Divider()
                        Text("2. Verantwortlicher")
                            .bold()
                            .font(.system(size: 15, design: .monospaced))
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        Text("Der Verantwortliche für die Verarbeitung Ihrer personenbezogenen Daten im Zusammenhang mit der App ist: \(Adress.adressKey). Zum Datenschutz können Sie jederzeit unter der oben genannten Adresse oder per E-Mail an \(Email.emailKey) an den Entwickler wenden.")
                        Divider()
                        Text("3. Verarbeitung personenbezogener Daten")
                            .bold()
                            .font(.system(size: 15, design: .monospaced))
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        Text("Für die Nutzung der App ist die Erstellung eines Benutzerkontos unter Angabe personenbezogener Daten wie E-Mail, Benutzername und Passwort erforderlich. Die Kontoerstellung und -verwaltung erfolgt über den Dienst Firebase in anonymisierter Form. Das bedeutet, dass wir keine personenbezogenen Daten wie Namen, E-Mail-Adressen oder Telefonnummern speichern, die direkt auf Ihre Identität schließen lassen.")
                        Divider()
                        Text("4. Zweck der Datenverarbeitung")
                            .bold()
                            .font(.system(size: 15, design: .monospaced))
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        Text("Die Erstellung des Benutzerkontos in Firebase dient dazu, personalisierte Funktionen der App zur Verfügung zu stellen und die Nutzungserfahrung zu verbessern. Die Datenverarbeitung erfolgt ausschließlich zu dem Zwecke, die Funktionalität der App zu gewährleisten und diese zu verbessern.")
                        Divider()
                        Text("5. Löschung von Daten")
                            .bold()
                            .font(.system(size: 15, design: .monospaced))
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        Text("Sie haben jederzeit die Möglichkeit, Ihr Benutzerkonto in den Einstellungen der App zu löschen. Mit der Löschung Ihres Kontos werden alle damit verbundenen Daten unwiederbringlich entfernt.")
                        Divider()
                        Text("6. Rechte der betroffenen Person")
                            .bold()
                            .font(.system(size: 15, design: .monospaced))
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        Text("Sie haben das Recht auf Auskunft, Berichtigung, Löschung, Einschränkung der Verarbeitung, Datenübertragbarkeit und Widerspruch bezüglich Ihrer personenbezogenen Daten. Wenn Sie glauben, dass die Verarbeitung Ihrer Daten gegen das Datenschutzrecht verstößt oder Ihre datenschutzrechtlichen Ansprüche sonst in einer Weise verletzt worden sind, können Sie sich bei der Aufsichtsbehörde beschweren.")
                        Divider()
                        Text("7. Änderungen dieser Datenschutzerklärung")
                            .bold()
                            .font(.system(size: 15, design: .monospaced))
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        Text("Wir behalten uns vor, diese Datenschutzerklärung zu ändern, um sie an veränderte Rechtslagen oder Änderungen der App sowie der Datenverarbeitung anzupassen. Die Nutzer werden gebeten, sich regelmäßig über den Inhalt der Datenschutzerklärung zu informieren.")
                        Divider()
                        Text("Datum der letzten Aktualisierung: 04.05.2024")
                            .bold()
                    }
                    .padding(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.cyan, lineWidth: 2)
                    )
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    Spacer()
                }
                Divider()
            }
            .toolbar{
                Button("Fertig"){
                    showPrivacySheet.toggle()
                }
            }
            .navigationBarTitle("Datenschutz", displayMode: .inline)
            .scrollContentBackground(.hidden)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
        }
        .background(Color(UIColor.systemBackground))
    }
}


#Preview {
    PrivacySheet(showPrivacySheet: .constant(false))
}
