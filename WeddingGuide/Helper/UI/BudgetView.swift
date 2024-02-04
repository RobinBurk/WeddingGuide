import SwiftUI

// View with circle on HomeView.
// Has a BudgetViewModel with all data.
// Opens on click BudgetManagementView.
struct BudgetView: View {
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var dataManager: DataManager
    
    @State private var trimValue: CGFloat = 0.0
    @State private var remainingBudget = 0.0
    
    var body: some View {
        ZStack {
            ZStack {
                Circle()
                    .fill(Color(hex: 0xB8C7B9))
                    .frame(width: 200, height: 200)
                    .shadow(radius: 10)
                
                Circle()
                    .trim(from: 0.0, to: trimValue)
                    .stroke(Color(hex: 0x425C54), lineWidth: 20)
                    .frame(width: 200 - 20, height: 200)
                    .rotationEffect(.degrees(-90))
                
                Circle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 160, height: 160)
                
                NavigationLink(destination:
                                BudgetManagementView()
                    .onDisappear {
                        updateBudget()
                    }
                ) {
                    Text("Restbudget:\n\(formatNumber(remainingBudget))€")
                        .font(.custom("Lustria-Regular", size: 30))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .frame(width: 140)
                        .lineLimit(2)
                        .minimumScaleFactor(0.2)
                }
            }
        }
        .onAppear {
            updateBudget()
        }
    }
    
    private func updateBudget() {
        let totalExpense = userModel.user?.budgetItems
            .filter { $0.type == .expense }
            .reduce(0.0) { $0 + $1.amount }

        let totalIncome = userModel.user?.budgetItems
            .filter { $0.type == .income }
            .reduce(0.0) { $0 + $1.amount }

        remainingBudget = (userModel.user?.startBudget ?? 0.0) + (totalIncome ?? 0.0) - (totalExpense ?? 0.0)
        trimValue = CGFloat(remainingBudget / (userModel.user?.startBudget ?? 1.0))
    }

    
    func formatNumber(_ number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = -1
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
}

struct BudgetManagementButton: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(action: {
            isPresented.toggle()
        }) {
            Text("Manage Budget")
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}
