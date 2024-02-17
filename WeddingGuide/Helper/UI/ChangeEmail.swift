import SwiftUI

enum ChangeEmailActiveAlert {
    case error, success
}

struct ChangeEmailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
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
                        TextField("Current Password", text: $currentPassword)
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
                        SecureField("Current Password", text: $currentPassword)
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
                TextField("New Email", text: $newEmail)
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
                    Image(systemName: "envelope.circle.fill")
                    Text("Change Email")
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
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            case .success:
                return Alert(
                    title: Text("Erfolgreich"),
                    message: Text("Email wurde erfolgreich geändert."),
                    dismissButton: .default(Text("OK"))
                )
            }
            
        }
        .padding(.top, 50)
        .overlay {
            Toolbar(text: "Change Email", backAction: { self.goBack() })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
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
