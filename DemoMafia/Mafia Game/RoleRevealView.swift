//
//  RoleRevealView.swift
//  DemoMafia
//
//  Created by Claude on 1/8/26.
//

import SwiftUI

struct RoleRevealView: View {
    @ObservedObject var game: MafiaGame
    @State private var currentPlayerIndex: Int = 0
    @State private var showRole: Bool = false

    var body: some View {
        ZStack {
            MafiaUI.Gradients.night
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {
                    if !game.gameTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text(game.gameTitle)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(MafiaUI.Colors.textMuted)
                    }

                    Text("Role Assignment")
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(MafiaUI.Colors.textPrimary)
                        .accessibilityIdentifier("roleReveal.title")

                    Spacer(minLength: 8)

                    if currentPlayerIndex < game.players.count {
                        let player = game.players[currentPlayerIndex]

                        if showRole {
                            VStack(spacing: 24) {
                                Text(player.name)
                                    .font(.title.weight(.bold))
                                    .foregroundColor(MafiaUI.Colors.textPrimary)

                                Text("Your role is:")
                                    .font(.title3)
                                    .foregroundColor(MafiaUI.Colors.textSecondary)

                                RoleIndicatorView(role: player.role)
                                    .scaleEffect(1.5)

                                Text(roleDescription(for: player.role))
                                    .font(.body)
                                    .foregroundColor(MafiaUI.Colors.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .mafiaCard(fill: MafiaUI.Colors.cardFill, stroke: MafiaUI.Colors.cardStroke)
                                    .padding(.horizontal)

                                Button(action: {
                                    moveToNextPlayer()
                                }) {
                                    Text(currentPlayerIndex < game.players.count - 1 ? "Next Player" : "Start Game")
                                }
                                .buttonStyle(MafiaPrimaryButtonStyle(fill: .green))
                                .padding(.horizontal)
                                .accessibilityIdentifier("roleReveal.nextPlayerButton")
                            }
                        } else {
                            VStack(spacing: 24) {
                                Image(systemName: "hand.point.right.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.blue)

                                Text("Pass the device to:")
                                    .font(.title3)
                                    .foregroundColor(MafiaUI.Colors.textSecondary)

                                Text(player.name)
                                    .font(.largeTitle.weight(.bold))
                                    .foregroundColor(MafiaUI.Colors.textPrimary)

                                Text("When you're ready, tap below to see your role")
                                    .font(.body)
                                    .foregroundColor(MafiaUI.Colors.textSecondary)
                                    .multilineTextAlignment(.center)

                                Button(action: {
                                    withAnimation {
                                        showRole = true
                                    }
                                }) {
                                    Text("Reveal My Role")
                                }
                                .buttonStyle(MafiaPrimaryButtonStyle(fill: .blue))
                                .padding(.horizontal)
                                .accessibilityIdentifier("roleReveal.revealButton")
                            }
                        }
                    } else {
                        Text("All roles assigned!")
                            .font(.title)
                            .foregroundColor(MafiaUI.Colors.textPrimary)
                    }

                    Spacer(minLength: 8)
                }
                .mafiaContentFrame()
            }
        }
    }

    private func moveToNextPlayer() {
        if currentPlayerIndex < game.players.count - 1 {
            currentPlayerIndex += 1
            showRole = false
        } else {
            // All roles revealed, continue to day phase
            game.gamephase = .day
            game.dayPhase = .news
        }
    }

    private func roleDescription(for role: PlayerRole) -> String {
        switch role {
        case .mafia:
            return "You are part of the Mafia. Each night, choose a player to eliminate. Win by equaling or outnumbering the town."
        case .doctor:
            return "You are the Doctor. Each night, choose a player to save from the Mafia's attack. You can save yourself."
        case .detective:
            return "You are the Detective. Each night, investigate a player to discover if they are Mafia or not."
        case .villager:
            return "You are a Villager. You have no special powers, but you can vote during the day to eliminate suspected Mafia members."
        }
    }
}

struct RoleRevealView_Previews: PreviewProvider {
    static var previews: some View {
    RoleRevealView(game: MafiaGame())

    }
}
