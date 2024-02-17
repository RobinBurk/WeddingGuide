import SwiftUI

enum ChangePasswordActiveAlert {
    case error, success
}

struct ChangePasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isCurrentPasswordVisible = false
    @State private var isPasswordVisible = false
    @State private var changePasswordActiveAlert: ChangePasswordActiveAlert = .error
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Spacer().frame(width: 60)
                ZStack (alignment: .trailing) {
                    if isCurrentPasswordVisible {
                        TextField("Aktuelles Password", text: $currentPassword)
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
                        SecureField("Aktuelles Password", text: $currentPassword)
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
                SecureField("Neues Password", text: $newPassword)
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
            
            HStack {
                Spacer().frame(width: 60)
                ZStack (alignment: .trailing) {
                    if isPasswordVisible {
                        TextField("Passwort bestätigen", text: $confirmPassword)
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
                        SecureField("Passwort bestätigen", text: $confirmPassword)
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
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(hex: 0x425C54))
                            .fontWeight(.bold)
                    }
                }
                Spacer().frame(width: 60)
            }
            
            Button(action: {
                changePassword()
            }) {
                HStack {
                    Image(systemName: "lock.rotate")
                    Text("Passwort ändern")
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
            switch changePasswordActiveAlert {
            case .error:
                return Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            case .success:
                return Alert(
                    title: Text("Erfolgreich"),
                    message: Text("Password wurde erfolgreich geändert."),
                    dismissButton: .default(Text("OK"))
                )
            }
            
        }
        .padding(.top, 50)
        .overlay {
            Toolbar(text: "Passwort ändern", backAction: { self.goBack() })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    private func changePassword() {
        guard newPassword == confirmPassword else {
            alertMessage = "Passwords do not match."
            showAlert.toggle()
            return
        }
        
        userModel.updatePassword(currentPassword: currentPassword, newPassword: newPassword) { error in
            if let nsError = error {
                changePasswordActiveAlert = ChangePasswordActiveAlert.error
                alertMessage = nsError.localizedDescription
                showAlert.toggle()
            } else {
                changePasswordActiveAlert = ChangePasswordActiveAlert.success
                showAlert.toggle()
            }
        }
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
}
