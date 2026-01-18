import SwiftUI

struct PlayerView: View {
    var body: some View {
        VStack {
            Image("3A521FFB-E342-4EC4-AA08-39D55CB972E0")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 63)
                .cornerRadius(44)
                .padding()
            Text("Hi")
        }
    }
}

#Preview {
    NavigationStack {
        PlayerView()
    }
}
