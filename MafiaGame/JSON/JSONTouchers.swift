//
//  JSONTouchers.swift
//  MafiaGame
//
//  Created by Conner Yoon on 4/7/25.
//

import Foundation
enum JSONLoadError: Error {
    case fileNotFound
    case dataUnreadable
    case decodingFailed
}
func loadFlavorText() -> GameText? {
    do {
        guard let url = Bundle.main.url(forResource: "GameText", withExtension: "json") else {
            throw JSONLoadError.fileNotFound
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw JSONLoadError.dataUnreadable
        }

        return try JSONDecoder().decode(GameText.self, from: data)

    } catch {
        #if DEBUG
        print("⚠️ GameText loading failed with error: \(error)")
        #endif
        return nil
    }
}


/*
 These are tasks that will allow the roles to disguise their actions. We could also use these to engage the townsfolk. We could also use these as part of a progression.
 Naturally, we will give a task for the mafia to fake. So the question "what was your task" doesn't doom a new mafia. We could also use these as a means for the mafia to disguise them talking.
 We could however use these as another source of clues.
 Unless the tasks are disabled.
 */
struct GameText: Codable {
    let gameStart: [String]
    let nothingHappen : [String]
    let murder : [String]
    let night : [String]
    let tasks : [String]
}
func loadAppText() -> AppText? {
    do {
        guard let url = Bundle.main.url(forResource: "AppText", withExtension: "json") else {
            throw JSONLoadError.fileNotFound
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw JSONLoadError.dataUnreadable
        }

        return try JSONDecoder().decode(AppText.self, from: data)

    } catch {
        print("⚠️ AppText loading failed with error: \(error)")
        return nil
    }
}

struct AppText: Codable {
    let fun: [String]
    let tips : [String]
    let otherprojects : [String]
    let familyprojects : [String]
}
