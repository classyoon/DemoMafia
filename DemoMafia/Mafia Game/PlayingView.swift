//
//  PlayingView.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/7/25.
//

import SwiftUI

struct PlayingView: View {
    @ObservedObject var game: MafiaGame
    var body: some View {
        switch game.gamephase {
        case .roleReveal:
            RoleRevealView(game: game)
        case .day:
            DayView(game: game)
        case .night:
            NightView(game: game)
        }
    }
}

#Preview {
    PlayingView(game: MafiaGame())
}
