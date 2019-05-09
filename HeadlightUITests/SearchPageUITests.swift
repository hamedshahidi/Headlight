//
//  SearchPageUITests.swift
//  HeadlightUITests
//
//  Created by iosdev on 06/05/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import XCTest

class SearchPageUITests: XCTestCase {
    // var user: User = User(name: "Test", skills: ["c++"], history: [])

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments += ["UI-Testing", "UI-User"]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchBar() {
        
        let app = XCUIApplication()
        app.scrollViews.otherElements.searchFields["Search"].tap()
        let searchbar = app.searchFields["Search by course or subject"]
        XCTAssert(searchbar.exists)
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSearchResult() {
        let app = XCUIApplication()
        app.scrollViews.otherElements.searchFields["Search"].tap()
        let searchBar = app.searchFields["Search by course or subject"]
        searchBar.tap()
        searchBar.typeText("ios")
        XCTAssert(app.tables.staticTexts["Mobile Application Development (iOS)"].exists)
        
    }
    
    func testBackToFrontPage() {
        let app = XCUIApplication()
        let frontPageSearchBar = app.scrollViews.otherElements.searchFields["Search"]
        frontPageSearchBar.tap()
        // Back button
        XCUIApplication().navigationBars.buttons.element.tap()
        XCTAssertTrue(frontPageSearchBar.exists)
    }
    
    func testCancelButton(){
        let app = XCUIApplication()
        app.scrollViews.otherElements.searchFields["Search"].tap()
        let searchBySubjectSearchField = app.searchFields["Search by course or subject"]
        searchBySubjectSearchField.tap()
        searchBySubjectSearchField.typeText("ios")
        searchBySubjectSearchField.buttons["Clear text"].tap()
        XCTAssert(!app.tables.staticTexts["Mobile Application Development (iOS)"].exists)
        
    }

}
