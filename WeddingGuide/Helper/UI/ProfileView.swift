import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    var body: some View {
        VStack {
            ProfileItemView(title: "Vorname", value: userModel.user?.firstName ?? "")
                    .padding(.horizontal)
                ProfileItemView(title: "Nachname", value: userModel.user?.lastName ?? "")
                    .padding(.horizontal)
                EmailView()
                    .padding(.horizontal)
                PasswordView()
                    .padding(.horizontal)
                StartBudgetView()
                    .padding(.horizontal)
                
                Button(action: {
                    // Action when VIP Access button is tapped
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
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .padding(.top)
                }
                
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
        //.onAppear {
        //    user = userModel.user
       // }
        .padding(.top, 50)
        .overlay {
            Toolbar(text: "Dein Profil", backAction: { self.goBack() })
        }
        .onTapGesture {
            // Dismiss the keyboard when tapped outside the text fields
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .swipeToDismiss()
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
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
            Spacer()
            Text(value)
                .font(.custom("Lustria-Regular", size: 16))
                .fontWeight(.bold)
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
    
    var body: some View {
        HStack {
            Text("Email")
                .font(.custom("Lustria-Regular", size: 16))
                .foregroundColor(.secondary)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.trailing , 15)
            Spacer()
            Text(userModel.user?.email ?? "")
                .font(.custom("Lustria-Regular", size: 16))
                .fontWeight(.bold)
            Spacer()
            NavigationLink(destination: ChangeEmailView()) {
                Text("Ändern")
                    .font(.custom("Lustria-Regular", size: 16))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 15)
                    .foregroundColor(.white)
                    .background(Color(hex: 0x425C54))
                    .cornerRadius(10)
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
    var body: some View {
        HStack {
            Text("Passwort")
                .font(.custom("Lustria-Regular", size: 16))
                .foregroundColor(.secondary)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.trailing , 15)
            Spacer()
            NavigationLink(destination: ChangePasswordView()) {
                Text("Ändern")
                    .font(.custom("Lustria-Regular", size: 16))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 15)
                    .foregroundColor(.white)
                    .background(Color(hex: 0x425C54))
                    .cornerRadius(10)
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
            TextField("Budget", text: $editedBudget)
                .font(.custom("Lustria-Regular", size: 16))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .background(Color.white)
                .fontWeight(.bold)
                .multilineTextAlignment(.trailing)
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
                Text("OK")
                    .font(.custom("Lustria-Regular", size: 16))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 15)
                    .foregroundColor(.white)
                    .background(Color(hex: 0x425C54)) 
                    .cornerRadius(10)
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
        
        // Create a new user for preview
        let previewUser = User(firstName: "John", lastName: "Doe", email: "john.doe@example.com", startBudget: 50000)
        userViewModel.user = previewUser
        
        return ProfileView()
            .environmentObject(userViewModel)
            .previewDisplayName("Profile View")
    }
}
