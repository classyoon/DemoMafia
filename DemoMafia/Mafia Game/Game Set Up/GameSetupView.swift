//
//  GameSetupView.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/6/25.
//

import SwiftUI

struct GameSetupView: View {
    @ObservedObject var game: MafiaGame
    @ScaledMetric(relativeTo: .largeTitle) private var titleSize: CGFloat = 34

    var body: some View {
        ZStack {
            MafiaUI.Gradients.setup
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    Text("CREATE GAME")
                        .kerning(6)
                        .font(.system(size: titleSize, weight: .black, design: .rounded))
                        .foregroundColor(.white)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Game Name")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(MafiaUI.Colors.textMuted)

                        TextField("Mafia Party", text: $game.gameTitle)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.black.opacity(0.26))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(MafiaUI.Colors.cardStroke, lineWidth: 1)
                            )
                            .foregroundColor(MafiaUI.Colors.textPrimary)
                            .accessibilityIdentifier("setup.gameNameField")
                    }
                    .mafiaCard(fill: MafiaUI.Colors.cardFillSoft, stroke: MafiaUI.Colors.cardStroke, cornerRadius: 14)

                    Text("Players: \(game.players.count)")
                        .font(.headline)
                        .foregroundColor(MafiaUI.Colors.textSecondary)
                        .accessibilityIdentifier("setup.playersCountLabel")
                        .accessibilityValue("\(game.players.count)")

                    Text("Minimum players are added automatically so you can start fast.")
                        .font(.footnote)
                        .foregroundColor(MafiaUI.Colors.textMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)

                    VStack(spacing: 12) {
                        Toggle(isOn: $game.enforceValidSetup) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Enforce Valid Setup")
                                    .font(.headline)
                                    .foregroundColor(MafiaUI.Colors.textPrimary)
                                Text("On by default. Prevents overpowered role combinations.")
                                    .font(.caption)
                                    .foregroundColor(MafiaUI.Colors.textMuted)
                            }
                        }
                        .tint(.green)
                        .accessibilityIdentifier("setup.validationToggle")

                        HStack(spacing: 10) {
                            Button("Auto Balance Roles") {
                                game.autoBalanceSetup()
                                clampSetupIfNeeded()
                            }
                            .buttonStyle(MafiaPrimaryButtonStyle(fill: .blue, textColor: .white, font: .subheadline.weight(.black)))
                            .accessibilityIdentifier("setup.autoBalanceButton")

                            Text("Mafia max: \(GameSetup.maxMafiaAllowed(for: game.players.count))")
                                .font(.caption)
                                .foregroundColor(MafiaUI.Colors.textMuted)
                                .multilineTextAlignment(.trailing)
                        }

                        roleStepper("Mafia", value: $game.gameSetup.mafiaCount, range: mafiaRange, tint: .red)
                        roleStepper("Detective", value: $game.gameSetup.detectiveCount, range: detectiveRange, tint: .blue)
                        roleStepper("Doctor", value: $game.gameSetup.doctorCount, range: doctorRange, tint: .green)
                    }
                    .mafiaCard(fill: MafiaUI.Colors.cardFillSoft, stroke: MafiaUI.Colors.cardStroke, cornerRadius: 16)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Player Names")
                            .font(.headline)
                            .foregroundColor(MafiaUI.Colors.textPrimary)

                        ForEach(Array(game.players.indices), id: \.self) { index in
                            HStack(spacing: 10) {
                                Text("\(index + 1).")
                                    .font(.subheadline.weight(.bold))
                                    .foregroundColor(MafiaUI.Colors.textMuted)
                                    .frame(width: 26, alignment: .leading)

                                TextField("Player \(index + 1)", text: bindingForPlayerName(at: index))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(.black.opacity(0.22))
                                    )
                                    .foregroundColor(MafiaUI.Colors.textPrimary)
                                    .accessibilityIdentifier("setup.playerNameField.\(index + 1)")
                            }
                        }
                    }
                    .mafiaCard(fill: MafiaUI.Colors.cardFillSoft, stroke: MafiaUI.Colors.cardStroke, cornerRadius: 14)

                    Button("Add Player") {
                        game.players.append(Player(name: "Player \(game.players.count + 1)"))
                    }
                    .buttonStyle(MafiaPrimaryButtonStyle(fill: .teal, textColor: .white, font: .headline.weight(.black)))
                    .accessibilityIdentifier("setup.addPlayerButton")

                    Button("Start Game") {
                        game.startGame()
                    }
                    .buttonStyle(MafiaPrimaryButtonStyle(fill: .green, textColor: .white, font: .headline.weight(.black)))
                    .disabled(!canStart)
                    .opacity(canStart ? 1 : 0.45)
                    .accessibilityIdentifier("setup.startGameButton")
                }
                .mafiaContentFrame()
            }
        }
        .onAppear {
            game.ensureMinimumPlayers()
            clampSetupIfNeeded()
        }
        .onChange(of: game.players.count) { _ in
            clampSetupIfNeeded()
        }
        .onChange(of: game.enforceValidSetup) { _ in
            clampSetupIfNeeded()
        }
    }

    private var canStart: Bool {
        guard game.players.count >= MafiaGame.minimumPlayers else { return false }
        if game.enforceValidSetup {
            return game.gameSetup.isValid(for: game.players.count, enforceBalance: true)
        }
        return true
    }

    private var mafiaRange: ClosedRange<Int> {
        let upperBound: Int
        if game.enforceValidSetup {
            upperBound = GameSetup.maxMafiaAllowed(for: game.players.count)
        } else {
            upperBound = max(1, game.players.count - 1)
        }
        return 1...max(1, upperBound)
    }

    private var detectiveRange: ClosedRange<Int> {
        let upperBound: Int
        if game.enforceValidSetup {
            upperBound = max(0, game.players.count - game.gameSetup.mafiaCount - game.gameSetup.doctorCount - 1)
        } else {
            upperBound = max(0, game.players.count - 1)
        }
        return 0...upperBound
    }

    private var doctorRange: ClosedRange<Int> {
        let upperBound: Int
        if game.enforceValidSetup {
            upperBound = max(0, game.players.count - game.gameSetup.mafiaCount - game.gameSetup.detectiveCount - 1)
        } else {
            upperBound = max(0, game.players.count - 1)
        }
        return 0...upperBound
    }

    private func bindingForPlayerName(at index: Int) -> Binding<String> {
        Binding(
            get: { game.players[index].name },
            set: { game.players[index].name = $0 }
        )
    }

    private func clampSetupIfNeeded() {
        game.gameSetup = game.gameSetup.normalized(
            for: game.players.count,
            enforceBalanceLimit: game.enforceValidSetup
        )
    }

    private func roleStepper(
        _ title: String,
        value: Binding<Int>,
        range: ClosedRange<Int>,
        tint: Color
    ) -> some View {
        HStack {
            Text("\(title): \(value.wrappedValue)")
                .font(.headline)
                .foregroundColor(MafiaUI.Colors.textPrimary)
            Spacer()
            Stepper("", value: value, in: range)
                .labelsHidden()
                .tint(tint)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.black.opacity(0.22))
                )
        }
    }
}

