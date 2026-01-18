import SwiftUI

struct VoteView: View {
    var body: some View {
        VStack {
            VStack {
                Text("DAY")
                    .kerning(10)
                    .font(.largeTitle)
                    .padding()
                Text("Breaking News ")
                Divider()
                Text("BILL IT’S YOUR TURN TO VOTE")
                Spacer()
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
                                Text("Vote")
                                    .foregroundColor(Color.primary.opacity(1))
                            }
                        }
                }
                Spacer()
                HStack {
                    Spacer()
                    Text("Abstain")
                        .padding()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        VoteView()
    }
}
