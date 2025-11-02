import SwiftUI

// MARK: - CartItem Model
struct CartItem: Identifiable, Codable {
    var id: Int { productId }
    let productId: Int
    let productName: String
    let productImageUrl: String
    let quantity: Int
    let price: Double

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case productName = "product_name"
        case productImageUrl = "product_image_url"
        case quantity, price
    }
}

// MARK: - API Response
struct CartResponse: Codable {
    let status: String
    let data: [CartItem]?
    let message: String?
}

// MARK: - CartView
struct CartView: View {
    @AppStorage("user_id") private var userId: Int = 0

    @State private var cartItems: [CartItem] = []
    @State private var isLoading = true
    @State private var errorMessage = ""

    var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    var body: some View {
        VStack {
            if userId == 0 {
                Text("Please log in to view your cart.")
                    .foregroundColor(.gray)
                    .padding()
            } else if isLoading {
                ProgressView("Loading cart...")
            } else if !errorMessage.isEmpty {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else if cartItems.isEmpty {
                Text("Your cart is empty.")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(cartItems) { item in
                        HStack(spacing: 16) {
                            if let imageUrl = URL(string: item.productImageUrl) {
                                AsyncImage(url: imageUrl) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 100, height: 100)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(12)
                                    case .failure:
                                        Image(systemName: "photo.fill")
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .foregroundColor(.red)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.productName)
                                    .font(.headline)
                                Text("Qty: \(item.quantity)")
                                    .font(.subheadline)
                                Text("₹\(item.price, specifier: "%.2f") each")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            VStack {
                                Text("₹\(item.price * Double(item.quantity), specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)

                                Button(action: {
                                    deleteCartItem(for: item)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding(.vertical, 8)
                    }

                    Section {
                        HStack {
                            Text("Total")
                                .font(.headline)
                            Spacer()
                            Text("₹\(totalPrice, specifier: "%.2f")")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                    }
                }
                .listStyle(.plain)

                NavigationLink(destination: CheckoutView(cartItems: cartItems)) {
                    Text("Checkout")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .padding(.bottom)
            }
        }
        .padding(.top)
        .navigationTitle("My Cart")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadCart)
    }

    // MARK: - Load Cart
    private func loadCart() {
        guard userId > 0 else {
            errorMessage = "Invalid user ID"
            isLoading = false
            return
        }

        guard let url = URL(string: "\(ServiceAPI.cart)?user_id=\(userId)") else {
            errorMessage = "Invalid cart URL"
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    errorMessage = "No data received"
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(CartResponse.self, from: data)
                    if decoded.status == "success", let items = decoded.data {
                        self.cartItems = items
                    } else {
                        errorMessage = decoded.message ?? "Failed to load cart"
                    }
                } catch {
                    errorMessage = "Parse error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    // MARK: - Delete Cart Item
    private func deleteCartItem(for item: CartItem) {
        guard let url = URL(string: ServiceAPI.deleteFromCart) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = "user_id=\(userId)&product_id=\(item.productId)"
        request.httpBody = body.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Delete error: \(error.localizedDescription)"
                    return
                }

                self.cartItems.removeAll { $0.productId == item.productId }
            }
        }.resume()
    }
}
