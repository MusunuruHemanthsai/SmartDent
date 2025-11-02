import SwiftUI

struct AdminHomeView: View {
    @Binding var isLoggedIn: Bool
    @Binding var isAdmin: Bool

    @State private var selectedPage: AdminPage? = nil

    enum AdminPage: Hashable {
        case manageProducts
        case services
        case manageOrders
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Removed title bar, logo now in toolbar

                // ✅ Scrollable Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Carousel
                        TabView {
                            Image("dentalequipment")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .padding(.horizontal)

                            Image("dentalequipment1")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .padding(.horizontal)
                        }
                        .frame(height: 300)
                        .tabViewStyle(PageTabViewStyle())

                        // Title
                        Text("ADMIN CONTROLS")
                            .font(.system(size: 23, weight: .bold))
                            .padding(.horizontal)

                        // Cards
                        VStack(spacing: 12) {
                            NavigationLink(destination: HomeView()) {
                                adminCard(
                                    imageName: "manageproducts",
                                    title: "MANAGE PRODUCTS",
                                    subtitle: "Add, edit, or remove products."
                                )
                            }

                            NavigationLink(destination: ServiceRequestsView()) {
                                adminCard(
                                    imageName: "serviceicon",
                                    title: "SERVICES",
                                    subtitle: "Product service"
                                )
                            }

                            NavigationLink(destination: ManageOrdersView()) {
                                adminCard(
                                    imageName: "manageorders",
                                    title: "MANAGE ORDERS",
                                    subtitle: "Process and track orders."
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // ✅ Centered Logo in NavigationBar
                ToolbarItem(placement: .principal) {
                    Image("a")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                }

                // Menu button
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("Manage Products") {
                            selectedPage = .manageProducts
                        }
                        Button("Services") {
                            selectedPage = .services
                        }
                        Button("Manage Orders") {
                            selectedPage = .manageOrders
                        }
                        Button("Logout", role: .destructive) {
                            logout()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .imageScale(.large)
                    }
                }
            }
            // Background Navigation Links
            .background(
                Group {
                    NavigationLink("", destination: HomeView(), tag: .manageProducts, selection: $selectedPage).hidden()
                    NavigationLink("", destination: ServiceRequestsView(), tag: .services, selection: $selectedPage).hidden()
                    NavigationLink("", destination: ManageOrdersView(), tag: .manageOrders, selection: $selectedPage).hidden()
                }
            )
        }
    }

    // MARK: - Card UI
    func adminCard(imageName: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    // MARK: - Logout Logic
    func logout() {
        isLoggedIn = false
        isAdmin = false
    }
}
