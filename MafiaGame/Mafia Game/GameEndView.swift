//
//  GameEndView.swift
//  MafiaGame
//
//  Created by Claude on 1/8/26.
//

import SwiftUI

struct GameEndView: View {
    @ObservedObject var game: MafiaGame

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Victory icon
            Image(systemName: victoryIcon)
                .font(.system(size: 80))
                .foregroundColor(victoryColor)

            // Winner announcement
            Text(winnerText)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            // Victory message
            Text(game.victoryMessage)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Divider()
                .padding(.horizontal)

            // Final player list
            VStack(spacing: 12) {
                Text("Final Status")
                    .font(.headline)

                ForEach(game.players) { player in
                    HStack {
                        Circle()
                            .fill(player.isAlive ? Color.green : Color.red)
                            .frame(width: 12, height: 12)

                        Text(player.name)
                            .font(.body)

                        Spacer()

                        RoleIndicatorView(role: player.role)
                            .scaleEffect(0.8)

                        if !player.isAlive {
                            Text("Dead")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer()

            // Play again button
            Button(action: {
                game.openGame()
            }) {
                Text("Play Again")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }

    var victoryIcon: String {
        guard let winner = game.winner else {
            return "questionmark.circle.fill"
        }
        switch winner {
        case .mafia:
            return "exclamationmark.triangle.fill"
        case .town:
            return "checkmark.seal.fill"
        case .none:
            return "xmark.circle.fill"
        }
    }

    var victoryColor: Color {
        guard let winner = game.winner else {
            return .gray
        }
        switch winner {
        case .mafia:
            return .red
        case .town:
            return .green
        case .none:
            return .gray
        }
    }

    var winnerText: String {
        guard let winner = game.winner else {
            return "Game Over"
        }
        switch winner {
        case .mafia:
            return "Mafia Wins!"
        case .town:
            return "Town Wins!"
        case .none:
            return "Draw"
        }
    }
}

#Preview {
    GameEndView(game: MafiaGame())
}
