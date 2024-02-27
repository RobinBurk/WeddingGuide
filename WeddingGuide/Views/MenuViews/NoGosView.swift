import SwiftUI

struct NoGosView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var parentGeometry: GeometryProxy
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Eure Hochzeit, eure Entscheidungen! Einige Überlegungen könnten die Feier noch angenehmer gestalten, nicht nur für euch, sondern auch für die Dienstleister.")
                        .foregroundColor(.black)
                    Text("1. Achtet darauf, euren eigenen Stil beizubehalten, denn wenn euch die Hochzeit gefällt, werden auch eure Gäste glücklich sein.")
                        .foregroundColor(.black)
                    Text("2. Bleibt bei der Outfitwahl und im Styling authentisch, damit ihr euch wohlfühlt – insbesondere wichtig für die Braut und ihr Makeup.")
                        .foregroundColor(.black)
                    Text("3. Passt die Brautfrisur dem Kleid an und vermeidet Strähnchen, die ins Gesicht fallen – euer Fotograf wird es zu schätzen wissen!")
                        .foregroundColor(.black)
                    Text("4. Wählt Anzüge ohne Neonfarben, kleine Muster oder schimmernde Effekte, um Unruhe auf den Bildern zu vermeiden.")
                        .foregroundColor(.black)
                    Text("5. Überlegt, ob eine übergroße Hochzeit wirklich notwendig ist oder ob eine intimere Feier mit gut bekannten Gästen nicht schöner wäre.")
                        .foregroundColor(.black)
                    Text("6. Seid kreativ bei den Gastgeschenken, um ihnen eine persönliche Note zu verleihen.")
                        .foregroundColor(.black)
                    Text("7. Vermeidet gestellte Fotos und respektiert, wenn jemand nicht vor der Kamera lächeln möchte – ein guter Fotograf kann spontane Momente einfangen.")
                        .foregroundColor(.black)
                    Text("8. Begrenzt die Zeit für Gruppenbilder, um nicht zu lange in diesem Format gefangen zu sein.")
                        .foregroundColor(.black)
                }.padding()
            }
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
                Toolbar(presentationMode: presentationMode, parentGeometry: parentGeometry, title: "No-Go's")
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
