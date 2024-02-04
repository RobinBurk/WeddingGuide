import SwiftUI

struct SwipeToDismiss: ViewModifier {
    @Environment(\.presentationMode) var presentationMode
    @GestureState private var dragOffset = CGSize.zero
    @State private var dismissAnimation = false

    func body(content: Content) -> some View {
         content
             .gesture(dragToDismissGesture)
     }

     private var dragToDismissGesture: some Gesture {
         DragGesture()
             .updating($dragOffset) { drag, state, _ in
                 state = drag.translation
             }
             .onEnded { drag in
                 let horizontalDrag = drag.translation.width
                 if horizontalDrag > 50 {
                     dismissAnimation = true
                     self.goBack()
                 } else {
                     dismissAnimation = false
                 }
             }
     }

     private func goBack() {
         presentationMode.wrappedValue.dismiss()
     }
}

extension View {
    func swipeToDismiss() -> some View {
        self.modifier(SwipeToDismiss())
    }
}
