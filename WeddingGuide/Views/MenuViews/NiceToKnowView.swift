import SwiftUI

struct NiceToKnowView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var section1Expanded = false
    @State private var section2Expanded = false
    @State private var section3Expanded = false
    @State private var section4Expanded = false
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeaderView(title: "ABLAUFPLAN", isExpanded: $section1Expanded)
                    if section1Expanded {
                        Text("Es ist wichtig, bei der Planung einer Hochzeitszeremonie flexibel zu bleiben und nicht jeden Moment bis ins kleinste Detail zu durchplanen. Oftmals kommt es anders als erwartet und es können unvorhergesehene Ereignisse auftreten. Indem man den Tag nicht zu straff durchplant, schafft man Raum für spontane Momente und kann sich besser auf unvorhergesehene Situationen einstellen. Des Weiteren ist es ratsam, genügend Pufferzeiten einzuplanen, sodass man nicht in Stress gerät, wenn sich etwas verspätet oder länger dauert als geplant. Diese Pufferzeiten ermöglichen es auch, den Moment zu genießen und sich bewusst auf das Hier und Jetzt zu konzentrieren, anstatt ständig an den nächsten Programmpunkt denken zu müssen. Denkt dran Euch nicht zu sehr an bestimmten Abläufen und Traditionen festzuklammern. Jede Hochzeit ist einzigartig und es gibt keinen festgelegten Fahrplan, dem man folgen muss. Erlaubt euch, spontan zu sein und auf eure Intuition zu hören. Manchmal ergeben sich die schönsten Momente aus ungeplanten Situationen.")
                    }
                    
                    SectionHeaderView(title: "VOR DER TRAUUNG", isExpanded: $section2Expanded)
                    if section2Expanded {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Es ist am besten, das Brautpaar-Shooting vor der Trauung zu planen, um mögliche Stressmomente zu vermeiden. Hierzu empfiehlt es sich, einen detaillierten \"Ablaufplan\" zu erstellen, der alle wichtigen Punkte und Zeiten festhält. Weitere Tipps zum Ablaufplan findet ihr unter dem separaten Punkt: ")
                            NavigationLink(destination: TimeLineView(text: "Ablaufplan")) {
                                Text("Ablaufplan")
                                    .foregroundColor(Color(hex: 0x425C54))
                                    .fontWeight(.bold)
                            }
                            Text("Es ist hilfreich sich mit dem Pfarrer oder Trauredner im Voraus abzustimmen, ob das Fotografieren in der Location erlaubt ist und was beachtet werden soll. Des Weiteren sollte Ihnen mitgeteilt werden, dass sie sich zur Seite stellen sollen, wenn das Brautpaar sich küsst. Dadurch wird gewährleistet, dass der Kuss ungestört und ohne Hindernisse stattfinden kann und dieser einzigartige Moment von den Fotografen richtig festgehalten werden kann. Klären Sie diese Details im Vorfeld ab, um Missverständnisse zu vermeiden und sicherzustellen, dass der Kuss reibungslos abläuft.")
                            
                        }
                    }
                    
                    SectionHeaderView(title: "WÄHREND DER TRAUUNG", isExpanded: $section3Expanded)
                    if section3Expanded {
                        Text("Sei Dir bewusst, dass der Ein- und Auszug bei der Hochzeitszeremonie ein bedeutungsvoller Moment ist, der von vielen Gästen mit Spannung erwartet wird. Es ist wichtig, diesen Moment zu genießen und langsam zu gehen, um die Atmosphäre der Feier zu spüren und den Augenblick voll auszukosten.")
                        Text("Der Kuss zwischen dem Brautpaar ist ein Höhepunkt der Hochzeitszeremonie und sollte daher gebührend zelebriert werden. Nehmt Euch die Zeit, um euch in die Augen zu schauen oder euch in die Arme zu nehmen um den Kuss in aller Ruhe zu genießen. Lasst Euch Euch von der Freude und Liebe, die an diesem Tag in der Luft liegt, inspirieren.")
                        Text("Während der Trauung solltet ihr als Brautpaar eine aufrechte Haltung einnehmen, um Eure Würde und Stärke als Paar auszustrahlen. Eine aufrechte Haltung symbolisiert auch Vertrauen und Offenheit, was sich positiv auf die gesamte Atmosphäre der Zeremonie auswirkt. Indem ihr aufrecht steht, zeigt ihr euren Gästen, wie wichtig euch dieser Moment ist und dass ihr bereit seid, den Bund der Ehe einzugehen.")
                        Text("Es ist ratsam, Taschentücher für das Brautpaar bereitzuhalten, um mögliche Tränen während der Trauung aufzufangen. Eine Hochzeitszeremonie ist oft von starken Emotionen geprägt und Tränen der Freude oder Rührung sind keine Seltenheit. Indem ihr Taschentücher bereithaltet, könnt ihr sicherstellen, dass ihr euch während der Zeremonie nicht um Tränen kümmern müsst und euch voll und ganz auf den Moment konzentrieren könnt.")
                    }
                    
                    SectionHeaderView(title: "SONSTIGES", isExpanded: $section4Expanded)
                    if section4Expanded {
                        Text("Eine separate Emailadresse für all eure Hochzeitskommunikation kann helfen, den Überblick zwischen Angeboten und Vereinbarungen zu behalten. Es ist wichtig, dass ihr alle wichtigen Hochzeitsdetails an einem Ort sammelt und organisiert. Durch die Verwendung einer separaten Emailadresse könnt ihr sicherstellen, dass keine wichtige Information verloren geht und ihr jederzeit darauf zugreifen könnt.")
                        Text("Ihr entscheidet, wer eingeladen wird und wer nicht! Bei der Planung eurer Hochzeit ist es von entscheidender Bedeutung, dass ihr die Gästeliste sorgfältig erstellt. Ihr solltet nur die Menschen einladen, die euch wirklich am Herzen liegen und die eurem besonderen Tag eine positive Atmosphäre verleihen werden. Lasst euch nicht von äußeren Erwartungen oder Meinungen beeinflussen und vertraut eurem Bauchgefühl.")
                        Text("Spart nicht an guten Dienstleistern. Sie sind maßgeblich am Gelingen eurer Hochzeit beteiligt. Falls ihr noch passende Dienstleister sucht, schaut gerne im Punkt \"Dienstleister\" vorbei. Hier haben wir sorgfältig ausgewählte Dienstleister, die wir jederzeit empfehlen können, da wir ihre hervorragende Arbeit kennen. Investiert in erfahrene Hochzeitsplaner, talentierte Fotografen, professionelle Caterer und andere Dienstleister, die eurem besonderen Tag den perfekten Rahmen geben werden.")
                        Text("Lasst euch helfen und gebt auch Aufgaben ab. Die Planung einer Hochzeit kann stressig sein und eine Menge Arbeit erfordern. Scheut euch nicht davor, Hilfe anzunehmen und Aufgaben an vertrauenswürdige Freunde oder Familienmitglieder abzugeben. Es ist wichtig, dass ihr euch auf eurem Hochzeitstag entspannen und den Moment genießen könnt, anstatt euch um jedes Detail kümmern zu müssen.")
                        Text("Lauft eure Schuhe ein. Blasen an den Füßen am Hochzeitstag müssen nicht sein. Denkt daran, dass ihr den Großteil eures Hochzeitstages auf den Beinen verbringen werdet. Daher ist es wichtig, dass ihr eure Hochzeitsschuhe vorher einlauft, um Blasen und unbequemes Tragen zu vermeiden. Tragt die Schuhe zuhause ein paar Mal, um sicherzustellen, dass sie bequem sind und gut passen.")
                        Text("Die Braut sollte sich im Vorfeld überlegen, wie sie am besten mit ihrem Brautkleid die Toilette besuchen kann. Je nach Kleid kann das manchmal gar nicht so einfach sein. Ein Brautkleid kann wunderschön sein, aber auch sehr umständlich beim Toilettengang. Die Braut sollte im Vorfeld überlegen, welche Techniken oder Hilfsmittel sie verwenden kann, um diesen Moment stressfrei zu gestalten. Es gibt spezielle Hochzeitstoilettenkleider oder auch die Möglichkeit, eine vertraute Person um Hilfe zu bitten. So könnt ihr sicherstellen, dass ihr euren besonderen Tag ohne unnötige Hindernisse genießen könnt.")
                    }
                }.padding()
            }
            .swipeToDismiss()
            .padding(.top, 35)
            .overlay {
                Toolbar(text: text, backAction: { self.goBack() })
            }
            
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button.
        .navigationBarHidden(true)
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct NiceToKnowView_Previews: PreviewProvider {
    static var previews: some View {
        NiceToKnowView(text: "Nice-To-Know")
    }
}

