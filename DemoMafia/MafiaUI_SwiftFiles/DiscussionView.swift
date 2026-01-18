import SwiftUI

struct DiscussionView: View {
    var body: some View {
        VStack {
            VStack {
                Text("DAY")
                    .kerning(10)
                    .font(.largeTitle)
                    .padding()
                Text("Breaking News ")
                Divider()
                Text("TIME TO DISCUSS : 100 SECONDS")
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
                }
                Spacer()
                HStack {
                    Spacer()
                    Text("Next")
                        .padding()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DiscussionView()
    }
}
