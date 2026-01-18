import SwiftUI

struct StatView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Stats")
                    .font(.system(size: 90, weight: .bold, design: .monospaced))
                    .padding()
                ScrollView {
                    VStack {
                        ForEach(0..<5, id: \.self) { _ in
                            Text("Stat : #")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        StatView()
    }
}
