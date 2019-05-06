//
//  CourseViewUITests.swift
//  HeadlightUITests
//
//  Created by iosdev on 06/05/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import XCTest

class CourseViewUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMapPage(){
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.searchFields["Search"].tap()
        let searchbar = app.searchFields["search by subject"]
        searchbar.tap()
        searchbar.typeText("ios")
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Mobile Application Development (iOS)"]/*[[".cells.staticTexts[\"Mobile Application Development (iOS)\"]",".staticTexts[\"Mobile Application Development (iOS)\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let mapPage = scrollViewsQuery.otherElements.containing(.image, identifier:"arrow").children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.children(matching: .map).element
        XCTAssert(mapPage.exists)
    }

    func testMapBackButton(){
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.searchFields["Search"].tap()
        let searchBar = app.searchFields["search by subject"]
        searchBar.tap()
        searchBar.typeText("ios")
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Mobile Application Development (iOS)"]/*[[".cells.staticTexts[\"Mobile Application Development (iOS)\"]",".staticTexts[\"Mobile Application Development (iOS)\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        scrollViewsQuery.otherElements.containing(.image, identifier:"arrow").children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.children(matching: .map).element.tap()
        let backButton = app.navigationBars["overviewView"].buttons["Course Information"]
        XCTAssert(backButton.exists)
    }

}
