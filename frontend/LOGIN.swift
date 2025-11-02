import SwiftUI

struct LoginScreenView: View {
    var role: String
    @Binding var isLoggedIn: Bool
    @Binding var isAdmin: Bool

    @AppStorage("user_id") var userID: Int?
    @AppStorage("user_name") var userName: String?
    @AppStorage("user_email") var userEmail: String?
    @AppStorage("is_admin") var isAdminStored: Bool = false
    @AppStorage("is_logged_in") var isLoggedInStored: Bool = false

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var navigateToSignUp = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("\(role.capitalized) Login")
                    .font(.largeTitle)
                    .bold()

                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.gray)

                VStack(alignment: .leading) {
                    Text("Email").bold()
                    TextField("Enter your email", text: $email)
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }

                VStack(alignment: .leading) {
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
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))

                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        }
                        .padding(.trailing, 10)
                    }
                }

                Button("Login") {
                    loginUser()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)

                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                Button(action: {
                    navigateToSignUp = true
                }) {
                    HStack {
                        Text("Don't have an account?")
                        Text("Create an account")
                            .foregroundColor(.blue)
                            .bold()
                    }
                }
                .padding(.top, 20)
            }
            .padding()
            .navigationDestination(isPresented: $navigateToSignUp) {
                UserSignUpView(isLoggedIn: $isLoggedIn)
            }
        }
    }

    func loginUser() {
        guard let url = URL(string: ServiceAPI.loginURL) else {
            showError = true
            errorMessage = "Invalid server URL."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyString = "email=\(email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&password=\(password.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        request.httpBody = bodyString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    showError = true
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    showError = true
                    errorMessage = "No data received."
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let status = json["status"] as? String {
                        if status == "success",
                           let user = json["user"] as? [String: Any] {

                            userID = user["user_id"] as? Int
                            userName = user["name"] as? String
                            userEmail = user["email"] as? String

                            isLoggedIn = true
                            isLoggedInStored = true

                            if role.lowercased() == "admin" {
                                isAdmin = true
                                isAdminStored = true
                            } else {
                                isAdmin = false
                                isAdminStored = false
                            }

                        } else {
                            showError = true
                            errorMessage = json["message"] as? String ?? "Login failed."
                        }
                    } else {
                        showError = true
                        errorMessage = "Invalid response format."
                    }
                } catch {
                    showError = true
                    errorMessage = "Failed to decode response."
                }
            }
        }.resume()
    }
}
