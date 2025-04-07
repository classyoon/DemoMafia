//
//  Models.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/5/25.
//

import Foundation

struct Player : Identifiable {
    var name : String = ""
    var id : UUID = UUID()
    var role : PlayerRole = .villager
    var isAlive : Bool = true
}
enum NightAction {
    case kill(UUID), save(UUID), visit(UUID), investigate(UUID)
}

enum PlayerRole: String, Codable {
    case mafia
    case detective
    case villager
    case doctor
}


class MafiaGame: ObservableObject {
    @Published var state: GameState = .setup
    @Published var day: TurnCycle = .day
    @Published var players: [Player] = []
    @Published var gameSetup = GameSetup()
    
    func openGame() {
        state = .setup
    }
    
    func assignRoles() {
        guard gameSetup.isValid(for: players.count) else {
            // Handle invalid setup - too many special roles for player count
            return
        }
        
        let roles = gameSetup.generateRoles(for: players.count)
        
        // Assign each role to a player
        for i in 0..<players.count {
            players[i].role = roles[i]
        }
    }
    
    func startGame() {
        if players.count < 4 {
            // Show error - not enough players
        } else {
            assignRoles()
            state = .playing
            day = .day
        }
    }
    
    func endGame() {
        state = .ended
    }
}

enum GameState : String, Codable {
    case setup
    case playing
    case ended
}
enum TurnCycle{
    case day, night
}

enum AppState {
    case menu, findGame, settings, game(MafiaGame)
}
