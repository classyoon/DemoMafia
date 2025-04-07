//
//  NightView.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/7/25.
//

import SwiftUI

struct NightView: View {
    @ObservedObject var game : MafiaGame
    var body: some View {
        ScrollView {
            Text("NIGHT")
            PeopleListView(people: game.players)
            Button("Move to Day"){
                game.resolveNight()
            }
        }
    }
}

#Preview {
    NightView(game: MafiaGame())
}
