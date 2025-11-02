import SwiftUI

// MARK: - Service Request Model
struct ServiceRequest: Identifiable, Codable {
    let id: Int
    let service_type: String
    let name: String
    let contact: String
    let address: String
}

// MARK: - Response Wrapper
struct ServiceRequestResponse: Codable {
    let status: String
    let data: [ServiceRequest]?
    let message: String?
}

// MARK: - Main View
struct ServiceRequestsView: View {
    @State private var isLoading = true
    @State private var errorMessage: String = ""
    @State private var serviceRequests: [ServiceRequest] = []

    // Optional user ID for filtering
    var userId: Int? = nil

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if !errorMessage.isEmpty {
                    Text("❌ \(errorMessage)")
                        .foregroundColor(.red)
                        .font(.headline)
                        .padding()
                } else if serviceRequests.isEmpty {
                    Text("📭 No service requests found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(serviceRequests) { request in
                        ServiceRequestCard(request: request)
                    }
                }
            }
            .navigationTitle("Service Requests")
        }
        .onAppear(perform: fetchServiceRequests)
    }

    // MARK: - Fetch Requests from Backend
    func fetchServiceRequests() {
        let urlString = ServiceAPI.serviceRequestsURL(for: userId)

        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
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
                    let decoded = try JSONDecoder().decode(ServiceRequestResponse.self, from: data)
                    if decoded.status == "success", let requests = decoded.data {
                        self.serviceRequests = requests
                    } else {
                        self.errorMessage = decoded.message ?? "Failed to fetch service requests"
                    }
                } catch {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

// MARK: - Card View
struct ServiceRequestCard: View {
    let request: ServiceRequest

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(request.service_type)
                .font(.headline)
                .foregroundColor(.blue)

            Text("👤 Name: \(request.name)")
            Text("📞 Contact: \(request.contact)")
            Text("🏠 Address: \(request.address)")
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        .padding(.vertical, 4)
    }
}
