import SwiftUI

struct ChangeEmailPhotographView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    
    var parentGeometry: GeometryProxy
    
    @State private var newEmail = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer().frame(width: 60)
                TextField("Neue E-Mail für Fotografen", text: $newEmail)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.custom("Lustria-Regular", size: 18))
                    .padding()
                    .background(Color(hex: 0xB8C7B9))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .cornerRadius(10)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                Spacer().frame(width: 60)
            }
            
            Button(action: {
                changeEmailPhotograph()
            }) {
                HStack {
                    Image(systemName: "envelope.fill")
                    Text("E-Mail ändern")
                }
                .padding()
                .font(.custom("Lustria-Regular", size: 18))
                .background(Color(hex: 0x425C54))
                .foregroundColor(.white)
                .cornerRadius(10)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            }
            
            Spacer()
        } 
        .onAppear {
            if let emailPhotograph = userModel.user?.emailPhotograph {
                newEmail = emailPhotograph
            }
        }
        .onTapGesture {
            // Dismiss the keyboard when tapped outside the text fields.
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .swipeToDismiss()
        .padding(.top, 10)
        .navigationBarBackButtonHidden()
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Toolbar(presentationMode: presentationMode, parentGeometry: parentGeometry, title: "E-Mail Fotographen")
            }
        }
        .foregroundColor(.white)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(hex: 0x425C54), for: .navigationBar)
    }
    
    private func changeEmailPhotograph() {
        userModel.user?.emailPhotograph = newEmail
        userModel.update()
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
}
