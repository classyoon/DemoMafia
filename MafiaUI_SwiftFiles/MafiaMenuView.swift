import SwiftUI

struct MafiaMenuView: View {
    var body: some View {
        VStack {
            VStack {
                Text("MAFIA")
                    .font(.system(size: 90, weight: .bold, design: .monospaced))
                    .padding()
                NavigationLink(destination: SetGameView()) {
                    RoundedRectangle(cornerRadius: 30, style: .continuous).fill(Color.green.opacity(1))
                        .overlay(RoundedRectangle(cornerRadius: 30, style: .continuous).stroke(Color(.systemBackground), lineWidth: 2))
                        .frame(width: 140, height: 70)
                        .overlay {
                            Group {
                                Text("Play")
                                    .foregroundColor(Color(.systemBackground))
                                    .font(.title2)
                            }
                        }
                        .aspectRatio(contentMode: .fit)
                        .shadow(color: Color.black.opacity(0.5), radius: 8, x: 0, y: 4)
                }
                NavigationLink(destination: EmptyView()) {
                    RoundedRectangle(cornerRadius: 30, style: .continuous).fill(Color.yellow.opacity(1))
                        .frame(width: 140, height: 70)
                        .overlay {
                            Group {
                                Text("Credits")
                                    .foregroundColor(Color(.systemBackground))
                                    .font(.title2)
                            }
                        }
                        .shadow(color: Color.black.opacity(0.5), radius: 8, x: 0, y: 4)
                }
                    .tint(Color.primary.opacity(1))
                NavigationLink(destination: EmptyView()) {
                    RoundedRectangle(cornerRadius: 30, style: .continuous).fill(Color.red.opacity(1))
                        .frame(width: 140, height: 70)
                        .overlay {
                            Group {
                                Text("Shop")
                                    .foregroundColor(Color(.systemBackground))
                                    .font(.title2)
                            }
                        }
                        .shadow(color: Color.black.opacity(0.5), radius: 8, x: 0, y: 4)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MafiaMenuView()
    }
}
