import SwiftUI

struct BudgetManagementView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userModel: UserViewModel
    
    @State private var isAddBudgetItemPresented: Bool = false
    @State private var incomeText: String = ""
    @State private var expenseText: String = ""
    @State private var remainingBudget = 0.0
    @State private var temporaryNewItem: BudgetItem = BudgetItem()
    @State private var startBudget = 0.0
    @State private var budgetItems: [BudgetItem] = []
    
    private let text: String = "Budget"
    
    var body: some View {
        NavigationView {
            VStack( alignment: .leading, spacing: 10) {
                VStack(spacing: 10) {
                    HStack (spacing: 10) {
                        Text(NumberFormatter.localizedString(from: NSNumber(value: remainingBudget), number: .currency))
                            .font(.custom("Arial", size: 30))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        Text("Verbleibend")
                            .font(.custom("Lustria-Regular", size: 12))
                            .foregroundColor(.white)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                        Spacer()
                    }
                    
                    ProgressBar(currentValue: startBudget - remainingBudget, maxValue: startBudget, firstColor: Color(hex: 0x425C54), secondColor: .white)
                        .frame(height: 15)
                    
                    HStack (spacing: 0) {
                        Text(NumberFormatter.localizedString(from: NSNumber(value: startBudget - remainingBudget), number: .currency))
                            .font(.caption)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)
                            .fontWeight(.bold)
                        Text(" von ")
                            .font(.caption)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)
                        Text(NumberFormatter.localizedString(from: NSNumber(value: startBudget ), number: .currency))
                            .font(.caption)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)
                            .fontWeight(.bold)
                        Text(" verbraucht")
                            .font(.caption)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)
                        Spacer()
                    }
                }
                .padding()
                .background(Color(hex: 0xB8C7B9))
                
                HStack {
                    VStack (alignment: .leading){
                        Text("Einkommen")
                        Text(incomeText)
                            .foregroundColor(Color(hex: 0x425C54))
                    }
                    Spacer()
                    VStack (alignment: .trailing) {
                        Text("Ausgaben")
                        Text(expenseText)
                            .foregroundColor(Color(hex: 0x990000))
                    }
                }
                .padding(10)
                
                List {
                    ForEach(budgetItems.indices, id: \.self) { index in
                        BudgetItemRowView(budgetItem: $budgetItems[index])
                            .cornerRadius(8)
                            .padding(5)
                            .contextMenu {
                                Button(action: {
                                    deleteUserBudgetItem(at: index)
                                }) {
                                    Text("Löschen")
                                    Image(systemName: "trash")
                                }
                            }
                    }
                    .onDelete { indexSet in
                        userModel.user?.budgetItems.remove(atOffsets: indexSet)
                        userModel.update()
                        updateBudget()
                    }
                }
                .highPriorityGesture(DragGesture())
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: Color.gray.opacity(0.8), radius: 3, x: 0, y: 2)
                .scrollContentBackground(.hidden)
                
                HStack{
                    Spacer()
                    NavigationLink(destination:
                                    AddBudgetItemView().onDisappear {
                        updateBudget()
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
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onAppear {
            updateBudget()
        }
        .padding(.top, 35)
        .overlay {
            Toolbar(text: text, backAction: { self.goBack() })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    private func deleteUserBudgetItem(at index: Int) {
        DispatchQueue.main.async {
            userModel.user?.budgetItems.remove(at: index)
            userModel.update()
            updateBudget()
        }
    }
    
    private func updateBudget() {
        startBudget = userModel.user?.startBudget ?? 0.0
        budgetItems = userModel.user?.budgetItems ?? []
        
        let totalExpense = budgetItems.filter { $0.type == .expense }.reduce(0) { $0 + ($1.amount ) }
        let totalIncome = budgetItems.filter { $0.type == .income }.reduce(0) { $0 + ($1.amount ) }
        
        remainingBudget = startBudget + totalIncome - totalExpense
        
        incomeText = String(NumberFormatter.localizedString(from: NSNumber(value: totalIncome), number: .currency))
        expenseText = String(NumberFormatter.localizedString(from: NSNumber(value: totalExpense), number: .currency))
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct ProgressBar: View {
    var currentValue: Double
    var maxValue: Double
    var firstColor: Color
    var secondColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(secondColor)
                    .cornerRadius(geometry.size.height / 2)
                
                Rectangle()
                    .frame(width: min(CGFloat(self.currentValue / self.maxValue) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(firstColor)
                    .cornerRadius(geometry.size.height / 2)
            }
        }
    }
}

struct BudgetItemRowView: View {
    @Binding var budgetItem: BudgetItem
    
    var body: some View {
        VStack {
            Picker("", selection: $budgetItem.type) {
                Text("Einkommen").tag(BudgetItemType.income)
                Text("Ausgabe").tag(BudgetItemType.expense)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 10)
            
            HStack {
                Text(budgetItem.description)
                Spacer()
                Text(NumberFormatter.localizedString(from: NSNumber(value: budgetItem.amount), number: .currency))
                    .foregroundColor(budgetItem.type == .income ? Color(hex: 0x425C54) : Color(hex: 0x990000))
            }.padding(.top, 5)
        }
        .padding()
    }
}

struct CustomNumberField: View {
    var title: String
    var value: Binding<NSNumber>
    
    private var formattedValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter.string(from: value.wrappedValue) ?? ""
    }
    
    var body: some View {
        TextField(title, text: Binding(
            get: { self.formattedValue },
            set: { newText in
                let filtered = newText.filter { "0123456789,".contains($0) }
                if let newValue = NumberFormatter().number(from: filtered) {
                    self.value.wrappedValue = newValue
                }
            }
        ))
    }
}

struct BudgetItem: Identifiable, Codable {
    var id: UUID
    var description: String
    var type: BudgetItemType
    var amount: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case type
        case amount
    }
    
    init(
        id: UUID = UUID(),
        description: String = "",
        type: BudgetItemType = .expense,
        amount: Double = 0.0
    ) {
        self.id = id
        self.description = description
        self.type = type
        self.amount = amount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        description = try container.decode(String.self, forKey: .description)
        type = try container.decode(BudgetItemType.self, forKey: .type)
        amount = try container.decode(Double.self, forKey: .amount)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(description, forKey: .description)
        try container.encode(type, forKey: .type)
        try container.encode(amount, forKey: .amount)
    }
    
    static func fromJSONArrayString(_ jsonString: String) throws -> [BudgetItem] {
        let decoder = JSONDecoder()
        let data = Data(jsonString.utf8)
        return try decoder.decode([BudgetItem].self, from: data)
    }
    
    static func toJSONStringArray(_ items: [BudgetItem]) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(items)
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw EncodingError.invalidValue(items, EncodingError.Context(codingPath: [], debugDescription: "Failed to convert data to string"))
        }
        return jsonString
    }
}

enum BudgetItemType: String, CaseIterable, Identifiable, Codable {
    case income = "Income"
    case expense = "Expense"
    
    var id: String { self.rawValue }
    
    enum CodingKeys: String, CodingKey {
        case income, expense
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.income) {
            self = .income
        } else if container.contains(.expense) {
            self = .expense
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Invalid budget item type"
                )
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .income:
            try container.encode(true, forKey: .income)
        case .expense:
            try container.encode(true, forKey: .expense)
        }
    }
}