//
//  Models.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/5/25.
//

import Foundation

class Player {
    var name : String = ""
    var id : UUID = UUID()
    var role : PlayerRole = .civilian
    var isAlive : Bool = true
    func nightAction(targetID : UUID) -> NightAction {
        guard isAlive else {
            print("Place holder action for ghosts")
        }
        switch role {
        case .civilian:
            NightAction.visit(targetID)
        case .mafia :
            NightAction.kill(targetID)
        case .detective:
            NightAction.investigate(targetID)
        }
    }
}

class Game {
    var players : [Player] = []
    var currentPlayer : Player?
    func test() {
        guard let currentPlayer else { return }
        var target = UUID()
        guard players.contains(where: { $0.id == target }) else { return }
        currentPlayer.nightAction(targetID: target)
    }
    func kill(targetID : UUID){
    
    }
}
struct Vote {
    
}
enum NightAction {
    case kill(UUID), save(UUID), visit(UUID), investigate(UUID)
}


enum PlayerRole: String, Codable {
    case mafia
    case detective
    case civilian
}
