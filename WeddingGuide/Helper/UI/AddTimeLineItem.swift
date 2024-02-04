import SwiftUI

struct AddTimeLineItem: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    @State private var newItem: TimeLineItem = TimeLineItem()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var startTime = Date()
    @State private var endTime = Date()
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Eintrag hinzufügen")
                .font(.custom("Lustria-Regular", size: 26))
            
            TextField("Titel", text: $newItem.title)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.custom("Lustria-Regular", size: 20))
            
            TextField("Zusatztext", text: $newItem.extra)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.custom("Lustria-Regular", size: 20))
            
            DatePicker("Startzeit", selection: $startTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .font(.custom("Lustria-Regular", size: 20))
                .onChange(of: startTime) { newValue in
                    updateStartTime(newValue)
                }
            
            DatePicker("Endzeit", selection: $endTime, in: startTime..., displayedComponents: .hourAndMinute)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .font(.custom("Lustria-Regular", size: 20))
                .onChange(of: endTime) { newValue in
                    updateEndTime(newValue)
                }
            
            Button(action: {
                // Check if the title is empty.
                guard !newItem.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    showAlert = true
                    alertMessage = "Title kann nicht leer sein."
                    return
                }
                
                print("Added new item \(newItem.title)")
                updateStartTime(startTime)
                updateEndTime(endTime)
                
                DispatchQueue.main.async {
                    userModel.user?.timeLineItems.append(newItem)
                    userModel.update()
                    print("Temporary new item title: \(newItem.title)")
                }
                
                goBack()
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
            // Set the start time to the end time of the last item in the list.
            if let lastItem = userModel.user?.timeLineItems.last {
                var lastItemDate: Date
                
                if lastItem.endTime == 0 {
                    lastItemDate = Calendar.current.date(bySettingHour: lastItem.startTime / 60, minute: lastItem.startTime % 60, second: 0, of: Date()) ?? Date()
                } else {
                    lastItemDate = Calendar.current.date(bySettingHour: lastItem.endTime / 60, minute: lastItem.endTime % 60, second: 0, of: Date()) ?? Date()
                }
                
                startTime = lastItemDate
                updateStartTime(lastItemDate)
                
                // Set the end time to start time + 1 hour, or use start time if end time is 0.
                let newEndDate = lastItem.endTime != 0 ?
                Calendar.current.date(byAdding: .hour, value: 1, to: lastItemDate) ?? lastItemDate :
                lastItemDate
                
                endTime = newEndDate
                updateEndTime(newEndDate)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .padding()
    }
    
    private func updateStartTime(_ newDate: Date) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: newDate)
        if let hour = components.hour, let minute = components.minute {
            newItem.startTime = hour * 60 + minute
            
            // Ensure end time is after start time.
            if newItem.endTime < newItem.startTime {
                newItem.endTime = newItem.startTime
                endTime = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: startTime) ?? newDate
            }
        }
    }
    
    private func updateEndTime(_ newDate: Date) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: newDate)
        if let hour = components.hour, let minute = components.minute {
            newItem.endTime = hour * 60 + minute
            
            // Ensure start time is before end time.
            if newItem.startTime > newItem.endTime {
                newItem.startTime = newItem.endTime
                startTime = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: endTime) ?? newDate
            }
        }
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddTimeLineItem_Previews: PreviewProvider {
    static var previews: some View {
        let dataManager = DataManager()

        return AddTimeLineItem()
            .environmentObject(dataManager)
    }
}
