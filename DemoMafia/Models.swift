//
//  Models.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/5/25.
//

import Foundation

/*I'm getting a bit lost on player.*/
struct Player : Identifiable {
    var name : String = ""
    var id : UUID = UUID()
    var role : PlayerRole = .villager
    var isAlive : Bool = true
    var action : NightAction = .nothing
    var target : UUID?
    var status : PlayerStatus = .done
    var needTurn : Bool {
        if isAlive && target == nil {
            return true
        }
        return false
    }
    mutating func setTarget(_ newtarget: UUID) {
        target = newtarget
    }
    mutating func resetNightAction() {
        target = nil
        status = .notchosen
    }
}
enum NightAction {
    case kill(UUID), save(UUID), visit(UUID), investigate(UUID), nothing
}
enum PlayerRole: String, Codable {
    case mafia
    case detective
    case villager
    case doctor
}
enum PlayerStatus {
    case notchosen, done, choosing
}
class MafiaGame: ObservableObject {
    @Published var state: GameState = .setup
    @Published var gamephase: TurnCycle = .day
    @Published var players: [Player] = []
    @Published var gameSetup = GameSetup()
    @Published var news = "Attention citizens, this is the police. Intel leads us to suspect there may be a mafia among your folk. However, we do not have the manpower to help, you are on your own."
    @Published var lastnight : NightResult = .gamestarted
    @Published var nightregistry : [NightAction] = []
    @Published var dayNum : Int = 1
    @Published var dayPhase : DayTime = .news
    var premium = true
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
        gamephase = .night
    }
    func startMorning(){
        if !premium {
            gamephase = .intermission("A message from our sponsor")
        }else{
            gamephase = .day
            
        }
        updateNews()
    }
    func updateNews(){
        switch lastnight {
        case .nothing:
            if let flavor = loadFlavorText() {
                news = flavor.nothingHappen.randomElement() ?? news
            }else{
                news = "Nothing happened tonight"
            }
        case .somebodiedied:
            if let flavor = loadFlavorText() {
                news = flavor.murder.randomElement() ?? news
            }else {
                news = "Death occurred tonight"
            }
        case .gamestarted:
            if let flavor = loadFlavorText() {
                news = flavor.gameStart.randomElement() ?? news
            }else {
                news = "The game begins"
            }
        }
    }
    func startGame() {
        if players.count < 4 {
            // Show error - not enough players
        } else {
          
            assignRoles()
            state = .playing
            gamephase = .day
            lastnight = .gamestarted
            updateNews()
        }
    }
    
    func endGame() {
        state = .ended
    }
}


enum TurnCycle{
    case day, intermission(String), night
}
enum DayDecision {
    case accuse(UUID), vote(UUID), abstain
}
enum NightResult {
    case nothing, somebodiedied, gamestarted
}
enum DayTime {
    case special, news, discussion, accusations, voting, results
}
