import SwiftUI

struct Toolbar: View {
    var text: String
    var backAction: () -> Void

    var body: some View {
        ZStack {
            Color(hex: 0x425C54)
                .frame(height: 90)
                .blur(radius: 0.5)
                .edgesIgnoringSafeArea(.top)
                .opacity(1)

            HStack {
                Button(action: {
                    backAction()
                }) {
                    Text("←")
                        .foregroundColor(.white)
                        .font(.custom("Lustria-Regular", size: 30))
                        .padding(.bottom)
                }
                
                Spacer() // Spacer hinzufügen, um den verfügbaren Platz zu zentrieren
            }
            .offset(y: -25)
            .padding(.horizontal)
            
            HStack {
                Text(text)
                    .fontWeight(.bold)
                    .font(.custom("Lustria-Regular", size: 22))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom)
                    .foregroundColor(.white)
            }
            .offset(y: -25)
            .padding(.horizontal)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct Toolbar_Previews: PreviewProvider {
    static var previews: some View {
        Toolbar(text: "Your Title", backAction: {})
            .previewLayout(.fixed(width: 375, height: 100)) // Adjust width and height as needed
            .background(Color.gray) // Set a background color for better visibility
    }
}
