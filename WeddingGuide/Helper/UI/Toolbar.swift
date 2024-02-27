import SwiftUI

struct Toolbar: View {
    @Binding var presentationMode: PresentationMode
    var parentGeometry: GeometryProxy
    var title: String
    
    var body: some View {
        HStack {
            Button(action: {
                presentationMode.dismiss()
            }) {
                Text("←")
                    .foregroundColor(.white)
                    .font(Font.custom("Lustria-Regular", size: parentGeometry.size.height * 0.025))
            }
            
            Spacer()
            
            Text(title)
                .font(.custom("Lustria-Regular", size: parentGeometry.size.height * 0.02))
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}
