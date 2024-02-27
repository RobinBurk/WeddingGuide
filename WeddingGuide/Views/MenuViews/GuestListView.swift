import SwiftUI

struct GuestListView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    var parentGeometry: GeometryProxy
    
    @State private var isAddGuestListItemPresented = false
    @State private var guestListItems: [GuestListItem] = []
    @State private var changeGuestListItemIsActive = false
    @State private var rememberedIndexForEdit: Int? = nil
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                SummaryView(guestListItems: guestListItems)
                    .padding(.top, 15)
                    .padding(.horizontal)
                
                List {
                    ForEach(self.guestListItems.indices, id: \.self) { index in
                        GuestListItemView(guestListItem: $guestListItems[index])
                            .cornerRadius(8)
                            .padding(5)
                            .contextMenu {
                                Button(action: {
                                    rememberedIndexForEdit = index
                                    changeGuestListItemIsActive.toggle()
                                }) {
                                    Label("Bearbeiten", systemImage: "pencil")
                                }
                                
                                Button(action: {
                                    deleteGuestListLineItem(at: index)
                                }) {
                                    Label("Löschen", systemImage: "trash")
                                }
                            }
                    }
                    .onDelete { indexSet in
                        DispatchQueue.main.async {
                            userModel.user?.guestListItems.remove(atOffsets: indexSet)
                            userModel.update()
                            guestListItems = userModel.user?.guestListItems ?? []
                        }
                    }
                }
                .highPriorityGesture(DragGesture())
                .shadow(color: Color.gray.opacity(0.8), radius: 3, x: 0, y: 2)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .scrollContentBackground(.hidden)
                
                Spacer()
                
                HStack{
                    Spacer()
                    NavigationLink(destination: ChangeGuestListItem(mode: .add ).onDisappear {
                        guestListItems = userModel.user?.guestListItems ?? []}
                    ) {
                        Label("", systemImage: "plus.circle")
                            .font(.custom("Lustria-Regular", size: 30))
                            .foregroundColor(Color(hex: 0x425C54))
                    }
                    .padding(.top, 15)
                    .padding(.horizontal, 10)
                    .padding(.bottom, parentGeometry.size.height * 0.02)
                    Spacer()
                }
                .background(Color(hex: 0xB8C7B9))
                
                NavigationLink(destination: ChangeGuestListItem(
                    mode: .edit,
                    index: rememberedIndexForEdit ?? 0,
                    items: userModel.user?.guestListItems ?? []
                ).onDisappear {
                    guestListItems = userModel.user?.guestListItems ?? []
                }, isActive: $changeGuestListItemIsActive) {
                    EmptyView()
                }
            }
        }
        .onAppear {
            guestListItems = userModel.user?.guestListItems.sorted(by: { $0.tableNumber < $1.tableNumber }) ?? []
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
                Toolbar(presentationMode: presentationMode, parentGeometry: parentGeometry, title: "Gästeliste")
            }
        }
        .foregroundColor(.white)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(hex: 0x425C54), for: .navigationBar)
    }
    
    private func deleteGuestListLineItem(at index: Int) {
        DispatchQueue.main.async {
            userModel.user?.guestListItems.remove(at: index)
            userModel.update()
            guestListItems = userModel.user?.guestListItems ?? []
        }
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SummaryView: View {
    var guestListItems: [GuestListItem]
    
    var body: some View {
        VStack {
            ProgressBarHorizontal(confirmedCount: confirmedCount, declinedCount: declinedCount, notRespondedCount: notRespondedCount, totalCount: totalCount)
                .frame(width: 350, height: 20)
            
            HStack {
                VStack (alignment: .leading) {
                    Text("Zugesagt")
                        .foregroundColor(Color(hex: 0x425C54))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                    Text("\(confirmedCount) Personen")
                        .foregroundColor(Color(hex: 0x425C54))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                }
                Spacer()
                VStack {
                    Text("Abgesagt ")
                        .foregroundColor(Color(hex: 0x800020))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                    Text("\(declinedCount) Personen")
                        .foregroundColor(Color(hex: 0x800020))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                }
                Spacer()
                VStack (alignment: .trailing) {
                    Text("Offen ")
                        .foregroundColor(Color(hex: 0x999999))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                    Text("\(notRespondedCount) Personen")
                        .foregroundColor(Color(hex: 0x999999))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                }
            }
            .font(.custom("Lustria-Regular", size: 18))
            .foregroundColor(Color(hex: 0x425C54))
        }
    }
    
    var confirmedCount: Int {
        guestListItems.filter { $0.confirmationStatus == .confirmed }.map { $0.numberOfPeople }.reduce(0, +)
    }
    
    var declinedCount: Int {
        guestListItems.filter { $0.confirmationStatus == .declined }.map { $0.numberOfPeople }.reduce(0, +)
    }
    
    var notRespondedCount: Int {
        guestListItems.filter { $0.confirmationStatus == .notResponded }.map { $0.numberOfPeople }.reduce(0, +)
    }
    
    var totalCount: Int {
        guestListItems.map { $0.numberOfPeople }.reduce(0, +)
    }
}

struct ProgressBarHorizontal: View {
    var confirmedCount: Int
    var declinedCount: Int
    var notRespondedCount: Int
    var totalCount: Int // Gesamtanzahl hinzufügen
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 20)
                .foregroundColor(Color.gray) // Standardfarbe setzen
            
            HStack(spacing: 0) {
                progressRectangle(count: confirmedCount, color: Color(hex: 0x425C54), isFirst: true)
                progressRectangle(count: declinedCount, color: Color(hex: 0x800020))
                progressRectangle(count: notRespondedCount, color: Color(hex: 0x999999), isLast: true)
            }
        }
        .frame(height: 20) // Höhe des Fortschrittsbalkens festlegen
    }
    
    private func progressRectangle(count: Int, color: Color, isFirst: Bool = false, isLast: Bool = false) -> some View {
        Rectangle()
            .frame(width: progressWidth(count), height: 20)
            .foregroundColor(color)
    }
    
    private func progressWidth(_ count: Int) -> CGFloat {
        let totalCount = CGFloat(totalCount)
        return totalCount > 0 ? (CGFloat(count) / totalCount) * 350 : 0
    }
}

struct GuestListItem : Identifiable, Codable  {
    var id : UUID
    var familyName: String
    var tableNumber: Int
    var numberOfPeople: Int
    var confirmationStatus: ConfirmationStatus = .notResponded
    
    init(
        id: UUID = UUID(),
        familyName: String = "",
        tableNumber: Int = 0,
        numberOfPeople: Int = 0,
        confirmationStatus: ConfirmationStatus = .notResponded
    ) {
        self.id = id
        self.familyName = familyName
        self.tableNumber = tableNumber
        self.numberOfPeople = numberOfPeople
        self.confirmationStatus = confirmationStatus
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case familyName
        case tableNumber
        case numberOfPeople
        case confirmationStatus
    }
}

enum ConfirmationStatus: String, Codable {
    case confirmed = "Zugesagt"
    case declined = "Abgesagt"
    case notResponded = "Noch keine Antwort"
}

