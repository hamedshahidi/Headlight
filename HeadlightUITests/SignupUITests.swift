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
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInvalidUsernameAlertIsShown() {
        let app = XCUIApplication()
        app.scrollViews.otherElements.buttons["Enter"].tap()
        let alert = app.alerts["Error"]
        XCTAssert(alert.exists)
    }
    
    func testNameEnterButtonSegue() {
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        let usernameTextField = elementsQuery.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("name")
        elementsQuery.buttons["Enter"].tap()
        let title = app.staticTexts["Your skills"]
        XCTAssert(title.exists)
    }
    
    func testSkillTableViewCell() {
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        let usernameTextField = elementsQuery.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("name")
        elementsQuery.buttons["Enter"].tap()
        let tableView = app.descendants(matching: .table).firstMatch
        guard let firstCell = tableView.cells.allElementsBoundByIndex.first else { return }
        XCTAssert(firstCell.isHittable)
    }
    
    func testSkillSelectNextButton() {
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        let usernameTextField = elementsQuery.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("name")
        elementsQuery.buttons["Enter"].tap()
        let nextButton = app.buttons["Next"]
        XCTAssert(nextButton.isHittable)
    }

}
