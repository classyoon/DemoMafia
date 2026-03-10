//
//  MafiaGameView.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/6/25.
//

import SwiftUI
enum GameState : String, Codable, Equatable {
    case setup
    case playing
    case ended
}
struct MafiaGameView: View {
    @ObservedObject var vm : MafiaGame
    var body: some View {
        switch vm.state {
        case .setup:
            GameSetupView(game: vm)
        case .playing:
            PlayingView(game: vm)
        case .ended:
            GameEndView(game: vm)
        }
    }
}

struct MafiaGameView_Previews: PreviewProvider {
    static var previews: some View {
    MafiaGameView(vm: MafiaGame())

    }
}

