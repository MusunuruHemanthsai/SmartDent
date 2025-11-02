// HomePageView.swift
import SwiftUI

struct HomePageView: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("user_id") var userId: Int?

    @State private var allProducts: [UnifiedProduct] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var searchText = ""
    @State private var path: [MenuDestination] = []

    private let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]

    var filteredProducts: [UnifiedProduct] {
        searchText.isEmpty
            ? allProducts
            : allProducts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 16) {
                    SearchBar(searchText: $searchText)
                        .padding(.horizontal)

                    if !isLoading && !allProducts.isEmpty {
                        FeaturedProductsCarousel(products: Array(allProducts.prefix(5))) { selectedProduct in
                            path.append(.productDetail(selectedProduct))
                        }
                        .padding(.bottom)
                    }

                    if isLoading {
                        ProgressView("Loading products...")
                            .frame(height: 200)
                    } else if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                    } else {
                        LazyVGrid(columns: gridColumns, spacing: 16) {
                            ForEach(filteredProducts) { product in
                                Button {
                                    path.append(.productDetail(product))
                                } label: {
                                    ProductCard(product: product)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("a")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("Profile") { path.append(.profile) }
                        Button("Orders History") {
                            if let uid = userId {
                                path.append(.orders(userId: uid))
                            }
                        }
                        Button("Services") { path.append(.services) }
                        Button("Logout", role: .destructive) {
                            isLoggedIn = false
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }

                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        path.append(.chatbot)
                    } label: {
                        Image(systemName: "brain.head.profile")
                            .imageScale(.large)
                    }
                    Button {
                        if let uid = userId {
                            path.append(.cart(userId: uid))
                        }
                    } label: {
                        Image(systemName: "cart")
                            .imageScale(.large)
                    }
                }
            }
            .navigationDestination(for: MenuDestination.self) { destination in
                switch destination {
                case .profile:
                    ProfileView()
                case .orders(let uid):
                    UserOrdersView(userID: uid)
                case .services: // ✅ Assuming services(userId: Int) is defined
                    ServicesScreen(userId: _userId)
                case .productDetail(let product):
                    productDetailView(for: product)
                case .chatbot:
                    AIChatbotView()
                case .cart(_):
                    CartView()
                }
            }
            .onAppear {
                fetchAllProducts()
            }
        }
    }

    private func fetchAllProducts() {
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: ServiceAPI.fetchAllProducts) else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    errorMessage = "Error: \(error.localizedDescription)"
                    return
                }
                guard let data = data else {
                    errorMessage = "No data received"
                    return
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let dataArray = json["data"] as? [[String: Any]] {
                        self.allProducts = dataArray.compactMap { item in
                            guard let name = item["product_name"] as? String,
                                  let price = item["price"] as? Double,
                                  let imageURL = item["image_url"] as? String else { return nil }

                            return UnifiedProduct(
                                id: UUID().hashValue,
                                name: name,
                                imageURL: imageURL,
                                category: "General",
                                price: price,
                                description: item["description"] as? String ?? ""
                            )
                        }
                        self.allProducts.shuffle()
                    } else {
                        errorMessage = "Invalid data format"
                    }
                } catch {
                    errorMessage = "Failed to parse JSON"
                }
            }
        }.resume()
    }

    func productDetailView(for product: UnifiedProduct) -> some View {
        let lowerName = product.name.lowercased()

        if ["dental mirror"].contains(lowerName), let uid = userId {
            return AnyView(DentalMirrorDetailView(userId: uid))
        } else if ["dental explorer"].contains(lowerName), let uid = userId {
            return AnyView(DentalExplorerDetailView(userId: uid))
        } else if ["intraoral camera"].contains(lowerName), let uid = userId {
            return AnyView(IntraoralCameraDetailView(userId: uid))
        } else if ["x-ray", "x-ray machine", "xray"].contains(lowerName), let uid = userId {
            return AnyView(XRayMachinesDetailView(userId: uid))
        } else if ["dental handpieces"].contains(lowerName), let uid = userId {
            return AnyView(DentalHandpiecesDetailView(userId: uid))
        } else if ["air-driven handpieces", "air driven handpieces"].contains(lowerName), let uid = userId {
            return AnyView(AirDrivenHandpiecesDetailView(userId: uid))
        } else if ["ultrasonic scaler"].contains(lowerName), let uid = userId {
            return AnyView(UltrasonicScalerDetailView(userId: uid))
        } else if ["laser equipment"].contains(lowerName), let uid = userId {
            return AnyView(LaserEquipmentDetailView(userId: uid))
        } else if ["curing lights", "curing light"].contains(lowerName){
            return AnyView(CuringLightsDetailView())
        } else if ["dental chairs"].contains(lowerName) {
            return AnyView(DentalChairDetailView())
        } else if ["operating light"].contains(lowerName), let uid = userId {
            return AnyView(OperatingLightView(userId: uid))
        } else if ["suction devices"].contains(lowerName), let uid = userId {
            return AnyView(SuctionDeviceDetailView(userId: uid))
        } else if ["archwires"].contains(lowerName), let uid = userId {
            return AnyView(ArchwireDetailView(userId: uid))
        } else if ["elastics and springs"].contains(lowerName), let uid = userId {
            return AnyView(ElasticsAndSpringsDetailView(userId: uid))
        } else if ["ligatures"].contains(lowerName), let uid = userId {
            return AnyView(LigaturesDetailView(userId: uid))
        } else if ["endodontic files"].contains(lowerName), let uid = userId {
            return AnyView(EndodonticFilesDetailView(userId: uid))
        } else if ["root canal filling material"].contains(lowerName), let uid = userId {
            return AnyView(RootCanalFillingDetailView(userId: uid))
        } else if ["endodontic motors"].contains(lowerName), let uid = userId {
            return AnyView(EndodonticMotorsDetailView(userId: uid))
        } else if ["forceps"].contains(lowerName) {
            return AnyView(ForcepsDetailView())
        } else if ["scalpel"].contains(lowerName) {
            return AnyView(ScalpelDetailView())
        } else if ["elevators"].contains(lowerName) {
            return AnyView(ElevatorsDetailView())
        } else if ["sutures"].contains(lowerName) {
            return AnyView(SuturesDetailView())
        } else if ["bone grafting instrument"].contains(lowerName) {
            return AnyView(BoneGraftingDetailView())
        } else if ["autoclaves"].contains(lowerName), let uid = userId {
            return AnyView(AutoclaveDetailView(userId: uid))
        } else if ["ultrasonic cleaner"].contains(lowerName), let uid = userId {
            return AnyView(UltrasonicCleanerDetailView(userId: uid))
        } else if ["sterilizers monitoring"].contains(lowerName), let uid = userId {
            return AnyView(SterilizerDetailView(userId: uid))
        } else if ["uv sterilizers"].contains(lowerName), let uid = userId {
            return AnyView(UVSterilizerDetailView(userId: uid))
        } else if ["dental impression"].contains(lowerName), let uid = userId {
            return AnyView(DentalImpressionDetailView(userId: uid))
        } else if ["mixer and dispenser"].contains(lowerName), let uid = userId {
            return AnyView(MixAndDispenserDetailView(userId: uid))
        } else if ["vacuum former"].contains(lowerName), let uid = userId {
            return AnyView(VacuumFormerDetailView(userId: uid))
        } else {
            return AnyView(GenericProductDetailView(product: product))
        }
    }
}

