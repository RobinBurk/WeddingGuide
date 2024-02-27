import SwiftUI
import ConfettiSwiftUI

struct HomeView: View {
    @EnvironmentObject var storeKitManager : StoreKitManager
    @EnvironmentObject var userModel: UserViewModel
    
    @State private var isActionSheetOrganisationPresented = false
    @State private var navigationTimeLineIsActive = false
    @State private var navigationGuestListIsActive = false
    @State private var isActionSheetGadgetPresented = false
    
    @State var isPremium: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundImageView()
            GeometryReader { geometry in
                VStack {
                    navigationAndGeometrySection(geometry)
                    menuSection(geometry)
                }
            }
        }
        .onAppear {
            if !isPremium && !(userModel.user?.isVIP ?? true) {
                Task {
                    // Get product of storeProducts by ID.
                    if let product = storeKitManager.storeProducts.first(where: { $0.id == "Gekauft_ID" }) {
                        print("Found product: \(product)")
                        do {
                            // Check if the product has been purchased.
                            isPremium = try await storeKitManager.isPurchased(product)
                        } catch {
                            // Handle error
                            print("Error checking purchase status: \(error)")
                        }
                    } else {
                        print("Product not found")
                    }
                }
            }
        }
        .onChange(of: storeKitManager.purchasedCourses) { newValue in
            Task {
                // Get product of storeProducts by display name.
                if let product = storeKitManager.storeProducts.first(where: { $0.id == "Gekauft_ID" }) {
                    // Use the product
                    print("Found product: \(product)")
                    isPremium = (try? await storeKitManager.isPurchased(product)) ?? false
                } else {
                    print("Product not found")
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    func navigationAndGeometrySection(_ geometry: GeometryProxy) -> some View {
        VStack {
            // Hamburger menu.
            HStack {
                Spacer()
                HamburgerMenu(parentGeometry: geometry)
                    .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.055)
            }
            .padding(.vertical, 5)
            
            CountDownView(width: geometry.size.width, height: geometry.size.height * 0.1125)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: geometry.size.width, height: geometry.size.height * 0.1125)
                .padding(.vertical, 5)
            
            BudgetView(parentGeometry: geometry, width: geometry.size.width, height: geometry.size.height * 0.225)
                .frame(height: geometry.size.height * 0.225)
                .padding(5)
        }
    }
    
    func menuSection(_ geometry: GeometryProxy) -> some View {
        LazyVGrid(columns: [
            GridItem(spacing: 20),
            GridItem(spacing: 20),
            GridItem(spacing: 0)
        ], spacing: 20) {
            ZStack {
                if (userModel.user?.isVIP ?? false) {
                    Button(action: {
                        isActionSheetOrganisationPresented.toggle()
                    }) {
                        Text("Organisation").menuItemStyle(width: geometry.size.width/3 - 40 - 20, height: (geometry.size.height * 0.55)/3 - 60, lineLimit: 1)
                    }.actionSheet(isPresented: $isActionSheetOrganisationPresented) {
                        ActionSheet(
                            title: Text("Was willst du sehen?"),
                            buttons: [
                                .default(Text("Ablaufplan")) {
                                    navigationTimeLineIsActive.toggle()
                                },
                                .default(Text("Gästeliste")) {
                                    navigationGuestListIsActive.toggle()
                                },
                                .cancel(Text("Abbrechen"))
                            ]
                        )
                    }
                } else {
                    if isPremium {
                        NavigationLink(destination: TimeLineView(parentGeometry: geometry)) {
                            Text("Ablaufplan").menuItemStyle(width: geometry.size.width/3 - 40 - 20, height: (geometry.size.height * 0.55)/3 - 60,lineLimit: 1)
                        }
                    }
                    else {
                        Text("Ablaufplan").menuItemStyle(width: geometry.size.width/3 - 40 - 20, height: (geometry.size.height * 0.55)/3 - 60,lineLimit: 1)
                    }
                }
                LockedView(isVIP: Binding<Bool>(
                    get: { userModel.user?.isVIP ?? false },
                    set: { _ in }
                ), isPurchased: $isPremium)
            }.onTapGesture {
                tryToPurchasePremium()
            }
            
            ZStack {
                if (userModel.user?.isVIP ?? false) || isPremium {
                    NavigationLink(destination: InspirationView(parentGeometry: geometry)) {
                        Text("Inspiration").menuItemStyle(width: geometry.size.width/3 - 40 - 20, height: (geometry.size.height * 0.55)/3 - 60,lineLimit: 1)
                    }
                } else {
                    Text("Inspiration").menuItemStyle(width: geometry.size.width/3 - 40 - 20, height: (geometry.size.height * 0.55)/3 - 60,lineLimit: 1)
                }
                LockedView(isVIP: Binding<Bool>(
                    get: { userModel.user?.isVIP ?? false },
                    set: { _ in }
                ), isPurchased: $isPremium)
            }.onTapGesture {
                tryToPurchasePremium()
            }
            
            ZStack {
                if (userModel.user?.isVIP ?? false) {
                    NavigationLink(destination: ServiceProviderView(parentGeometry: geometry)) {
                        Text("Dienstleister")
                            .menuItemStyle(width: geometry.size.width/3 - 40 - 20, height: (geometry.size.height * 0.55)/3 - 60, lineLimit: 2)
                    }
                } else {
                    if isPremium {
                        NavigationLink(destination: GuestListView(parentGeometry: geometry)) {
                            Text("Gästeliste")
                                .menuItemStyle(width: geometry.size.width/3 - 40 - 20, height: (geometry.size.height * 0.55)/3 - 60, lineLimit: 2)
                        }
                    } else {
                        Text("Gästeliste").menuItemStyle(width: geometry.size.width/3 - 40 - 20, height: (geometry.size.height * 0.55)/3 - 60, lineLimit: 2)
                    }
                }
                LockedView(isVIP: Binding<Bool>(
                    get: { userModel.user?.isVIP ?? false },
                    set: { _ in }
                ), isPurchased: $isPremium)
            }.onTapGesture {
                tryToPurchasePremium()
            }
            
            ZStack {
                if (userModel.user?.isVIP ?? false) || isPremium {
                    NavigationLink(destination: WitnessesView(parentGeometry: geometry)) {
                        Text("Trauzeugen").menuItemStyle(width: geometry.size.width/3 - 40 - 20, height: (geometry.size.height * 0.55)/3 - 60,lineLimit: 2)
                    }
                } else {
                    Text("Trauzeugen").menuItemStyle(width: geometry.size.width/3 - 40 - 20, height: (geometry.size.height * 0.55)/3 - 60,lineLimit: 1)
                }
                LockedView(isVIP: Binding<Bool>(
                    get: { userModel.user?.isVIP ?? false },
                    set: { _ in }
                ), isPurchased: $isPremium)
            }.onTapGesture {
                tryToPurchasePremium()
            }
            
            ZStack {
                if ((userModel.user?.isVIP ?? true)) || isPremium {
                    Button(action: {
                        isActionSheetGadgetPresented.toggle()
                    }) {
                        Text("Gadgets").menuItemStyle(width: geometry.size.width/3 - 40 - 20, height: (geometry.size.height * 0.55)/3 - 60,lineLimit: 2)
                    }.actionSheet(isPresented: $isActionSheetGadgetPresented) {
                        ActionSheet(
                            title: Text("Was willst du sehen?"),
                            buttons: [
                                .default(Text("Musik")) {
                                    openURL(url: "https://open.spotify.com/playlist/7gE8BHDO6NPXLggzaGaNGn?si=3TkzdCZbT42yu6uP7yYFgg&pi=e-mrO0m7z5RpaB")
                                },
                                .default(Text("Location")) {
                                    openURL(url: "https://guides.apple.com/?ug=Ch1XZWRkaW5nIExvY2F0aW9ucyAtIEtXSUNLU0hPVBJbGjdIb2YgTmV1YmF1IDEsIElubmVuc3RhZHQsIDg4MjEyIFJhdmVuc2J1cmcsIERldXRzY2hsYW5kIhIJdufkoN%2FhR0ARHV0AdV5GI0AqDEhvZiBOZXViYXUgMRIOCNkyEM%2B%2F58%2FdmqClpAESDgiuTRDdiZHV2KPcyJMBEg0Irk0Q8a7tpo2pwblrEg0Irk0Qy4zSm8vxq60qEmkaPFN0LU1vcml0ei1TdHJhw59lIDMsIEJsaWVuc2hvZmVuLCA4OTU4NCBFaGluZ2VuLCBEZXV0c2NobGFuZCISCYknu5nRJ0hAEcTCWsaXhiNAKhVCbGllbnNob2ZlciBGZXN0c3RhZGwSDQjZMhC0xvP67sGxhFASchpAR3LDvG5ld2FsZGVyIFN0cmHDn2UgMjksIEjDtmhzY2hlaWQsIDQyNjU3IFNvbGluZ2VuLCBEZXV0c2NobGFuZCISCV6F71jHlElAEVJ95xclUBxAKhpNYXNjaGluZW5oYWxsZSBJdHRlbmhhdXNlbhINCK5NEKq%2Bz%2BiI28mRERJfGjZTdGVpZ2UgMTEsIFdhbHBlcnRzaG9mZW4sIDg4NDg3IE1pZXRpbmdlbiwgRGV1dHNjaGxhbmQiEglQOLu1TBhIQBH3fv7WqdkjQCoRUGFydHlzdGFkbCBBbmdlbGUSDQiuTRDX4MHBy42Xn1oSDgiuTRDy5tbOxZrfsMgBElkaMlRhbHN0cmHDn2UgMjUsIDg4NDI3IEJhZCBTY2h1c3NlbnJpZWQsIERldXRzY2hsYW5kIhIJe4kMBjIDSEARPCqjNhY9I0AqD0FpbGluZ2VyIE3DvGhsZRIOCK5NEPXjk97P4NGNrgESDgiuTRD4iKbT0I%2B%2B8ZABEg4Irk0Q8NDMqZmntPe7ARJ3GkJEw7xybWVudGluZ2VyIFN0cmHDn2UgNiwgSGV1ZG9yZiwgODg1MjUgRMO8cm1lbnRpbmdlbiwgRGV1dHNjaGxhbmQiEgn%2BvW%2FXphBIQBH%2B%2BteoPQcjQCodRG9yZmdlbWVpbnNjaGFmdHNoYXVzIEhldWRvcmYSDgiuTRDqmZOXvKmPkNkBElsaMERhaW1sZXJzdHJhw59lIDE3LCA3MzYzNSBSdWRlcnNiZXJnLCBEZXV0c2NobGFuZCISCdC%2FE2nRcUhAEQaeew%2BXFCNAKhNBQ0hUV0VSSyBFdmVudCBHbWJIEg0Irk0Qg7fm6J6zssUSEg4Irk0Qwd2w4%2Fv2kr%2FmARINCK5NEIPXwu6hscWlZBINCK5NEKKRqM%2Bz%2Fb3ZGxINCK5NEMr%2F2OGdy9qSaxIOCK5NEM31voXhg8mrtgE%3D")
                                },
                                .default(Text("Sonstiges")) {
                                    openURL(url: "https://www.amazon.de/hz/wishlist/ls/5OINKSOYZB9K?ref_=wl_share")
                                },
                                .cancel(Text("Abbrechen"))
                            ]
                        )
                    }
                }
                else {
                    Text("Gadgets").menuItemStyle(width: geometry.size.width/3 - 40 - 20, height: (geometry.size.height * 0.55)/3 - 60,lineLimit: 2)
                }
                LockedView(isVIP: Binding<Bool>(
                    get: { userModel.user?.isVIP ?? false },
                    set: { _ in }
                ), isPurchased: $isPremium)
            }
            .onTapGesture {
                tryToPurchasePremium()
            }
            
            ZStack {
                if (userModel.user?.isVIP ?? false) || isPremium {
                    NavigationLink(destination: NiceToKnowView(parentGeometry: geometry)) {
                        Text("Nice to know").menuItemStyle(width: geometry.size.width/3 - 40 - 20, height: (geometry.size.height * 0.55)/3 - 60, lineLimit: 2)
                    }
                } else {
                    Text("Nice to know").menuItemStyle(width: geometry.size.width/3 - 40 - 20, height: (geometry.size.height * 0.55)/3 - 60, lineLimit: 2)
                }
                LockedView(isVIP: Binding<Bool>(
                    get: { userModel.user?.isVIP ?? false },
                    set: { _ in }
                ), isPurchased: $isPremium)
            }
            .onTapGesture {
                tryToPurchasePremium()
            }
            
            NavigationLink(destination: GettingReadyView(parentGeometry: geometry)) {
                Text("Getting Ready").menuItemStyle(width: geometry.size.width/3 - 40 - 20, height: (geometry.size.height * 0.55)/3 - 60,lineLimit: 2)
            }
            
            NavigationLink(destination: NoGosView(parentGeometry: geometry)) {
                Text("No-Go's").menuItemStyle(width: geometry.size.width/3 - 40 - 20, height: (geometry.size.height * 0.55)/3 - 60,lineLimit: 1)
            }
            
            NavigationLink(destination: InfoForPhotographView(parentGeometry: geometry)) {
                Text("Infos für Fotografen").menuItemStyle(width: geometry.size.width/3 - 40 - 20, height: (geometry.size.height * 0.55)/3 - 60,lineLimit: 2)
            }
            
            NavigationLink(isActive: $navigationTimeLineIsActive, destination: { TimeLineView(parentGeometry: geometry) }, label: {
                EmptyView()
            })
            
            NavigationLink(isActive: $navigationGuestListIsActive, destination: { GuestListView(parentGeometry: geometry) }, label: {
                EmptyView()
            })
        }
        .frame(width: geometry.size.width - geometry.size.height * 0.03, height: geometry.size.height * 0.55 - geometry.size.height * 0.015)
        .padding(.horizontal, geometry.size.height * 0.015)
        .padding(.top, geometry.size.height * 0.015)
    }
    
    func isUserVIP() -> Bool {
        if let user = userModel.user {
            return user.isVIP
        } else {
            return false
        }
    }
    
    func tryToPurchasePremium() {
        Task {
            print("Anzahl der Produkte:", storeKitManager.storeProducts.count)
            // Get product of storeProducts by display name.
            if let product = storeKitManager.storeProducts.first(where: { $0.id == "Gekauft_ID" }) {
                try await storeKitManager.purchase(product)
            } else {
                print("Product not found")
            }
        }
    }
}

struct LockedView: View {
    @Binding var isVIP: Bool
    @Binding var isPurchased: Bool
    
    var body: some View {
        if !isPurchased && !isVIP {
            Image(systemName: "lock.fill")
                .foregroundColor(Color(hex: 0xB8C7B9))
                .font(.system(size: 24))
        } else {
            EmptyView()
        }
    }
}

struct HamburgerMenu: View {
    @State private var isProfileViewVisible = false
    var parentGeometry: GeometryProxy // Add this
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color(hex: 0x425C54))
            NavigationLink(destination: ProfileView(parentGeometry: parentGeometry)
            ) {
                Image(systemName: "line.horizontal.3")
                    .font(.title)
                    .foregroundColor(Color.white)
            }
        }
    }
    
    func goBack() {
        isProfileViewVisible = false
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserViewModel())
            .environmentObject(StoreKitManager())
    }
}
