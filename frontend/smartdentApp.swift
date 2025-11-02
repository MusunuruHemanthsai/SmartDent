import SwiftUI

@main
struct SmartDentApp: App {
    // Persisted login status and role
    @AppStorage("is_logged_in") private var isLoggedIn = false
    @AppStorage("is_admin") private var isAdmin = false

    // Show user/admin selector after welcome screen
    @State private var showUserAdminSelection = false

    var body: some Scene {
        WindowGroup {     
            Group {
                if showUserAdminSelection {
  
                    if isLoggedIn {
                        if isAdmin {
                            AdminHomeView(isLoggedIn: $isLoggedIn, isAdmin: $isAdmin)
                        } else {
                            HomePageView(isLoggedIn: $isLoggedIn) // ✅ Updated name here
                        }
                    } else {
                        UserAdminSelectionView(isLoggedIn: $isLoggedIn, isAdmin: $isAdmin)
                    }
                } else {
                    WelcomeView(showUserAdminSelection: $showUserAdminSelection)
                }
            }
        }
    }
}
