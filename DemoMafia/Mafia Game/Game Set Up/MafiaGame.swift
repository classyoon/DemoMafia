//
//  MafiaGame.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/12/25.
//

import Foundation
class MafiaGame: ObservableObject {
    @Published var state: GameState = .setup
    @Published var gamephase: TurnCycle = .day
    @Published var players: [Player] = []
    @Published var gameSetup = GameSetup()
    @Published var news = "Attention citizens, this is the police. Intel leads us to suspect there may be a mafia among your folk. However, we do not have the manpower to help, you are on your own."
    @Published var nightFlavor = "It's night now."
    @Published var lastnight : NightResult = .gamestarted
    var nightActions : [ChosenNightAction] = []
    var votes : [VoteAction] = []
    @Published var dayNum : Int = 1
    @Published var dayPhase : DayTime = .news
    var revealExecuted : Bool = false
    
    var premium = true
    func openGame() {
        state = .setup
    }
    
    func assignRoles() {
        guard gameSetup.isValid(for: players.count) else {
            // Handle invalid setup - too many special roles for player count
            assertionFailure("⚠️ INVALID SET UP")
            news = "Something is off with the number of folk here"
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
        guard let flavor = loadFlavorText() else {
            assertionFailure("Failed to load flavor text")
            return
        }
        if let nighttext =  flavor.night.randomElement() {
            nightFlavor = nighttext
        }
        lastnight = .nothing
        gamephase = .night
    }
    func startMorning(){
        gamephase = .day
        updateNews()
    }
    func chooseAction(for playerID: UUID, targetID: UUID?) {
        // Find that player's role
        guard let player = players.first(where: { $0.id == playerID }),
              player.isAlive else {
            return // invalid or dead
        }
        
        if gamephase == .night {
            let actionType = player.role.defaultNightAction()
            let chosen = ChosenNightAction(actorID: playerID, targetID: targetID, actionType: actionType)
            nightActions.removeAll { $0.actorID == playerID }
            nightActions.append(chosen)
        }else if gamephase == .day {
            guard let livingPlayer = players.first(where: { $0.id == targetID }),
                  livingPlayer.isAlive else {
                assertionFailure("Someone voted for a dead person somehow or nobody is alive")
                return // invalid or dead
            }
            let chosen = VoteAction(actorID: playerID, targetID: livingPlayer.id)
            votes.removeAll { $0.actorID == playerID }
            votes.append(chosen)
        }else {
            fatalError("Another game phase was added without the proper code")
        }
        
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
    func tallyVotes() {
        let executeNumber = players.count / 2 // Assuming all players are alive
        var voteCount: [UUID: Int] = [:] // Dictionary to count votes per player

        // Count the votes
        for vote in votes {
            if let targetID = vote.targetID {
                voteCount[targetID, default: 0] += 1
            }
        }

        // Find the player(s) with the most votes
        let maxVotes = voteCount.values.max() ?? 0
        let mostVoted = voteCount.filter { $0.value == maxVotes }.map { $0.key }

        // Handle results
        if mostVoted.count == 1 && maxVotes >= executeNumber {
            let executedPlayerID = mostVoted[0]
            if revealExecuted {
                news = "Player \(executedPlayerID) is executed with \(maxVotes) votes. They were a [INSERT ROLE HERE ONCE CODE IS FINISHED]"
            }else{
                news = "Player \(executedPlayerID) is executed with \(maxVotes) votes."
            }
        } else {
            news = "No one is executed. Either tie or not enough votes."
        }
        dayPhase = .results
    }

    func updateNews() {
        let defaultStatements: [NightResult: String] = [
            .nothing: "Nothing happened tonight",
            .gamestarted: "The game begins",
            .somebodiedied: "Death occurred tonight"
        ]
        
        guard let defaultText = defaultStatements[lastnight] else {
            assertionFailure("⚠️ No default statement provided for case: \(lastnight)")
            news = "The night was unclear..."
            return
        }
        news = defaultText
        assert(defaultText == "", "EMPTY STRING")
        
        guard let flavor = loadFlavorText() else {
            assertionFailure("Failed to load flavor text")
            return
        }
        
        let flavorMap: [NightResult: [String]] = [
            .nothing: flavor.nothingHappen,
            .somebodiedied: flavor.murder,
            .gamestarted: flavor.gameStart
        ]
        
        if let possibleNews = flavorMap[lastnight]?.randomElement() {
            news = possibleNews
        }
    }
    
    func startGame() {
        guard players.count > 3 else {
#if DEBUG
            assertionFailure("Start game was triggered when it shouldn't have")
#endif
            return
        }
        assignRoles()
        state = .playing
        gamephase = .day
        lastnight = .gamestarted
        updateNews()
        
    }
    
    func endGame() {
        state = .ended
    }
}

enum TurnCycle{
    case day, night
}
enum NightResult {
    case nothing, somebodiedied, gamestarted
}
enum DayTime {
    case special, news, discussion, accusations, voting, results
}
