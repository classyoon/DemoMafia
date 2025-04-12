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
struct VoteAction {
    let actorID: UUID
    let targetID: UUID?
}


