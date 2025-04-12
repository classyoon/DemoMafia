//
//  NightDraft.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/9/25.
//

import Foundation

struct PlayerAction {
    var targets : [UUID]
    var actor : UUID
}
class PlayerManager {
    var players : [Player] = []
    var actions : [PlayerAction] = []
    var currentPlayer : Player? = nil
    
    init(players: [Player] = [], actions: [PlayerAction] = [], currentPlayer: Player? = nil) {
        self.players = players
        self.actions = actions
        self.currentPlayer = players.first
    }
    func addAction(){
        currentPlayer
    }
    
    func runActions (){
//        var targets : Set<UUID> = []
//        for action in actions {
//            guard action.targets.isEmpty == false else {
//                #if DEBUG
//                return PersonError.actionCalledOnNonExistingPlayers
//                #else
//                return UUID()
//                #endif
//            }
//            action.targets.forEach { targets.insert($0) }
//            
//            
//        }
    }
}


enum PersonError : Error {
    case actionCalledWithoutActor
    case actionCalledOnNonExistingPlayers
}
