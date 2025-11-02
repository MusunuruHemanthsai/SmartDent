import SwiftUI

class AppState: ObservableObject {
    @Published var currentScreen: Screen = .welcome

    enum Screen {
        case welcome
        case selection
        case main
    }
}
