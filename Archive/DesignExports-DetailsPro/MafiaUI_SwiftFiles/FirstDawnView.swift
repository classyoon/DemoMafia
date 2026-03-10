import SwiftUI

struct FirstDawnView: View {
    var body: some View {
        VStack {
            VStack {
                Text("DAWN")
                    .kerning(10)
                    .font(.largeTitle)
                Text("The Game Begins")
            }
        }
    }
}

#Preview {
    NavigationStack {
        FirstDawnView()
    }
}
