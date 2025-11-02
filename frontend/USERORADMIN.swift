import SwiftUI

struct UserAdminSelectionView: View {
    @Binding var isLoggedIn: Bool
    @Binding var isAdmin: Bool

    @State private var navigateToUserLogin = false
    @State private var navigateToAdminLogin = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                Image("a")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)

                Button {
                    isAdmin = false
                    navigateToUserLogin = true
                } label: {
                    VStack(spacing: 10) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.black)
                        Text("USER")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }

                Text("OR")
                    .font(.headline)
                    .fontWeight(.bold)

                Button {
                    isAdmin = true
                    navigateToAdminLogin = true
                } label: {
                    VStack(spacing: 10) {
                        Image(systemName: "person.crop.rectangle.stack.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.black)
                        Text("ADMIN")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }

                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $navigateToUserLogin) {
                LoginScreenView(role: "user", isLoggedIn: $isLoggedIn, isAdmin: $isAdmin)
            }
            .navigationDestination(isPresented: $navigateToAdminLogin) {
                AdminLoginView(role: "admin", isLoggedIn: $isLoggedIn, isAdmin: $isAdmin)
            }
            .navigationBarHidden(true)
        }
    }
}
