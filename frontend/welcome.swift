import SwiftUI

struct WelcomeView: View {
    @Binding var showUserAdminSelection: Bool

    var body: some View {
        VStack {
            Spacer()

            Image("a")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 500, height: 500)
                .padding(.bottom, 50)

            Text("Smart Dent welcomes you")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)

            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                showUserAdminSelection = true
            }
        }
    }
}
