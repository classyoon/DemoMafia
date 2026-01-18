import SwiftUI

struct AnonymousView_88510AE5: View {
    var body: some View {
        VStack {
            Rectangle().fill(Color.clear)
                .overlay {
                    Group {
                        VStack {
                            HStack {
                                Spacer()
                                Text("Resume")
                                Spacer()
                                Text("New Game")
                                Spacer()
                            }
                            Text("GAMES : #, TOWN : #, MAFIA : #")
                                .padding()
                                .foregroundColor(Color.primary.opacity(1))
                                .font(.caption)
                                .kerning(0.3)
                        }
                    }
                }
        }
    }
}

#Preview {
    NavigationStack {
        AnonymousView_88510AE5()
    }
}
