import SDWebImageSwiftUI
import SwiftUI

struct BigImageView: View {
    @EnvironmentObject var dataManager : DataManager
    
    @State var animateCircle: Bool = false
    @Binding var selectedImage: String?
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.8)
                .ignoresSafeArea(.all)
            WebImage(url: URL(string: selectedImage ?? ""))
                .resizable()
                .scaledToFill()
                .frame(maxWidth: UIScreen.main.bounds.width - 60, maxHeight: UIScreen.main.bounds.height - 60)
                .clipped()
                .cornerRadius(20)
                .overlay(alignment: .bottom) {
                    HStack {
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 5)
                            Circle()
                                .trim(from: 0.0, to: animateCircle ? 1.0: 0.0)
                                .stroke(Color.green, lineWidth: 5)
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut(duration: 2.0), value: animateCircle)
                            Button{
                                animateCircle.toggle()
                                dataManager.downloadAndSaveImage(url: selectedImage ?? "")
                            } label: {
                                Image(systemName: animateCircle ? "checkmark" : "arrow.down.to.line")
                                    .font(.title3)
                                    .foregroundColor(animateCircle ? .green : .white.opacity(0.7))
                                    .padding(6)
                                    .background(.black.opacity(0.7))
                                    .clipShape(Circle())
                            }
                        } 
                        .frame (width: 35, height: 35)
                        .padding(.bottom)
                        .padding(.horizontal)
                        Spacer()
                        
                        Button {
                            selectedImage = nil
                            animateCircle = false
                        } label : {
                            Image(systemName: "xmark")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.7))
                                .padding(6)
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .padding(.bottom)
                        .padding(.horizontal)
                    }
                }
        }
        .swipeToDismiss()
    }
}
