import SwiftUI

struct SetUpGameView: View {
    var body: some View {
        VStack {
            VStack {
                Text("CREATE GAME")
                    .kerning(10)
                    .font(.largeTitle)
                    .padding()
                Divider()
                Text("Players : 5")
                VStack {
                    HStack {
                        Spacer()
                        Text("Default")
                        Spacer()
                        Text("Guess")
                        Spacer()
                    }
                    Rectangle().fill(Color.mint.opacity(1))
                        .overlay {
                            Group {
                                Text("Doctor #")
                            }
                        }
                    Rectangle().fill(Color.mint.opacity(1))
                        .overlay {
                            Group {
                                Text("Detective #")
                            }
                        }
                    Rectangle().fill(Color.mint.opacity(1))
                        .overlay {
                            Group {
                                Text("Mafia #")
                            }
                        }
                }
                    .frame(height: 120)
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 100)), count: 4)) {
                        ForEach(0..<5, id: \.self) { _ in
                            VStack {
                                Image("3A521FFB-E342-4EC4-AA08-39D55CB972E0")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 63)
                                    .cornerRadius(44)
                                    .padding()
                                Text("Hi")
                            }
                        }
                    }
                }
                HStack {
                    Spacer()
                    NavigationLink(destination: MafiaMenuView()) {
                        Text("Begin")
                            .padding()
                    }
                        .tint(Color(.quaternaryLabel))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SetUpGameView()
    }
}
