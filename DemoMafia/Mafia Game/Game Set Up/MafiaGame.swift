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
    @Published var winner: Winner? = nil
    @Published var victoryMessage: String = ""
    @Published var currentActorIndex: Int = 0
    @Published var selectedTargetID: UUID? = nil
    @Published var investigationResults: [InvestigationResult] = []

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
        currentActorIndex = 0
        selectedTargetID = nil
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

    func getCurrentActor() -> Player? {
        if gamephase == .day && dayPhase == .voting {
            // During voting, only consider alive players
            let alivePlayers = players.filter { $0.isAlive }
            guard currentActorIndex < alivePlayers.count else { return nil }
            return alivePlayers[currentActorIndex]
        } else {
            // During night, all players act (including dead ones who do nothing)
            guard currentActorIndex < players.count else { return nil }
            return players[currentActorIndex]
        }
    }

    func submitNightAction() {
        guard let currentPlayer = getCurrentActor() else { return }
        chooseAction(for: currentPlayer.id, targetID: selectedTargetID)
        selectedTargetID = nil
        moveToNextActor()
    }

    func moveToNextActor() {
        currentActorIndex += 1
    }

    var allPlayersActed: Bool {
        return currentActorIndex >= players.count
    }
    func startMorning(){
        gamephase = .day
        dayPhase = .news
        votes = []
        selectedTargetID = nil
        updateNews()
    }

    func startVoting() {
        dayPhase = .voting
        currentActorIndex = 0
        selectedTargetID = nil
    }

    func submitVote() {
        guard let currentPlayer = getCurrentActor() else { return }
        if let targetID = selectedTargetID {
            chooseAction(for: currentPlayer.id, targetID: targetID)
        }
        selectedTargetID = nil
        moveToNextActor()
    }

    var allPlayersVoted: Bool {
        return currentActorIndex >= players.filter({ $0.isAlive }).count
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

        // 4) Process investigations
        let investigations = nightActions.filter { $0.actionType == .investigate }
        for investigation in investigations {
            guard let targetID = investigation.targetID,
                  let target = players.first(where: { $0.id == targetID }) else {
                continue
            }

            let result = InvestigationResult(
                detectiveID: investigation.actorID,
                targetID: targetID,
                targetName: target.name,
                isMafia: target.role == .mafia,
                nightNumber: dayNum
            )
            investigationResults.append(result)
        }

        // 5) Check victory conditions
        checkVictoryConditions()

        // 6) Move on to day (if game hasn't ended)
        if state != .ended {
            dayNum += 1
            startMorning()
        }
    }
    func tallyVotes() {
        let aliveCount = players.filter { $0.isAlive }.count
        let executeNumber = aliveCount / 2 // Use only alive players for threshold
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

            // Actually execute the player
            if let idx = players.firstIndex(where: { $0.id == executedPlayerID }) {
                let executedPlayer = players[idx]
                players[idx].isAlive = false

                if revealExecuted {
                    news = "\(executedPlayer.name) is executed with \(maxVotes) votes. They were a \(executedPlayer.role.rawValue.capitalized)."
                } else {
                    news = "\(executedPlayer.name) is executed with \(maxVotes) votes."
                }
            }
        } else {
            news = "No one is executed. Either tie or not enough votes."
        }

        // Clear votes for next round
        votes = []
        dayPhase = .results

        // Check victory conditions after execution
        checkVictoryConditions()
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
        gamephase = .roleReveal
        lastnight = .gamestarted
        updateNews()

    }
    
    func endGame() {
        state = .ended
    }

    func checkVictoryConditions() {
        let alivePlayers = players.filter { $0.isAlive }
        let aliveMafia = alivePlayers.filter { $0.role == .mafia }
        let aliveNonMafia = alivePlayers.filter { $0.role != .mafia }

        // Mafia wins if they equal or outnumber non-mafia
        if aliveMafia.count >= aliveNonMafia.count && aliveMafia.count > 0 {
            winner = .mafia
            victoryMessage = "The Mafia has taken over the town! Mafia wins with \(aliveMafia.count) member(s) remaining."
            state = .ended
        }
        // Town wins if all mafia are dead
        else if aliveMafia.isEmpty && aliveNonMafia.count > 0 {
            winner = .town
            victoryMessage = "The town has eliminated all the Mafia! Town wins with \(aliveNonMafia.count) citizen(s) surviving."
            state = .ended
        }
        // If everyone is dead (edge case)
        else if alivePlayers.isEmpty {
            winner = .none
            victoryMessage = "Everyone has perished. There are no winners."
            state = .ended
        }
    }

    func getInvestigationResults(for detectiveID: UUID) -> [InvestigationResult] {
        return investigationResults.filter { $0.detectiveID == detectiveID }
    }

    func getLatestInvestigation(for detectiveID: UUID) -> InvestigationResult? {
        return investigationResults.filter { $0.detectiveID == detectiveID }.last
    }
}

enum TurnCycle{
    case roleReveal, day, night
}
enum NightResult {
    case nothing, somebodiedied, gamestarted
}
enum DayTime {
    case special, news, detectiveReport, discussion, accusations, voting, results
}
enum Winner {
    case mafia, town, none
}
