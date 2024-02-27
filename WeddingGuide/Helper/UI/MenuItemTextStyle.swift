import SwiftUI

struct MenuItemTextStyle: ViewModifier {
    var width: CGFloat
    var height: CGFloat
    var lineLimit: Int
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Lustria-Regular", size: 14))
            .frame(width: width, height: height)
            .padding()
            .background(Color(hex: 0x425C54))
            .foregroundColor(.white)
            .lineLimit(lineLimit)
            .minimumScaleFactor(0.4)
            .multilineTextAlignment(.center)
            .cornerRadius(10)
            .shadow(radius: 8)
    }
}

extension View {
    func menuItemStyle(width: CGFloat, height: CGFloat, lineLimit: Int) -> some View {
        self.modifier(MenuItemTextStyle(width: width, height: height, lineLimit: lineLimit))
    }
}