struct GameSetupView_Previews: PreviewProvider {
    static var previews: some View {
    GameSetupView(game: MafiaGame())

    }
}



// Game setup configuration
struct GameSetup {
    var mafiaCount: Int = 1
    var detectiveCount: Int = 1
    var doctorCount: Int = 1

    static func maxMafiaAllowed(for playerCount: Int) -> Int {
        guard playerCount > 0 else { return 1 }
        return max(1, (playerCount - 1) / 3)
    }

    // Valid means playable and (optionally) balanced.
    func isValid(for playerCount: Int, enforceBalance: Bool = true) -> Bool {
        guard playerCount >= MafiaGame.minimumPlayers else { return false }
        guard mafiaCount >= 1 else { return false }
        guard detectiveCount >= 0, doctorCount >= 0 else { return false }

        let specialRoles = mafiaCount + detectiveCount + doctorCount
        guard specialRoles <= playerCount else { return false }
        guard (playerCount - specialRoles) >= 1 else { return false } // keep at least one villager

        if enforceBalance && mafiaCount > Self.maxMafiaAllowed(for: playerCount) {
            return false
        }

        return true
    }

    // Always returns a technically playable setup (with optional balance cap).
    func normalized(for playerCount: Int, enforceBalanceLimit: Bool) -> GameSetup {
        guard playerCount > 0 else {
            return GameSetup()
        }

        var mafia = max(1, mafiaCount)
        var detective = max(0, detectiveCount)
        var doctor = max(0, doctorCount)

        mafia = min(mafia, max(1, playerCount - 1))
        if enforceBalanceLimit {
            mafia = min(mafia, Self.maxMafiaAllowed(for: playerCount))
        }

        let maxSpecialRoles = max(1, playerCount - 1) // reserve one villager
        var overflow = (mafia + detective + doctor) - maxSpecialRoles
        if overflow > 0 {
            let doctorCut = min(doctor, overflow)
            doctor -= doctorCut
            overflow -= doctorCut
        }
        if overflow > 0 {
            let detectiveCut = min(detective, overflow)
            detective -= detectiveCut
            overflow -= detectiveCut
        }
        if overflow > 0 {
            mafia = max(1, mafia - overflow)
        }

        return GameSetup(mafiaCount: mafia, detectiveCount: detective, doctorCount: doctor)
    }

    static func recommended(for playerCount: Int) -> GameSetup {
        guard playerCount > 0 else { return GameSetup() }

        let mafia = min(maxMafiaAllowed(for: playerCount), max(1, playerCount / 4))
        let remainingAfterMafia = max(0, playerCount - mafia)
        let detective = remainingAfterMafia >= 3 ? 1 : 0
        let doctor = (remainingAfterMafia - detective) >= 3 ? 1 : 0

        return GameSetup(mafiaCount: mafia, detectiveCount: detective, doctorCount: doctor)
            .normalized(for: playerCount, enforceBalanceLimit: true)
    }
    
    // This generates and shuffles all roles needed
    func generateRoles(for playerCount: Int) -> [PlayerRole] {
        let safeSetup = normalized(for: playerCount, enforceBalanceLimit: false)
        let specialRoles = safeSetup.mafiaCount + safeSetup.detectiveCount + safeSetup.doctorCount
        guard specialRoles <= playerCount else { return [] }
        
        var roles: [PlayerRole] = []
        
        // Add special roles
        roles += Array(repeating: .mafia, count: safeSetup.mafiaCount)
        roles += Array(repeating: .detective, count: safeSetup.detectiveCount)
        roles += Array(repeating: .doctor, count: safeSetup.doctorCount)
        
        // Fill remaining with villagers
        let villagersNeeded = playerCount - roles.count
        roles += Array(repeating: .villager, count: villagersNeeded)
        
        // Shuffle roles for random assignment
        return roles.shuffled()
    }
}
