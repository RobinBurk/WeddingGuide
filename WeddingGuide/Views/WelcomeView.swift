import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var userModel : UserViewModel
    
    @State private var goToPreHome = false
    
    var body: some View {
        NavigationView {
            if (!(userModel.user?.hasFinishedWelcome ?? false)) {
                ZStack {
                    BackgroundImageView()
                    if (!goToPreHome) {
                        TypingAnimationView(text: "Willkommen \(userModel.user?.firstName ?? "tempFirstName") 👋🏻") {
                            goToPreHome = true
                        }
                    } else {
                        PreHomeView()
                            .preferredColorScheme(.light)
                            .navigationBarBackButtonHidden(true)
                    }
                }
            } else {
                HomeView()
                    .preferredColorScheme(.light)
                    .navigationBarBackButtonHidden(true)
            }
        }
        .onTapGesture {
            // Dismiss the keyboard when tapped outside the text fields
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
