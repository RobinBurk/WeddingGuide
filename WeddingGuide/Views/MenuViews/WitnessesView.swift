import SwiftUI

struct WitnessesView: View {
    @EnvironmentObject var userModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var parentGeometry: GeometryProxy
    
    @State private var section1Expanded = false
    @State private var section2Expanded = false
    
    @State private var checkboxStatesBeforeWedding = Array(repeating: false, count: 11)
    private let checkboxTitlesBeforeWedding = [
        "Festlegung des Hochzeitsmottos",
        "Auswahl des Hochzeitskleids/Anzugs",
        "Beteiligung an der Brautentführung",
        "Blumenauswahl",
        "Besprechung des Dresscodes",
        "Kommunikation mit den Gästen",
        "Planung von Junggesellenabschied und Polterabend",
        "Gästebuch und Hochzeitszeitung vorbereiten",
        "Organisation von Hochzeitsspielen",
        "Vorbereitung der Rede/Fürbitten",
        "Auto organisieren"
    ]
    
    @State private var checkboxStatesOnWeddingDay = Array(repeating: false, count: 16)
    private let checkboxTitlesOnWeddingDay = [
        "Verpflegung des Brautpaares mit Trinken & Snacks.",
        "Zelebrieren von Bräuchen, z. B. Braut, die die Nacht vor der Hochzeit außer Haus schläft, und Organisation von etwas Altem, Neuem und Blauem.",
        "Hilfe beim Ankleiden",
        "Bereithalten eines Notfalltäschchens",
        "Mitbringen des Personalausweises für das Standesamt",
        "Taschentücher dabei haben",
        "Verantwortung für die Ringe",
        "Halten des Brautstraußes, wenn nötig",
        "Vortragen der Fürbitten",
        "Aufmerksamkeit auf die Braut und den Sitz des Kleides sowie des Schleiers richten",
        "Babysitter für evtl. schon vorhandene Kinder während der Trauung",
        "Unterstützung beim Brautpaarshooting (Handys halten, Taschen leeren, Outfit Check usw.)",
        "Hilfe bei den Gruppenfotos (Gäste herbeiholen)",
        "Halten von Reden bei der Hochzeitsfeier",
        "Organisation des Ablaufs der Hochzeitsspiele",
        "Beteiligung an der Brautentführung"
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Ihr habt eure Trauzeugen gefunden? Jetzt geht es darum, gemeinsam mit ihnen die Planung eures großen Tages anzugehen! Hier sind einige ToDo‘s, damit nichts vergessen wird und die Trauzeugen wissen, welche Aufgaben auf sie zukommen:")
                    .foregroundColor(.black)
                
                SectionHeaderView(title: "Vor der Hochzeit", isExpanded: $section1Expanded)
                if section1Expanded {
                    CheckboxListView(items: checkboxTitlesBeforeWedding, checkboxStates: $checkboxStatesBeforeWedding)
                    {
                        userModel.user?.checkboxStatesBeforeWedding = checkboxStatesBeforeWedding
                        userModel.update()
                    }
                }
                
                SectionHeaderView(title: "Am Hochzeitstag", isExpanded: $section2Expanded)
                if section2Expanded {
                    CheckboxListView(items: checkboxTitlesOnWeddingDay, checkboxStates: $checkboxStatesOnWeddingDay)
                    {
                        userModel.user?.checkboxStatesOnWeddingDay = checkboxStatesOnWeddingDay
                        userModel.update()
                    }
                }
                
                Text("Liebes Brautpaar: Vergesst nicht: Es ist eure Hochzeit! Entscheidet, was ihr wollt, und sprecht euch gut mit euren Trauzeugen ab – dann kann nichts schiefgehen.")
                    .foregroundColor(.black)
            }.padding()
        }
        .onAppear{
            checkboxStatesBeforeWedding = userModel.user?.checkboxStatesBeforeWedding ?? Array(repeating: false, count: 11)
            checkboxStatesOnWeddingDay = userModel.user?.checkboxStatesOnWeddingDay ?? Array(repeating: false, count: 16)
        }
        .onTapGesture {
            // Dismiss the keyboard when tapped outside the text fields
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .swipeToDismiss()
        .padding(.top, 10)
        .navigationBarBackButtonHidden()
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Toolbar(presentationMode: presentationMode, parentGeometry: parentGeometry, title: "Trauzeugen")
            }
        }
        .foregroundColor(.white)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(hex: 0x425C54), for: .navigationBar)
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct WitnessesView_Previews: PreviewProvider {
    static var previews: some View {
        let userModel = UserViewModel()
        
        return GeometryReader { geometry in
            WitnessesView(parentGeometry: geometry)
                .environmentObject(userModel)
                .previewLayout(.fixed(width: 375, height: 1000))
                .padding()
                .background(Color.white)
                .padding(.top, 50)
        }
    }
}

