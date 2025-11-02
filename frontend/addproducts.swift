import SwiftUI
import PhotosUI

struct AddProductView: View {
    @State private var productName = ""
    @State private var productDescription = ""
    @State private var productPrice = ""
    @State private var selectedImages: [UIImage] = []
    @State private var photoItems: [PhotosPickerItem] = []
    @State private var showConfirmation = false
    @State private var uploadMessage = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Multiple Image Picker
                    PhotosPicker(selection: $photoItems, maxSelectionCount: 5, matching: .images) {
                        if selectedImages.isEmpty {
                            Image(systemName: "photo.on.rectangle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .foregroundColor(.gray)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(selectedImages, id: \.self) { image in
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                    }
                    .onChange(of: photoItems) { _, newItems in
                        Task {
                            selectedImages = []
                            for item in newItems {
                                if let data = try? await item.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImages.append(uiImage)
                                }
                            }
                        }
                    }

                    // Product Name
                    TextField("Product Name", text: $productName)
                        .padding()
                        .background(Color(.systemGray6))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1))

                    // Description
                    TextField("Description", text: $productDescription, axis: .vertical)
                        .padding()
                        .background(Color(.systemGray6))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1))

                    // Price
                    TextField("Price", text: $productPrice)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1))

                    // Submit
                    Button("Submit") {
                        uploadProduct()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(productName.isEmpty || productDescription.isEmpty || productPrice.isEmpty || selectedImages.isEmpty)
                }
                .padding()
                .alert("Server Response", isPresented: $showConfirmation) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(uploadMessage)
                }
            }
            .navigationTitle("Add Product")
        }
    }

    // MARK: - Upload Function
    func uploadProduct() {
        guard let url = URL(string: ServiceAPI.addProduct),
              let firstImage = selectedImages.first,
              let firstImageData = firstImage.jpegData(compressionQuality: 0.8) else {
            uploadMessage = "Missing data."
            showConfirmation = true
            return
        }

        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append(convertFormField(named: "name", value: productName, using: boundary))
        body.append(convertFormField(named: "description", value: productDescription, using: boundary))
        body.append(convertFormField(named: "price", value: productPrice, using: boundary))

        // Only uploading the first image — backend should handle multiple
        body.append(convertFileData(fieldName: "image", fileName: "product.jpg", mimeType: "image/jpeg", fileData: firstImageData, using: boundary))

        body.appendString("--\(boundary)--\r\n")
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    uploadMessage = "Upload failed: \(error.localizedDescription)"
                } else if let data = data,
                          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                          let status = json["status"] as? String,
                          let message = json["message"] as? String {
                    uploadMessage = "\(status.uppercased()): \(message)"
                } else {
                    uploadMessage = "Invalid server response."
                }
                showConfirmation = true
            }
        }.resume()
    }

    // MARK: - Form Helpers
    func convertFormField(named name: String, value: String, using boundary: String) -> Data {
        var field = "--\(boundary)\r\n"
        field += "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
        field += "\(value)\r\n"
        return Data(field.utf8)
    }

    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        var data = Data()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        return data
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        append(Data(string.utf8))
    }
}
