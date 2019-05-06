//
//  SignupUITests.swift
//  HeadlightUITests
//
//  Created by iosdev on 05/05/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import XCTest

class SignupUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments += ["UI-Testing"]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func enterUsername(_ app: XCUIApplication, _ name: String) {
        let elementsQuery = app.scrollViews.otherElements
        let usernameTextField = elementsQuery.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText(name)
        elementsQuery.buttons["Enter"].tap()
    }
    
    func waitForElementToAppear(_ element: XCUIElement) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testInvalidUsernameAlertIsShown() {
        let app = XCUIApplication()
        app.scrollViews.otherElements.buttons["Enter"].tap()
        let alert = app.alerts["Error"]
        XCTAssert(alert.exists)
    }
    
    func testInvalidUsernameAlertIsShownLongName() {
        let app = XCUIApplication()
        enterUsername(app, "Really long name to go over the allowed character count")
        let alert = app.alerts["Error"]
        XCTAssert(alert.exists)
    }
    
    func testNameEnterButtonSegue() {
        let app = XCUIApplication()
        enterUsername(app, "name")
        let title = app.staticTexts["Your skills"]
        XCTAssert(title.exists)
    }
    
    func testSkillTableViewCell() {
        let app = XCUIApplication()
        enterUsername(app, "name")
        let tableView = app.descendants(matching: .table).firstMatch
        guard let firstCell = tableView.cells.allElementsBoundByIndex.first else { return }
        XCTAssert(firstCell.isHittable)
    }
    
    func testSkillSelectNextButton() {
        let app = XCUIApplication()
        enterUsername(app, "name")
        let nextButton = app.buttons["Next"]
        XCTAssert(nextButton.isHittable)
    }
    
    func testCareerPathsExist() {
        let app = XCUIApplication()
        enterUsername(app, "name")
        let nextButton = app.buttons["Next"]
        nextButton.tap()
        let frontEnd = app.tables/*@START_MENU_TOKEN@*/.staticTexts["Front-End Developer"]/*[[".cells.staticTexts[\"Front-End Developer\"]",".staticTexts[\"Front-End Developer\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssert(frontEnd.exists)
    }
    
    func testPickCareerPath() {
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        enterUsername(app, "name")
        app.buttons["Next"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Front-End Developer"]/*[[".cells.staticTexts[\"Front-End Developer\"]",".staticTexts[\"Front-End Developer\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Pick this path"].tap()
        let career = elementsQuery.tables.staticTexts["Front-End Developer"]
        waitForElementToAppear(career)
        XCTAssert(career.exists)
    }
    
    func testCareerPathToCourseView() {
        let app = XCUIApplication()
        enterUsername(app, "name")
        let elementsQuery = app.scrollViews.otherElements
        app.buttons["Next"].tap()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Front-End Developer"]/*[[".cells.staticTexts[\"Front-End Developer\"]",".staticTexts[\"Front-End Developer\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Smart Systems 01"]/*[[".cells.staticTexts[\"Smart Systems 01\"]",".staticTexts[\"Smart Systems 01\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let desc = elementsQuery.staticTexts["Description:"]
        XCTAssert(desc.exists)
    }
    
    func testCareerPathBackButton() {
        let app = XCUIApplication()
        enterUsername(app, "name")
        app.buttons["Next"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Front-End Developer"]/*[[".cells.staticTexts[\"Front-End Developer\"]",".staticTexts[\"Front-End Developer\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Front-End Developer"].buttons["Select Career"].tap()
        let select = app.navigationBars["Select Career"].staticTexts["Select Career"]
        waitForElementToAppear(select)
        XCTAssert(select.exists)
    }

}
