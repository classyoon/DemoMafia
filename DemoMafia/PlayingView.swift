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
        VStack{
            Text("BEGIN")
            Text(game.news)
            Button("Reroll"){
                game.startGame()
            }
        }
    }
}

#Preview {
    PlayingView(game: MafiaGame())
}
