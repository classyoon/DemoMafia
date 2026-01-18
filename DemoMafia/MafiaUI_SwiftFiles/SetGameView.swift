import SwiftUI

struct SetGameView: View {
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
                    VStack {
                        ForEach(0..<5, id: \.self) { _ in
                            HStack {
                                Image("3A521FFB-E342-4EC4-AA08-39D55CB972E0")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 63)
                                    .cornerRadius(44)
                                    .padding()
                                    .clipShape(Circle())
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
                                            Text("X")
                                                .foregroundColor(Color.primary.opacity(1))
                                        }
                                    }
                            }
                        }
                    }
                }
                Spacer()
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
        SetGameView()
    }
}
