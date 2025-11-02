import SwiftUI

// MARK: - Models
struct ProductItem: Codable {
    let productName: String
    let quantity: Int
}

struct Order1: Identifiable, Codable {
    let id: Int
    let userId: Int
    let address: String
    let totalPrice: Double
    let orderDate: String
    let products: [ProductItem]
}

struct ResponseData: Codable {
    let status: String
    let orders: [Order1]
}

// MARK: - View
struct ManageOrdersView: View {
    @State private var orders: [Order1] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading orders...")
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(orders) { order in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Order ID: \(order.id)")
                                        .font(.headline)
                                        .bold()
                                    Text("User ID: \(order.userId)")
                                    Text("Address: \(order.address)")
                                    Text("Total Price: ₹\(String(format: "%.2f", order.totalPrice))")
                                    Text("Order Date: \(order.orderDate)")
                                        .padding(.bottom, 4)

                                    // List of products
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Products:")
                                            .font(.subheadline)
                                            .bold()
                                        ForEach(order.products.indices, id: \.self) { index in
                                            let product = order.products[index]
                                            Text("- \(product.productName) x\(product.quantity)")
                                                .font(.subheadline)
                                        }
                                    }
                                    .padding(.top, 4)

                                    Button(action: {
                                        acceptOrder(orderId: order.id)
                                    }) {
                                        Text("Accept")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("Manage Orders")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: fetchOrders)
        }
    }

    private func fetchOrders() {
        guard let url = URL(string: "http://localhost/smartdent1/order_fetch.php") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    errorMessage = "No data received"
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(ResponseData.self, from: data)
                    if decoded.status == "success" {
                        orders = decoded.orders
                    } else {
                        errorMessage = "Failed to load orders"
                    }
                } catch {
                    errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    private func acceptOrder(orderId: Int) {
        guard let url = URL(string: "http://localhost/smartdent1/accept_order.php") else {
            errorMessage = "Invalid accept order URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "order_id=\(orderId)"
        request.httpBody = postString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = "Accept failed: \(error.localizedDescription)"
                    return
                }

                // Remove the accepted order from the list
                orders.removeAll { $0.id == orderId }
            }
        }.resume()
    }
}

// MARK: - Preview
struct ManageOrdersView_Previews: PreviewProvider {
    static var previews: some View {
        ManageOrdersView()
    }
}
