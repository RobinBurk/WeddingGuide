import SwiftUI

struct HomeView: View {
    @State private var isActionSheetPresented = false
    
    let menuItems = ["Ablaufplan", "Inspiration", "Dienstleister", "Trauzeugen", "Gadgets", "Nice to know", "Getting Ready", "No-Go's", "Infos für Fotografen"]
    
    var body: some View {
        ZStack {
            BackgroundImageView()
            
            VStack(spacing: 20) {
                
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .foregroundColor(Color(hex: 0x425C54))
                            .frame(width: 40, height: 40)
                        
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "line.horizontal.3")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .padding()
                        }
                    }
                    .padding(.top, -60)
                }
                
                CountDownView().fixedSize(horizontal: false, vertical: true)
                    .padding(.top, -20)
                BudgetView().padding(10)
                
                LazyVGrid(columns: [
                    GridItem(.fixed(100), spacing: 20),
                    GridItem(.fixed(100), spacing: 20),
                    GridItem(.fixed(100), spacing: 0)
                ], spacing: 20) {
                    NavigationLink(destination: TimeLineView(text: menuItems[0])) {
                        Text(menuItems[0]).menuItemStyle(lineLimit: 1)
                    }
                    
                    NavigationLink(destination: InspirationView(text: menuItems[1])) {
                        Text(menuItems[1]).menuItemStyle(lineLimit: 1)
                    }
                    
                    NavigationLink(destination: ServiceProviderView(text: menuItems[2])) {
                        Text(menuItems[2]).menuItemStyle(lineLimit: 2)
                    }
                    
                    NavigationLink(destination: WitnessesView(text: menuItems[3])) {
                        Text(menuItems[3]).menuItemStyle(lineLimit: 2)
                    }
                    
                    Text(menuItems[4]).menuItemStyle(lineLimit: 2).onTapGesture {
                        isActionSheetPresented.toggle()
                    }
                    
                    NavigationLink(destination: NiceToKnowView(text: menuItems[5])) {
                        Text(menuItems[5]).menuItemStyle(lineLimit: 1)
                    }
                    
                    NavigationLink(destination: PreparationView(text: menuItems[6])) {
                        Text(menuItems[6]).menuItemStyle(lineLimit: 2)
                    }
                    
                    NavigationLink(destination: NoGosView(text: menuItems[7])) {
                        Text(menuItems[7]).menuItemStyle(lineLimit: 1)
                    }
                    
                    NavigationLink(destination: InfoForPhotographView(text: menuItems[8])) {
                        Text(menuItems[8]).menuItemStyle(lineLimit: 2)
                    }
                }
            }
            .padding(.horizontal, 40)
        }
        .actionSheet(isPresented: $isActionSheetPresented) {
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
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserViewModel())
    }
}
