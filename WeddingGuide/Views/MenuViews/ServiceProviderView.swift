import SwiftUI
import SDWebImageSwiftUI

struct ServiceProviderView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: DataManager
    
    var parentGeometry: GeometryProxy
    
    let menuItems = ["TRAUREDNER", "MUSIKER", "STYLISTEN", "HOCHZEITSTORTEN", "CATERING", "VIDEOGRAFEN", "GRAFIKER"]
    
    var body: some View {
        ScrollView {
            Text("Ihr seid auf der Suche nach verschiedenen Dienstleistern rund um den Bodensee die eure Hochzeit zu einem unvergesslichen Moment machen? Um es Euch so einfach wie möglich zu machen, haben wie Euch verschiedene Dienstleister zusammengestellt, die wir herzlichst empfehlen würden. Schaut Euch um, stellt direkt eure Anfrage oder nehmt telefonisch Kontakt auf.")
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
            
            ForEach(dataManager.serviceProviderGroups, id: \.title) { group in
                let serviceProviderDetailViews = group.serviceProviders.map { serviceProvider in
                    ServiceProviderDetailView(
                        imageName: serviceProvider.imageName,
                        address: serviceProvider.address,
                        title: serviceProvider.title,
                        description: serviceProvider.description,
                        email: serviceProvider.email,
                        telephone: serviceProvider.telephone
                    )
                }
                AllServiceProviderDetailView(title: group.title, serviceProviders: serviceProviderDetailViews)
            }
        }
        .onAppear {
            dataManager.loadServiceProviders { success, message in
                if !success {
                   print("Error: \(message)")
                }
                
                dataManager.loadImagesServiceProvider(name: "images_service_providers") { success, message in
                    if !success {
                       print("Error: \(message)")
                    }
                }
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
                Toolbar(presentationMode: presentationMode, parentGeometry: parentGeometry, title: "Dienstleister")
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

struct AllServiceProviderDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    
    @State private var show: Bool = false
    let title: String
    var serviceProviders = [ServiceProviderDetailView]()
    
    init(title: String, serviceProviders: [ServiceProviderDetailView]) {
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

struct ServiceProviderDetailView: View , Hashable{
    @EnvironmentObject var dataManager: DataManager
    
    let imageName: String
    let address: String
    let title: String
    let description: String
    let email: String
    let telephone: String
    
    @State private var imageUrl: String
    
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
        self.imageUrl = ""
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if !imageUrl.isEmpty {
                WebImage(url: URL(string: imageUrl))
                    .resizable()
                    .scaledToFill()
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
                .foregroundColor(.black)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                .minimumScaleFactor(0.4)
                .multilineTextAlignment(.center)
            
            Text(description)
                .foregroundColor(.black)
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
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("ANRUFEN")
                        }
                        .font(.custom("Lustria-Regular", size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(hex: 0x425C54))
                        .cornerRadius(10)
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
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
                        HStack {
                            Image(systemName: "envelope.fill")
                            Text("E-MAIL")
                        }
                        .frame(maxWidth: .infinity)
                        .font(.custom("Lustria-Regular", size: 18))
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(hex: 0x425C54))
                        .cornerRadius(10)
                    }.frame(maxWidth: .infinity)
                }
            }
            .padding(10)
        }
        .onAppear {
            // Search in list to image name and get url.
            if let imageUrlTemp = dataManager.imagesUrlsServiceProviders.first(where: { $0[0] == imageName })?.last {
                self.imageUrl = imageUrlTemp
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .background(Color(hex: 0xF5F5F5))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(5)
    }
    
    static func == (lhs: ServiceProviderDetailView, rhs: ServiceProviderDetailView) -> Bool {
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

struct ServiceProviderGroup  {
    var title: String
    var serviceProviders: [ServiceProvider] = []
}

struct ServiceProvider {
    var address: String
    var description: String
    var email: String
    var imageName: String
    var telephone: String
    var title: String
}
