import SwiftUI
import PhotosUI

// MARK: - Main Profile View
struct ProfileView: View {
    @AppStorage("user_id") var userID: Int?
    @AppStorage("user_name") var userName: String?
    @AppStorage("user_email") var userEmail: String?

    @State private var profileImage: UIImage?
    @State private var photoPickerItem: PhotosPickerItem?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Profile Image + Upload
                VStack(spacing: 12) {
                    if let image = profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue.opacity(0.7))
                    }

                    PhotosPicker("Change Profile Image", selection: $photoPickerItem, matching: .images)
                        .onChange(of: photoPickerItem) {
                            Task { await uploadSelectedImage() }
                        }

                    Text(userName ?? "User")
                        .font(.title2.bold())

                    Text(userEmail ?? "-")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 32)

                // Detail Section
                VStack(spacing: 16) {
                    ProfileDetailCard(icon: "number", label: "User ID", value: "\(userID ?? 0)")
                    ProfileDetailCard(icon: "person.fill", label: "Name", value: userName ?? "-")
                    ProfileDetailCard(icon: "envelope.fill", label: "Email", value: userEmail ?? "-")
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("My Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { fetchProfileImage() }
    }

    // MARK: - Upload Image to PHP Server
    func uploadSelectedImage() async {
        guard let item = photoPickerItem,
              let data = try? await item.loadTransferable(type: Data.self),
              let userID = userID,
              let uploadURL = URL(string: ServiceAPI.uploadProfileImage) else { return }

        let boundary = UUID().uuidString
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"user_id\"\r\n\r\n")
        body.append("\(userID)\r\n")
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"profile_image\"; filename=\"profile.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(data)
        body.append("\r\n--\(boundary)--\r\n")

        request.httpBody = body

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                self.profileImage = UIImage(data: data)
            }
        } catch {
            print("Upload failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Fetch Profile Image from PHP Server
    func fetchProfileImage() {
        guard let userID = userID,
              let url = URL(string: ServiceAPI.fetchProfileImage(for: userID)) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let result = try? JSONDecoder().decode(ProfileImageResponse.self, from: data),
                  let imageURL = URL(string: result.image_url) else { return }

            URLSession.shared.dataTask(with: imageURL) { imageData, _, _ in
                if let imageData = imageData {
                    DispatchQueue.main.async {
                        self.profileImage = UIImage(data: imageData)
                    }
                }
            }.resume()
        }.resume()
    }
}

// MARK: - Profile Image Response Model
struct ProfileImageResponse: Codable {
    let status: String
    let image_url: String
}

// MARK: - Profile Detail Card
struct ProfileDetailCard: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 36, height: 36)
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
            }

            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

// MARK: - Data.append helper
extension Data {
    mutating func append1(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
