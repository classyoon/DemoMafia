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
    @Published var news = "Attention citizens, this is the police. We have recieved intel that leads us to suspect there may be a mafia among your folk. As we do not have the man power to help you, you are on your own."
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
    func startNight(){
        day = .night
    }
    func startMorning(){
        day = .day
        news = updateNews()
    }
    func updateNews()->String{
        return "Nothing happened tonight"
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
enum DayDecision {
    case accuse(UUID), vote(UUID), abstain
}
enum DayTime {
    case special, news(Bool), discussion, accusations, voting, results
}

/// Hypothetically this class would come into handy if we start having a bunch of complex rules that can create interlocking actions.
/// Like say we have vigilante role, who can fire a shot to kill, but if the person they kill isn't a mafia, they take both out.
/// We have to say somewhere that if a vigilante shoots the mafia at night, and the mafia was going to kill someone, whether
/// the vigilante kills the mafia before the mafia kills their victim. Maybe we could do that in enums?
class NightMediator {//Hypothetically.
    var events : [UUID : NightAction] = [:]
    func calculate(){
        /*
         This I imagine would be where we do all the logic for if like at the very least, if the mafia
         tries to kill someone but the doctor saves that person.
         */
    }
}
