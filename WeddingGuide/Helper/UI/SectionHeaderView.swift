import SwiftUI

struct SectionHeaderView: View {
        var title: String
        @Binding var isExpanded: Bool

        var body: some View {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Text(title)
                    .padding()
                    .font(.custom("Lustria-Regular", size: isExpanded ? 18 : 16))
                    .frame(maxWidth: .infinity)
                    .background(isExpanded ? Color(hex: 0xB8C7B9) : Color(hex: 0x425C54))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
    }

struct SectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderView(title: "Test", isExpanded: .constant(false))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
