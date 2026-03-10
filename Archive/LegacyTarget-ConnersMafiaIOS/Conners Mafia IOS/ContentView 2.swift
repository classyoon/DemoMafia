import SwiftUI
import SwiftData

struct ContentView: View {
    // Access the model context if needed
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Welcome to Conner's Mafia")
                    .font(.title)
                    .bold()
                Text("ContentView is set up and ready.")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
