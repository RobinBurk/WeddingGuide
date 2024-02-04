import SwiftUI

struct NoGosView: View {
    @Environment(\.presentationMode) var presentationMode
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Eure Hochzeit, eure Entscheidungen! Einige Überlegungen könnten die Feier noch angenehmer gestalten, nicht nur für euch, sondern auch für die Dienstleister.")
                    Text("1. Achtet darauf, euren eigenen Stil beizubehalten, denn wenn euch die Hochzeit gefällt, werden auch eure Gäste glücklich sein.")
                    Text("2. Bleibt bei der Outfitwahl und im Styling authentisch, damit ihr euch wohlfühlt – insbesondere wichtig für die Braut und ihr Makeup.")
                    Text("3. Passt die Brautfrisur dem Kleid an und vermeidet Strähnchen, die ins Gesicht fallen – euer Fotograf wird es zu schätzen wissen!")
                    Text("4. Wählt Anzüge ohne Neonfarben, kleine Muster oder schimmernde Effekte, um Unruhe auf den Bildern zu vermeiden.")
                    Text("5. Überlegt, ob eine übergroße Hochzeit wirklich notwendig ist oder ob eine intimere Feier mit gut bekannten Gästen nicht schöner wäre.")
                    Text("6. Seid kreativ bei den Gastgeschenken, um ihnen eine persönliche Note zu verleihen.")
                    Text("7. Vermeidet gestellte Fotos und respektiert, wenn jemand nicht vor der Kamera lächeln möchte – ein guter Fotograf kann spontane Momente einfangen.")
                    Text("8. Begrenzt die Zeit für Gruppenbilder, um nicht zu lange in diesem Format gefangen zu sein.")
                }.padding()
            }
        }
        .swipeToDismiss()
        .padding(.top, 35)
        .overlay {
            Toolbar(text: text, backAction: { self.goBack() })
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button.
        .navigationBarHidden(true)
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NoGosView(text: "No-Go's")
}
