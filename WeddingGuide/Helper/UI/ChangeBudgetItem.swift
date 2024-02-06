import SwiftUI

struct ChangeBudgetItem: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    @State private var newItem: BudgetItem = BudgetItem()
    @State private var type: BudgetItemType = .income
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var amountText = ""
    
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
            self.index = index
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
            
            TextField("Beschreibung", text: $newItem.description)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.custom("Lustria-Regular", size: 20))
            
            Picker("Typ", selection: $type) {
                Text("Einkommen").tag(BudgetItemType.income).accentColor(Color(hex: 0xB8C7B9))
                Text("Ausgabe").tag(BudgetItemType.expense).accentColor(Color(hex: 0x800020))
            }
            .font(.custom("Lustria-Regular", size: 14))
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            TextField("Betrag", text: $amountText)
                .font(.custom("Lustria-Regular", size: 14))
                .keyboardType(.decimalPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(type == .expense ? Color(hex: 0x990000) : Color(hex: 0x425C54))
            
            Button(action: {
                // Check if the description is empty.
                guard !newItem.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    showAlert = true
                    alertMessage = "Beschreibung kann nicht leer sein."
                    return
                }
                
                // Try to convert amountText to double.
                if let amount = Double(amountText), amount > 0 {
                    newItem.amount = amount
                    newItem.type = type
                   
                    if mode == Mode.add {
                        DispatchQueue.main.async {
                            userModel.user?.budgetItems.append(newItem)
                            userModel.update()
                            print("Temporary new item description: \(newItem.description), amount: \(newItem.amount)")
                        }
                    }
                    
                    if mode == Mode.edit {
                        DispatchQueue.main.async {
                            userModel.user?.budgetItems[index] = newItem // Update the existing item
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
                Text(actionButtonText)
                    .font(.custom("Lustria-Regular", size: 18))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
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
                Text("Abbrechen")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .font(.custom("Lustria-Regular", size: 18))
            .padding()
            
            Spacer()
        }
        .onAppear {
            // Reset new item.
            newItem.description = ""
            newItem.amount = 0
            amountText = ""
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
            return "Hinzufügen"
        case .edit:
            return "Bearbeiten"
        }
    }
}
