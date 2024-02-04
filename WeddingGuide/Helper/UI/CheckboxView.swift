import SwiftUI

struct CheckboxView: View {
    var title: String
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            HStack {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(isChecked ? Color(hex: 0x425C54) : .gray)
                
                Text(title)
                    .foregroundColor(isChecked ? Color(hex: 0x425C54) : .black)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

struct CheckboxView_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxView(title: "test", isChecked: .constant(true))
    }
}
