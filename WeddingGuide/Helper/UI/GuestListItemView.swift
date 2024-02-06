import SwiftUI

struct GuestListItemView: View {
    @EnvironmentObject var userModel: UserViewModel
    @Binding var guestListItem: GuestListItem
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            VStack {
                Text("Tisch")
                    .font(.custom("Lustria-Regular", size: 13))
                Text(String(guestListItem.tableNumber))
                    .font(.custom("Lustria-Regular", size: 13))
            }
            
            Rectangle()
                .fill(Color(hex: 0xB8C7B9))
                .frame(width: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(guestListItem.familyName)
                    .font(.custom("Lustria-Regular", size: 18))
                Text("\(guestListItem.numberOfPeople) Personen")
                    .lineLimit(2)
                    .minimumScaleFactor(0.4)
                    .font(.custom("Lustria-Regular", size: 13))
                    .foregroundColor(Color.gray)
                    .fontWeight(.thin)
            }
            
            Picker("", selection: $guestListItem.confirmationStatus) {
                Text("Zugesagt").tag(ConfirmationStatus.confirmed)
                    .font(.custom("Lustria-Regular", size: 13))
                Text("Abgesagt").tag(ConfirmationStatus.declined)
                    .font(.custom("Lustria-Regular", size: 13))
                Text("Noch keine Antwort").tag(ConfirmationStatus.notResponded)
                    .font(.custom("Lustria-Regular", size: 13))
            }
            .pickerStyle(MenuPickerStyle())
            .font(.custom("Lustria-Regular", size: 14))
            .colorMultiply(Color(hex: 0xB8C7B9))
            .colorMultiply(Color(hex: 0x800020))
            .colorMultiply(Color(hex: 0x999999))
            .onChange(of: guestListItem.confirmationStatus) { _ in
                if let index = userModel.user?.guestListItems.firstIndex(where: { $0.id == guestListItem.id }) {
                    userModel.user?.guestListItems[index].confirmationStatus = guestListItem.confirmationStatus
                    userModel.update()
                }
            }
        }
    }
    
}

struct GuestListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleItem = GuestListItem (
            familyName : "Sample Name",
            tableNumber: 240,
            numberOfPeople: 20
        )
        
        return GuestListItemView(guestListItem:.constant(sampleItem))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

