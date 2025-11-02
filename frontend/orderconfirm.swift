import SwiftUI

// MARK: - OrderConfirmationPage
struct OrderConfirmationPage: View {
    // This property holds the order ID passed to this view.
    let orderId: Int

    // The body property defines the content and layout of the view.
    var body: some View {
        // NavigationView provides a navigation bar at the top.
        NavigationView {
            // Center the content horizontally and vertically.
            VStack {
                // Display the confirmation message with the order ID.
                Text("Order #\(orderId) placed successfully!")
                    .font(.title2) // Set a larger font size.
                    .fontWeight(.bold) // Make the text bold.
                    .multilineTextAlignment(.center) // Center-align text if it wraps.
                    .padding() // Add some padding around the text.
            }
            .navigationTitle("Order Confirmation") // Set the title for the navigation bar.
            .navigationBarTitleDisplayMode(.inline) // Keep the title compact.
        }
    }
}

// MARK: - Preview
// This struct provides a preview of the OrderConfirmationPage in Xcode's canvas.
struct OrderConfirmationPage_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of the view with a sample orderId for the preview.
        OrderConfirmationPage(orderId: 12345)
    }
}
