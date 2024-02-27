import SwiftUI

struct TypingAnimationView: View {
    let text: String
    let completion: () -> Void

    @State private var visibleText = ""
    @State private var opacity: Double = 0.0

    var body: some View {
        Text(visibleText)
            .font(.custom("Lustria-Regular", size: 45))
            .foregroundColor(.black)
            .padding()
            .minimumScaleFactor(0.5)
            .lineLimit(1)
            .opacity(opacity)
            .onAppear {
                animateText()
            }
    }

    private func animateText() {
            var currentIndex = text.startIndex
            let animationDuration = 0.08

            func updateText() {
                visibleText = String(text.prefix(upTo: currentIndex))
            }

            Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { timer in
                currentIndex = text.index(after: currentIndex)
                updateText()

                withAnimation(.easeIn) {
                    opacity = 1.0
                }

                if currentIndex == text.endIndex {
                    timer.invalidate()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation {
                            opacity = 0.0
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            completion()
                        }
                    }
                }
            }
        }
}

struct TypingAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        TypingAnimationView(text: "Willkommen") {
            // Handle completion if needed
        }
    }
}
