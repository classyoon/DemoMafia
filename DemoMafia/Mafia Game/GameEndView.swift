//
//  GameEndView.swift
//  DemoMafia
//
//  Created by Claude on 1/8/26.
//

import SwiftUI

struct GameEndView: View {
    @ObservedObject var game: MafiaGame
    @ScaledMetric(relativeTo: .largeTitle) private var winnerTitleSize: CGFloat = 36

    var body: some View {
        ZStack {
            MafiaUI.Gradients.end
            .ignoresSafeArea()

            VStack(spacing: 22) {
                Spacer(minLength: 10)

                Image(systemName: victoryIcon)
                    .font(.system(size: 80))
                    .foregroundColor(victoryColor)

                Text(winnerText)
                    .font(.system(size: winnerTitleSize, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text(game.victoryMessage)
                    .font(.headline)
                    .foregroundColor(MafiaUI.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(spacing: 10) {
                    Text("Final Status")
                        .font(.headline)
                        .foregroundColor(.white)

                    ForEach(game.players) { player in
                        HStack {
                            Circle()
                                .fill(player.isAlive ? Color.green : Color.red)
                                .frame(width: 10, height: 10)

                            Text(player.name)
                                .font(.body.weight(.semibold))
                                .foregroundColor(.white)

                            Spacer()

                            RoleIndicatorView(role: player.role)
                                .scaleEffect(0.8)

                            if !player.isAlive {
                                Text("Dead")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .mafiaCard(fill: MafiaUI.Colors.cardFillSoft, stroke: MafiaUI.Colors.cardStroke, cornerRadius: 16)
                .padding(.horizontal)

                Spacer()

                Button("Play Again") {
                    game.openGame()
                }
                .buttonStyle(MafiaPrimaryButtonStyle(fill: .blue, font: .headline.weight(.black)))
                .padding(.horizontal)
                .accessibilityIdentifier("end.playAgainButton")
            }
            .frame(maxWidth: 560)
            .padding(.vertical, 20)
        }
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

struct GameEndView_Previews: PreviewProvider {
    static var previews: some View {
    GameEndView(game: MafiaGame())

    }
}

