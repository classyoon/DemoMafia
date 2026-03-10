import SwiftUI

struct PlayView: View {
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
                    .padding()
                Spacer()
            }
                .background {
                    Group {
                        RoundedRectangle(cornerRadius: 4, style: .continuous).fill(Color(.displayP3, red: 0.1526, green: 0.0544, blue: 0.5635, opacity: 0.8000))
                    }
                }
                .foregroundColor(Color.primary.opacity(1))
        }
    }
}

#Preview {
    NavigationStack {
        PlayView()
    }
}
