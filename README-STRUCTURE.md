# DemoMafia Structure

## Active Runtime Scope
These folders are the active app/runtime source of truth:
- `DemoMafia/`
- `DemoMafiaTests/`
- `DemoMafiaUITests/`
- `DemoMafia.xcodeproj/`

Active shared schemes:
- `MafiaParty` (macOS)
- `MafiaParty-iOS` (iPhone/iPad)

Within `DemoMafia/`, runtime game UI and logic are in:
- `DemoMafia/Mafia Game/`
- `DemoMafia/AppSection/`
- `DemoMafia/JSON/`

## Archived (Design/Legacy)
These paths are intentionally archived and should not be part of compile/runtime:
- `Archive/LegacyTarget-ConnersMafiaIOS/`
- `Archive/DesignExports-DetailsPro/`

Archive contents include:
- Legacy `Conners Mafia IOS` file trees.
- Details Pro exports and `.detailspro` design artifact.

## Rules
- Exported design files must not live under active compile root (`DemoMafia/`).
- `MafiaUI_SwiftFiles` is design-source only and must remain archived.
- Keep design exports out of active compile root.
- Ensure project graph includes at least one iOS-capable app target.

## Validation
Run:
- `./scripts/check_structure.sh`

It fails when the structure drifts from these rules.
