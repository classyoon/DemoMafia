//
//  DemoMafiaUITests.swift
//  DemoMafiaUITests
//
//  UI smoke tests for critical "new game" funnel durability.
//

import XCTest

final class DemoMafiaUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testPlayFlowStartsWithMinimumPlayers() throws {
        // Verifies startup friction is removed:
        // tapping PLAY should land on setup with at least 4 players ready.
        let app = XCUIApplication()
        app.launch()

        let playButton = app.buttons["menu.playButton"]
        XCTAssertTrue(playButton.waitForExistence(timeout: 3))
        playButton.tap()

        let playersLabel = app.staticTexts["setup.playersCountLabel"]
        XCTAssertTrue(playersLabel.waitForExistence(timeout: 3))
        let countText = playersLabel.value as? String ?? playersLabel.label
        let count = Int(countText) ?? Int(countText.filter(\.isNumber))
        XCTAssertNotNil(count, "Could not parse players count from UI text: \(countText)")
        XCTAssertGreaterThanOrEqual(count ?? 0, 4, "Expected setup to auto-seed minimum players.")
    }

    @MainActor
    func testDefaultSetupCanStartIntoRoleReveal() throws {
        // Verifies default setup is playable without extra manual setup.
        let app = XCUIApplication()
        app.launch()

        let playButton = app.buttons["menu.playButton"]
        XCTAssertTrue(playButton.waitForExistence(timeout: 3))
        playButton.tap()

        let startButton = app.buttons["setup.startGameButton"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 3))
        XCTAssertTrue(startButton.isEnabled, "Start button should be enabled with minimum roster.")
        startButton.tap()

        let roleTitle = app.staticTexts["roleReveal.title"]
        XCTAssertTrue(roleTitle.waitForExistence(timeout: 3), "Expected transition into role reveal after Start Game.")
    }

    @MainActor
    func testValidationToggleDefaultsOnAndCanBeDisabled() throws {
        // Verifies the "invalid game guardrail" starts ON but is user-controllable.
        let app = XCUIApplication()
        app.launch()

        let playButton = app.buttons["menu.playButton"]
        XCTAssertTrue(playButton.waitForExistence(timeout: 3))
        playButton.tap()

        let validationToggle = app.switches["setup.validationToggle"]
        XCTAssertTrue(validationToggle.waitForExistence(timeout: 3))
        XCTAssertEqual(validationToggle.value as? String, "1", "Validation should default to ON.")

        validationToggle.tap()
        XCTAssertEqual(validationToggle.value as? String, "0", "Validation should be user-disableable.")
    }
}
