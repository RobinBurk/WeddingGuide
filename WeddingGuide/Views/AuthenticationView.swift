import SwiftUI

enum ActiveAlert {
    case error, success
}

struct AuthenticationView: View {
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .error
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView{
            SignInView(showAlert: $showAlert, errorMessage: $errorMessage, activeAlert: $activeAlert)
                .alert(isPresented: $showAlert) {
                    switch activeAlert {
                    case .error:
                        return Alert(
                            title: Text("Error"),
                            message: Text(errorMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    case .success:
                        return Alert(
                            title: Text("Erfolgreich"),
                            message: Text("Eine E-Mail zum Zurücksetzen des Passworts wurde gesendet."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct SignInView: View {
    @EnvironmentObject var userModel: UserViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    
    @Binding var showAlert: Bool
    @Binding var errorMessage: String
    @Binding var activeAlert: ActiveAlert
    
    var body: some View {
        ZStack {
            BackgroundImageView()
            Spacer()
            VStack(spacing: 20) {
                Text("WEDDING GUIDE")
                    .font(.custom("Lustria-Regular", size: 30))
                    .padding()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                Text("Login")
                    .font(.custom("Lustria-Regular", size: 20))
                    .padding(.top, -15)
                    .offset(y: -15)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                HStack {
                    Spacer().frame(width: 60)
                    TextField("Email", text: $email)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.custom("Lustria-Regular", size: 18))
                        .padding()
                        .background(Color(hex: 0xB8C7B9))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .cornerRadius(10)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    Spacer().frame(width: 60)
                }
                
                HStack {
                    Spacer().frame(width: 60)
                    SecureField("Password", text: $password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.custom("Lustria-Regular", size: 18))
                        .padding()
                        .background(Color(hex: 0xB8C7B9))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .cornerRadius(10)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    Spacer().frame(width: 60)
                }
                Button(action: {
                    userModel.resetPassword(email: email) { nsError in
                        if let nsError = nsError {
                            errorMessage = nsError.localizedDescription
                            activeAlert = ActiveAlert.error
                            showAlert.toggle()
                            print("Error during password-reset: \(nsError.localizedDescription)")
                        } else {
                            activeAlert = ActiveAlert.success
                            showAlert.toggle()
                            print("Password-reset successfull!")
                        }
                    }
                })
                {
                    HStack {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(Color(hex: 0x425C54))
                            .font(.custom("Lustria-Regular", size: 16))
                        Text("Passwort vergessen?")
                            .minimumScaleFactor(0.3)
                            .lineLimit(1)
                            .foregroundColor(Color(hex: 0x425C54))
                            .font(.custom("Lustria-Regular", size: 16))
                    }
                }
                
                Button(action: {
                    userModel.signIn(email: email, password: password) { nsError in
                        if let nsError = nsError {
                            errorMessage = nsError.localizedDescription
                            activeAlert = ActiveAlert.error
                            showAlert.toggle()
                            print("Error during sign-in: \(nsError.localizedDescription)")
                        } else {
                            // Sign-in was successful
                            print("Sign-in successful!")
                        }
                    }
                }) {
                    Text("LET'S START")
                        .padding()
                        .font(.custom("Lustria-Regular", size: 18))
                        .background(Color(hex: 0x425C54))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
                NavigationLink(destination: SignUpView(showError: $showAlert, errorMessage: $errorMessage)) {
                    Text("Ich bin neu hier. Jetzt Konto erstellen!")
                        .foregroundColor(Color(hex: 0x425C54))
                        .underline()
                        .padding(.top)
                        .minimumScaleFactor(0.3)
                        .lineLimit(1)
                        .shadow(radius: 10)
                }
            }
            Spacer()
        }
    }
}

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isPasswordVisible = false
    
    
    @Binding var showError: Bool
    @Binding var errorMessage: String
    
    var body: some View {
        ZStack {
            BackgroundImageView()
            
            Spacer()
            VStack(spacing: 20) {
                Text("WEDDING GUIDE")
                    .font(.custom("Lustria-Regular", size: 30))
                    .padding()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                Text("Konto erstellen")
                    .font(.custom("Lustria-Regular", size: 20))
                    .padding(.top, -15)
                    .offset(y: -15)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                HStack {
                    Spacer().frame(width: 60)
                    TextField("Vorname", text: $firstName)
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
                    TextField("Nachname", text: $lastName)
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
                    TextField("E-Mail", text: $email)
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
                    SecureField("Password", text: $password)
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
                    // Check if passwords match
                    guard password == confirmPassword else {
                        errorMessage = "Passwords do not match."
                        showError.toggle()
                        return
                    }
                    
                    userModel.signUp(email: email, firstName: firstName, lastName: lastName, password: password) { error in
                        if error != nil, let error = error {
                            errorMessage = error.localizedDescription
                            showError.toggle()
                            print("Error during sign-up: \(error.localizedDescription)")
                        } else {
                            // Sign-up was successful
                            print("Sign-up successful!")
                        }
                    }
                }) {
                    Text("SIGN UP")
                        .padding()
                        .font(.custom("Lustria-Regular", size: 18))
                        .background(Color(hex: 0x425C54))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
                
                Button(action: {
                    self.goBack()
                }) {
                    Text("Ich habe bereits ein Konto. Jetzt anmelden!")
                        .foregroundColor(Color(hex: 0x425C54))
                        .underline()
                        .padding(.top)
                        .minimumScaleFactor(0.3)
                        .lineLimit(1)
                        .shadow(radius: 10)
                }
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    private func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct ToggleButtonView: View {
    @Binding var isLoginMode: Bool
    
    var body: some View {
        HStack {
            Spacer()
            if !isLoginMode {
                Text("Ich habe bereits ein Konto. Jetzt anmelden!")
                    .foregroundColor(Color(hex: 0x425C54))
                    .underline()
                    .padding(.top)
                    .minimumScaleFactor(0.3)
                    .lineLimit(1)
                    .shadow(radius: 10)
                    .onTapGesture {
                        isLoginMode.toggle()
                    }
            } else {
                Text("Ich bin neu hier. Jetzt Konto erstellen!")
                    .foregroundColor(Color(hex: 0x425C54))
                    .underline()
                    .padding(.top)
                    .minimumScaleFactor(0.3)
                    .lineLimit(1)
                    .shadow(radius: 10)
                    .onTapGesture {
                        isLoginMode.toggle()
                    }
            }
            Spacer()
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(UserViewModel())  // Pass a sample UserViewModel as an environment object
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(showAlert: .constant(false), errorMessage: .constant(""), activeAlert: .constant(ActiveAlert.error))
            .environmentObject(UserViewModel())  // Pass a sample UserViewModel as an environment object
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(showError: .constant(false), errorMessage: .constant(""))
            .environmentObject(UserViewModel())  // Pass a sample UserViewModel as an environment object
    }
}
