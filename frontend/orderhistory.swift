import SwiftUI

struct UserOrdersView: View {
    let userID: Int

    @State private var orders: [Order] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var expandedOrderIDs: Set<Int> = []

    // MARK: - Order Model
    struct Order: Identifiable, Decodable {
        let id: Int
        let product_name: String
        let quantity: Int
        let total_price: Double

        enum CodingKeys: String, CodingKey {
            case id = "order_id"
            case product_name
            case quantity
            case total_price
        }
    }

    // MARK: - Order Response
    struct OrderResponse: Decodable {
        let status: String
        let message: String?
        let orders: [Order]
    }

    // MARK: - View
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if isLoading {
                    ProgressView("Loading Orders...")
                        .padding()
                } else if let error = errorMessage {
                    Text("❌ \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if orders.isEmpty {
                    Text("📭 No orders found.")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(orders) { order in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Order #\(order.id)")
                                    .font(.headline)

                                Spacer()

                                Button(action: {
                                    toggleOrderExpansion(order.id)
                                }) {
                                    Image(systemName: expandedOrderIDs.contains(order.id) ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.blue)
                                }
                            }

                            if expandedOrderIDs.contains(order.id) {
                                Divider()
                                Text("🦷 Product: \(order.product_name)")
                                Text("📦 Quantity: \(order.quantity)")
                                Text("💰 Total: ₹\(String(format: "%.2f", order.total_price))")
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
        .navigationTitle("My Orders")
        .onAppear {
            fetchOrders()
        }
    }

    // MARK: - Toggle Expand/Collapse
    private func toggleOrderExpansion(_ orderId: Int) {
        if expandedOrderIDs.contains(orderId) {
            expandedOrderIDs.remove(orderId)
        } else {
            expandedOrderIDs.insert(orderId)
        }
    }

    // MARK: - Fetch Orders
    private func fetchOrders() {
        guard let url = URL(string: ServiceAPI.ordersHistory(for: userID)) else {
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
                    let decoded = try JSONDecoder().decode(OrderResponse.self, from: data)
                    if decoded.status == "success" {
                        self.orders = decoded.orders
                    } else {
                        errorMessage = decoded.message ?? "Failed to load orders."
                    }
                } catch {
                    errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
