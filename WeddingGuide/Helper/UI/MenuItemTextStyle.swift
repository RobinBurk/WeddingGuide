import SwiftUI

struct MenuItemTextStyle: ViewModifier {
    var lineLimit: Int
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Lustria-Regular", size: 14))
            .frame(width: 70, height: 60)
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
    func menuItemStyle(lineLimit: Int) -> some View {
        self.modifier(MenuItemTextStyle(lineLimit: lineLimit))
    }
}
