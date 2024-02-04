import SwiftUI

struct CheckboxListView: View {
    @EnvironmentObject var userModel : UserViewModel
    let items: [String]
    @Binding var checkboxStates: [Bool]
    let onChange: () -> Void
    
    var body: some View {
        ForEach(items.indices, id: \.self) { index in
            CheckboxView(title: items[index], isChecked: binding(for: index))
        }
        .onAppear {
            // Check if checkboxStates has enough elements
            if checkboxStates.count < items.count {
                // Calculate the number of additional elements needed
                let additionalElements = items.count - checkboxStates.count
                // Fill the binding array with false values
                checkboxStates.append(contentsOf: Array(repeating: false, count: additionalElements))
            }
        }
    }
    
    private func binding(for index: Int) -> Binding<Bool> {
           Binding(
               get: {
                   checkboxStates[index]
               },
               set: { newValue in
                   checkboxStates[index] = newValue
                   onChange() // Trigger the callback
               }
           )
       }
}
