import SwiftUI

struct GameOverView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Town Wins")
                    .font(.system(size: 90, weight: .bold, design: .monospaced))
                    .padding()
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
                                Capsule().fill(Color.red.opacity(1))
                                    .frame(width: 70, height: 50)
                                    .padding()
                                    .overlay {
                                        Group {
                                            Text("Town")
                                                .foregroundColor(Color.primary.opacity(1))
                                        }
                                    }
                            }
                        }
                    }
                }
                HStack {
                    Text("Play Again")
                        .padding()
                    Text("Menu")
                        .padding()
                    Text("Play Different")
                        .padding()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GameOverView()
    }
}
