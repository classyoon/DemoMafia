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
        var app = AppStateManager()
        #expect(app.state == "menu")
        app.makeGame()
        #expect(app.state == "game")
    }

}
