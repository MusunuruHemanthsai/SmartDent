import SwiftUI

struct CheckoutView: View {
    @AppStorage("user_id") private var userId: Int = 0
    let cartItems: [CartItem]

    @Environment(\.presentationMode) private var presentationMode

    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var streetAddress = ""
    @State private var city = ""
    @State private var zipCode = "" {
        didSet {
            lookupPinCode(zipCode)
        }
    }
    @State private var selectedState = ""
    @State private var selectedPaymentMethod = ""
    @State private var isPlacingOrder = false
    @State private var showConfirmation = false
    @State private var errorMessage: String?

    private let paymentMethods = ["Cash on Delivery"]

    private let indianStates = [
        "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh",
        "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand",
        "Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur",
        "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab",
        "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura",
        "Uttar Pradesh", "Uttarakhand", "West Bengal",
        "Andaman and Nicobar Islands", "Chandigarh", "Dadra and Nagar Haveli and Daman and Diu",
        "Delhi", "Jammu and Kashmir", "Ladakh", "Lakshadweep", "Puducherry"
    ]

    private let pinCodeDatabase: [String: (city: String, state: String)] = [
        "110001": ("New Delhi", "Delhi"),
        "400001": ("Mumbai", "Maharashtra"),
        "600001": ("Chennai", "Tamil Nadu"),
        "560001": ("Bengaluru", "Karnataka"),
        "500001": ("Hyderabad", "Telangana"),
        "700001": ("Kolkata", "West Bengal"),
        "122001": ("Gurugram", "Haryana"),
        "380001": ("Ahmedabad", "Gujarat"),
        "751001": ("Bhubaneswar", "Odisha")
    ]

    private var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Contact Information
                    Group {
                        Text("Contact Information")
                            .font(.title2).bold()

                        labeledField(title: "Name", text: $name)
                        labeledField(title: "Phone Number", text: $phoneNumber)
                            .keyboardType(.numberPad)
                    }

                    // MARK: - Shipping Address
                    Group {
                        Text("Shipping Address")
                            .font(.title2).bold()

                        labeledField(title: "Street Address", text: $streetAddress)
                        labeledField(title: "City", text: $city)
                        labeledField(title: "ZIP Code", text: $zipCode)
                            .keyboardType(.numberPad)

                        Text("State").font(.headline)
                        Menu {
                            ForEach(indianStates, id: \.self) { state in
                                Button(state) {
                                    selectedState = state
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedState.isEmpty ? "Select State" : selectedState)
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                        }
                    }

                    // MARK: - Payment Method
                    Group {
                        Text("Payment Method")
                            .font(.title2).bold()

                        Menu {
                            ForEach(paymentMethods, id: \.self) { method in
                                Button(method) {
                                    selectedPaymentMethod = method
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedPaymentMethod.isEmpty ? "Select Payment Method" : selectedPaymentMethod)
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                        }

                        Text("Total: ₹\(totalPrice, specifier: "%.2f")")
                            .font(.title3)
                            .padding(.top)
                    }

                    // MARK: - Error
                    if let errorMessage = errorMessage {
                        Text("Error: \(errorMessage)").foregroundColor(.red)
                    }

                    // MARK: - Place Order Button
                    Button(action: placeOrder) {
                        if isPlacingOrder {
                            ProgressView()
                        } else {
                            Text("Place Order")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .disabled(!isFormValid || isPlacingOrder)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Checkout")
            .alert("Order Placed!", isPresented: $showConfirmation) {
                Button("OK") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }

    // MARK: - Helpers

    private func labeledField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline)
            TextField("Enter \(title.lowercased())", text: text)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
        }
    }

    private var isFormValid: Bool {
        !name.isEmpty &&
        !phoneNumber.isEmpty &&
        phoneNumber.allSatisfy(\.isNumber) &&
        phoneNumber.count >= 10 &&
        !streetAddress.isEmpty &&
        !city.isEmpty &&
        !zipCode.isEmpty &&
        !selectedState.isEmpty &&
        !selectedPaymentMethod.isEmpty
    }

    private func lookupPinCode(_ pin: String) {
        if let match = pinCodeDatabase[pin] {
            city = match.city
            selectedState = match.state
        }
    }

    private func placeOrder() {
        guard userId > 0 else {
            errorMessage = "User not logged in."
            return
        }

        let fullAddress = "\(name), \(phoneNumber), \(streetAddress), \(city), \(selectedState) - \(zipCode)"

        guard let url = URL(string: ServiceAPI.checkout) else {
            errorMessage = "Invalid server URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let params: [String: String] = [
            "user_id": "\(userId)",
            "address": fullAddress,
            "payment_method": selectedPaymentMethod
        ]

        let bodyString = params
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")

        request.httpBody = bodyString.data(using: .utf8)

        isPlacingOrder = true
        errorMessage = nil

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                isPlacingOrder = false

                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    errorMessage = "No response from server."
                    return
                }

                do {
                    let response = try JSONDecoder().decode([String: String].self, from: data)
                    if response["status"] == "success" {
                        showConfirmation = true
                    } else {
                        errorMessage = response["message"] ?? "Order failed."
                    }
                } catch {
                    errorMessage = "Invalid response format."
                }
            }
        }.resume()
    }
}
