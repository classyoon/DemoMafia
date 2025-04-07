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
