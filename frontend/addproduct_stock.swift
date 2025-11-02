import SwiftUI
struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) { // reduced spacing
                // Logo
                Image("a") // Ensure this image is in your Assets.xcassets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, 20) // reduced top padding

                // Add Product Box
                NavigationLink(destination: AddProductView()) {
                    HomeBox(title: "Add Product", icon: "plus.circle.fill")
                }

                // Divider between boxes
                Divider()
                    .frame(height: 2)
                    .overlay(Color.gray)
                    .padding(.horizontal, 40)

                // Manage Stock Box
                NavigationLink(destination: ManageStockView()) {
                    HomeBox(title: "Manage Stock", icon: "cube.box.fill")
                }

                Spacer()
                    .padding(.bottom, 10) // reduce bottom space
            }
            .padding()
            .offset(y: -20) // shift the whole view slightly up
        }
    }
}

struct HomeBox: View {
    let title: String
    let icon: String

    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 2)
                )

            HStack(spacing: 20) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.black)

                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height * 0.2)
        .padding(.horizontal)
    }
}

