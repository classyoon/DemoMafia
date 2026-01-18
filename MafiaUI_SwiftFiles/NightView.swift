import SwiftUI

struct NightView: View {
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Text("NIGHT")
                    .kerning(10)
                    .font(.largeTitle)
                    .padding()
                Text("You are the Mafia")
                Divider()
                Text("GOAL : TAKE THE TOWN FROM THE TOWNSFOLK WITHOUT BEING CAUGHT")
                Spacer()
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 100)), count: 2)) {
                        ForEach(0..<4, id: \.self) { _ in
                            HStack {
                                VStack {
                                    Image("3A521FFB-E342-4EC4-AA08-39D55CB972E0")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 63)
                                        .cornerRadius(44)
                                        .padding()
                                    Text("Hi")
                                }
                                Text("")
                            }
                        }
                    }
                }
                Divider()
                HStack {
                    HStack {
                        VStack {
                            Image("3A521FFB-E342-4EC4-AA08-39D55CB972E0")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 63)
                                .cornerRadius(44)
                                .padding()
                            Text("Hi")
                        }
                            .padding()
                        Text("")
                    }
                    Capsule().fill(Color.red.opacity(1))
                        .frame(width: 70, height: 50)
                        .padding()
                        .overlay {
                            Group {
                                Text("Kill")
                                    .foregroundColor(Color.primary.opacity(1))
                            }
                        }
                }
            }
                .background {
                    Group {
                        RoundedRectangle(cornerRadius: 4, style: .continuous).fill(Color(.displayP3, red: 0.1526, green: 0.0544, blue: 0.5635, opacity: 0.8000))
                        RoundedRectangle(cornerRadius: 4, style: .continuous).fill(Color(.displayP3, red: 0.1526, green: 0.0544, blue: 0.5635, opacity: 0.8000))
                    }
                }
                .foregroundColor(Color.white.opacity(1))
        }
    }
}

#Preview {
    NavigationStack {
        NightView()
    }
}
