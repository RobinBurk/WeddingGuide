import SwiftUI

struct PreHomeView: View {
    @EnvironmentObject var userModel: UserViewModel
    
    @State private var weddingDay = Date()
    @State private var startBudgetValue: Double = 0
    @State private var startBudgetFormatted = "0"
    @State private var isDatePickerVisible = false
    @State private var showStart = true
    @State private var showWeddingDay = true
    @State private var showStartBudget = false
    @State private var showAllFinished = false
    @State private var showNetworkAlert = false
    @State private var isLoggedIn = false
    
    var body: some View {
        if (!isLoggedIn) {
            VStack {
                if showWeddingDay {
                    Text("Wann heiratest du?")
                        .font(.custom("Lustria-Regular", size: 30))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Button("Auswählen") {
                        isDatePickerVisible = true
                    }
                    .padding()
                    .font(.custom("Lustria-Regular", size: 18))
                    .background(Color(hex: 0x425C54))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .transition(.opacity)
                }
                
                if showStartBudget {
                    Text("Welches Budget hast Du eingeplant?")
                        .font(.custom("Lustria-Regular", size: 30))
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                    HStack {
                        Spacer()
                        Spacer()
                        TextField("Startbudget", text: $startBudgetFormatted)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.custom("Lustria-Regular", size: 30))
                            .keyboardType(.numberPad)
                            .padding()
                            .onChange(of: startBudgetFormatted, perform: { value in
                                // Format the input to include dots every three characters.
                                let filtered = value.filter { "0123456789".contains($0) }
                                startBudgetFormatted = formatBudgetText(filtered)
                                startBudgetValue = Double(filtered) ?? 0
                            })
                        Text("€")
                            .font(.custom("Lustria-Regular", size: 30))
                            .foregroundColor(.black)
                            .padding()
                        Spacer()
                        Spacer()
                    }
                    
                    Button("Weiter") {
                        print("Startbudget bei WelcomeView gesetzt auf \(startBudgetValue)")
                        userModel.user?.startBudget = Double(startBudgetValue)
                        userModel.update()
                        showStartBudget = false
                        showAllFinished = true
                    }
                    .padding()
                    .font(.custom("Lustria-Regular", size: 18))
                    .background(Color(hex: 0x425C54))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .transition(.opacity)
                }
                
                if showAllFinished {
                    TypingAnimationView(text: "Alles erledigt 🤘🏻") {
                        userModel.user?.hasFinishedWelcome = true
                        userModel.update()
                        isLoggedIn = true
                        print("Benutzer Welcome beendet. Zeige HomeView.")
                    }
                }
            }.popover(isPresented: $isDatePickerVisible, content: {
                VStack {
                    DatePicker("", selection: $weddingDay, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .accentColor(Color(hex: 0x425C54))
                        .environment(\.locale, Locale(identifier: "de_DE"))
                    
                    Button("OK") {
                        isDatePickerVisible = false
                        setWeddingDayToMidnight()
                        print("Wedding day bei WelcomeView gesetzt aus \(weddingDay)")
                        userModel.user?.weddingDay = weddingDay
                        userModel.update()
                        showWeddingDay = false
                        showStartBudget = true
                    }
                    .padding()
                    .font(.custom("Lustria-Regular", size: 18))
                    .background(Color(hex: 0x425C54))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                }
            })
        } else {
            HomeView()
                .preferredColorScheme(.light)
                .navigationBarBackButtonHidden(true)
        }
    }
    
    private func setWeddingDayToMidnight() {
        let calendar = Calendar.current
        var components = calendar.dateComponents(in: calendar.timeZone, from: weddingDay)
        
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        if let midnightDate = calendar.date(from: components) {
            weddingDay = midnightDate
        }
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: weddingDay)
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
}

struct PreHomeview_Previews: PreviewProvider {
    static var previews: some View {
        let dataManager = DataManager()
        let networkMonitor = NetworkMonitor()
        
        return PreHomeView()
            .environmentObject(dataManager)
            .environmentObject(networkMonitor)
    }
}
