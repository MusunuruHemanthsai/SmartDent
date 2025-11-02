import SwiftUI

struct UserSignUpView: View {
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) var dismiss

    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSuccess = false

    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Sign up")
                        .font(.system(size: 36, weight: .bold))

                    Group {
                        buildField(label: "Name", placeholder: "Enter your name", text: $fullName)
                        buildField(label: "Email", placeholder: "simats@gmail.com", text: $email, keyboardType: .emailAddress)
                        buildField(label: "Create password", placeholder: "eg: 123456789", text: $password, isSecure: true, isVisible: $isPasswordVisible)
                        buildField(label: "Confirm password", placeholder: "Re-enter password", text: $confirmPassword, isSecure: true, isVisible: $isConfirmPasswordVisible)
                    }

                    HStack {
                        Spacer()
                        if isLoading {
                            ProgressView()
                        } else {
                            Button(action: signUpUser) {
                                Text("Create an Account")
                                    .font(.system(size: 20, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
            .navigationBarBackButtonHidden(false)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(isSuccess ? "Success" : "Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if isSuccess {
                            dismiss()
                        }
                    }
                )
            }
        }
    }

    func buildField(
        label: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false,
        isVisible: Binding<Bool>? = nil,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 24, weight: .semibold))

            if isSecure, let isVisible = isVisible {
                HStack {
                    Group {
                        if isVisible.wrappedValue {
                            TextField(placeholder, text: text)
                                .keyboardType(keyboardType)
                                .textInputAutocapitalization(.never)
                        } else {
                            SecureField(placeholder, text: text)
                                .keyboardType(keyboardType)
                        }
                    }
                    .padding()

                    Button(action: {
                        isVisible.wrappedValue.toggle()
                    }) {
                        Image(systemName: isVisible.wrappedValue ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 8)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 2)
                )
            } else {
                TextField(placeholder, text: text)
                    .padding()
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(.never)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 2)
                    )
            }
        }
    }

    func signUpUser() {
        let trimmedName = fullName.trimmingCharacters(in: .whitespaces)
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        let trimmedPassword = password.trimmingCharacters(in: .whitespaces)
        let trimmedConfirm = confirmPassword.trimmingCharacters(in: .whitespaces)

        guard !trimmedName.isEmpty, !trimmedEmail.isEmpty, !trimmedPassword.isEmpty, !trimmedConfirm.isEmpty else {
            showError("All fields are required.")
            return
        }

        let emailRegex = #"^[^@]+@[^@]+\.[^@]+$"#
        guard trimmedEmail.range(of: emailRegex, options: .regularExpression) != nil else {
            showError("Invalid email format.")
            return
        }

        guard trimmedPassword == trimmedConfirm else {
            showError("Passwords do not match.")
            return
        }

        isLoading = true

        guard let url = URL(string: ServiceAPI.signupURL) else {
            showError("Invalid server URL.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // Encode form fields
        let bodyString = "name=\(trimmedName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&email=\(trimmedEmail.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&password=\(trimmedPassword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&confirmPassword=\(trimmedConfirm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        request.httpBody = bodyString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    showError("Network error: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    showError("No data received from server.")
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let status = json["status"] as? String {
                        if status == "success" {
                            showSuccess("Signup successful!")
                        } else {
                            showError(json["message"] as? String ?? "Signup failed.")
                        }
                    } else {
                        showError("Invalid server response.")
                    }
                } catch {
                    showError("Failed to decode server response.")
                }
            }
        }.resume()
    }

    func showError(_ message: String) {
        alertMessage = message
        isSuccess = false
        showAlert = true
    }

    func showSuccess(_ message: String) {
        alertMessage = message
        isSuccess = true
        showAlert = true
    }
}
