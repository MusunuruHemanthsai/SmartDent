import SwiftUI

struct XRayMachinesDetailView: View {
    let userId: Int
    private let productId = 4

    @State private var product: Product?
    @State private var quantity = 1
    @State private var currentPage = 0
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading Product...")
                } else if let error = errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
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

                                HStack(spacing: 6) {
                                    ForEach(product.images.indices, id: \.self) { index in
                                        Circle()
                                            .fill(index == currentPage ? Color.black : Color.gray.opacity(0.3))
                                            .frame(width: 8, height: 8)
                                    }
                                }
                            }

                            Text(product.product_name)
                                .font(.title)
                                .fontWeight(.bold)

                            Text("₹\(product.price)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)

                            Text(product.description)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            HStack(spacing: 20) {
                                Button(action: { if quantity > 1 { quantity -= 1 } }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                }

                                Text("\(quantity)")
                                    .font(.title2)
                                    .fontWeight(.bold)

                                Button(action: { quantity += 1 }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                }
                            }

                            Button(action: addToCart) {
                                HStack(spacing: 10) {
                                    Image(systemName: "cart.badge.plus")
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
            .onAppear(perform: loadProduct)
            .background(Color.white.ignoresSafeArea())
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
        guard let url = URL(string: ServiceAPI.productDetailURL(for: 4)) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received."
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(ProductResponse.self, from: data)
                    self.product = decoded.data
                } catch {
                    self.errorMessage = "Failed to parse product data."
                }
            }
        }.resume()
    }

    // MARK: - Add to Cart
    private func addToCart() {
        guard let product = product else { return }
        guard let url = URL(string: ServiceAPI.addToCart) else {
            self.errorMessage = "Invalid Add to Cart URL"
            self.showErrorAlert = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "user_id=\(userId)&product_id=\(product.id)&quantity=\(quantity)"
        request.httpBody = body.data(using: .utf8)
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

struct XRayMachinesDetailView_Previews: PreviewProvider {
    static var previews: some View {
        XRayMachinesDetailView(userId: 1)
    }
}
