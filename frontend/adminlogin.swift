import SwiftUI

struct AdminLoginView: View {
    var role: String
    @Binding var isLoggedIn: Bool
    @Binding var isAdmin: Bool

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("\(role.capitalized) Login")
                .font(.largeTitle)
                .bold()

            Image(systemName: "person.crop.circle.badge.checkmark")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .foregroundColor(.black)

            // Email Field
            VStack(alignment: .leading) {
                Text("Email").bold()
                TextField("Enter your email", text: $email)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }

            // Password Field
            VStack(alignment: .leading, spacing: 10) {
                Text("Password").bold()
                ZStack(alignment: .trailing) {
                    Group {
                        if isPasswordVisible {
                            TextField("Enter your password", text: $password)
                        } else {
                            SecureField("Enter your password", text: $password)
                        }
                    }
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )

                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 10)
                }
            }

            // Login Button
            Button("Login") {
                loginAdmin()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)

            // Error Message
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
        }
        .padding()
    }

    // MARK: - Admin Login Function
    func loginAdmin() {
        guard let url = URL(string: ServiceAPI.admin_loginURL) else {
            showError = true
            errorMessage = "Invalid login URL."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // Encode as form-data string
        let formBody = "email=\(email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&password=\(password.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        request.httpBody = formBody.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    showError = true
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    showError = true
                    errorMessage = "No data received from server."
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let status = json["status"] as? String {
                        if status == "success" {
                            isLoggedIn = true
                            isAdmin = true
                        } else {
                            showError = true
                            errorMessage = json["message"] as? String ?? "Admin login failed."
                        }
                    } else {
                        showError = true
                        errorMessage = "Invalid server response format."
                    }
                } catch {
                    showError = true
                    errorMessage = "Failed to decode server response."
                }
            }
        }.resume()
    }
}
