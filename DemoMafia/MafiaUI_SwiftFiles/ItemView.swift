import SwiftUI

struct ItemView: View {
    var body: some View {
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

#Preview {
    NavigationStack {
        ItemView()
    }
}
