import SwiftUI

struct StockItem: Identifiable, Codable {
    let id: Int
    let name: String
    let image: String
    let price: Double
    var stock: Int
}

struct StockResponse: Codable {
    let status: String
    let message: String?
    let products: [StockItem]?
}

struct ManageStockView: View {
    @State private var products: [StockItem] = []
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var updateStatus: [Int: String] = [:]

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach($products) { $product in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack(alignment: .top, spacing: 12) {
                                        AsyncImage(url: URL(string: product.image)) { phase in
                                            if let image = phase.image {
                                                image.resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 60, height: 60)
                                                    .cornerRadius(8)
                                            } else {
                                                Rectangle()
                                                    .fill(Color.gray.opacity(0.3))
                                                    .frame(width: 60, height: 60)
                                                    .overlay(Text("No Image").font(.caption))
                                            }
                                        }

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(product.name)
                                                .font(.headline)
                                            Text("₹\(String(format: "%.2f", product.price))")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }

                                        Spacer()

                                        VStack(spacing: 6) {
                                            TextField("Stock", value: $product.stock, formatter: NumberFormatter())
                                                .keyboardType(.numberPad)
                                                .frame(width: 60)
                                                .padding(6)
                                                .background(Color(.secondarySystemBackground))
                                                .cornerRadius(6)
                                                .multilineTextAlignment(.center)

                                            Button("Update") {
                                                updateStock(for: product)
                                            }
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 8)
                                            .background(Color.blue)
                                            .cornerRadius(5)
                                        }
                                    }

                                    if let status = updateStatus[product.id] {
                                        Text(status)
                                            .font(.footnote)
                                            .foregroundColor(.green)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Manage Stock")
            .onAppear {
                fetchProducts()
            }
        }
    }

    func fetchProducts() {
        guard let url = URL(string: "http://localhost/smartdent1/stock.php") else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = ""

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "Failed to load: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received"
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(StockResponse.self, from: data)
                if decoded.status == "success", let products = decoded.products {
                    DispatchQueue.main.async {
                        self.products = products
                    }
                } else {
                    DispatchQueue.main.async {
                        errorMessage = decoded.message ?? "Failed to load products"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    func updateStock(for product: StockItem) {
        guard let url = URL(string: "http://localhost/smartdent1/managestock.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "id=\(product.id)&stock=\(product.stock)"
        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    updateStatus[product.id] = "Update failed: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    updateStatus[product.id] = "No server response"
                    return
                }

                if let decoded = try? JSONDecoder().decode(StockResponse.self, from: data) {
                    updateStatus[product.id] = decoded.message ?? "Updated successfully"
                } else {
                    updateStatus[product.id] = "Invalid response"
                }
            }
        }.resume()
    }
}
