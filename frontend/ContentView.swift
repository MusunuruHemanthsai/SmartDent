import SwiftUI

struct MainAppView: View {
    @AppStorage("is_logged_in") private var isLoggedIn = false
    @AppStorage("is_admin") private var isAdmin = false

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                if isAdmin {
                    AdminHomeView(isLoggedIn: .constant(isLoggedIn), isAdmin: .constant(isAdmin))
                } else {
                    HomePageView(isLoggedIn: .constant(isLoggedIn))
                }
            } else {
                UserAdminSelectionView(isLoggedIn: .constant(isLoggedIn), isAdmin: .constant(isAdmin))
            }
        }
    }
}

#Preview {
    MainAppView()
}
