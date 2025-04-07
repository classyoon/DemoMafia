//
//  MenuView.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/7/25.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var vm : AppStateManager
    var body: some View {
        VStack{
            Text("MAFIA")
                .font(.system(size: 40, weight: .bold, design: .default))
            Text(vm.fun.description)
            Button("PLAY"){
                vm.state = AppState.game(MafiaGame())
            }
            Text(vm.tip.description)
            Button("Reroll"){
                vm.setText()
            }
        }
    }
}

#Preview {
    MenuView(vm: AppStateManager())
}
