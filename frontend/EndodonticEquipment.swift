import SwiftUI

// MARK: - Model
struct EndodonticEquipment: Identifiable, Codable {
    let id: Int
    let product_name: String
    let product_image_url: String
    let created_at: String

    var name: String { product_name }
    var imageURL: String { product_image_url }
}

// MARK: - Response
struct EndodonticFetchResponse: Codable {
    let status: String
    let message: String?
    let data: [EndodonticEquipment]
}

// MARK: - Main View
struct EndodonticEquipmentsView: View {
    @State private var equipmentList: [EndodonticEquipment] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Spacer()
                Image("a")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 90)
                Spacer()
            }
            .padding(.top, -30)

            // Title
            Text("Endodontic Equipment")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 12)

            // Content
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
                        ForEach(equipmentList) { item in
                            NavigationLink(destination: detailView(for: item)) {
                                EndodonticCard(item: item)
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
            fetchEndodonticEquipments()
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    // MARK: - Fetch
    func fetchEndodonticEquipments() {
        isLoading = true
        errorMessage = nil

        var components = URLComponents(string: "http://localhost/smartdent1/fetch.php")!
        components.queryItems = [
            URLQueryItem(name: "category", value: "ENDODONTIC_EQUIPMENTS")
        ]

        guard let url = components.url else {
            errorMessage = "Invalid URL"
            isLoading = false
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
                    let decoded = try JSONDecoder().decode(EndodonticFetchResponse.self, from: data)
                    if decoded.status == "success" {
                        equipmentList = decoded.data
                    } else {
                        errorMessage = decoded.message ?? "Failed to fetch data"
                    }
                } catch {
                    errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    // MARK: - Navigation
    @ViewBuilder
    func detailView(for item: EndodonticEquipment) -> some View {
        switch item.name.lowercased() {
        case "endodontic files":
            EndodonticFilesDetailView()
        case "root canal filling material":
            RootCanalFillingDetailView()
        case "endodontic motors":
            EndodonticMotorsDetailView()
        default:
            Text("No detail page available for \(item.name)")
                .navigationTitle(item.name)
        }
    }
}

// MARK: - Card View
struct EndodonticCard: View {
    let item: EndodonticEquipment

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: item.imageURL)) { image in
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
        .frame(height: 220)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(1.0), lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        EndodonticEquipmentsView()
    }
}
