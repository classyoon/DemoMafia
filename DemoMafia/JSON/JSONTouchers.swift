//
//  JSONTouchers.swift
//  DemoMafia
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


struct GameText: Codable {
    let gameStart: [String]
    let nothingHappen : [String]
    let murder : [String]
    let night : [String]
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
        #if DEBUG
        print("⚠️ AppText loading failed with error: \(error)")
        #endif
        return nil
    }
}

struct AppText: Codable {
    let fun: [String]
    let tips : [String]
    let otherprojects : [String]
    let familyprojects : [String]
}
