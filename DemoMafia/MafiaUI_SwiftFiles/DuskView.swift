import SwiftUI

struct DuskView: View {
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(colors: [Color.red.opacity(1), Color(.displayP3, red: 0.1526, green: 0.0544, blue: 0.5635, opacity: 1.0000)], startPoint: .bottom, endPoint: .top)
                VStack {
                    Text("DUSK")
                        .kerning(10)
                        .font(.largeTitle)
                        .padding()
                    Text("Nobody was executed")
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
        DuskView()
    }
}