// MARK: - Enums & Models

enum MenuDestination: Hashable {
    case profile
    case orders(userId: Int)
    case services
    case productDetail(UnifiedProduct)
    case cart(userId: Int)
    case chatbot
}

struct UnifiedProduct: Identifiable, Hashable {
    let id: Int
    let name: String
    let imageURL: String
    let category: String
    var price: Double
    var description: String
}

// MARK: - UI Components

struct ProductCard: View {
    let product: UnifiedProduct

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: product.imageURL)) { phase in
                switch phase {
                case .success(let image): image.resizable().scaledToFit()
                case .failure: Image(systemName: "photo").resizable().scaledToFit().foregroundColor(.gray)
                default: ProgressView()
                }
            }
            .frame(height: 120)

            Text(product.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2)
                .foregroundColor(.primary)

            Text("₹\(String(format: "%.2f", product.price))")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.blue)

            Text(product.category)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct FeaturedProductsCarousel: View {
    let products: [UnifiedProduct]
    var onTap: (UnifiedProduct) -> Void
    @State private var currentPage = 0

    var body: some View {
        VStack(alignment: .leading) {
            Text("Featured")
                .font(.headline)
                .padding(.horizontal)

            TabView(selection: $currentPage) {
                ForEach(products) { product in
                    Button(action: { onTap(product) }) {
                        FeaturedProductCard(product: product)
                    }
                    .tag(product.id)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 300)
        }
    }
}

struct FeaturedProductCard: View {
    let product: UnifiedProduct

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: product.imageURL)) { phase in
                switch phase {
                case .success(let image): image.resizable().scaledToFill()
                default: Color.gray
                }
            }
            .frame(height: 300)
            .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text("₹\(String(format: "%.2f", product.price))")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.6)]),
                               startPoint: .top, endPoint: .bottom)
            )
        }
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search products...", text: $searchText)
                .autocapitalization(.none)
                .disableAutocorrection(true)

            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct GenericProductDetailView: View {
    let product: UnifiedProduct

    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: product.imageURL)) { phase in
                switch phase {
                case .success(let image): image.resizable().scaledToFit()
                case .failure: Image(systemName: "photo").resizable().scaledToFit().foregroundColor(.gray)
                default: ProgressView()
                }
            }
            .frame(height: 200)

            Text(product.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text("₹\(String(format: "%.2f", product.price))")
                .font(.title2)
                .foregroundColor(.blue)

            Text(product.description)
                .foregroundColor(.primary)
                .padding()

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .navigationTitle("Product Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}


