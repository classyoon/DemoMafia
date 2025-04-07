//
//  AppView.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/6/25.
//

import SwiftUI
struct AppView : View {
    @StateObject var vm : AppStateManager = AppStateManager()
    var body: some View {
        switch vm.state {
        case .menu:
            Button("PLAY"){
                vm.state = AppState.game(MafiaGame())
            }
        case .findGame:
            Text("Find game - Set up a game or find a game?")
        case .settings:
            Text("User Settings")
        case .game(let mafiaGame):
            GameSetupView(game: mafiaGame)
        }
    }
}

#Preview {
    AppView()
}

class AppStateManager : ObservableObject {
    @Published var state : AppState = .menu
    func makeGame(){
        let newGame = MafiaGame()
        newGame.openGame()
        state = .game(newGame)
    }
    func enterSettings(){
        
    }
    init(state: AppState = .menu) {
        self.state = state
    }
}

enum AppState {
    case menu, findGame, settings, game(MafiaGame)
}
