//
//  AppView.swift
//  MafiaGame
//
//  Created by Conner Yoon on 4/6/25.
//

import SwiftUI
struct AppView : View {
    @StateObject var vm : AppStateManager = AppStateManager()
    var body: some View {
        switch vm.state {
        case .menu:
            MenuView(vm: vm)
        case .findGame:
            Text("Find game - Set up a game or find a game?")//When online
        case .settings:
            Text("User Settings")//When applicable
        case .game(let mafiaGame):
            MafiaGameView(vm: mafiaGame)
        }
    }
}

#Preview {
    AppView()
}

class AppStateManager : ObservableObject {
    @Published var state : AppState = .menu
    @Published var tip : String = ""
    @Published var fun : String = ""
    
    func makeGame(){
        let newGame = MafiaGame()
        newGame.openGame()
        state = .game(newGame)
    }
    func enterSettings(){
     //I can't think of settings yet.
    }
    init(state: AppState = .menu) {
        self.state = state
        setText()
    }
    func setText(){
        if let flavor = loadAppText() {
            tip = flavor.tips.randomElement() ?? tip
            fun = flavor.fun.randomElement() ?? fun
        }
    }
}

enum AppState {
    case menu, findGame, settings, game(MafiaGame)
}
