import SwiftUI

struct PreparationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel : UserViewModel
    
    @State private var section1Expanded = false
    @State private var section2Expanded = false
    @State private var section3Expanded = false
    
    private let text: String
    
    @State private var checkboxStatesPreparationBride = Array(repeating: false, count: 6)
    private let checkboxTitlesPreparationBride = [
        "Schmuck (Kette, Ohrringe): Wähle deinen Lieblingsschmuck aus, der perfekt zu deinem Hochzeitskleid passt. Eine funkelnde Kette und elegante Ohrringe verleihen deinem Look einen Hauch von Glamour und lassen dich strahlen.",
        "Besonderes Make-Up wie Lippenstift, Pinsel und Parfüm: Nutze diese Gelegenheit, um dich mit deinem Make-Up zu verwöhnen. Wähle einen Lippenstift in deiner Lieblingsfarbe, der deine Lippen zum Küssen verführerisch macht. Mit hochwertigen Pinseln zauberst du ein perfektes Make-Up, das den ganzen Tag hält. Vergiss auch nicht, dein Lieblingsparfüm aufzutragen, um einen unvergesslichen Duft zu hinterlassen.",
        "Strapsen: Wenn du dich für ein Brautkleid mit Strapsen entschieden hast, denke daran, diese vorzubereiten. Achte darauf, dass sie gut sitzen und dich den ganzen Tag über bequem begleiten.",
        "Schöner Kleiderbügel für das Aufhängen des Hochzeitskleides: Dein Hochzeitskleid verdient einen besonderen Platz. Investiere in einen schönen Kleiderbügel, auf dem dein Kleid perfekt zur Geltung kommt. Dies ist nicht nur praktisch, sondern verleiht dem Getting Ready auch eine elegante Note.",
        "Brautschuhe & -strauß: Vergiss nicht, deine Brautschuhe bereitzustellen, damit du dich beim Getting Ready komplett fühlen kannst. Wähle bequeme Schuhe, die dir den ganzen Tag über ein angenehmes Tragegefühl bieten. Außerdem solltest du auch deinen Brautstrauß bereitlegen, damit du ihn später stolz in den Händen halten kannst.",
        "Einladungskarten & Ablaufplan: Halte auch die Einladungskarten und den Ablaufplan bereit, damit wir diese auf den Bildern und beim Gesamtkonzept nicht vergessen, denn hier steckt schließlich ebenso viel Arbeit drin."
    ]
    @State private var checkboxStatesPreparationGroom = Array(repeating: false, count: 6)
    private let checkboxTitlesPreparationGroom = [
        "Schmuck wie Manschettenknöpfe, Krawatte oder Fliege: Wähle Schmuckstücke aus, die zu deinem Hochzeitsoutfit passen und deinen Look vervollständigen. Manschettenknöpfe, eine Krawatte oder Fliege können deinem Outfit eine elegante Note verleihen.",
        "Dein spezielles Parfüm, das dich wohlfühlen lässt: Trage dein Lieblingsparfüm auf, um dich wohlzufühlen und einen unvergesslichen Duft zu hinterlassen.",
        "Die Eheringe: Vergiss nicht, die Eheringe bereitzustellen, damit sie auf den Bildern festgehalten werden können und Teil des Gesamtkonzepts sind.",
        "Einladungskarten & Ablaufplan: Halte auch die Einladungskarten und den Ablaufplan bereit, damit sie auf den Bildern und beim Gesamtkonzept nicht vergessen werden. Schließlich steckt auch hier viel Arbeit drin."
    ]
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeaderView(title: "ORT", isExpanded: $section1Expanded)
                    if section1Expanded {
                        Text("Das Getting Ready sollte an einem hellen und schönen Ort stattfinden. Am besten dort wo es eine Fensterfront gibt um dort das Tageslicht gut miteinbinden zu können.")
                    }
                    
                    SectionHeaderView(title: "VORBEREITUNG BRAUT", isExpanded: $section2Expanded)
                    if section2Expanded {
                        Text("Mache Dir Gedanken, wer an deinem Getting Ready dabei sein soll. Überlege, welche Personen dir besonders nahestehen und mit denen du diesen besonderen Moment teilen möchtest. Vielleicht möchtest du deine Mutter dabeihaben, um dich zu unterstützen und dir emotional zur Seite zu stehen. Vielleicht möchtest du auch deine Trauzeugin oder enge Freundinnen einladen, um gemeinsam die Vorfreude und Aufregung zu teilen. Denke auch darüber nach, wie die Outfits aussehen sollen. Du könntest zum Beispiel einheitliche Bademäntel oder personalisierte T-Shirts für dein Team zusammenstellen, um ein Gefühl der Zusammengehörigkeit zu schaffen.\n\nUm die Atmosphäre während des Getting Ready noch angenehmer zu gestalten, könnt ihr auch sehr gerne Musik abspielen lassen. Überlege, welche Lieder und Melodien dir besonders am Herzen liegen und welche Stimmung du gerne während dieser besonderen Zeit haben möchtest. Musik kann eine wunderbare Möglichkeit sein, um entspannter und fröhlicher in den Tag zu starten.\n\nDenke daran, dass das Getting Ready ein wichtiger Teil deiner Hochzeit ist und du dich dabei wohlfühlen solltest. Plane daher im Voraus und bereite alles vor, damit du den Tag in vollen Zügen genießen kannst.\nDes Weiteren bitten wir dich, folgende Sachen für das Braut Getting Ready vorzubereiten:")
                        
                        CheckboxListView(items: checkboxTitlesPreparationBride, checkboxStates: $checkboxStatesPreparationBride) {
                            userModel.user?.checkboxStatesPreparationBride = checkboxStatesPreparationBride
                            userModel.update()
                        }
                        
                        Text("Denke daran, dass das Getting Ready ein besonderer Moment ist, indem du dich verwöhnen und auf den großen Tag einstimmen kannst. Mit der richtigen Vorbereitung und den passenden Accessoires wird dieser Moment unvergesslich.")
                    }
                    
                    SectionHeaderView(title: "VORBEREITUNG BRÄUTIGAM", isExpanded: $section3Expanded)
                    if section3Expanded {
                        Text("Bitte mache dir Gedanken, wer an deinem Bräutigam Getting Ready dabei sein sollte. Neben deinem Vater und deinem Bruder könntest du auch erwägen, einige enge Freunde einzuladen, um gemeinsam mit dir anzustoßen. Es wäre eine großartige Gelegenheit, sich mit einem Bier zu entspannen und in die richtige Stimmung zu kommen.\n\nUm dich wohlzufühlen, ist es natürlich gestattet, deine Lieblingsmusik abspielen zu lassen, um direkt in die richtige Atmosphäre einzutauchen. Wähle Lieder aus, die dir besonders am Herzen liegen und die dich in eine entspannte und fröhliche Stimmung versetzen.\n\nFür das Shooting während des Bräutigam Getting Ready solltest du folgende Sachen vorbereiten:")
                        
                        CheckboxListView(items: checkboxTitlesPreparationGroom, checkboxStates: $checkboxStatesPreparationGroom)
                        {
                            userModel.user?.checkboxStatesPreparationGroom = checkboxStatesPreparationGroom
                            userModel.update()
                        }
                        
                        Text("Denke daran, dass das Getting Ready ein besonderer Moment ist, indem du dich verwöhnen und auf den großen Tag einstimmen kannst. Mit der richtigen Vorbereitung und den passenden Accessoires wird dieser Moment unvergesslich.")
                    }
                }.padding()
            }
            .onAppear{
                checkboxStatesPreparationBride = userModel.user?.checkboxStatesPreparationBride ?? Array(repeating: false, count: 6)
                checkboxStatesPreparationGroom = userModel.user?.checkboxStatesPreparationGroom ?? Array(repeating: false, count: 4)
            }
            .swipeToDismiss()
            .padding(.top, 35)
            .overlay {
                Toolbar(text: text, backAction: { self.goBack() })
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
}
