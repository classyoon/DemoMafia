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
            MenuView(vm: vm)
        case .findGame:
            PlaceholderView(
                title: "Find Game",
                description: "Online matchmaking isn’t wired up yet.",
                missingItems: [
                    "Networked lobby and matchmaking",
                    "Invite/link sharing",
                    "Online game state sync"
                ],
                onBack: { vm.state = .menu }
            )
        case .settings:
            PlaceholderView(
                title: "Settings",
                description: "Settings are planned but not implemented yet.",
                missingItems: [
                    "Audio/visual preferences",
                    "Accessibility options",
                    "Saved profile or player presets"
                ],
                onBack: { vm.state = .menu }
            )
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
    func enterFindGame() {
        state = .findGame
    }
    func enterSettings(){
        state = .settings
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
