import SwiftUI

struct StoreView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Store")
                    .font(.system(size: 90, weight: .bold, design: .monospaced))
                    .padding()
                ScrollView {
                    VStack {
                        ForEach(0..<3, id: \.self) { _ in
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.green.opacity(1))
                                        .frame(height: 60)
                                    Text("John")
                                }
                                Capsule().fill(Color.red.opacity(1))
                                    .frame(width: 70, height: 50)
                                    .padding()
                                    .overlay {
                                        Group {
                                            Text("Buy")
                                                .foregroundColor(Color.primary.opacity(1))
                                        }
                                    }
                            }
                        }
                    }
                }
                HStack {
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        StoreView()
    }
}
