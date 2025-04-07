//
//  DayView.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/7/25.
//

import SwiftUI

struct DayView: View {
    @ObservedObject var game : MafiaGame
    var body: some View {
        ScrollView {
            Text("BEGIN")
            Text(game.news)
            PeopleListView(people: game.players)
            Button("Reroll"){
                game.startGame()
            }
            Button("Night"){
                game.startNight()
            }
        }
    }
}

#Preview {
    DayView(game: MafiaGame())
}
