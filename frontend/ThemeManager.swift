import UIKit

enum AppTheme {
    case light, dark, system

    static func apply(_ theme: AppTheme) {
        // Get the active window scene
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            return
        }

        switch theme {
        case .light:
            window.overrideUserInterfaceStyle = .light
        case .dark:
            window.overrideUserInterfaceStyle = .dark
        case .system:
            window.overrideUserInterfaceStyle = .unspecified
        }
    }
}
