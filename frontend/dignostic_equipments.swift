import SwiftUI

// MARK: - DiagnosticEquipment Model
struct DiagnosticItem: Identifiable, Codable {
    let id: Int
    let product_name: String
    let product_image_url: String
    let created_at: String

    var name: String { product_name }
    var imageName: String { product_image_url }
}

// MARK: - API Response Model
struct FetchResponse: Codable {
    let status: String
    let message: String?
    let data: [DiagnosticItem]
}

// MARK: - DiagnosticEquipments View
struct DiagnosticEquipmentsView: View {
    @State private var diagnosticList: [DiagnosticItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Top Header
            HStack {
                Spacer()
                Image("a")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 90)
                Spacer()
            }
            .padding(.top, -30)

            Text("Diagnostic Equipment")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 8)

            if isLoading {
                ProgressView("Loading...")
                    .padding()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(diagnosticList) { item in
                            NavigationLink(destination: diagnosticDetail(for: item)) {
                                DiagnosticCard(item: item)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
        }
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchDiagnosticProducts()
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    // MARK: - Fetch Products
    func fetchDiagnosticProducts() {
        guard let url = URL(string: "http://localhost/smartdent1/fetch.php?category=DIAGNOSTIC_EQUIPMENTS") else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(FetchResponse.self, from: data)
                    if decodedResponse.status == "success" {
                        self.diagnosticList = decodedResponse.data
                    } else {
                        self.errorMessage = decodedResponse.message ?? "Unknown error"
                    }
                } catch {
                    self.errorMessage = "Failed to decode: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    // MARK: - Navigation Routing
    @ViewBuilder
    func diagnosticDetail(for item: DiagnosticItem) -> some View {
        switch item.name.lowercased() {
        case "dental mirror":
            DentalMirrorDetailView(userId: <#Int#>)
        case "dental explorer":
            DentalExplorerDetailView()
        case "intraoral camera":
            IntraoralCameraDetailView()
        case "x-ray", "x-ray machine", "xray":
            XRayMachinesDetailView()
        default:
            Text("No detail page available for \(item.name)")
                .navigationTitle(item.name)
        }
    }
}

// MARK: - DiagnosticCard View
struct DiagnosticCard: View {
    let item: DiagnosticItem

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: item.imageName)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding(.top, 16)
            } placeholder: {
                ProgressView()
                    .frame(height: 100)
            }

            Text(item.name)
                .font(.custom("IBM Plex Sans", size: 16))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal, 8)
                .padding(.bottom, 16)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 220) // Equal card height
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(1.0), lineWidth: 1) // Gray 1px border
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        DiagnosticEquipmentsView()
    }
}
