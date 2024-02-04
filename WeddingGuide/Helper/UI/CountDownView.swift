import SwiftUI

struct CountDownView: View {
    @EnvironmentObject var userModel: UserViewModel
    
    @State private var countdownComponents: DateComponents = DateComponents()
    @State private var isDatePickerVisible: Bool = false
    @State private var weddingDate = Date()
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                VStack(spacing: 10) {
                    Text("\(countdownComponents.day ?? 0)")
                        .font(.custom("Lustria-Regular", size: 35))
                        .foregroundColor(Color(hex: 0x425C54))
                        .fontWeight(.bold)
                    Text("TAGE")
                        .foregroundColor(Color(hex: 0x425C54))
                        .font(.custom("Lustria-Regular", size:15))
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                }
                
                VStack(spacing: 10) {
                    Text("\(countdownComponents.hour ?? 0)")
                        .font(.custom("Lustria-Regular", size: 35))
                        .foregroundColor(Color(hex: 0x425C54))
                        .fontWeight(.bold)
                    Text("STUNDEN")
                        .foregroundColor(Color(hex: 0x425C54))
                        .font(.custom("Lustria-Regular", size: 15))
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                }
                
                VStack(spacing: 10) {
                    Text("\(countdownComponents.minute ?? 0)")
                        .font(.custom("Lustria-Regular", size: 35))
                        .foregroundColor(Color(hex: 0x425C54))
                        .fontWeight(.bold)
                    Text("MINUTEN")
                        .foregroundColor(Color(hex: 0x425C54))
                        .font(.custom("Lustria-Regular", size: 15))
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                }
                
                VStack(spacing: 10) {
                    Text("\(countdownComponents.second ?? 0)")
                        .font(.custom("Lustria-Regular", size: 35))
                        .foregroundColor(Color(hex: 0x425C54))
                        .fontWeight(.bold)
                    Text("SEKUNDEN")
                        .foregroundColor(Color(hex: 0x425C54))
                        .font(.custom("Lustria-Regular", size: 15))
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                }
            }
        }
        .sheet(isPresented: $isDatePickerVisible) {
            VStack {
                DatePicker("", selection: $weddingDate, in: Date()..., displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .accentColor(Color(hex: 0x425C54))
                    .environment(\.locale, Locale(identifier: "de_DE"))
                    .onDisappear {
                        setSelectedDayToMidnight()
                        print("WeddingDate set via popup to \(userModel.user?.weddingDay ?? Date()).")
                        updateCountdown()
                    }
                
                Button("OK") {
                    isDatePickerVisible = false
                }
                .padding()
                .font(.custom("Lustria-Regular", size: 18))
                .background(Color(hex: 0x425C54))
                .foregroundColor(.white)
                .cornerRadius(10)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            }
        }
        .padding(10)
        .background(
            Color.white.opacity(0.8)
        )
        .cornerRadius(10)
        .shadow(radius: 8)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if !isDatePickerVisible {
                updateCountdown()
            }
        }
        .onAppear {
            weddingDate = userModel.user?.weddingDay ?? Date()
            updateCountdown()
        }
        .onTapGesture {
            isDatePickerVisible.toggle()
        }
    }
    
    private func updateCountdown() {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: weddingDate)
        withAnimation {
            countdownComponents = components
        }
    }
    
    private func setSelectedDayToMidnight() {
        let calendar = Calendar.current
        var components = calendar.dateComponents(in: calendar.timeZone, from: weddingDate)
        
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        if let midnightDate = calendar.date(from: components) {
            userModel.user?.weddingDay = midnightDate
            userModel.update()
        }
    }
}
