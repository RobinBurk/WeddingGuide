import SwiftUI

struct AddBudgetItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    @State private var newItem: BudgetItem = BudgetItem()
    @State private var type: BudgetItemType = .income
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var amountText = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Eintrag hinzufügen")
                .font(.custom("Lustria-Regular", size: 26))
            
            TextField("Beschreibung", text: $newItem.description)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.custom("Lustria-Regular", size: 20))
            
            Picker("Typ", selection: $type) {
                Text("Einkommen").tag(BudgetItemType.income)
                Text("Ausgabe").tag(BudgetItemType.expense)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            TextField("Betrag", text: $amountText)
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
                    
                    DispatchQueue.main.async {
                        userModel.user?.budgetItems.append(newItem)
                        userModel.update()
                        print("Temporary new item description: \(newItem.description), amount: \(newItem.amount)")
                    }
                    
                    goBack()
                } else {
                    showAlert = true
                    alertMessage = "Betrag muss größer als 0 sein und eine gültige Zahl sein."
                }
            }) {
                Text("Hinzufügen")
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
}
