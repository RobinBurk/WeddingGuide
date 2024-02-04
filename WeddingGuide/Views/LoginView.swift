import SwiftUI

struct LoginView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @AppStorage("isLoginMode") private var isLoginMode: Bool = false
    
    @State private var isLoggedIn = false
    @State private var isLoggedInAgain = false
    @State private var showLoginErrorAlert = false
    @State private var errorMessage = ""
    @State private var showNetworkAlert = false
    @State private var networkAlertIsShown = false
    @State private var hasPerformedSetup = false
    
    var body: some View {
        NavigationStack {
            ZStack	{
                BackgroundImageView()
                
                VStack(spacing: 20) {
                    HeaderView(isLoginMode: $isLoginMode)
                    UserInputView(isLoginMode: $isLoginMode)
                    ActionButtonView(
                        isLoginMode: $isLoginMode,
                        isLoggedIn: $isLoggedIn,
                        isLoggedInAgain: $isLoggedInAgain,
                        showLoginErrorAlert: $showLoginErrorAlert,
                        errorMessage: $errorMessage,
                        showNetworkAlert: $showNetworkAlert,
                        networkAlertIsShown: $networkAlertIsShown
                    )
                    
                    ToggleButtonView(isLoginMode: $isLoginMode)
                }
                .alert(isPresented: $showNetworkAlert) {
                    Alert(
                        title: Text("Offline"),
                        message: Text("Es scheint, als wäre keine Internetverbindung vorhanden."),
                        dismissButton: .default(Text("Beenden"), action: {
                            // Close the app when the user taps "OK"
                            exit(0)
                        })
                    )
                }
                .alert(isPresented: $showLoginErrorAlert) {
                    Alert(
                        title: Text("Anmeldung fehlgeschlagen"),
                        message: Text(errorMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .onChange(of: networkMonitor.isConnected) { connection in
                    print("Show dialog")
                    if (!networkAlertIsShown) {
                        showNetworkAlert = connection == false
                        networkAlertIsShown = true
                    }
                }
                .padding()
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                WelcomeView()
                    .navigationBarBackButtonHidden(true)
            }
            .navigationDestination(isPresented: $isLoggedInAgain) {
                HomeView()
                        .preferredColorScheme(.light)
                        .navigationBarBackButtonHidden(true)
               // WelcomeBackView()
               //     .navigationBarBackButtonHidden(true)
            }
        }
        .environmentObject(dataManager)
        .environmentObject(networkMonitor)
    }
}

struct HeaderView: View {
    @Binding var isLoginMode: Bool
    
    var body: some View {
        Text("WEDDING GUIDE")
            .font(.custom("Lustria-Regular", size: 30))
            .padding()
            .minimumScaleFactor(0.5)
            .lineLimit(1)
        
        if isLoginMode {
            Text("LOGIN")
                .font(.custom("Lustria-Regular", size: 20))
                .padding(.top, -15)
                .offset(y: -15)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        } else {
            Text("Konto erstellen")
                .font(.custom("Lustria-Regular", size: 20))
                .padding(.top, -15)
                .offset(y: -15)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
    }
}

struct UserInputView: View {
    @EnvironmentObject var dataManager: DataManager
    
    @Binding var isLoginMode: Bool
    
    var body: some View {
        if !isLoginMode {
            HStack {
                Spacer().frame(width: 60)
                TextField("Vorname", text: $dataManager.user.firstName)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.custom("Lustria-Regular", size: 18))
                    .padding()
                    .background(Color(hex: 0xB8C7B9))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .cornerRadius(10)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .onChange(of: dataManager.user.firstName) { newValue in
                        // Save the user input to app properties
                        UserDefaults.standard.set(newValue, forKey: "firstName")
                    }
                Spacer().frame(width: 60)
            }
            
            HStack {
                Spacer().frame(width: 60)
                TextField("Nachname", text: $dataManager.user.lastName)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.custom("Lustria-Regular", size: 18))
                    .padding()
                    .background(Color(hex: 0xB8C7B9))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .cornerRadius(10)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .onChange(of: dataManager.user.lastName) { newValue in
                        // Save the user input to app properties
                        UserDefaults.standard.set(newValue, forKey: "lastName")
                    }
                Spacer().frame(width: 60)
            }
        }
        
        HStack {
            Spacer().frame(width: 60)
            TextField("E-Mail", text: $dataManager.user.email)
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
                .onChange(of: dataManager.user.email) { newValue in
                    UserDefaults.standard.set(newValue, forKey: "email")
                }
            Spacer().frame(width: 60)
        }
        
        HStack {
            Spacer().frame(width: 60)
            TextField("Startcode", text: $dataManager.user.startCode)
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
                .onChange(of: dataManager.user.startCode) { newValue in
                    // Save the user input to app properties
                    UserDefaults.standard.set(newValue, forKey: "startCode")
                }
            Spacer().frame(width: 60)
        }
    }
}

struct ActionButtonView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @Binding var isLoginMode: Bool
    @Binding var isLoggedIn: Bool
    @Binding var isLoggedInAgain: Bool
    @Binding var showLoginErrorAlert: Bool
    @Binding var errorMessage: String
    @Binding var showNetworkAlert: Bool
    @Binding var networkAlertIsShown: Bool
    
    var body: some View {
        Button("LET'S START") {
            // First check if user has enteres all fields.
            isValidInput { isValid, error in
                if isValid {
                    if isLoginMode {
                        performLogin()
                    } else {
                        registerUser()
                    }
                } else {
                    errorMessage = error
                    showLoginErrorAlert = true
                }
            }
        }
        .padding()
        .font(.custom("Lustria-Regular", size: 18))
        .background(Color(hex: 0x425C54))
        .foregroundColor(.white)
        .cornerRadius(10)
        .minimumScaleFactor(0.5)
        .lineLimit(1)
    }
    
    private func performLogin() {
        doesUserAlreadyExist { (success, error) in
            if success {
                print("Load user from DB.")
                dataManager.loadUser() { (success, error)  in
                    if success {
                        print("Benutzer \(dataManager.user.firstName) angemeldet. Zeige WelcomeBackView.")
                        isLoggedInAgain = true
                    } else {
                        errorMessage = error
                        showLoginErrorAlert = true
                    }
                }
            } else if error.isEmpty {
                print("User not found. Show appropriate message.")
                errorMessage = "Benutzer nicht gefunden. Bitte registrieren Sie sich zuerst."
                showLoginErrorAlert = true
            } else {
                print("\(error)")
                errorMessage = error
                showLoginErrorAlert = true
            }
        }
    }
    
    private func registerUser() {
        doesUserAlreadyExist {(success, error) in
            if success {
                print("Load user from DB.")
                dataManager.loadUser() { (success, error)  in
                    if success {
                        print("Benutzer \(dataManager.user.firstName) angemeldet.")
                        if (dataManager.user.hasFinishedWelcome) {
                            isLoggedInAgain = true
                        }
                        else {
                            isLoggedIn = true
                        }
                    } else {
                        errorMessage = error
                        showLoginErrorAlert = true
                    }
                }
            } else if error.isEmpty {
                // Check the uniqueness of the email address.
                dataManager.checkEmailAddressInUnique(email: dataManager.user.email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()) { (success, emailError) in
                    if success {
                        print("Email \(dataManager.user.email) is unique.")
                        dataManager.createUserOnDb() { ( success, error) in
                            if success {
                                print("Benutzer \(dataManager.user.firstName) angemeldet. Zeige WelcomeView.")
                                isLoggedIn = true
                            } else {
                                print("\(error)")
                                errorMessage = error
                                showLoginErrorAlert = true
                            }
                        }
                    } else {
                        errorMessage = emailError
                        showLoginErrorAlert = true
                    }
                }
            } else {
                print("\(error)")
                errorMessage = error
                showLoginErrorAlert = true
            }
        }
    }
    
    private func isValidInput(completion: @escaping (Bool, String) -> Void) {
        // Check if the inputs are valid.
        if !isLoginMode && (dataManager.user.firstName.isEmpty || dataManager.user.lastName.isEmpty || dataManager.user.email.isEmpty || dataManager.user.startCode.isEmpty) {
            completion(false, "Bitte fülle alle Felder aus.")
            return
        }
        
        if isLoginMode && (dataManager.user.email.isEmpty || dataManager.user.startCode.isEmpty) {
            if (dataManager.user.email.isEmpty) {
                print("email is empty")
            } else {
                print("startcode is empty")
            }
            
            completion(false, "Bitte fülle alle Felder aus.")
            return
        }
        completion(true, "")
    }
    
    private func doesUserAlreadyExist(completion: @escaping (Bool, String) -> Void) {
        if networkMonitor.isConnected {
            dataManager.checkIfUserAlreadyExists { (userExists, error) in
                if userExists {
                    completion(true, "")
                } else {
                    completion(false, error)
                }
            }
        } else {
            completion(false, "Keine Internet Verbindung.")
        }
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let dataManager = DataManager()
        let networkMonitor = NetworkMonitor()
        
        return LoginView()
            .environmentObject(dataManager)
            .environmentObject(networkMonitor)
    }
}
