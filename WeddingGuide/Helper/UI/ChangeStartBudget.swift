import SwiftUI

struct ChangeStartBudget: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    var parentGeometry: GeometryProxy
    
    @State private var newStartBudget: Double = 0
    @State private var startBudgetFormatted = "0"
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer().frame(width: 60)
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(hex: 0xB8C7B9)) // Background color
                        .padding(.horizontal, 10) // Adjust padding as needed
                    
                    TextField("Startbudget", text: $startBudgetFormatted)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.custom("Lustria-Regular", size: 30))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20) // Adjust padding as needed
                        .keyboardType(.numberPad)
                        .onChange(of: startBudgetFormatted, perform: { value in
                            // Format the input to include dots every three characters.
                            let filtered = value.filter { "0123456789".contains($0) }
                            startBudgetFormatted = formatBudgetText(filtered)
                            newStartBudget = Double(filtered) ?? 0
                        })
                }
                .frame(height: 60) // Adjust height as needed
                .cornerRadius(10) // Match the corner radius with the RoundedRectangle
                Text("€")
                    .font(.custom("Lustria-Regular", size: 30))
                    .foregroundColor(.black)
                    .padding()
                Spacer().frame(width: 60)
            }
            
            Button(action: {
                userModel.user?.startBudget = Double(newStartBudget)
                userModel.update()
                goBack()
            }) {
                HStack {Image(systemName: "eurosign")
                    Text("Startbudget ändern")
                }
                .padding()
                .font(.custom("Lustria-Regular", size: 18))
                .background(Color(hex: 0x425C54))
                .foregroundColor(.white)
                .cornerRadius(10)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            }
            
            Spacer()
        }
        .onTapGesture {
            // Dismiss the keyboard when tapped outside the text fields.
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .swipeToDismiss()
        .padding(.top, 10)
        .navigationBarBackButtonHidden()
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Toolbar(presentationMode: presentationMode, parentGeometry: parentGeometry, title: "Startbudget")
            }
        }
        .foregroundColor(.white)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(hex: 0x425C54), for: .navigationBar)
    }
    
    private func formatBudgetText(_ input: String) -> String {
        guard let value = Double(input) else {
            return input
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
}
