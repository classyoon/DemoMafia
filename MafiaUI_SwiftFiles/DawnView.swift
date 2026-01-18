import SwiftUI

struct DawnView: View {
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(colors: [Color.yellow.opacity(1), Color.cyan.opacity(1)], startPoint: .bottom, endPoint: .top)
                VStack {
                    Text("DAWN")
                        .kerning(10)
                        .font(.largeTitle)
                        .padding()
                    Text("The game continues")
                        .padding()
                }
                    .background {
                        Group {
                            Rectangle().fill(Color(.secondarySystemGroupedBackground).opacity(0.3))
                                .overlay(Rectangle().stroke(Color(.systemBackground).opacity(0.13), lineWidth: 2))
                        }
                    }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DawnView()
    }
}
