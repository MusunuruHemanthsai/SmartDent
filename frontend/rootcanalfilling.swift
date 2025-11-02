import SwiftUI

struct RootCanalFillingDetailView: View {
    let userId: Int

    @State private var product: Product?
    @State private var quantity = 1
    @State private var currentPage = 0
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false

    private let productId = 30
    private var apiURL: String {
        return "\(ServiceAPI.productDetails)?product_id=\(30)"
    }
    private let addToCartURL = ServiceAPI.addToCart

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading Product...")
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if let product = product {
                    ScrollView {
                        VStack(spacing: 20) {

                            // Image Carousel
                            if !product.images.isEmpty {
                                TabView(selection: $currentPage) {
                                    ForEach(product.images.indices, id: \.self) { index in
                                        AsyncImage(url: URL(string: product.images[index])) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                            } else if phase.error != nil {
                                                Color.red.overlay(Text("Error loading image"))
                                            } else {
                                                ProgressView()
                                            }
                                        }
                                        .tag(index)
                                        .padding()
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                .frame(height: 260)

                                // Page Indicators
                                HStack(spacing: 6) {
                                    ForEach(product.images.indices, id: \.self) { index in
                                        Circle()
                                            .fill(index == currentPage ? Color.black : Color.gray.opacity(0.3))
                                            .frame(width: 8, height: 8)
                                    }
                                }
                            }

                            // Product Title
                            Text(product.product_name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)

                            // Price
                            Text("₹\(product.price)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)

                            // Description
                            Text(product.description)
                                .font(.body)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            // Quantity Selector
                            HStack(spacing: 20) {
                                Button {
                                    if quantity > 1 { quantity -= 1 }
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                }

                                Text("\(quantity)")
                                    .font(.title2)
                                    .fontWeight(.bold)

                                Button {
                                    quantity += 1
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                }
                            }

                            // Add to Cart Button
                            Button(action: addToCart) {
                                HStack(spacing: 10) {
                                    Image(systemName: "cart.fill.badge.plus")
                                        .font(.title2)
                                    Text("Add to Cart")
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .cornerRadius(12)
                                .padding(.top, 10)
                            }

                            Spacer()
                        }
                        .padding(.bottom, 30)
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Image("a")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .offset(y: -50)
                        }
                    }
                }
            }
            .onAppear(perform: fetchProduct)
            .background(Color.white.ignoresSafeArea())
            .alert("Success", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Item added to cart.")
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "Failed to add item to cart.")
            }
        }
    }

    // MARK: - Load Product
    private func fetchProduct() {
        guard let url = URL(string: apiURL) else {
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
                    let decoded = try JSONDecoder().decode(ProductResponse.self, from: data)
                    self.product = decoded.data
                } catch {
                    errorMessage = "Failed to decode product data"
                }
            }
        }.resume()
    }

    // MARK: - Add to Cart
    private func addToCart() {
        guard let product = product else { return }
        guard let url = URL(string: addToCartURL) else {
            errorMessage = "Invalid Add to Cart URL"
            showErrorAlert = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postData = "user_id=\(userId)&product_id=\(product.id)&quantity=\(quantity)"
        request.httpBody = postData.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = "Request error: \(error.localizedDescription)"
                    showErrorAlert = true
                    return
                }

                guard let data = data else {
                    errorMessage = "No response from server"
                    showErrorAlert = true
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let status = json["status"] as? String {
                        if status == "success" {
                            showSuccessAlert = true
                        } else {
                            errorMessage = json["message"] as? String ?? "Failed to add item to cart"
                            showErrorAlert = true
                        }
                    } else {
                        errorMessage = "Unexpected server response"
                        showErrorAlert = true
                    }
                } catch {
                    errorMessage = "Failed to parse server response"
                    showErrorAlert = true
                }
            }
        }.resume()
    }
}

struct RootCanalFillingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RootCanalFillingDetailView(userId: 1)
    }
}
