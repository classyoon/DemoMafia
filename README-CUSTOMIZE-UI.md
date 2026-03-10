# MafiaParty UI Customization Guide

This project now has a centralized style file so you can tweak visuals quickly without hunting through every screen.

## Primary edit points
- `DemoMafia/MafiaStyle.swift`
  - `MafiaUI.Layout`: spacing, corner radius, max width
  - `MafiaUI.Colors`: text/surface colors
  - `MafiaUI.Gradients`: per-screen background gradients
  - `MafiaPrimaryButtonStyle` and `MafiaMenuButtonStyle`: all main button behavior
  - `mafiaCard` and `mafiaContentFrame`: shared card/screen wrappers

## Screens using centralized style now
- `DemoMafia/AppSection/MenuView.swift`
- `DemoMafia/Mafia Game/Game Set Up/GameSetupView.swift`
- `DemoMafia/Mafia Game/NightView.swift`
- `DemoMafia/Mafia Game/DayView.swift`
- `DemoMafia/Mafia Game/RoleRevealView.swift`
- `DemoMafia/Mafia Game/GameEndView.swift`
- `DemoMafia/Mafia Game/PeopleListView.swift`

## Fast iteration loop
1. Change values in `DemoMafia/MafiaStyle.swift`.
2. Run:
   - `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -project DemoMafia.xcodeproj -scheme "MafiaParty-iOS" -destination "generic/platform=iOS" build`
3. Launch in Xcode using scheme `MafiaParty-iOS`.

## Text provenance helper
To inspect original committed text and current diffs for game/app text:
- `./scripts/show_text_provenance.sh`
