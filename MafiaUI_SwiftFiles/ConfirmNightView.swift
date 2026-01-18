import SwiftUI

struct ConfirmNightView: View {
    var body: some View {
        VStack {
            Spacer()
            Circle()
            Spacer()
            VStack {
                Text("NIGHT")
                    .kerning(10)
                    .font(.largeTitle)
                Text("Has everyone taken their turn?")
                    .padding()
                HStack {
                    Spacer()
                    Text("Yes")
                    Spacer()
                    Text("Restart")
                    Spacer()
                }
            }
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        ConfirmNightView()
    }
}
