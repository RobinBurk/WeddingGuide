import SwiftUI

struct ChangeTimeLineItem: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    @State private var newItem: TimeLineItem
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var startTime = Date()
    @State private var endTime = Date()
    
    var mode: Mode
    var index: Int
    
    // Initializer for the add mode
    init(mode: Mode) {
        self.mode = mode
        self._newItem = State(initialValue: TimeLineItem())
        self.index = -1 // Set a default value for index, or you can make it optional
    }
    
    // Initializer for the edit mode
    init(mode: Mode, index: Int, items: [TimeLineItem]) {
        self.mode = mode
        
        if index >= 0 && index < items.count {
            self.index = index
            self._newItem = State(initialValue: items[index])
        } else {
            // Handle the case where index is out of range, set a default or handle it accordingly.
            self.index = -1
            self._newItem = State(initialValue: TimeLineItem())
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(titleText)
                .font(.custom("Lustria-Regular", size: 26))
                .foregroundColor(.black)
            
            TextField("Titel", text: $newItem.title)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.custom("Lustria-Regular", size: 20))
                .foregroundColor(.black)
            
            TextField("Zusatztext", text: $newItem.extra)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.custom("Lustria-Regular", size: 20))
                .foregroundColor(.black)
            
            DatePicker("Startzeit", selection: $startTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .font(.custom("Lustria-Regular", size: 20))
                .foregroundColor(.black)
                .onChange(of: startTime) { newValue in
                    updateStartTime(newValue)
                }
            
            DatePicker("Endzeit", selection: $endTime, in: startTime..., displayedComponents: .hourAndMinute)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .font(.custom("Lustria-Regular", size: 20))
                .foregroundColor(.black)
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
                
                updateStartTime(startTime)
                updateEndTime(endTime)
                
                if mode == Mode.add {
                    print("Added new item \(newItem.title)")
                    
                    DispatchQueue.main.async {
                        userModel.user?.timeLineItems.append(newItem)
                        userModel.update()
                        print("Temporary new item title: \(newItem.title)")
                    }
                }
                
                if mode == Mode.edit {
                    print("Changed new item \(newItem.title)")
                    
                    DispatchQueue.main.async {
                        userModel.user?.timeLineItems[index] = newItem // Update the existing item
                        userModel.update()
                        print("Temporary updated item title: \(newItem.title)")
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
        ChangeTimeLineItem(mode: Mode.add)
            .environmentObject(UserViewModel())
    }
}
