import SwiftUI

struct TimeLineView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    var parentGeometry: GeometryProxy
    
    @State private var isAddTimeLineItemPresented = false
    @State private var newItemTitle = ""
    @State private var newItemStartTime = Date()
    @State private var newItemEndTime = Date()
    @State private var timeLineItems: [TimeLineItem] = []
    
    @State private var changeTimeLineItemIsActive = false
    @State private var rememberedIndexForEdit: Int? = nil
    
    var body: some View {
        VStack (alignment: .leading){
            Spacer()
            Text("Hochzeitstag: \(formattedWeddingDay())")
                .font(.custom("Lustria-Regular", size: 20))
                .foregroundColor(.black)
                .padding()
                .lineLimit(1)
                .minimumScaleFactor(0.4)
            
            List {
                ForEach(self.timeLineItems.indices, id: \.self) { index in
                    TimeLineItemView(timeLineItem: $timeLineItems[index])
                        .cornerRadius(8)
                        .padding(5)
                        .contextMenu {
                            Button(action: {
                                rememberedIndexForEdit = index
                                changeTimeLineItemIsActive.toggle()
                            }) {
                                Label("Bearbeiten", systemImage: "pencil")
                            }
                            
                            Button(action: {
                                deleteUserTimeLineItem(at: index)
                            }) {
                                Text("Löschen")
                                Image(systemName: "trash")
                            }
                        }
                }
                .onDelete { indexSet in
                    DispatchQueue.main.async {
                        userModel.user?.timeLineItems.remove(atOffsets: indexSet)
                        userModel.user?.timeLineItems.sort(by: { $0.startTime < $1.startTime })
                        userModel.update()
                        timeLineItems = userModel.user?.timeLineItems ?? []
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
                NavigationLink(destination: ChangeTimeLineItem(mode: Mode.add)
                    .onDisappear {
                        userModel.user?.timeLineItems.sort(by: { $0.startTime < $1.startTime })
                        timeLineItems = userModel.user?.timeLineItems ?? []}
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
            
            NavigationLink(destination: ChangeTimeLineItem(
                mode: .edit,
                index: rememberedIndexForEdit ?? 0,
                items: userModel.user?.timeLineItems ?? []
            ).onDisappear {
                userModel.user?.timeLineItems.sort(by: { $0.startTime < $1.startTime })
                timeLineItems = userModel.user?.timeLineItems ?? []
            }, isActive: $changeTimeLineItemIsActive) {
                EmptyView()
            }
        }
        .onAppear {
            timeLineItems = userModel.user?.timeLineItems ?? []
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
                Toolbar(presentationMode: presentationMode, parentGeometry: parentGeometry, title: "Ablaufplan")
            }
        }
        .foregroundColor(.white)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(hex: 0x425C54), for: .navigationBar)
    }
    
    private func deleteUserTimeLineItem(at index: Int) {
        DispatchQueue.main.async {
            userModel.user?.timeLineItems.remove(at: index)
            userModel.user?.timeLineItems.sort(by: { $0.startTime < $1.startTime })
            userModel.update()
            timeLineItems = userModel.user?.timeLineItems ?? []
        }
    }
    
    private func formattedWeddingDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d. MMMM"
        dateFormatter.locale = Locale(identifier: "de_DE")
        let formattedDate = dateFormatter.string(from: userModel.user?.weddingDay ?? Date())
        
        return formattedDate
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct TimeLineItem: Identifiable, Codable  {
    var id : UUID
    var title: String
    var extra: String
    var startTime: Int
    var endTime: Int
    
    init(
        id: UUID = UUID(),
        title: String = "",
        extra: String = "",
        startTime: Int = 0,
        endTime: Int = 0
    ) {
        self.id = id
        self.title = title
        self.extra = extra
        self.startTime = startTime
        self.endTime = endTime
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case extra
        case startTime
        case endTime
    }
}
