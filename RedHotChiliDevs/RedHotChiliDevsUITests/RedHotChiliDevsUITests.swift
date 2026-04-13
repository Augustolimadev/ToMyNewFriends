//
//  RedHotChiliDevsUITests.swift
//  RedHotChiliDevsUITests
//
//  Created by Augusto Lima on 13/4/2026.
//

import XCTest

final class RedHotChiliDevsUITests3: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Helper

    private func launchApp() {
        app.launch()
    }
    
    // MARK: - Artists List Tests
    func testNavigateToArtistDetailAndBack() {
        
        launchApp()
        
        // Tap first artist
        let firstCell = app.collectionViews.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
        
        // Wait for detail view
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.waitForExistence(timeout: 3))
        
        // Go back
        backButton.tap()
        
        // Verify we're back at the list
        let navigationBar = app.navigationBars["Artists"]
        XCTAssertTrue(navigationBar.exists)
    }
    
    // MARK: - Venues List Tests
    func testTapFirstVenueNavigatesToDetail() {
        
        launchApp()
        
        // Switch to Venues tab
        let venuesTab = app.tabBars.buttons["Venues"]
        venuesTab.tap()
        
        // Wait for list to load
        let firstCell = app.collectionViews.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        
        // Tap first venue
        firstCell.tap()
        
        // Verify navigation (back button appears)
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.waitForExistence(timeout: 3))
        
        // Go back
        backButton.tap()
        
        // Verify we're back at the list
        let navigationBar = app.navigationBars["Venues"]
        XCTAssertTrue(navigationBar.exists)
    }
    
    // MARK: - Pull to Refresh Tests
    func testPullToRefreshOnArtistsList() {
        
        launchApp()
        
        let list = app.collectionViews.firstMatch
        XCTAssertTrue(list.waitForExistence(timeout: 5))
        
        // Swipe down to refresh
        list.swipeDown()
        
        // List should still exist after refresh
        XCTAssertTrue(list.exists)
    }
    
    func testPullToRefreshOnVenuesList() {
        
        launchApp()
        
        // Switch to Venues tab
        let venuesTab = app.tabBars.buttons["Venues"]
        venuesTab.tap()
        
        let list = app.collectionViews.firstMatch
        XCTAssertTrue(list.waitForExistence(timeout: 5))
        
        // Swipe down to refresh
        list.swipeDown()
        
        // List should still exist after refresh
        XCTAssertTrue(list.exists)
    }
    
    // MARK: - Detail View Tests
    func testArtistDetailShowsPerformancesSection() {
        
        launchApp()
        
        // Navigate to first artist
        let firstCell = app.collectionViews.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
        
        // Wait for detail to load
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
    }
    
    func testVenueDetailShowsPerformancesSection() {
        
        launchApp()
        
        // Switch to Venues tab
        let venuesTab = app.tabBars.buttons["Venues"]
        venuesTab.tap()
        
        // Navigate to first venue
        let firstCell = app.collectionViews.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
        
        // Wait for detail to load
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
    }
    
    // MARK: - State Persistence Tests
    func testSelectedTabPersistsAcrossNavigation() {
        
        launchApp()
        
        // Switch to Venues
        let venuesTab = app.tabBars.buttons["Venues"]
        venuesTab.tap()
        
        // Navigate to a venue
        let firstCell = app.collectionViews.cells.firstMatch
        if firstCell.waitForExistence(timeout: 5) {
            firstCell.tap()
            
            // Go back
            let backButton = app.navigationBars.buttons.element(boundBy: 0)
            if backButton.waitForExistence(timeout: 3) {
                backButton.tap()
            }
        }
        
        // Venues tab should still be selected
        XCTAssertTrue(venuesTab.isSelected)
    }
    
    // MARK: - Performance Tests
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
