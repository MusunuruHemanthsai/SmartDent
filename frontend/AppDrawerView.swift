import SwiftUI

struct AppDrawerView: View {
    @Binding var isLoggedIn: Bool
    @Binding var navigateToServices: Bool
    @Binding var isShowingAppDrawer: Bool // <--- Add this binding
    @State private var showingLogoutAlert = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Menu")
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue)
                .foregroundColor(.white)

            List {
                // Wrap in NavigationLink and add dismissal logic
                NavigationLink(destination: Text("Home View")) { // Replace Text("Home View") with your actual Home destination
                    Label("Home", systemImage: "house.fill")
                }
                .onTapGesture {
                    isShowingAppDrawer = false // Dismiss drawer when Home is tapped
                }

                NavigationLink(destination: Text("Profile View")) { // Replace Text("Profile View") with your actual Profile destination
                    Label("Profile", systemImage: "person.fill")
                }
                .onTapGesture {
                    isShowingAppDrawer = false // Dismiss drawer when Profile is tapped
                }

                Button {
                    navigateToServices = true
                    isShowingAppDrawer = false // Dismiss the drawer after action
                } label: {
                    Label("Services", systemImage: "lightbulb.fill")
                }

                Button {
                    showingLogoutAlert = true
                } label: {
                    Label("Logout", systemImage: "arrow.left.square.fill")
                        .foregroundColor(.red)
                }
            }

            Spacer()
        }
        .alert("Logout Confirmation", isPresented: $showingLogoutAlert) {
            Button("Logout", role: .destructive) {
                isLoggedIn = false
                isShowingAppDrawer = false // Dismiss the drawer after logout
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to logout?")
        }
    }
}

// You will likely need a preview provider if this is in its own file
#Preview {
    // These bindings are just for the preview
    AppDrawerView(isLoggedIn: .constant(true), navigateToServices: .constant(false), isShowingAppDrawer: .constant(true))
}
