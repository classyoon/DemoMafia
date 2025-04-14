//
//  Models.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/5/25.
//

import Foundation

/*I'm getting a bit lost on player.*/
struct Avatar {
    var name : String
    var id : UUID = UUID()
    var imageURL : String = ""
}

struct Player : Identifiable {
    var name : String = ""
    var avatarURL : String = ""
    var id : UUID = UUID()
    var role : PlayerRole = .villager
    var isAlive : Bool = true
}
enum NightAction {
    case kill, save, investigate, nothing    
}

enum PlayerRole: String, Codable {
    case mafia
    case detective
    case villager
    case doctor
    
    func defaultNightAction() -> NightAction {
            switch self {
            case .mafia: return .kill
            case .doctor: return .save
            case .detective: return .investigate
            case .villager: return .nothing
            }
        }
}
struct ChosenNightAction {
    let actorID: UUID
    let targetID: UUID?
    let actionType: NightAction
}
class MafiaGame: ObservableObject {
    @Published var state: GameState = .setup
    @Published var gamephase: TurnCycle = .day
    @Published var players: [Player] = []
    @Published var gameSetup = GameSetup()
    @Published var news = "Attention citizens, this is the police. Intel leads us to suspect there may be a mafia among your folk. However, we do not have the manpower to help, you are on your own."
    @Published var lastnight : NightResult = .gamestarted
    var nightActions : [ChosenNightAction] = []
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
        nightActions = []
        lastnight = .nothing
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
    func chooseNightAction(for playerID: UUID, targetID: UUID?) {
           // Find that player's role
           guard let player = players.first(where: { $0.id == playerID }),
                 player.isAlive else {
               return // invalid or dead
           }
           
           let actionType = player.role.defaultNightAction()
           let chosen = ChosenNightAction(actorID: playerID, targetID: targetID, actionType: actionType)
           
           // Remove old action from that player if it exists, then append
           nightActions.removeAll { $0.actorID == playerID }
           nightActions.append(chosen)
       }
    
    func resolveNight() {
          // Example resolution logic:
          
          // 1) Identify all 'save' actions.
          let saves = nightActions.filter { $0.actionType == .save }
                                  .compactMap { $0.targetID }
          
          // 2) Identify all 'kill' actions.
          let kills = nightActions.filter { $0.actionType == .kill }
          
          // 3) For each kill, see if the target was saved.
          for killAction in kills {
              guard let targetID = killAction.targetID else { continue }
              // If the target is not in the saved list, kill them
              if !saves.contains(targetID) {
                  // Mark that player as dead
                  if let idx = players.firstIndex(where: { $0.id == targetID }) {
                      players[idx].isAlive = false
                      lastnight = .somebodiedied
                  }
              }
          }
          
          // 4) Investigations, etc.
          
          // 5) Move on to day
          startMorning()
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
