import SwiftUI

struct ServicesScreen: View {
    @State private var name: String = ""
    @State private var contact: String = ""
    @State private var serviceType: String = ""
    @State private var streetAddress: String = ""
    @State private var city: String = ""
    @State private var zipCode: String = "" {
        didSet {
            lookupPinCode(zipCode)
        }
    }
    @State private var selectedState: String = ""

    @State private var showingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""

    @AppStorage("user_id") var userId: Int?

    let indianStates = [
        "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh",
        "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand",
        "Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur",
        "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab",
        "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura",
        "Uttar Pradesh", "Uttarakhand", "West Bengal",
        "Andaman and Nicobar Islands", "Chandigarh", "Delhi",
        "Jammu and Kashmir", "Ladakh", "Puducherry"
    ]

    let pinCodeDatabase: [String: (city: String, state: String)] = [
        "110001": ("New Delhi", "Delhi"),
        "400001": ("Mumbai", "Maharashtra"),
        "600001": ("Chennai", "Tamil Nadu"),
        "560001": ("Bengaluru", "Karnataka"),
        "500001": ("Hyderabad", "Telangana"),
        "700001": ("Kolkata", "West Bengal")
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("SERVICES")
                        .font(.largeTitle.bold())
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 20)

                    Group {
                        Text("Name").font(.headline)
                        TextField("Enter your name", text: $name)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black))
                    }

                    Group {
                        Text("Contact Number").font(.headline)
                        TextField("Enter contact number", text: $contact)
                            .keyboardType(.phonePad)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black))
                    }

                    Group {
                        Text("Type of Service").font(.headline)
                        TextField("Enter type of service", text: $serviceType)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black))
                    }

                    Group {
                        Text("Street Address").font(.headline)
                        TextField("Enter street address", text: $streetAddress)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black))

                        Text("City").font(.headline)
                        TextField("City", text: $city)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black))

                        Text("ZIP Code").font(.headline)
                        TextField("ZIP Code", text: $zipCode)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black))

                        Text("State").font(.headline)
                        Menu {
                            ForEach(indianStates, id: \.self) { state in
                                Button {
                                    selectedState = state
                                } label: {
                                    Text(state)
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedState.isEmpty ? "Select State" : selectedState)
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black))
                        }
                    }

                    Button(action: submitServiceRequest) {
                        Text("SERVICE REQUEST")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }

    // MARK: - Helpers

    private func lookupPinCode(_ pin: String) {
        if let match = pinCodeDatabase[pin] {
            city = match.city
            selectedState = match.state
        }
    }

    private func submitServiceRequest() {
        guard let userId = userId else {
            showAlert("Login Error", "User not logged in.")
            return
        }

        guard !name.isEmpty,
              !contact.isEmpty,
              !serviceType.isEmpty,
              !streetAddress.isEmpty,
              !city.isEmpty,
              !zipCode.isEmpty,
              !selectedState.isEmpty else {
            showAlert("Validation Error", "Please fill in all fields.")
            return
        }

        let fullAddress = "\(streetAddress), \(city), \(selectedState) - \(zipCode)"

        guard let url = URL(string: ServiceAPI.submitServiceRequest) else {
            showAlert("URL Error", "Invalid service URL.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let parameters: [String: String] = [
            "name": name,
            "contact": contact,
            "service_type": serviceType,
            "address": fullAddress,
            "user_id": "\(userId)"
        ]

        let formData = parameters
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")

        request.httpBody = formData.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                showAlert("Network Error", error.localizedDescription)
                return
            }

            guard let data = data else {
                showAlert("Server Error", "No data received.")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(ServiceResponse.self, from: data)
                DispatchQueue.main.async {
                    showAlert(decoded.status.capitalized, decoded.message)
                    if decoded.status == "success" {
                        clearForm()
                    }
                }
            } catch {
                showAlert("Decoding Error", "Unable to parse server response.")
            }
        }.resume()
    }

    private func showAlert(_ title: String, _ message: String) {
        DispatchQueue.main.async {
            alertTitle = title
            alertMessage = message
            showingAlert = true
        }
    }

    private func clearForm() {
        name = ""
        contact = ""
        serviceType = ""
        streetAddress = ""
        city = ""
        zipCode = ""
        selectedState = ""
    }
}

// MARK: - Supporting Models

struct ServiceResponse: Codable {
    let status: String
    let message: String
}

// MARK: - Preview

struct ServicesScreen_Previews: PreviewProvider {
    static var previews: some View {
        ServicesScreen()
    }
}
