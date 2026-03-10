//
//  MenuView.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/7/25.
//

import SwiftUI 

struct MenuView: View {
    @ObservedObject var vm : AppStateManager
    @ScaledMetric(relativeTo: .largeTitle) private var titleSize: CGFloat = 58

    var body: some View {
        ZStack {
            MafiaUI.Gradients.menu
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer(minLength: 16)

                Text(AppConfig.appDisplayName.uppercased())
                    .font(.system(size: titleSize, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .red.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Text(vm.fun)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(MafiaUI.Colors.textSecondary)
                    .padding(.horizontal, 20)

                VStack(spacing: 12) {
                    Button("PLAY") {
                        vm.makeGame()
                    }
                    .buttonStyle(MafiaMenuButtonStyle(fill: .green))
                    .accessibilityIdentifier("menu.playButton")

                    if AppConfig.showFindGame {
                        Button("FIND GAME") {
                            vm.enterFindGame()
                        }
                        .buttonStyle(MafiaMenuButtonStyle(fill: .yellow))
                        .accessibilityIdentifier("menu.findGameButton")
                    }

                    if AppConfig.showSettings {
                        Button("SETTINGS") {
                            vm.enterSettings()
                        }
                        .buttonStyle(MafiaMenuButtonStyle(fill: .red))
                        .accessibilityIdentifier("menu.settingsButton")
                    }
                }
                .padding(.top, 10)

                if !AppConfig.showFindGame || !AppConfig.showSettings {
                    Text("Online play and settings are hidden while local gameplay is finalized.")
                        .font(.caption)
                        .foregroundColor(MafiaUI.Colors.textMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                VStack(spacing: 10) {
                    Text(vm.tip)
                        .font(.subheadline)
                        .foregroundColor(MafiaUI.Colors.textMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    Button("Reroll Tip") {
                        vm.setText()
                    }
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(.white.opacity(0.16))
                    )
                }

                Spacer()
            }
            .mafiaContentFrame()
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
    MenuView(vm: AppStateManager())

    }
}

