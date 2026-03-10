import SwiftUI

struct CreditView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Credit")
                    .font(.system(size: 90, weight: .bold, design: .monospaced))
                    .padding()
                ScrollView {
                    VStack {
                        ForEach(0..<5, id: \.self) { _ in
                            Text("Hi")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreditView()
    }
}
