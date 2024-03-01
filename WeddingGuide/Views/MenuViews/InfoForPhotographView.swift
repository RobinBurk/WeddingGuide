import SwiftUI
import MessageUI

struct InfoForPhotographView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    var parentGeometry: GeometryProxy
    
    @State private var isKeyboardVisible = false
    @State var emailRecipient = "";
    @State var emailBody = "";
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var showAlert = false
    
    @State private var weddingMotto = ""
    @State private var dressCode = ""
    @State private var outfitAndHairstyleInfo = ""
    @State private var importantDetails = ""
    @State private var addressWedding = ""
    @State private var addressParty = ""
    @State private var namePrideAndGrum = ""
    @State private var nameWitnesses = ""
    @State private var nameChilds = ""
    @State private var nameFamiliy = ""
    @State private var groupPicturesList = ""
    @State private var plannedActions = ""
    @State private var additionalInfo = ""
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack(alignment: .leading, spacing: 16) {
                    createSectionWithTitle("Hochzeitsmotto oder roter Faden", text: $weddingMotto, hint: "")
                    createSectionWithTitle("Dresscode", text: $dressCode, hint: "Alles in weiß")
                    createSectionWithTitle("Wichtiges für euch zum Fotografieren", text: $importantDetails, hint: "Dekoelemente")
                    createSectionWithTitle("Adresse für die Trauung", text: $addressWedding, hint: "")
                    createSectionWithTitle("Adresse für die Festlocation", text: $addressParty, hint: "")
                    createSectionWithTitle("Namen des Brautpaares", text: $namePrideAndGrum, hint: "")
                    createSectionWithTitle("Namen der Trauzeugen + Telefonnummer", text: $nameWitnesses, hint: "")
                    createSectionWithTitle("Namen der Kinder", text: $nameChilds, hint: "")
                    createSectionWithTitle("Zukünftiger Familienname", text: $nameFamiliy, hint: "")
                    createSectionWithTitle("Gewünschte Gruppenbilder-Konstelationen", text: $groupPicturesList, hint: "Familie, Fußballmannschaft, Freundinen")
                    createSectionWithTitle("Geplante Aktionen", text: $plannedActions, hint: "Spalier, Rituale, Spiele, Überraschungen")
                    createSectionWithTitle("Weitere wichtige Informationen", text: $additionalInfo, hint: "")
                    
                    HStack {
                        Button("Senden an Jovi") {
                            updateUser()
                            sendEmail(recipient: "kwickshot@gmx.de", subject: "WeddingGuide - Neue Informationen | \(userModel.user?.lastName ?? "tempLastName")")
                        }
                        .disabled(!MFMailComposeViewController.canSendMail())
                        .padding()
                        .font(.custom("Lustria-Regular", size: 18))
                        .background(Color(hex: 0x425C54))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        
                        Button("Senden an Julia") {
                            updateUser()
                            sendEmail(recipient: "julia_krause_fotografie@web.de", subject: "WeddingGuide - Neue Informationen | \(userModel.user?.lastName ?? "tempLastName")")
                        }
                        .disabled(!MFMailComposeViewController.canSendMail())
                        .padding()
                        .font(.custom("Lustria-Regular", size: 18))
                        .background(Color(hex: 0x425C54))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
            }
            .onAppear {
                weddingMotto = userModel.user?.weddingMotto ?? ""
                dressCode = userModel.user?.dressCode ?? ""
                importantDetails = userModel.user?.importantDetails ?? ""
                addressWedding = userModel.user?.addressWedding ?? ""
                addressParty = userModel.user?.addressParty ?? ""
                namePrideAndGrum = userModel.user?.namePrideAndGrum ?? ""
                nameWitnesses = userModel.user?.nameWitnesses ?? ""
                nameChilds = userModel.user?.nameChilds ?? ""
                nameFamiliy = userModel.user?.nameFamiliy ?? ""
                groupPicturesList = userModel.user?.groupPicturesList ?? ""
                plannedActions = userModel.user?.plannedActions ?? ""
                additionalInfo = userModel.user?.additionalInfo ?? ""
            }
            .onDisappear {
                userModel.update()
            }
            .onTapGesture {
                // Dismiss the keyboard when tapped outside the text fields
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .onTapGesture {
            // Dismiss the keyboard when tapped outside the text fields.
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .swipeToDismiss()
        .padding(.top, 10)
        .navigationBarBackButtonHidden()
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Toolbar(presentationMode: presentationMode, parentGeometry: parentGeometry, title: "Info's für Fotografen")
            }
        }
        .foregroundColor(.white)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(hex: 0x425C54), for: .navigationBar)
    }
    
    private func updateUser() {
        userModel.user?.weddingMotto = weddingMotto
        userModel.user?.dressCode = dressCode
        userModel.user?.importantDetails = importantDetails
        userModel.user?.addressWedding = addressWedding
        userModel.user?.addressParty = addressParty
        userModel.user?.namePrideAndGrum = namePrideAndGrum
        userModel.user?.nameWitnesses = nameWitnesses
        userModel.user?.nameChilds = nameChilds
        userModel.user?.nameFamiliy = nameFamiliy
        userModel.user?.groupPicturesList = groupPicturesList
        userModel.user?.plannedActions = plannedActions
        userModel.user?.additionalInfo = additionalInfo
        userModel.update()
    }
    
    private func sendEmail(recipient: String, subject: String) {
        guard let user = userModel.user else {
            return
        }
        
        let emailBody = """
                               Neue Nachricht von \(user.firstName) \(user.lastName).
                               Hochzeitsmotto oder roter Faden: \(user.weddingMotto)
                               Dresscode: \(user.dressCode)
                               Wichtiges für euch zum Fotografieren: \(user.importantDetails)
                               Adresse für die Trauung: \(user.addressWedding)
                               Adresse für die Festlocation: \(user.addressParty)
                               Namen des Brautpaares: \(user.namePrideAndGrum)
                               Namen der Trauzeugen + Telefonnummer: \(user.nameWitnesses)
                               Namen der Kinder: \(user.nameChilds)
                               Zukünftiger Familienname: \(user.nameFamiliy)
                               Gewünschte Gruppenbilder-Konstellationen: \(user.groupPicturesList)
                               Geplante Aktionen: \(user.plannedActions)
                               Weitere wichtige Informationen: \(user.additionalInfo)
                               """
        
        if let emailURL = createEmailURL(recipient: recipient, subject: subject, body: emailBody) {
            if UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
            } else {
                showAlert(title: "Fehler", message: "E-Mail konnte nicht geöffnet werden. Überprüfen Sie Ihre E-Mail-Konfiguration.")
            }
        } else {
            showAlert(title: "Fehler", message: "E-Mail konnte nicht geöffnet werden. Überprüfen Sie Ihre E-Mail-Konfiguration.")
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        
        DispatchQueue.main.async {
            showAlert = true
        }
    }
    
    private func createSectionWithTitle(_ title: String, text: Binding<String>, hint: String) -> some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text(title).foregroundColor(.white).font(.custom("Lustria-Regular", size: 18)).shadow(radius: 10)
                TextEditorWrapper(text: text)
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    .frame(minHeight: 60)
                    .cornerRadius(10)
            }
        }
        .padding()
        .shadow(radius: 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(hex: 0xB8C7B9))
        )
    }
    
    struct TextEditorWrapper: View {
        @Binding var text: String
        
        var body: some View {
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text("Dein Placeholder-Text")
                        .foregroundColor(Color.gray)
                        .padding(.leading, 5)
                        .padding(.top, 8)
                }
                TextEditor(text: $text)
                    .foregroundColor(.black)
                    .disableAutocorrection(true)
                    .autocapitalization(.sentences)
                    .onSubmit {
                        self.text += "\n" // On enter, add new line
                    }
            }
        }
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
}
