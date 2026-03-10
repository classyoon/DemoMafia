//
//  DemoMafiaTests.swift
//  DemoMafiaTests
//
//  These tests are intentionally focused on game durability:
//  - bootstrap behavior
//  - core phase transitions
//  - vote/night resolution invariants
//

import XCTest
import Foundation
@testable import MafiaParty

final class GameBootstrapTests: XCTestCase {

    func testOpenGameSeedsMinimumAndResets() {
        let game = MafiaGame()
        game.players = [Player(name: "A"), Player(name: "B"), Player(name: "C"), Player(name: "D"), Player(name: "E")]
        game.state = .ended
        game.gamephase = .night
        game.dayNum = 7
        game.dayPhase = .voting
        game.winner = .mafia
        game.victoryMessage = "old"
        game.currentActorIndex = 3
        game.selectedTargetID = UUID()

        game.openGame()

        XCTAssertEqual(game.state, .setup)
        XCTAssertEqual(game.gamephase, .day)
        XCTAssertEqual(game.dayNum, 1)
        XCTAssertEqual(game.dayPhase, .news)
        XCTAssertNil(game.winner)
        XCTAssertTrue(game.victoryMessage.isEmpty)
        XCTAssertEqual(game.currentActorIndex, 0)
        XCTAssertNil(game.selectedTargetID)
        XCTAssertEqual(game.players.count, MafiaGame.minimumPlayers)
        XCTAssertEqual(game.players.map(\.name), ["Player 1", "Player 2", "Player 3", "Player 4"])
    }

    func testStartGameTransitionsAndAssignsRoles() {
        let game = MafiaGame()
        game.openGame()

        game.startGame()

        XCTAssertEqual(game.state, .playing)
        XCTAssertEqual(game.gamephase, .roleReveal)
        XCTAssertGreaterThanOrEqual(game.players.count, MafiaGame.minimumPlayers)
        XCTAssertTrue(game.players.allSatisfy { $0.isAlive })

        let roleCounts = Dictionary(grouping: game.players.map(\.role), by: { $0 }).mapValues { $0.count }
        XCTAssertEqual(roleCounts[.mafia, default: 0], game.gameSetup.mafiaCount)
        XCTAssertEqual(roleCounts[.doctor, default: 0], game.gameSetup.doctorCount)
        XCTAssertEqual(roleCounts[.detective, default: 0], game.gameSetup.detectiveCount)
    }
}

final class NightResolutionTests: XCTestCase {

    func testUnsavedTargetDies() {
        let game = makeDeterministicNightGame()
        let mafiaID = game.players[0].id
        let targetID = game.players[3].id

        game.chooseAction(for: mafiaID, targetID: targetID)
        game.resolveNight()

        XCTAssertFalse(game.players[3].isAlive)
        XCTAssertEqual(game.dayNum, 2)
        XCTAssertEqual(game.gamephase, .day)
        XCTAssertEqual(game.dayPhase, .news)
    }

    func testDoctorSavePreventsKill() {
        let game = makeDeterministicNightGame()
        let mafiaID = game.players[0].id
        let doctorID = game.players[1].id
        let targetID = game.players[3].id

        game.chooseAction(for: mafiaID, targetID: targetID)
        game.chooseAction(for: doctorID, targetID: targetID)
        game.resolveNight()

        XCTAssertTrue(game.players[3].isAlive)
        XCTAssertEqual(game.lastnight, .nothing)
        XCTAssertEqual(game.dayNum, 2)
        XCTAssertEqual(game.gamephase, .day)
    }

    private func makeDeterministicNightGame() -> MafiaGame {
        let game = MafiaGame()
        game.openGame()
        game.state = .playing
        game.gamephase = .night
        game.dayNum = 1

        game.players[0].role = .mafia
        game.players[1].role = .doctor
        game.players[2].role = .detective
        game.players[3].role = .villager
        return game
    }
}

final class VotingResolutionTests: XCTestCase {

    func testMajorityVoteExecutesTarget() {
        let game = MafiaGame()
        game.openGame()
        game.state = .playing
        game.gamephase = .day
        game.dayPhase = .voting

        game.players[0].role = .mafia
        game.players[1].role = .doctor
        game.players[2].role = .detective
        game.players[3].role = .villager

        let targetID = game.players[3].id
        game.chooseAction(for: game.players[0].id, targetID: targetID)
        game.chooseAction(for: game.players[1].id, targetID: targetID)
        game.chooseAction(for: game.players[2].id, targetID: game.players[0].id)
        game.chooseAction(for: game.players[3].id, targetID: targetID)

        game.tallyVotes()

        XCTAssertFalse(game.players[3].isAlive)
        XCTAssertTrue(game.dayPhase == .results || game.state == .ended)
    }
}

final class AppStateIntegrationTests: XCTestCase {

    func testMakeGameCreatesReadySession() {
        let appState = AppStateManager()
        appState.makeGame()

        guard case .game(let game) = appState.state else {
            XCTFail("Expected app state to transition to `.game`.")
            return
        }

        XCTAssertEqual(game.state, .setup)
        XCTAssertEqual(game.players.count, MafiaGame.minimumPlayers)
    }
}

final class SetupValidationTests: XCTestCase {

    func testRecommendedSetupIsValidAcrossTypicalLobbySizes() {
        // Durability check:
        // Auto-balance should always produce a playable role layout.
        for players in 4...12 {
            let setup = GameSetup.recommended(for: players)
            XCTAssertTrue(
                setup.isValid(for: players, enforceBalance: true),
                "Recommended setup must be valid for \(players) players."
            )
        }
    }

    func testMafiaCapIsEnforcedWhenValidationIsOn() {
        // Product rule:
        // "Too many mafia" should be rejected by strict validation.
        let players = 8
        let tooManyMafia = GameSetup(mafiaCount: 3, detectiveCount: 1, doctorCount: 1)
        XCTAssertFalse(tooManyMafia.isValid(for: players, enforceBalance: true))
        XCTAssertTrue(tooManyMafia.isValid(for: players, enforceBalance: false))
    }

    func testStartGameAutoNormalizesIfValidationIsDisabled() {
        // Durability guard:
        // Even with nonsense input, start should normalize into a playable setup.
        let game = MafiaGame()
        game.openGame()
        game.enforceValidSetup = false
        game.gameSetup = GameSetup(mafiaCount: 50, detectiveCount: 50, doctorCount: 50)

        game.startGame()

        XCTAssertEqual(game.state, .playing)
        XCTAssertTrue(game.gameSetup.isValid(for: game.players.count, enforceBalance: false))
        let roleCounts = Dictionary(grouping: game.players.map(\.role), by: { $0 }).mapValues { $0.count }
        XCTAssertEqual(roleCounts[.mafia, default: 0], game.gameSetup.mafiaCount)
        XCTAssertEqual(roleCounts[.doctor, default: 0], game.gameSetup.doctorCount)
        XCTAssertEqual(roleCounts[.detective, default: 0], game.gameSetup.detectiveCount)
    }

    func testStartGameNormalizesBlankPlayerNames() {
        // UX durability:
        // Blank names should never leak into gameplay.
        let game = MafiaGame()
        game.openGame()
        game.players[0].name = "   "
        game.players[1].name = ""
        game.players[2].name = "Alice"
        game.players[3].name = "  Bob  "

        game.startGame()

        XCTAssertEqual(game.players[0].name, "Player 1")
        XCTAssertEqual(game.players[1].name, "Player 2")
        XCTAssertEqual(game.players[2].name, "Alice")
        XCTAssertEqual(game.players[3].name, "Bob")
    }
}
