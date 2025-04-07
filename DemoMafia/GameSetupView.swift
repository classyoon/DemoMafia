//
//  GameSetupView.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/6/25.
//

import SwiftUI

struct GameSetupView: View {
    @ObservedObject var game: MafiaGame
    
    var body: some View {
        ScrollView {
            Text("Game Setup")
                .font(.title)
            
            // Player list
            ForEach(game.players) { player in
                Text(player.name)
            }
            
            // Add player
            Button("Add Player") {
                game.players.append(Player(name: "Player \(game.players.count + 1)"))
            }
            
            // Role configuration
            Stepper("Mafia: \(game.gameSetup.mafiaCount)",
                    value: $game.gameSetup.mafiaCount, in: 1...5)
            
            Stepper("Detectives: \(game.gameSetup.detectiveCount)",
                    value: $game.gameSetup.detectiveCount, in: 0...3)
                    
            Stepper("Doctors: \(game.gameSetup.doctorCount)",
                    value: $game.gameSetup.doctorCount, in: 0...2)
            
            // Start game button
            Button("Start Game") {
                game.startGame()
            }
            .disabled(game.players.count < 4 ||
                      !game.gameSetup.isValid(for: game.players.count))
        }
        .padding()
    }
}


#Preview {
    GameSetupView(game: MafiaGame())
}


// Game setup configuration
struct GameSetup {
    var mafiaCount: Int = 1
    var detectiveCount: Int = 1
    var doctorCount: Int = 1
    
    // This validates the configuration is possible with player count
    func isValid(for playerCount: Int) -> Bool {
        let specialRoles = mafiaCount + detectiveCount + doctorCount
        return specialRoles <= playerCount
    }
    
    // This generates and shuffles all roles needed
    func generateRoles(for playerCount: Int) -> [PlayerRole] {
        guard isValid(for: playerCount) else { return [] }
        
        var roles: [PlayerRole] = []
        
        // Add special roles
        roles += Array(repeating: .mafia, count: mafiaCount)
        roles += Array(repeating: .detective, count: detectiveCount)
        roles += Array(repeating: .doctor, count: doctorCount)
        
        // Fill remaining with villagers
        let villagersNeeded = playerCount - roles.count
        roles += Array(repeating: .villager, count: villagersNeeded)
        
        // Shuffle roles for random assignment
        return roles.shuffled()
    }
}
