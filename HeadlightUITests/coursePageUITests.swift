//
//  coursePageUITests.swift
//  HeadlightUITests
//
//  Created by iosdev on 07/05/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import XCTest

class coursePageUITests: XCTestCase {
    
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
    }
    
    func navigateToCoursePage(_ app: XCUIApplication, course: String) {
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.searchFields["Search"].tap()
        let searchBar = app.searchFields["search by subject"]
        searchBar.tap()
        searchBar.typeText(course)
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Creating native applications for iOS."]/*[[".cells.staticTexts[\"Creating native applications for iOS.\"]",".staticTexts[\"Creating native applications for iOS.\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    
    func testButtonMarkedAsDone() {
        let app = XCUIApplication()
        navigateToCoursePage(app, course: "ios")
        let elementsQuery = app.scrollViews.otherElements
        if elementsQuery.buttons["Already done"].exists {
            elementsQuery.buttons["Already done"].tap()
        }
        let buttonMarkAsDone = elementsQuery.buttons["Mark as done"]
        XCTAssert(buttonMarkAsDone.exists)
    }
    
    func testButtonAlreadyDone() {
        let app = XCUIApplication()
        navigateToCoursePage(app, course: "ios")
        let elementsQuery = app.scrollViews.otherElements
        if elementsQuery.buttons["Mark as done"].exists {
            elementsQuery.buttons["Mark as done"].tap()
        }
        let buttonAlreadyDone = elementsQuery.buttons["Already done"]
        XCTAssert(buttonAlreadyDone.exists)
    }
    
    func testNavigateToMapPage() {
        let app = XCUIApplication()
        navigateToCoursePage(app, course: "ios")
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.containing(.image, identifier:"arrow").children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.children(matching: .map).element.tap()
        let mapPageTitle = app.navigationBars["Location"]
        XCTAssert(mapPageTitle.exists)
    }
    
    func testCourseTitle() {
        let app = XCUIApplication()
        navigateToCoursePage(app, course: "ios")
        let elementsQuery = app.scrollViews.otherElements
        let courseTitle = elementsQuery.staticTexts["Mobile Application Development (iOS)"]
        XCTAssert(courseTitle.exists)
    }
    
    func testCourseDescription() {
        let app = XCUIApplication()
        navigateToCoursePage(app, course: "ios")
        let elementsQuery = app.scrollViews.otherElements
        let courseDescription = elementsQuery.staticTexts["Creating native applications for iOS."]
        XCTAssert(courseDescription.exists)
    }
    
    func testCourseOrganizer() {
        let app = XCUIApplication()
        navigateToCoursePage(app, course: "ios")
        let elementsQuery = app.scrollViews.otherElements
        let courseOrganizer = elementsQuery.staticTexts["Metropolia"]
        XCTAssert(courseOrganizer.exists)
    }
    
    func testCourseStartDate() {
        let app = XCUIApplication()
        navigateToCoursePage(app, course: "ios")
        let elementsQuery = app.scrollViews.otherElements
        let courseStartDate = elementsQuery.staticTexts["1-12-2019"]
        XCTAssert(courseStartDate.exists)
    }
    
    func testCourseEndDate() {
        let app = XCUIApplication()
        navigateToCoursePage(app, course: "ios")
        let elementsQuery = app.scrollViews.otherElements
        let courseEndDate = elementsQuery.staticTexts["26-1-2020"]
        XCTAssert(courseEndDate.exists)
    }
    
    func testCourseGainedSkill() {
        let app = XCUIApplication()
        navigateToCoursePage(app, course: "ios")
        let elementsQuery = app.scrollViews.otherElements
        let courseGainedSkill = elementsQuery.tables/*@START_MENU_TOKEN@*/.staticTexts["  ios  "]/*[[".cells.staticTexts[\"  ios  \"]",".staticTexts[\"  ios  \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssert(courseGainedSkill.exists)
    }
    
    func testCourseRequiredSkill() {
        let app = XCUIApplication()
        navigateToCoursePage(app, course: "ios")
        let elementsQuery = app.scrollViews.otherElements
        let courseRequiredSkill = elementsQuery.tables.staticTexts["  object-oriented-programming  "]
        XCTAssert(courseRequiredSkill.exists)
    }
}
