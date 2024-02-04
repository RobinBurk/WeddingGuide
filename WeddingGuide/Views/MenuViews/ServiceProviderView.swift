import SwiftUI

struct ServiceProviderView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let text: String
    let menuItems = ["TRAUREDNER", "MUSIKER", "STYLISTEN", "HOCHZEITSTORTEN", "CATERING", "VIDEOGRAFEN", "GRAFIKER"]
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Ihr seid auf der Suche nach verschiedenen Dienstleistern die eure Hochzeit zu einem unvergesslichen Moment machen? Um es Euch so einfach wie möglich zu machen, haben wie Euch verschiedene Dienstleister zusammengestellt, die wir herzlichst empfehlen würden. Schaut Euch um, stellt direkt eure Anfrage oder nehmt telefonisch Kontakt auf.").padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                AllServiceProviderDetailView(title: menuItems[0], serviceProviders: [
                    ServieProviderDetailView(
                        imageName: "Annette-quadrat",
                        address: "Hochzeitsmärchen Bodensee - Annette Essert | Dornierstrasse 75 | 88048 Friedrichshafen | E-Mail: info@hochzeitsmaerchen-bodensee.de | Telefon: 0176 81629045",
                        title: "HOCHZEITSMÄRCHEN BODENSEE - ANNETTE",
                        description: "Ihr Lieben, ich bin hauptberuflich Sängerin und Traurednerin und liebe diesen Beruf nicht nur, sondern ich LEBE ihn. All' meine Paare, bekommen 200 % von mir, meiner Energie und meiner Leidenschaft (und meinen Humor). Meine Reden und mein Gesang kommen wirklich von Herzen und die schönsten Momente sind für mich: weinende Männer 🥹😁. Ich LIEBE es, wenn der Bräutigam oder die männlichen Gäste weinen, wenn ich auch die harte Kerne knacken konnte. Ich liebe den Augenblick, wenn die Bräute mir während dem Gesang mit Tränen in den Augen zuhören und wir uns alle zusammen während der Trauung immer wieder kaputtlachen. Die Dankbarkeit meiner Paare sind für mich abschließend so unglaublich schön. Jede Lovestory ist so komplett unterschiedlich und individuell. Ich arbeite mit keinen Gedichten oder Standards. Ich nehme EURE Geschichte, Leidenschaften, Persönlichkeiten und Eure Wünsche und packe meine Erfahrung und meine Tipps noch dazu. Das Ergebnis ist immer: LIEBE! Fühlt Euch gedrückt, Annette",
                        email: "info@hochzeitsmaerchen-bodensee.de",
                        telephone: "017681629045"
                    ),
                    ServieProviderDetailView(
                        imageName: "Tanja-Fimpel-quadrat",
                        address: "Freie Trauung Ravensburg - Tanja Fimpel | Birkenstraße 4 | 88214 Ravensburg | E-Mail: tanja.fimpel@gmx.de | Telefon: 0176 63427108 | Instagram: @freietrauungrv",
                        title: "FREIE TRAUUNG RAVENSBURG - TANJA",
                        description: "Ich biete euch eine humorvolle, emotionale und vor allem sehr individuelle freie Trauung. Wenn ihr möchtet, singe ich auch gerne bei eurer Trauung. Zu mir: Mein Name ist Tanja Heidi Fimpel und ich liebe das Leben!  ﻿Es gibt eigentlich kaum einen Tag, an dem ich nicht lache und singe. Ich bin ein von Grund auf positiv gestimmter Mensch und gebe auch gerne meine positiven Vibes an andere weiter. Durch das Singen bin ich zu diesem wunderbaren Beruf der Traurednerin gekommen. Seit 2016 bin ich freie Traurednerin mit Herz und Humor und liebe es, Menschen in ihrem Glück begleiten zu dürfen. Besonders wichtig ist für mich, dass die Chemie zwischen uns stimmt. Mein Bestreben ist es immer, eine möglichst individuelle Trauung inkl. Rede zu kreieren, die gut zu euch passt. Authentisch zu schreiben ist mein absoluter Fokus. Eure Gäste sollen euch wiedererkennen in der Rede und mein Ziel ist es, dass alle Gäste, samt euch, die ganze Rede über gespannt zuhören. Es sollen Emotionen frei werden und ihr sollt eine für euch perfekte und vor allem unvergessliche Trauung erleben. Eure Tanja",
                        email: "tanja.fimpel@gmx.de",
                        telephone: "017663427108"
                    ),
                    ServieProviderDetailView(
                        imageName: "Evelin-Stadler-quadrat",
                        address: "Hochzeitsplanung & Freie Trauung | 88427 Bad Schussenried | www.trausache.de | E-Mail: info@trausache.de | Telefon: 0173 8095877",
                        title: "TRAUSACHE - EVELIN STADLER",
                        description: "Bei TRAUSACHE könnt Ihr sowohl eine Hochzeitsplanung als auch eine Traurede buchen, sehr gerne auch Beides zusammen. Ich liebe diesen Beruf aus Leidenschaft und begleite Euch als Weddingplanerin von Beginn der Planung bis hin zu Eurem einzigartigen Hochzeitstag, damit ihr Euch voller Vertrauen ganz entspannt zurücklehnen könnt. Für die Trauzeremonie erstellen wir gemeinsam einen Ablauf, in dem ich Eure Wünsche individuell umsetze. Dabei kreiere ich für Euch eine sehr persönliche Traurede die von Herzen kommt und Eure Lovestory wiederspiegelt, welche uns und Eure Gäste zum Lachen und Weinen bringen wird. Diese emotionalen Momente werden dann von der lieben Jovanna von Kwickshot in wundervollen Bildern festgehalten, sodass ihr Euch immer an diesen unvergesslichen Tag zurückerinnern könnt. Ich freue mich auf Euch. Eure Evelin Stadler von TRAUSACHE",
                        email: "info@trausache.de",
                        telephone: "01738095877"
                    )
                    
                ])
                
                AllServiceProviderDetailView(title: menuItems[1], serviceProviders: [
                    ServieProviderDetailView(
                        imageName: "Tom-Mayer-quadrat",
                        address: "Tom Mayer | Langenenslingen | E-Mail: tom@tomiano.de | Telefon 0176 2029 2173 | www.tom-pianist.de | Spotify: Hier klicken (Playlist mit Klavierliedern für freie Trauungen)",
                        title: "TOM MAYER - PIANIST",
                        description: "Liebes Brautpaar, Ich bin Tom, der Pianist, und würde richtig gerne Eure Trauung mit Piano-Musik untermalen. Stellt euch vor: An Eurer Hochzeit hört ihr all Eure Lieblingslieder – sei es Pop, Rock, Metal, oder Malle-Songs – als gefühlvolle Klavierversionen. Zusammen mit der Traurednerin kreieren wir eine wunderschöne Stimmung für Eure Zeremonie. Meine Piano-Musik ist wie der Soundtrack eines Films und verstärkt die Emotionen, die transportiert werden. Meist beginne ich bereits 20 Minuten vor der Trauung zu spielen - so werden die ankommenden Gäste gleich in die richtige Stimmung gebracht. Auch während der Trauung untermale ich die Worte der Traurednerin passend, sodass sie noch intensiver auf euch und eure Gäste wirken. Gerne begleite ich euch auch danach für den Sektempfang oder während des Abendessens und sorge für gute Stimmung. Ihr könnt mich entweder solo am Klavier buchen oder mit einer Sängerin zusammen. Falls ihr jemanden im Familien-/Freundeskreis habt, die gerne singen würde, begleite ich sie gerne am Piano. Ich freue mich darauf, euren Tag so mitzugestalten, dass er für euch perfekt ist. Euer Tom",
                        email: "tom@tomiano.de",
                        telephone: "017620292173"
                    ),
                    
                    ServieProviderDetailView(
                        imageName: "twoforyou-quadrat",
                        address: "TwoforYou GbR - Katharina Pfister & Alexandra Glaser | Oberseehof 1 | 72511 Bingen | E-Mail: twoforyou.music@web.de | Telefon: 0162 7645937",
                        title: "TWO FOR YOU - BAND",
                        description: "Du suchst eine musikalische Umrahmung für deine Feier. Dann bist Du bei Uns genau richtig ! Wir sind Alexandra & Katharina, die Gesichter hinter TwoforYou. Wir kommen aus Bingen bei Sigmaringen. Uns verbindet nicht nur die Leidenschaft zur Musik, sondern auch eine langjährige Freundschaft. Wir freuen uns jedes mal aufs Neue ,vor Menschen zu stehen und sie mit unserer Musik berühren zu können. Unsere Vielfältigkeit durch zweistimmigen Gesang und Live-Gitarrenbegleitung verleiht den Zuschauen etwas ganz Besonderes. Mach auch du dein Event zu etwas Besonderem. Wir singen für Dich - egal ob im Standesamt, bei einer freien Trauung, in der Kirche, auf dem Sektempfang, bei der Taufe, auf einer Trauerfeier oder sonstigen Events. Schicke uns einfach eine unverbindliche Anfrage und wir kümmern uns dann um all Deine Wünsche. Gerne auch in einem persönlichen Gespräch. Wir freuen uns auf Dich! - Katharina & Alexandra",
                        email: "twoforyou.music@web.de",
                        telephone: "01627645937"
                    ),
                    
                    ServieProviderDetailView(
                        imageName: "",
                        address: "Lisa Steigmayer | Alemannenweg 14, 72474 Winterlingen | E-Mail: lisa.steigmayer@gamil.com | Telefon 0152 33869264 | www.leeeza.de",
                        title: "LOVE TONES - BAND",
                        description: "Hallo ihr lieben Brautpaare da draußen. Mein Name ist LISA STEIGMAYER und wohne im schönen WINTERLINGEN in Baden-Württemberg. Ihr sucht noch eine SÄNGERIN für euren BESONDEREN Tag?  Gerne würde ich eure HOCHZEIT oder TAUFE musikalisch umrahmen. Egal ob SOLO oder mit meinem GITARRISTEN - IHR entscheidet. Dank meiner GESANGSAUSBILDUNG bei Frau ABERNATHY bringe ich nicht nur die EMOTIONEN, sondern auch die richtige GESANGSTECHNIK mit. Freut euch auf GEFÜHLE. SPASS und LEICHTIGKEIT! Bis hoffentlich bald! Eure L I S A ",
                        email: "lisa.steigmayer@gamil.com",
                        telephone: "015233869264 "
                    )
                ])
                
                AllServiceProviderDetailView(title: menuItems[2], serviceProviders: [
                    ServieProviderDetailView(
                        imageName:"2022-12-10-Friseursalon-Rauch-kwickshot-14-quadrat",
                        address: "Der Haarslon - Friseurmeisterin Susanne Rauch-Ludwig | Hauptstraße 87 | 88348 Bad Saulgau | E-Mail: info@derhaarsalon.de | Telefon: 07581 6360",
                        title: "FRISEURSALON SUSANNE RAUCH - FRISEURIN",
                        description: "Unser wichtigster Grundsatz als Biosthetik-Friseur ist: Ihre Haare sind wertvoll. Sie demonstrieren Mode-Feeling und vermitteln Schönheit. Als Biosthetik-Spezialist nehmen wir uns Zeit für Sie, denn eine optimale Frisurenberatung ist Grundlage für Ihre und letztlich auch unsere Zufriedenheit. In unserem Team arbeiten daher dynamische, kompetente Mitarbeiter mit viel Freude am Umgang mit Menschen und Haar.",
                        email: "info@derhaarsalon.de",
                        telephone: "075816360"
                    ),
                    ServieProviderDetailView(
                        imageName: "Nadine-Ostermeier-quadrat",
                        address: "Nadine Ostermeier | Bachstraße 11 | 88348 Bad Saulgau | E-Mail: info@nadine-ostermeier.de | Telefon: 0176 63127487",
                        title: "NADINE OSTERMEIER - VISAGISTIN",
                        description: "Hallo, ich bin Nadine Ostermeier, wohne in Bad Saulgau und bin seit mehr als einem Jahrzehnt als Visagistin tätig. Es macht mir viel Freude, die über die Jahre erlernten und von mir entwickelten Schminktechniken in meinem Studio anzuwenden und wenn ich diese an Sie weitergeben darf. Damit ich mir für Sie Zeit nehmen kann, bitte ich um telefonische Terminvereinbarungen.",
                        email: "info@nadine-ostermeier.de",
                        telephone: "017663127487"
                    )
                ])
                
                AllServiceProviderDetailView(title: menuItems[3], serviceProviders: [
                    ServieProviderDetailView(
                        imageName: "Tonkaböhnle-Tamara",
                        address: "Tamara Bartnik | Badhausstraße 9 | 88422 Bad Buchau | Telefon: 07582 7959930",
                        title: "Madame TonkaBöhnle",
                        description: "Neben der klassischen Hochzeitstorte kredenzt Madame TonkaBöhnle individuell angefertigte Gastgeschenke in Form von Keksen, Macarons oder Gebäck. Für Euren Sweet Table könnt Ihr auch Törtchen, Desserts im Glas, Cupcakes und andere kleine Köstlichkeiten anfertigen lassen. Natürlich auch deftiges Kleingebäck aus handgemachtem Blätterteig für Euren Sektempfang. Der Verleih von Etageren, Tortenplatten und Tortenständer ist sehr gerne kostenlos möglich. Ich freue mich Eure Hochzeit mit Euch zu planen! Madame TonkaBöhnle freut sich über Eure Anfrage über das Kontaktformular.",
                        email: "info@tonkaboehnle.de",
                        telephone: "075827959930"
                    )
                ])
                
                AllServiceProviderDetailView(title: menuItems[4], serviceProviders: [
                    ServieProviderDetailView(
                        imageName: "",
                        address: "Stadiongaststätte Sportheim | Sportplatzstraße 18 | 88367 Hohentengen | Telefon: 07572 5768",
                        title: "SPORTHEIM HOHENTENGEN - CATERING",
                        description: "Schwäbische Spezialitäten aus guter Küche. Wir liefern dein individuelles Hochzeitsgericht für euren besonderen Anlass.",
                        email: "",
                        telephone: "075725768"
                    )
                ])
                
                AllServiceProviderDetailView(title: menuItems[5], serviceProviders: [
                    ServieProviderDetailView(
                        imageName: "2023-Niklas-Emotional-Wedding",
                        address: "Niklas Stadler | Am Kreuzberg 33 | 89441 Medlingen | E-Mail: info@emotional-wedding-movies.de | Telefon: 0160 99844214",
                        title: "EMOTIONAL WEDDING MOVIES - NIKLAS",
                        description: "Hey, Ich bin Niklas und ich bin Hochzeitsvideograf. Zusammen mit den Bildern ist es mein Ziel euren großen Tag für immer festzuhalten. Ich möchte euren Tag in einem einzigartigen und emotionalen Hochzeitsvideo für immer konservieren, mit all den Emotionen und Momenten, die leider viel zu schnell verfliegen.",
                        email: "info@emotional-wedding-movies.de",
                        telephone: "016099844214"
                    )
                ])
                
                AllServiceProviderDetailView(title: menuItems[6], serviceProviders: [
                    ServieProviderDetailView(
                        imageName: "Carolin-Vogelmann-quadrat",
                        address: "Carolin Vogelmann | 88348 Bad Saulgau | E-Mail: info@carolinvogelmann.de | Instagram: @carolinvogelmann.wedding",
                        title: "HOCHZEITSPAPETERIE - CAROLIN VOGELMANN",
                        description: "Bei mir findet ihr moderne & elegante Hochzeitspapeterie. Wählt zwischen einer fertigen Designkollektion oder einem individuell für euch erstellten Design. Gerne unterstütze und begleite ich euch von der Erstberatung bis hin zur finalen Papeterie. Über mich: Die Kombination aus Eleganz und Minimalismus beschreibt nicht nur meine Papeterie, sondern zieht sich durch mein ganzes Leben. Für manche mögen die beiden Aspekte gegensätzlich klingen, für mich schaffen sie die perfekte Harmonie. Zurückhaltend aber gleichzeitig auffallend, bodenständig aber gleichzeitig extravagant. Ich unterstütze und berate euch dabei ein Papeterie Design zu finden, das perfekt auf das Gesamtkonzept eurer Hochzeit abgestimmt ist. Meist sind es die kleinen Dinge, die das Große perfekt machen. Für mich gibt es keine besseren Werkzeuge als die Kombination aus digital und Handwerk. Mit viel Hingabe und Liebe zum Detail begleite ich euch von der Beratung über die Erstellung von Erstentwürfen bis hin zur finalen Papeterie.",
                        email: "info@carolinvogelmann.de",
                        telephone: ""
                    ),
                    ServieProviderDetailView(
                        imageName: "Laura-quadrat",
                        address: "Laura Schäfauer | Leopoldstraße 28 | 72488 Sigmaringen | E-Mail: info@lsmediendesign.de | Telefon: 0151 72745320",
                        title: "LS MEDIENDESIGN - GRAFIKERIN",
                        description: "Ich biete individuelle Gestaltung für Ihre Print- und Online-Projekte von A-Z. Für Privatpersonen biete ich personalisierte Produkte, wie z. B. Einladungskarten für Ihre Feier, Hochzeit oder Ihren Geburtstag an.",
                        email: "info@lsmediendesign.de",
                        telephone: "015172745320"
                    ),
                    ServieProviderDetailView(
                        imageName: "Alica-quadrat",
                        address: "Alica Freitag | Alter Dorfweg 13 | 88348 Bad Saulgau | E-Mail: kartenmalerei@web.de | Instagram: @alicas_kartenmalerei | Telefon: 0162 4396968",
                        title: "ALICA'S KARTENMALEREI",
                        description: "Ihr sucht nach einer besonderen und individuellen Papeterie für euren großen Tag? Bei mir erhaltet ihr liebevoll gestaltete Hochzeitseinladungen fernab der Massenware: Von der “Save the date”-Karte, über die Einladungskarte, bis hin zu weiterer Papeterie wie Menükarten, Sitzplan, Namenskärtchen, Dankeskarten & Co. – die Möglichkeiten an Papeterie für eure Hochzeit sind fast unendlich. Gemeinsam lassen wir aus euren Ideen & Wünschen euren Traum auf Papier wahr werden. Habt ihr spezielle Wünsche? Dann bin ich eure Ansprechpartnerin dafür",
                        email: "kartenmalerei@web.de",
                        telephone: "01624396968"
                    )
                ])
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


