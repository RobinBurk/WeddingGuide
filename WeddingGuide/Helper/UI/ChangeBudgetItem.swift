import SwiftUI

struct ChangeBudgetItem: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    @State private var newItem: BudgetItem = BudgetItem()
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var mode: Mode
    var index: Int
    
    // Initializer for the add mode
    init(mode: Mode) {
        self.mode = mode
        self._newItem = State(initialValue: BudgetItem())
        self.index = -1 // Set a default value for index, or you can make it optional
    }
    
    // Initializer for the edit mode
    init(mode: Mode, index: Int, items: [BudgetItem]) {
        self.mode = mode
        self.index = index
        
        if index >= 0 && index < items.count {
            self._newItem = State(initialValue: items[index])
        } else {
            // Handle the case where index is out of range, set a default or handle it accordingly.
            self.index = -1
            self._newItem = State(initialValue: BudgetItem())
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(titleText)
                .font(.custom("Lustria-Regular", size: 26))
                .foregroundColor(.black)
            
            TextField("Beschreibung", text: $newItem.description)
                .font(.custom("Lustria-Regular", size: 20))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .foregroundColor(.black)
                .onTapGesture {
                    DispatchQueue.main.async {
                        UIApplication.shared.sendAction(#selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil)
                    }
                }
            
            HStack {
                Text("Typ")
                    .font(.custom("Lustria-Regular", size: 20))
                    .foregroundColor(.black)
                
                Spacer()
                
                Picker("Typ", selection: $newItem.type) {
                    Text("Einnahmen").tag(BudgetItemType.income)
                    Text("Ausgabe").tag(BudgetItemType.expense)
                }
                .accentColor(.black)
                .font(.custom("Lustria-Regular", size: 20))
                .foregroundColor(.black)
                .pickerStyle(.menu)
            }
            .padding()
            
            TextField("Betrag", text: Binding<String>(
                get: { "\(newItem.amount)" },
                set: {
                    // Attempt to convert the entered text to an integer
                    if let amount = Double($0) {
                        newItem.amount = amount
                    }
                })
            )
            .font(.custom("Lustria-Regular", size: 20))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.decimalPad)
            .padding()
            .foregroundColor(newItem.type == .expense ? Color(hex: 0x990000) : Color(hex: 0x425C54))
            .onTapGesture {
                    DispatchQueue.main.async {
                        UIApplication.shared.sendAction(#selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil)
                    }
                }
            
            Button(action: {
                // Check if the description is empty.
                guard !newItem.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    showAlert = true
                    alertMessage = "Beschreibung kann nicht leer sein."
                    return
                }
                
                // Try to convert amountText to double.
                if newItem.amount > 0 {
                    if mode == Mode.add {
                        DispatchQueue.main.async {
                            userModel.user?.budgetItems.append(newItem)
                            userModel.update()
                            print("Temporary new item description: \(newItem.description), amount: \(newItem.amount)")
                        }
                    }
                    
                    if mode == Mode.edit {
                        DispatchQueue.main.async {
                            userModel.user?.budgetItems[index] = newItem
                            userModel.update()
                            print("Temporary updated item description: \(newItem.description), amount: \(newItem.amount)")
                        }
                    }
                    
                    goBack()
                } else {
                    showAlert = true
                    alertMessage = "Betrag muss größer als 0 sein und eine gültige Zahl sein."
                }
            }) {
                HStack {
                    actionButtonImage
                        .font(.custom("Lustria-Regular", size: 20))
                    Text(actionButtonText)
                        .font(.custom("Lustria-Regular", size: 18))
                }
                .frame(width: 300)
                .padding()
                .foregroundColor(.white)
                .background(Color(hex: 0x425C54))
                .cornerRadius(10)
            }
            .font(.custom("Lustria-Regular", size: 18))
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
                    Image(systemName: "xmark")
                        .font(.custom("Lustria-Regular", size: 20))
                    Text("ABBRECHEN")
                        .font(.custom("Lustria-Regular", size: 18))
                }
                .frame(width: 300)
                .padding()
                .foregroundColor(.white)
                .background(Color.gray)
                .cornerRadius(10)
            }
            .font(.custom("Lustria-Regular", size: 18))
            .padding()
            
            Spacer()
        }
        .onAppear {
            if mode == .add {
                // Reset new item.
                newItem.description = ""
                newItem.amount = 0
            }
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
            return Image(systemName: "plus")
        case .edit:
            return  Image(systemName: "pencil")
        }
    }
}
