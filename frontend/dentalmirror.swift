import SwiftUI

// MARK: - Models
struct Product: Codable {
    let id: Int
    let product_name: String
    let description: String
    let price: String
    let images: [String]
}

struct ProductResponse: Codable {
    let status: String
    let data: Product
}

// MARK: - View
struct DentalMirrorDetailView: View {
    let userId: Int

    @State private var product: Product?
    @State private var quantity = 1
    @State private var isLoading = true
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage: String?
    @State private var currentPage = 0

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading...")
                } else if let product = product {
                    ScrollView {
                        VStack(spacing: 16) {
                            // MARK: - Image Carousel
                            if !product.images.isEmpty {
                                TabView(selection: $currentPage) {
                                    ForEach(product.images.indices, id: \.self) { index in
                                        AsyncImage(url: URL(string: product.images[index])) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .cornerRadius(10)
                                                    .padding()
                                            } else if phase.error != nil {
                                                Color.red.overlay(Text("Error loading image"))
                                            } else {
                                                ProgressView()
                                            }
                                        }
                                        .tag(index)
                                    }
                                }
                                .frame(height: 250)
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                                // Dot indicators
                                HStack(spacing: 8) {
                                    ForEach(product.images.indices, id: \.self) { index in
                                        Circle()
                                            .fill(currentPage == index ? Color.blue : Color.gray.opacity(0.4))
                                            .frame(width: 8, height: 8)
                                    }
                                }
                            }

                            // MARK: - Product Info
                            Text(product.product_name)
                                .font(.title)
                                .bold()
                                .multilineTextAlignment(.center)

                            Text("₹\(product.price)")
                                .font(.title2)
                                .foregroundColor(.blue)

                            Text(product.description)
                                .padding()
                                .multilineTextAlignment(.center)

                            // MARK: - Quantity Selector
                            HStack {
                                Button(action: {
                                    if quantity > 1 { quantity -= 1 }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                }

                                Text("\(quantity)")
                                    .font(.title2)
                                    .padding(.horizontal)

                                Button(action: {
                                    quantity += 1
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                }
                            }

                            // MARK: - Add to Cart
                            Button(action: addToCart) {
                                Label("Add to Cart", systemImage: "cart.badge.plus")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                    }
                } else {
                    Text(errorMessage ?? "Error loading product.")
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("Dental Mirror")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadProduct)
            .alert("Success", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Item added to cart.")
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "Failed to add to cart.")
            }
        }
    }

    // MARK: - Load Product
    private func loadProduct() {
        let urlString = "\(ServiceAPI.productDetails)?product_id=1"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(ProductResponse.self, from: data)
                    self.product = decoded.data
                } catch {
                    self.errorMessage = "JSON decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    // MARK: - Add to Cart
    private func addToCart() {
        guard let product = product else { return }
        guard let url = URL(string: ServiceAPI.addToCart) else {
            self.errorMessage = "Invalid URL"
            self.showErrorAlert = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "user_id=\(userId)&product_id=\(product.id)&quantity=\(quantity)"
        request.httpBody = postString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Request error: \(error.localizedDescription)"
                    self.showErrorAlert = true
                    return
                }

                guard let data = data, !data.isEmpty else {
                    self.errorMessage = "Empty response from server"
                    self.showErrorAlert = true
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let status = json["status"] as? String {
                        if status == "success" {
                            self.showSuccessAlert = true
                        } else {
                            self.errorMessage = json["message"] as? String ?? "Failed to add to cart"
                            self.showErrorAlert = true
                        }
                    } else {
                        self.errorMessage = "Invalid server response"
                        self.showErrorAlert = true
                    }
                } catch {
                    self.errorMessage = "Parsing error: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
            }
        }.resume()
    }
}
