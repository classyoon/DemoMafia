import SwiftUI

struct ConfirmVoteView: View {
    var body: some View {
        VStack {
            VStack {
                Text("EXECUTION")
                    .kerning(10)
                    .font(.largeTitle)
                VStack {
                }
                Text("Shall John be executed?")
                    .padding()
                HStack {
                    Spacer()
                    Text("Yes")
                    Spacer()
                    Text("Restart")
                    Spacer()
                }
            }
                .foregroundColor(Color.primary.opacity(1))
        }
    }
}

#Preview {
    NavigationStack {
        ConfirmVoteView()
    }
}
