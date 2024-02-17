import SwiftUI
var titleText: String {
    switch mode {
    case .add:
        return "Eintrag hinzufügen"
    case .edit:
        return "Eintrag bearbeiten"
    }
}
