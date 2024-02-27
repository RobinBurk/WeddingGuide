import SwiftUI

enum ChangeEmailActiveAlert {
    case error, success
}

struct ChangeEmailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    var parentGeometry: GeometryProxy
    
    @State private var currentPassword = ""
    @State private var newEmail = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isCurrentPasswordVisible = false
    @State private var changeEmailActiveAlert: ChangeEmailActiveAlert = .error
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer().frame(width: 60)
                ZStack (alignment: .trailing) {
                    if isCurrentPasswordVisible {
                        TextField("Aktuelles Passwort", text: $currentPassword)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.custom("Lustria-Regular", size: 18))
                            .padding()
                            .background(Color(hex: 0xB8C7B9))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .cornerRadius(10)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                    } else {
                        SecureField("Aktuelles Passwort", text: $currentPassword)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.custom("Lustria-Regular", size: 18))
                            .padding()
                            .background(Color(hex: 0xB8C7B9))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .cornerRadius(10)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                    }
                    
                    Button(action: {
                        isCurrentPasswordVisible.toggle()
                    }) {
                        Image(systemName: isCurrentPasswordVisible ? "eye.slash" : "eye")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(hex: 0x425C54))
                            .fontWeight(.bold)
                    }
                }
                Spacer().frame(width: 60)
            }
            
            HStack {
                Spacer().frame(width: 60)
                TextField("Neue E-Mail", text: $newEmail)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.custom("Lustria-Regular", size: 18))
                    .padding()
                    .background(Color(hex: 0xB8C7B9))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .cornerRadius(10)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                Spacer().frame(width: 60)
            }
            
            Button(action: {
                changeEmail()
            }) {
                HStack {
                    Image(systemName: "envelope.fill")
                    Text("E-Mail ändern")
                }
                .padding()
                .font(.custom("Lustria-Regular", size: 18))
                .background(Color(hex: 0x425C54))
                .foregroundColor(.white)
                .cornerRadius(10)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            }
            
            Spacer()
        }
        .alert(isPresented: $showAlert) {
            switch changeEmailActiveAlert {
            case .error:
                return Alert(
                    title: Text("Fehler"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            case .success:
                return Alert(
                    title: Text("Erfolgreich"),
                    message: Text("E-Mail wurde erfolgreich geändert."),
                    dismissButton: .default(Text("OK"))
                )
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
                Toolbar(presentationMode: presentationMode, parentGeometry: parentGeometry, title: "E-Mail")
            }
        }
        .foregroundColor(.white)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(hex: 0x425C54), for: .navigationBar)
    }
    
    private func changeEmail() {
        userModel.updateEmail(currentPassword: currentPassword, newEmail: newEmail) { error in
            if let nsError = error {
                alertMessage = nsError.localizedDescription
                changeEmailActiveAlert = ChangeEmailActiveAlert.error
                showAlert.toggle()
            } else {
                changeEmailActiveAlert = ChangeEmailActiveAlert.success
                showAlert.toggle()
            }
        }
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
}
