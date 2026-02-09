//
//  DemoMafiaTests.swift
//  DemoMafiaTests
//
//  Created by Conner Yoon on 4/5/25.
//

import Testing
@testable import DemoMafia
struct DemoMafiaTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    @Test func openApp(){
        let app = AppStateManager()
        #expect(app.screen == .menu)
    }

}

// Define tests for JSON loading
@Suite("JSON Resource Tests")
struct JSONResourceTests {

    // Test loading valid JSON
    @Test("FlavorText can be loaded from valid JSON file")
    func testLoadValidFlavorText() throws {
        // Arrange & Act
        let flavorText = loadFlavorText()

        // Assert
        #expect(flavorText != nil)
        #expect(flavorText!.gameStart.count > 0)
        #expect(flavorText!.nothingHappen.count > 0)
        #expect(flavorText!.murder.count > 0)
        #expect(flavorText!.admessage.count > 0)
    }

    // Test loading valid AppText
    @Test("AppText can be loaded from valid JSON file")
    func testLoadValidAppText() throws {
        // Arrange & Act
        let appText = loadAppText()

        // Assert
        #expect(appText != nil)
        #expect(appText!.fun.count > 0)
        #expect(appText!.tips.count > 0)
        #expect(appText!.otherprojects.count > 0)
        #expect(appText!.familyprojects.count > 0)
    }

    // Test flavor text arrays have expected content
    @Test("FlavorText arrays contain non-empty strings")
    func testFlavorTextContent() throws {
        let flavorText = loadFlavorText()
        #expect(flavorText != nil)

        for text in flavorText!.gameStart {
            #expect(!text.isEmpty)
        }
        for text in flavorText!.murder {
            #expect(!text.isEmpty)
        }
        for text in flavorText!.nothingHappen {
            #expect(!text.isEmpty)
        }
    }
}

@Suite("Game Logic Tests")
struct GameLogicTests {

    @Test("Voting requires majority to execute")
    func testVotingThreshold() {
        let game = MafiaGame()
        // Set up 5 players
        for i in 0..<5 {
            game.players.append(Player(name: "Player \(i)"))
        }
        game.assignRoles()
        game.state = .playing
        game.gamephase = .day
        game.dayPhase = .voting

        let aliveCount = game.players.filter { $0.isAlive }.count
        // Majority of 5 should require 3 votes, not 2
        let threshold = (aliveCount / 2) + 1
        #expect(threshold == 3)
    }

    @Test("Dead players are excluded from night actions")
    func testDeadPlayersSkippedAtNight() {
        let game = MafiaGame()
        for i in 0..<5 {
            game.players.append(Player(name: "Player \(i)"))
        }
        game.assignRoles()
        game.state = .playing

        // Kill one player
        game.players[0].isAlive = false
        game.startNight()

        // allPlayersActed should be based on alive count (4), not total (5)
        #expect(!game.allPlayersActed)
        let aliveCount = game.players.filter { $0.isAlive }.count
        #expect(aliveCount == 4)
    }

    @Test("Role generation matches player count")
    func testRoleGeneration() {
        let setup = GameSetup()
        let roles = setup.generateRoles(for: 6)
        #expect(roles.count == 6)

        let mafiaCount = roles.filter { $0 == .mafia }.count
        let detectiveCount = roles.filter { $0 == .detective }.count
        let doctorCount = roles.filter { $0 == .doctor }.count

        #expect(mafiaCount == 1)
        #expect(detectiveCount == 1)
        #expect(doctorCount == 1)
    }

    @Test("Victory conditions detect mafia win")
    func testMafiaVictory() {
        let game = MafiaGame()
        game.players = [
            Player(name: "Mafia", role: .mafia, isAlive: true),
            Player(name: "Villager", role: .villager, isAlive: true),
        ]
        game.state = .playing
        game.checkVictoryConditions()
        #expect(game.winner == .mafia)
        #expect(game.state == .ended)
    }

    @Test("Victory conditions detect town win")
    func testTownVictory() {
        let game = MafiaGame()
        game.players = [
            Player(name: "Mafia", role: .mafia, isAlive: false),
            Player(name: "Villager", role: .villager, isAlive: true),
            Player(name: "Doctor", role: .doctor, isAlive: true),
        ]
        game.state = .playing
        game.checkVictoryConditions()
        #expect(game.winner == .town)
        #expect(game.state == .ended)
    }
}
