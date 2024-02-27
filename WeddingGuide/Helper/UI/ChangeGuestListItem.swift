import SwiftUI

struct ChangeGuestListItem: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    @State private var newItem: GuestListItem
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var mode: Mode
    var index: Int
    
    // Initializer for the add mode
    init(mode: Mode) {
        self.mode = mode
        self._newItem = State(initialValue: GuestListItem())
        self.index = -1 // Set a default value for index, or you can make it optional
    }
    
    // Initializer for the edit mode
    init(mode: Mode, index: Int, items: [GuestListItem]) {
        self.mode = mode
        self.index = index
        
        if index >= 0 && index < items.count {
            self.index = index
            self._newItem = State(initialValue: items[index])
        } else {
            // Handle the case where index is out of range, set a default or handle it accordingly.
            self.index = -1
            self._newItem = State(initialValue: GuestListItem())
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(titleText)
                .font(.custom("Lustria-Regular", size: 26))
                .foregroundColor(.black)
            
            TextField("Familienname", text: $newItem.familyName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.custom("Lustria-Regular", size: 20))
                .foregroundColor(.black)
            
            HStack {
                Text("Tischnummer:")
                    .font(.custom("Lustria-Regular", size: 20))
                    .foregroundColor(.black)
                
                Spacer()
                
                TextField("Tischnummer", text: Binding<String>(
                    get: { "\(newItem.tableNumber)" },
                    set: {
                        // Attempt to convert the entered text to an integer
                        if let tableNumber = Int($0) {
                            newItem.tableNumber = tableNumber
                        }
                    })
                )
                .keyboardType(.numberPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.custom("Lustria-Regular", size: 20))
                .foregroundColor(.black)
            }.padding(.leading, 20)
            
            HStack {
                Text("Anzahl Personen:")
                    .font(.custom("Lustria-Regular", size: 20))
                    .foregroundColor(.black)
                
                Spacer()
                
                TextField("Anzahl Personen", text: Binding<String>(
                    get: { "\(newItem.numberOfPeople)" },
                    set: {
                        // Attempt to convert the entered text to an integer
                        if let numberOfPeople = Int($0) {
                            newItem.numberOfPeople = numberOfPeople
                        }
                    })
                )
                .keyboardType(.numberPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.custom("Lustria-Regular", size: 20))
                .foregroundColor(.black)
            }.padding(.leading, 20)
            
            Button(action: {
                // Check if the title is empty.
                guard !newItem.familyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    showAlert = true
                    alertMessage = "Familienname kann nicht leer sein."
                    return
                }
                
                if mode == Mode.add {
                    print("Added new item \(newItem.familyName)")
                    
                    DispatchQueue.main.async {
                        userModel.user?.guestListItems.append(newItem)
                        userModel.update()
                        print("Temporary new item family name: \(newItem.familyName)")
                    }
                }
                
                if mode == Mode.edit {
                    print("Changed item \(newItem.familyName)")
                    
                    DispatchQueue.main.async {
                        userModel.user?.guestListItems[index] = newItem // Update the existing item
                        userModel.update()
                        print("Temporary updated item family name: \(newItem.familyName)")
                    }
                }
                
                goBack()
            }) {
                HStack {
                    actionButtonImage
                        .font(.custom("Lustria-Regular", size: 20))
                    Text(actionButtonText)
                        .font(.custom("Lustria-Regular", size: 18))
                }
                .frame(width: 320)
                .font(.headline)
                .padding()
                .foregroundColor(.white)
                .background(Color(hex: 0x425C54))
                .cornerRadius(10)
            }
            .font(.custom("Lustria-Regular", size: 18))
            .foregroundColor(.black)
            .background(Color(hex: 0x425C54))
            .cornerRadius(10)
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Fehler"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            Button(action: {
                goBack()
            }) {
                HStack {
                    Image(systemName: "xmark.circle")
                        .font(.custom("Lustria-Regular", size: 20))
                    Text("ABBRECHEN")
                        .font(.custom("Lustria-Regular", size: 18))
                }
                .frame(width: 320)
                .font(.headline)
                .padding()
                .foregroundColor(.white)
                .background(Color.gray)
                .cornerRadius(10)
            }
            .font(.custom("Lustria-Regular", size: 18))
            .padding()
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .padding()
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }  
    
    var titleText: String {
        switch mode {
        case .add:
            return "Eintrag hinzufügen"
        case .edit:
            return "Eintrag bearbeiten"
        }
    }
    
    var actionButtonText: String {
        switch mode {
        case .add:
            return "HINZUFÜGEN"
        case .edit:
            return "BEARBEITEN"
        }
    }
    
    var actionButtonImage: Image {
        switch mode {
        case .add:
            return Image(systemName: "plus.circle")
        case .edit:
            return  Image(systemName: "pencil")
        }
    }
}

struct AddGuestListItem_Previews: PreviewProvider {
    static var previews: some View {
        ChangeGuestListItem(mode: .add)
            .environmentObject(UserViewModel())
    }
}
