import SwiftUI

struct PauseView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Paused")
                    .font(.system(size: 90, weight: .bold, design: .monospaced))
                    .padding()
                Text("It will be John’s turn")
                Divider()
                ScrollView {
                    VStack {
                        ForEach(0..<5, id: \.self) { _ in
                            HStack {
                                Image("3A521FFB-E342-4EC4-AA08-39D55CB972E0")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 63)
                                    .cornerRadius(44)
                                    .padding()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.green.opacity(1))
                                        .frame(height: 60)
                                    Text("John")
                                }
                            }
                        }
                    }
                }
                HStack {
                    Text("Resume")
                        .padding()
                    Text("Restart Game")
                        .padding()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PauseView()
    }
}
