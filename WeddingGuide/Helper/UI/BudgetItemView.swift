import SwiftUI

struct BudgetItemView: View {
    @EnvironmentObject var userModel: UserViewModel
    @Binding var budgetItem: BudgetItem
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 20) {
            Text(budgetItem.description)
                .font(.custom("Lustria-Regular", size: 13))
            
            Rectangle()
                .fill(Color(hex: 0xB8C7B9))
                .frame(width: 2)
            
            Text(NumberFormatter.localizedString(from: NSNumber(value: budgetItem.amount), number: .currency))
                .foregroundColor(budgetItem.type == .income ? Color(hex: 0x425C54) : Color(hex: 0x990000))
                .font(.custom("Lustria-Regular", size: 13))
            
            Picker("", selection: $budgetItem.type) {
                Text("Einkommen").tag(BudgetItemType.income)
                    .font(.custom("Lustria-Regular", size: 13))
                Text("Ausgabe").tag(BudgetItemType.expense)
                    .font(.custom("Lustria-Regular", size: 13))
            }
            .pickerStyle(MenuPickerStyle())
            .font(.custom("Lustria-Regular", size: 14))
            .colorMultiply(Color(hex: 0xB8C7B9))
            .colorMultiply(Color(hex: 0x800020))
            .colorMultiply(Color(hex: 0x999999))
            .onChange(of: budgetItem.type) { _ in
                if let index = userModel.user?.budgetItems.firstIndex(where: { $0.id == budgetItem.id }) {
                    userModel.user?.budgetItems[index].type = budgetItem.type
                    userModel.update()
                }
            }
        }
    }
}
