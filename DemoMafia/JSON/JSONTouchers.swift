//
//  JSONTouchers.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/7/25.
//

import Foundation
func loadFlavorText() -> FlavorText? {
    guard let url = Bundle.main.url(forResource: "NewsPrompts", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let flavorText = try? JSONDecoder().decode(FlavorText.self, from: data) else {
        print("⚠️ Failed to load flavor text.")
        return nil
    }
    return flavorText
}
struct FlavorText: Codable {
    let gameStart: [String]
    let nothingHappen : [String]
    let murder : [String]
}
func loadAppText() -> AppText? {
    guard let url = Bundle.main.url(forResource: "AppText", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let appText = try? JSONDecoder().decode(AppText.self, from: data) else {
        print("⚠️ Failed to load app text.")
        return nil
    }
    return appText
}
struct AppText: Codable {
    let fun: [String]
    let tips : [String]
    let otherprojects : [String]
    let familyprojects : [String]
}
