//
//  RoleRevealView.swift
//  MafiaGame
//
//  Created by Claude on 1/8/26.
//

import SwiftUI

struct RoleRevealView: View {
    @ObservedObject var game: MafiaGame
    @State private var currentPlayerIndex: Int = 0
    @State private var showRole: Bool = false

    var body: some View {
        VStack(spacing: 30) {
            Text("Role Assignment")
                .font(.largeTitle)
                .fontWeight(.bold)

            Spacer()

            if currentPlayerIndex < game.players.count {
                let player = game.players[currentPlayerIndex]

                if showRole {
                    // Show the player their role
                    VStack(spacing: 24) {
                        Text(player.name)
                            .font(.title)
                            .fontWeight(.bold)

                        Text("Your role is:")
                            .font(.title3)
                            .foregroundColor(.secondary)

                        RoleIndicatorView(role: player.role)
                            .scaleEffect(1.5)

                        // Role description
                        Text(roleDescription(for: player.role))
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)

                        Spacer()

                        Button(action: {
                            moveToNextPlayer()
                        }) {
                            Text(currentPlayerIndex < game.players.count - 1 ? "Next Player" : "Start Game")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                } else {
                    // Waiting screen - pass device to next player
                    VStack(spacing: 24) {
                        Image(systemName: "hand.point.right.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)

                        Text("Pass the device to:")
                            .font(.title3)
                            .foregroundColor(.secondary)

                        Text(player.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("When you're ready, tap below to see your role")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)

                        Spacer()

                        Button(action: {
                            withAnimation {
                                showRole = true
                            }
                        }) {
                            Text("Reveal My Role")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
            } else {
                // All roles revealed, start game
                Text("All roles assigned!")
                    .font(.title)
            }

            Spacer()
        }
        .padding()
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

#Preview {
    RoleRevealView(game: MafiaGame())
}
