//
//  NightView.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/7/25.
//

import SwiftUI

struct NightView: View {
    @ObservedObject var game: MafiaGame
    @ScaledMetric(relativeTo: .largeTitle) private var titleSize: CGFloat = 38

    var body: some View {
        ZStack {
            MafiaUI.Gradients.night
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    if !game.gameTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text(game.gameTitle)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(MafiaUI.Colors.textMuted)
                    }

                    Text("NIGHT \(game.dayNum)")
                        .kerning(7)
                        .font(.system(size: titleSize, weight: .black, design: .rounded))
                        .foregroundColor(.white)

                    Text(game.nightFlavor)
                        .font(.body)
                        .foregroundColor(MafiaUI.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .mafiaCard()

                    if game.allPlayersActed {
                        VStack(spacing: 14) {
                            Text("All players have submitted their actions")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.92))

                            Button("Resolve Night") {
                                game.resolveNight()
                            }
                            .buttonStyle(MafiaPrimaryButtonStyle(fill: .blue))
                            .accessibilityIdentifier("night.resolveButton")
                        }
                    } else if let currentPlayer = game.getCurrentActor() {
                        PlayerNightActionView(
                            game: game,
                            player: currentPlayer
                        )
                    } else {
                        Text("Error: No current player")
                            .foregroundColor(.red)
                    }
                }
                .mafiaContentFrame()
            }
        }
    }
}

struct PlayerNightActionView: View {
    @ObservedObject var game: MafiaGame
    let player: Player

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("Current Player".uppercased())
                    .font(.caption)
                    .foregroundColor(MafiaUI.Colors.textMuted)

                Text(player.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                RoleIndicatorView(role: player.role)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.white.opacity(0.1))
            .cornerRadius(12)

            Text(actionInstructions(for: player.role))
                .font(.body)
                .foregroundColor(MafiaUI.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if player.role != .villager {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Target:")
                        .font(.headline)
                        .foregroundColor(.white)

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

            Button {
                game.submitNightAction()
            }
            label: {
                Text(submitButtonText(for: player.role))
            }
            .buttonStyle(MafiaPrimaryButtonStyle(fill: canSubmit ? .green : .gray))
            .disabled(!canSubmit)
            .accessibilityIdentifier("night.submitActionButton")
        }
    }

    var eligibleTargets: [Player] {
        return game.players.filter { $0.id != player.id }
    }

    var canSubmit: Bool {
        if player.role == .villager {
            return true
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
                .foregroundColor(.white)

            Text(role.rawValue.capitalized)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(roleBadgeColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(.white.opacity(0.28), lineWidth: 1)
        )
    }

    var roleIcon: String {
        switch role {
        case .mafia: return "exclamationmark.triangle.fill"
        case .doctor: return "cross.case.fill"
        case .detective: return "magnifyingglass"
        case .villager: return "person.fill"
        }
    }

    var roleBadgeColor: Color {
        switch role {
        case .mafia: return Color(red: 0.82, green: 0.10, blue: 0.16)
        case .doctor: return Color(red: 0.05, green: 0.52, blue: 0.33)
        case .detective: return Color(red: 0.08, green: 0.40, blue: 0.82)
        case .villager: return Color(red: 0.34, green: 0.36, blue: 0.40)
        }
    }
}

struct NightView_Previews: PreviewProvider {
    static var previews: some View {
    NightView(game: MafiaGame())

    }
}
