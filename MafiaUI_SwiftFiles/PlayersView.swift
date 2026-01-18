import SwiftUI

struct PlayersView: View {
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 100)), count: 2)) {
                ForEach(0..<4, id: \.self) { _ in
                    HStack {
                        VStack {
                            Image("3A521FFB-E342-4EC4-AA08-39D55CB972E0")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 63)
                                .cornerRadius(44)
                                .padding()
                            Text("Hi")
                        }
                        Text("")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PlayersView()
    }
}
