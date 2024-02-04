import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    var body: some View {
        VStack {
            if let user = userModel.user {
                ProfileItemView(title: "Vorname", value: user.firstName)
                    .padding(.horizontal)
                ProfileItemView(title: "Nachname", value: user.lastName)
                    .padding(.horizontal)
                ProfileItemView(title: "E-Mail", value: user.email)
                    .padding(.horizontal)
                StartBudgetView(user: user)
                    .padding(.horizontal)
                
            } else {
                Text("Benutzerinformationen konnten nicht abgerufen werden.")
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(action: {
                userModel.signOut()
            }) {
                Text("Abmelden")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.top)
            
            Spacer()
        }
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

struct StartBudgetView: View {
    @EnvironmentObject var userModel: UserViewModel
    
    @State var user: User
    @State private var editedBudget: String = ""
    @State private var showErrorAlert = false
    
    var body: some View {
        HStack {
            Text("Startbudget")
                .font(.headline)
                .foregroundColor(.secondary)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.trailing , 15)
            TextField("Budget", text: $editedBudget)
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
                    user.startBudget = userModel.user?.startBudget ?? 0.0
                    editedBudget = "\(user.startBudget)€"
                } else {
                    print("Invalid budget input")
                    showErrorAlert = true
                }
            }) {
                Text("OK")
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
            editedBudget = "\(user.startBudget)€"
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct ProfileItemView: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body)
                .fontWeight(.bold)
        }
        .padding(.vertical, 8)
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
