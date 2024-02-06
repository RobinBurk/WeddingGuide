import SwiftUI
import Firebase
import Photos
import SDWebImageSwiftUI

struct InspirationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: DataManager
    
    @State var selectedImage: String? = nil
    
    @State private var isLoadingImages = false
    @State private var showAllImages1 : Bool = false
    @State private var showAllImages2 : Bool = false
    @State private var showAllImages3 : Bool = false
    @State private var showAllImages4 : Bool = false
    @State private var showAllImages5 : Bool = false
    
    var columns:[GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    InspirationCategoryView(categoryName: "Anzug", showAllImages: { showAllImages1 = true }, imageUrls: dataManager.imageUrlsAnzug, selectedImage: $selectedImage)
                    InspirationCategoryView(categoryName: "Hochzeitskleid", showAllImages: { showAllImages2 = true }, imageUrls: dataManager.imageUrlsHochzeitskleid, selectedImage: $selectedImage)
                    InspirationCategoryView(categoryName: "Brautstrauß", showAllImages: { showAllImages3 = true }, imageUrls: dataManager.imageUrlsBrautstrauss, selectedImage: $selectedImage)
                    InspirationCategoryView(categoryName: "Frisuren", showAllImages: { showAllImages4 = true }, imageUrls: dataManager.imageUrlsFrisuren, selectedImage: $selectedImage)
                    InspirationCategoryView(categoryName: "Dekoration", showAllImages: { showAllImages5 = true }, imageUrls: dataManager.imageUrlsDekoration, selectedImage: $selectedImage)
                }
                .padding(.top)
                .onAppear{
                    isLoadingImages = true
                    dataManager.loadImages(name: "images_anzug", appendAction: { url in
                        dataManager.imageUrlsAnzug.append(url)
                    }) { success, error in
                        if success {
                            dataManager.loadImages(name: "images_hochzeitskleid", appendAction: { url in
                                dataManager.imageUrlsHochzeitskleid.append(url)
                            }) { success, error in
                                if success {
                                    dataManager.loadImages(name: "images_brautstrauss", appendAction: { url in
                                        dataManager.imageUrlsBrautstrauss.append(url)
                                    }) { success, error in
                                        if success {
                                            dataManager.loadImages(name: "images_frisuren", appendAction: { url in
                                                dataManager.imageUrlsFrisuren.append(url)
                                            }) { success, error in
                                                if success {
                                                    dataManager.loadImages(name: "images_dekoration", appendAction: { url in
                                                        dataManager.imageUrlsDekoration.append(url)
                                                    }) { success, error in
                                                        if success {
                                                            
                                                        } else {
                                                            print("Error loading images: \(error)")
                                                        }
                                                    }
                                                } else {
                                                    print("Error loading images: \(error)")
                                                }
                                            }
                                        } else {
                                            print("Error loading images: \(error)")
                                        }
                                    }
                                } else {
                                    print("Error loading images: \(error)")
                                }
                            }
                        } else {
                            print("Error loading images: \(error)")
                        }
                    }
                }
                .fullScreenCover(isPresented: $showAllImages1){
                    AllImagesView(selectedImage: $selectedImage, images: dataManager.imageUrlsAnzug)
                }
                .fullScreenCover(isPresented: $showAllImages2){
                    AllImagesView(selectedImage: $selectedImage, images: dataManager.imageUrlsHochzeitskleid)
                }
                .fullScreenCover(isPresented: $showAllImages3){
                    AllImagesView(selectedImage: $selectedImage, images: dataManager.imageUrlsBrautstrauss)
                }
                .fullScreenCover(isPresented: $showAllImages4){
                    AllImagesView(selectedImage: $selectedImage, images: dataManager.imageUrlsFrisuren)
                }
                .fullScreenCover(isPresented: $showAllImages5){
                    AllImagesView(selectedImage: $selectedImage, images: dataManager.imageUrlsDekoration)
                }
                
                if selectedImage != nil {
                    BigImageView(selectedImage: $selectedImage).swipeToDismiss()
                }
            }
            .padding(.top, 35)
            .overlay {
                Toolbar(text: text, backAction: { self.goBack() })
            }
            .swipeToDismiss()
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button.
        .navigationBarHidden(true)
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct InspirationCategoryView: View {
    let categoryName: String
    let showAllImages: () -> Void
    let imageUrls: [String]
    @Binding var selectedImage: String?
    
    var body: some View {
        VStack {
            HStack {
                Text(categoryName)
                    .font(.custom("Lustria-Regular", size: 16))
                    .padding(.leading, 5)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                Spacer()
                Button {
                    showAllImages()
                } label: {
                    Text("Alle")
                        .foregroundColor(Color(hex: 0x425C54))
                        .font(.custom("Lustria-Regular", size: 16))
                }.padding(.trailing, 5)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(imageUrls.prefix(3), id: \.self) { url in
                        ImageViewUrl(url: url)
                            .onTapGesture {
                                selectedImage = url
                            }
                    }
                }.padding(.trailing, 5).padding(.leading, 5)
            }
        }
    }
}

struct ImageViewUrl : View {
    let url:String
    var body: some View {
        WebImage(url: URL(string: url))
            .resizable()
            .scaledToFill()
            .frame(width:160, height: 350)
            .cornerRadius(10)
    }
}

struct AllImagesView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedImage: String?
    
    let images : [String]
    var colums: [GridItem] = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]
    
    var body: some View {
        ZStack {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: colums, spacing: 10) {
                        ForEach(images, id: \.self) {url in
                            WebImage(url: URL(string:url))
                                .resizable()
                                .scaledToFill()
                                .frame(width:170, height: 350)
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedImage = url
                                }
                            
                        }
                        .offset(y: 50)
                    }
                }
                .overlay(alignment: .topTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(6)
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }.offset(x: -10, y: -5)
                }
                .padding(.horizontal, 15)
            }
            
            if selectedImage != nil {
                BigImageView(selectedImage: $selectedImage).swipeToDismiss()
            }
        }
        .swipeToDismiss()
    }
}

struct InspirationView_Previews: PreviewProvider {
    static var previews: some View {
        InspirationView(text: "Inspiration").environmentObject(DataManager())
    }
}
