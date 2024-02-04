import SwiftUI

struct TimeLineView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    @State private var isAddTimeLineItemPresented = false
    @State private var newItemTitle = ""
    @State private var newItemStartTime = Date()
    @State private var newItemEndTime = Date()
    @State private var timeLineItems: [TimeLineItem] = []
    
    private let text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading){
                Spacer()
                Text("Hochzeitstag: \(formattedWeddingDay())")
                    .font(.custom("Lustria-Regular", size: 26))
                    .padding()
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                    .font(.custom("Lustria-Regular", size: 20))
                
                List {
                    ForEach(self.timeLineItems.indices, id: \.self) { index in
                        TimeLineItemView(timeLineItem: $timeLineItems[index])
                            .cornerRadius(8)
                            .padding(5)
                            .contextMenu {
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
                    NavigationLink(destination:
                                    AddTimeLineItem().onDisappear {
                        timeLineItems = userModel.user?.timeLineItems ?? []
                    }
                    ) {
                        Label("", systemImage: "plus.circle")
                            .font(.custom("Lustria-Regular", size: 30))
                            .foregroundColor(Color(hex: 0x425C54))
                    }
                    .padding(.top, 15)
                    .padding(.horizontal, 10)
                    .padding(.bottom, -15)
                    Spacer()
                }
                .background(Color(hex: 0xB8C7B9))
            }
        }
        .onAppear {
            timeLineItems = userModel.user?.timeLineItems ?? []
        }
        .padding(.top, 35)
        .overlay {
            Toolbar(text: text, backAction: { self.goBack() })
        }
        .onTapGesture {
            // Dismiss the keyboard when tapped outside the text fields
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .swipeToDismiss()
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    private func deleteUserTimeLineItem(at index: Int) {
        DispatchQueue.main.async {
            userModel.user?.timeLineItems.remove(at: index)
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        extra = try container.decode(String.self, forKey: .extra)
        startTime = try container.decode(Int.self, forKey: .startTime)
        endTime = try container.decode(Int.self, forKey: .endTime)
    }
    
    static func fromJSONArrayString(_ jsonString: String) throws -> [TimeLineItem] {
        let decoder = JSONDecoder()
        let data = Data(jsonString.utf8)
        return try decoder.decode([TimeLineItem].self, from: data)
    }
    
    static func toJSONStringArray(_ items: [TimeLineItem]) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(items)
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw EncodingError.invalidValue(items, EncodingError.Context(codingPath: [], debugDescription: "Failed to convert data to string"))
        }
        return jsonString
    }
}
