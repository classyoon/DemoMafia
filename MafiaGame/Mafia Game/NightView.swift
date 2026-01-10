//
//  NightView.swift
//  MafiaGame
//
//  Created by Conner Yoon on 4/7/25.
//

import SwiftUI

struct NightView: View {
    @ObservedObject var game: MafiaGame

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("NIGHT \(game.dayNum)")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(game.nightFlavor)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Divider()

                if game.allPlayersActed {
                    // All players have acted - show resolve button
                    VStack(spacing: 16) {
                        Text("All players have submitted their actions")
                            .font(.headline)

                        Button(action: {
                            game.resolveNight()
                        }) {
                            Text("Resolve Night")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                } else if let currentPlayer = game.getCurrentActor() {
                    // Show current player's action UI
                    PlayerNightActionView(
                        game: game,
                        player: currentPlayer
                    )
                } else {
                    Text("Error: No current player")
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
    }
}

struct PlayerNightActionView: View {
    @ObservedObject var game: MafiaGame
    let player: Player

    var body: some View {
        VStack(spacing: 16) {
            // Current player indicator
            VStack(spacing: 8) {
                Text("Current Player")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(player.name)
                    .font(.title)
                    .fontWeight(.bold)

                RoleIndicatorView(role: player.role)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)

            // Action instructions
            Text(actionInstructions(for: player.role))
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Target selection
            if player.role != .villager {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Target:")
                        .font(.headline)

                    PeopleListView(
                        people: eligibleTargets,
                        selectedPlayerID: game.selectedTargetID,
                        onSelect: { targetID in
                            game.selectedTargetID = targetID
                        },
                        showOnlyAlive: true
                    )
                }
            }

            // Submit button
            Button(action: {
                game.submitNightAction()
            }) {
                Text(submitButtonText(for: player.role))
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canSubmit ? Color.green : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(!canSubmit)
            .padding(.horizontal)
        }
    }

    var eligibleTargets: [Player] {
        // Filter out the current player from their own target list
        return game.players.filter { $0.id != player.id }
    }

    var canSubmit: Bool {
        if player.role == .villager {
            return true // Villagers can always submit (no action)
        }
        return game.selectedTargetID != nil
    }

    func actionInstructions(for role: PlayerRole) -> String {
        switch role {
        case .mafia:
            return "Choose a player to eliminate tonight."
        case .doctor:
            return "Choose a player to save from the Mafia."
        case .detective:
            return "Choose a player to investigate."
        case .villager:
            return "You have no special action. Rest for the night."
        }
    }

    func submitButtonText(for role: PlayerRole) -> String {
        if role == .villager {
            return "Continue"
        }
        return "Submit Action"
    }
}

struct RoleIndicatorView: View {
    let role: PlayerRole

    var body: some View {
        HStack {
            Image(systemName: roleIcon)
                .foregroundColor(roleColor)

            Text(role.rawValue.capitalized)
                .font(.headline)
                .foregroundColor(roleColor)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(roleColor.opacity(0.2))
        .cornerRadius(8)
    }

    var roleIcon: String {
        switch role {
        case .mafia: return "exclamationmark.triangle.fill"
        case .doctor: return "cross.case.fill"
        case .detective: return "magnifyingglass"
        case .villager: return "person.fill"
        }
    }

    var roleColor: Color {
        switch role {
        case .mafia: return .red
        case .doctor: return .green
        case .detective: return .blue
        case .villager: return .gray
        }
    }
}

#Preview {
    NightView(game: MafiaGame())
}
