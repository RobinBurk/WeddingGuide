import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    var parentGeometry: GeometryProxy
    
    @State private var counter = 0
    @State private var counterVIPAccessed = 0
    @State private var showStartCodeInputDialog = false
    @State private var enteredStartcode = ""
    @State private var showStartCodeErrorDialog = false
    @State private var startCodeErrorMessage = ""
    
    var body: some View {
        VStack {
            ProfileItemView(title: "Vorname", value: userModel.user?.firstName ?? "")
                .padding(.horizontal)
            ProfileItemView(title: "Nachname", value: userModel.user?.lastName ?? "")
                .padding(.horizontal)
            EmailView(parentGeometry: parentGeometry)
                .padding(.horizontal)
            PasswordView(parentGeometry: parentGeometry)
                .padding(.horizontal)
            StartBudgetView(parentGeometry: parentGeometry)
                .padding(.horizontal)
            
            Button(action: {
                if !(userModel.user?.isVIP ?? false) {
                    showStartCodeInputDialog.toggle()
                } else {
                    // Action when VIP Access button is tapped
                    // if userModel.isVIP {
                    counter+=1
                    // }
                }
            }) {
                HStack {
                    Image(systemName: "crown.fill")
                        .font(.custom("Lustria-Regular", size: 18))
                    Text("VIP-ACCESS")
                        .font(.custom("Lustria-Regular", size: 18))
                }
                .frame(width: 320)
                .padding()
                .foregroundColor(.white)
                .background(Color(hex: 0x425C54))
                .cornerRadius(10)
                .padding(.top)
            }
            .alert("VIP-Zugriff", isPresented: $showStartCodeInputDialog) {
                TextField("Startcode", text: $enteredStartcode)
                    .foregroundColor(.black)
                Button("OK") {
                    userModel.tryToAccessVIP(startcode: enteredStartcode) { error in
                        if let error = error {
                            print("Fehler beim Versuch, VIP-Zugriff zu erhalten: \(error.localizedDescription)")
                            startCodeErrorMessage = error.localizedDescription
                        } else {
                            print("VIP-Zugriff erfolgreich erhalten.")
                            counterVIPAccessed+=1
                        }
                    }
                }
                Button("Abbrechen", role: .cancel) { }
            }
            .preferredColorScheme(.light)
            .alert("Error", isPresented: $showStartCodeErrorDialog) {
                Text("Das hat nicht geklappt. Fehler: \(startCodeErrorMessage)")
            }
            .confettiCannon(counter: $counter, num: 30, confettis: [.text("🕊️"), .text("🤍")], confettiSize: 20.0, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 170)
            .confettiCannon(counter: $counterVIPAccessed, num: 100, confettis: [.text("🕊️"), .text("🤍")], confettiSize: 20.0, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 170, repetitions: 2)
            
            Button(action: {
                userModel.signOut()
            }) {
                HStack {
                    Image(systemName: "power")
                        .font(.custom("Lustria-Regular", size: 18))
                    Text("ABMELDEN")
                        .font(.custom("Lustria-Regular", size: 18))
                }
                .frame(width: 320)
                .font(.headline)
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(10)
            }
            Spacer()
        }
        .swipeToDismiss()
        .onTapGesture {
            // Dismiss the keyboard when tapped outside the text fields.
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .padding(.top, 10)
        .navigationBarBackButtonHidden()
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Toolbar(presentationMode: presentationMode, parentGeometry: parentGeometry, title: "Profile")
            }
        }
        .foregroundColor(.white)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(hex: 0x425C54), for: .navigationBar)
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct ProfileItemView: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("Lustria-Regular", size: 16))
                .foregroundColor(.secondary)
                .minimumScaleFactor(0.4)
                .lineLimit(1)
            Spacer()
            Text(value)
                .font(.custom("Lustria-Regular", size: 16))
                .foregroundColor(.black)
                .fontWeight(.bold)
                .minimumScaleFactor(0.4)
                .lineLimit(1)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct EmailView: View {
    @EnvironmentObject var userModel: UserViewModel
    
    var parentGeometry: GeometryProxy
    
    var body: some View {
        HStack {
            Text("Email")
                .font(.custom("Lustria-Regular", size: 16))
                .foregroundColor(.secondary)
                .background(Color.white)
                .cornerRadius(10)
                .minimumScaleFactor(0.4)
                .lineLimit(1)
                .padding(.trailing , 15)
            Spacer()
            Text(userModel.user?.email ?? "")
                .font(.custom("Lustria-Regular", size: 16))
                .foregroundColor(.black)
                .fontWeight(.bold)
                .minimumScaleFactor(0.4)
                .lineLimit(1)
            Spacer()
            NavigationLink(destination: ChangeEmailView(parentGeometry: parentGeometry)) {
                Text("Ändern")
                    .font(.custom("Lustria-Regular", size: 16))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 15)
                    .foregroundColor(.white)
                    .background(Color(hex: 0x425C54))
                    .cornerRadius(10)
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)
            }
            .padding(.vertical, 2)
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


struct PasswordView: View {
    var parentGeometry: GeometryProxy
    
    var body: some View {
        HStack {
            Text("Passwort")
                .font(.custom("Lustria-Regular", size: 16))
                .foregroundColor(.secondary)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.trailing , 15)
                .minimumScaleFactor(0.4)
                .lineLimit(1)
            Spacer()
            NavigationLink(destination: ChangePasswordView(parentGeometry: parentGeometry)) {
                Text("Ändern")
                    .font(.custom("Lustria-Regular", size: 16))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 15)
                    .foregroundColor(.white)
                    .background(Color(hex: 0x425C54))
                    .cornerRadius(10)
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)
            }
            .padding(.vertical, 2)
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct StartBudgetView: View {
    @EnvironmentObject var userModel: UserViewModel
    
    var parentGeometry: GeometryProxy
    
    @State private var editedBudget: String = ""
    @State private var showErrorAlert = false
    
    var body: some View {
        HStack {
            Text("Startbudget")
                .font(.custom("Lustria-Regular", size: 16))
                .foregroundColor(.secondary)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.trailing , 15)
                .minimumScaleFactor(0.4)
                .lineLimit(1)
            TextField("Budget", text: $editedBudget)
                .font(.custom("Lustria-Regular", size: 16))
                .foregroundColor(.black)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .background(Color.white)
                .fontWeight(.bold)
                .multilineTextAlignment(.trailing)
                .minimumScaleFactor(0.4)
                .lineLimit(1)
            Button(action: {
                // Remove Euro symbol if present and trim whitespaces
                var sanitizedBudget = editedBudget.trimmingCharacters(in: .whitespacesAndNewlines)
                sanitizedBudget.removeLast()  // Remove the last character (€)
                
                if let editedBudgetValue = Double(sanitizedBudget) {
                    // Update the user's startBudget in your UserViewModel
                    userModel.user?.startBudget = editedBudgetValue
                    userModel.update()
                    editedBudget = "\(userModel.user?.startBudget ?? 0.0)€"
                } else {
                    print("Invalid budget input")
                    showErrorAlert = true
                }
            }) {
                NavigationLink(destination: ChangeStartBudget(parentGeometry: parentGeometry)) {
                    Text("Ändern")
                        .font(.custom("Lustria-Regular", size: 16))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 15)
                        .foregroundColor(.white)
                        .background(Color(hex: 0x425C54))
                        .cornerRadius(10)
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                }
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Fehler"), message: Text("Ungültiges Budget"), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear {
            editedBudget = "\(userModel.user?.startBudget ?? 0.0)€"
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let userViewModel = UserViewModel()
        var isVisible = true
        
        // Create a new user for preview
        let previewUser = User(firstName: "John", lastName: "Doe", email: "john.doe@example.com", startBudget: 50000)
        userViewModel.user = previewUser
        
        return GeometryReader { proxy in
            ProfileView(parentGeometry: proxy)
                .environmentObject(userViewModel)
                .previewDisplayName("Profile View")
        }
    }
}
