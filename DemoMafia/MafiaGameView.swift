//
//  MafiaGameView.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/6/25.
//

import SwiftUI

struct MafiaGameView: View {
    @StateObject var vm : MafiaGame  = MafiaGame()
    var body: some View {
        switch vm.state {
        case .setup:
            GameSetupView(game: vm)
        case .playing:
            Text("Play")
        case .ended:
            Text("Over")
        }
    }
}

#Preview {
    MafiaGameView()
}