struct ServiceProviderView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceProviderView(text: "Dienstleister")
    }
}
struct AllServiceProviderDetailView: View {
    @State private var show: Bool = false
    let title: String
    var serviceProviders = [ServieProviderDetailView]()

    init(title: String, serviceProviders: [ServieProviderDetailView]) {
        self.title = title
        self.serviceProviders = serviceProviders
    }

    var body: some View {
        VStack {
            SectionHeaderView(title: title, isExpanded: $show)

            if show {
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        ForEach(serviceProviders, id: \.self) { serviceProvider in
                            serviceProvider
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

struct ServieProviderDetailView: View , Hashable{
    let imageName: String
    let address: String
    let title: String
    let description: String
    let email: String
    let telephone: String
    
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var showAlert = false
    
    init(imageName: String, address: String, title: String, description: String, email : String, telephone : String) {
        self.imageName = imageName
        self.address = address
        self.title = title
        self.description = description
        self.email = email
        self.telephone = telephone
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if !imageName.isEmpty {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.top, 10)
            }
            
            Text(address)
                .font(.custom("Lustria-Regular", size: 16))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.top, 10)
            
            Text(title)
                .fontWeight(.bold)
                .font(.custom("Lustria-Regular", size: 30))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                .minimumScaleFactor(0.4)
                .multilineTextAlignment(.center)
            
            Text(description)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.leading, 10)
                .padding(.trailing, 10)
            
            HStack(spacing: 16) {
                if !telephone.isEmpty {
                    Button(action: {
                        if let url = URL(string: "tel://" + telephone) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("ANRUFEN")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(hex: 0x425C54))
                            .cornerRadius(10)
                    }  .frame(maxWidth: .infinity)
                }
                
                if !email.isEmpty {
                    Button(action: {
                        if let emailURL = createEmailURL(recipient: email, subject: "Buchungsanfrage", body: "") {
                            if UIApplication.shared.canOpenURL(emailURL) {
                                UIApplication.shared.open(emailURL, options: [:])
                            } else {
                                showAlert(title: "Fehler", message: "E-Mail konnte nicht geöffnet werden. Überprüfen Sie Ihre E-Mail-Konfiguration.")
                            }
                        } else {
                            showAlert(title: "Fehler", message: "E-Mail konnte nicht geöffnet werden. Überprüfen Sie Ihre E-Mail-Konfiguration.")
                        }
                    }) {
                        Text("E-MAIL")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(hex: 0x425C54))
                            .cornerRadius(10)
                            .font(.custom("Lustria-Regular", size: 18))
                    }.frame(maxWidth: .infinity)
                }
            }
            .padding(10)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .background(Color(hex: 0xF5F5F5))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(5)
    }
    
    static func == (lhs: ServieProviderDetailView, rhs: ServieProviderDetailView) -> Bool {
        return lhs.imageName == rhs.imageName
        && lhs.address == rhs.address
        && lhs.title == rhs.title
        && lhs.description == rhs.description
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imageName)
        hasher.combine(address)
        hasher.combine(title)
        hasher.combine(description)
    }   
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        
        DispatchQueue.main.async {
            showAlert = true
        }
    }
}
