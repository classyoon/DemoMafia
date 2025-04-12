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
    }

}

// Define tests for the JSON Resource Manager
@Suite("JSON Resource Tests")
struct JSONResourceTests {
    
    // Test loading valid JSON
    @Test("FlavorText can be loaded from valid JSON file")
    func testLoadValidFlavorText() throws {
        // Arrange & Act
        let flavorText = try JSONResourceManager.load(GameText.self)
        
        // Assert
        #expect(flavorText.gameStart.count > 0)
        #expect(flavorText.nothingHappen.count > 0)
        #expect(flavorText.murder.count > 0)
        #expect(flavorText.admessage.count > 0)
    }
    
    // Test loading valid AppText
    @Test("AppText can be loaded from valid JSON file")
    func testLoadValidAppText() throws {
        // Arrange & Act
        let appText = try JSONResourceManager.load(AppText.self)
        
        // Assert
        #expect(appText.fun.count > 0)
        #expect(appText.tips.count > 0)
        #expect(appText.otherprojects.count > 0)
        #expect(appText.familyprojects.count > 0)
    }
    
    
    // Test random selection
    @Test("FlavorText random selection returns appropriate text for each type",
          arguments: [NightResult.nothing, NightResult.somebodiedied, NightResult.gamestarted])
    func testRandomSelection(nightResult: NightResult) throws {
        // Arrange
        let flavorText = try JSONResourceManager.load(GameText.self)
        
        // Act
        let randomText = flavorText.random(for: nightResult)
        
        // Assert
        switch nightResult {
        case .nothing:
            #expect(flavorText.nothingHappen.contains(randomText) || randomText == "Nothing happened tonight")
        case .somebodiedied:
            #expect(flavorText.murder.contains(randomText) || randomText == "Death occurred tonight")
        case .gamestarted:
            #expect(flavorText.gameStart.contains(randomText) || randomText == "The game begins")
        }
    }
    
    // Test caching
    @Test("Resource manager caches loaded resources")
    func testResourceCaching() throws {
        // Arrange - Load twice
        let firstLoad = try JSONResourceManager.load(GameText.self)
        let secondLoad = try JSONResourceManager.load(GameText.self)
        
        // Assert - Same instance (reference equality)
        #expect(ObjectIdentifier(firstLoad) == ObjectIdentifier(secondLoad))
    }
}
