//
//  UserCoreDataTests.swift
//  HeadlightTests
//
//  Created by Tuomas Pöyry on 22/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import XCTest
@testable import Headlight

class UserCoreDataTests: XCTestCase {
    var user: User?
    var course1: CourseStruct.Course?
    var course2: CourseStruct.Course?

    override func setUp() {
        course1 = CourseStruct.Course(id: "test-1", name: "Test course 1", description: "Test 1 course description", location: CourseStruct.Location(lgn: 10, ltd: 20), time: CourseStruct.Time(start: "10.10.2019", end: "10.11.2019"), organization: "Test", rating: 2.3, skills: CourseStruct.Skills(gained: ["css", "js"], required: ["html"]))
        
        course2 = CourseStruct.Course(id: "test-2", name: "Test course 2", description: "Test 2 course description", location: CourseStruct.Location(lgn: 10, ltd: 20), time: CourseStruct.Time(start: "10.10.2019", end: "10.11.2019"), organization: "Test", rating: 2.3, skills: CourseStruct.Skills(gained: ["css", "js"], required: ["html"]))
    }
    
    override func tearDown() {
        CoreDataHelper.clearUserData()
    }
    
    func testUserNameSaving() {
        CoreDataHelper.saveUserData(name: "Test User")
        
        let user = CoreDataHelper.getUserData()
        XCTAssert(user?.name == "Test User")
    }
    
    func testUserSkillParsing() {
        CoreDataHelper.saveUserData(name: "Test User")
        
        let user = CoreDataHelper.getUserData()
        XCTAssert(user?.skills.count == 0)
    }
    
    func testUserSkillAdding() {
        CoreDataHelper.saveUserData(name: "Test User")
        CoreDataHelper.addToUserSkills(skills: ["css", "js", "html"])
        
        let user = CoreDataHelper.getUserData()
        XCTAssert(user?.skills.count == 3)
        XCTAssert(user?.skills.contains("css") ?? false)
        XCTAssert(user?.skills.contains("js") ?? false)
        XCTAssert(user?.skills.contains("html") ?? false)
    }

    func testUserSkillAddingDuplicates() {
        CoreDataHelper.saveUserData(name: "Test User")
        CoreDataHelper.addToUserSkills(skills: ["css", "js", "html"])
        CoreDataHelper.addToUserSkills(skills: ["js", "html", "css"])
        
        let user = CoreDataHelper.getUserData()
        XCTAssert(user?.skills.count == 3)
    }
    
    func testUserHistoryAdding() {
        CoreDataHelper.saveUserData(name: "Test User")
        CoreDataHelper.addToUserHistory(course1!)
        
        var user = CoreDataHelper.getUserData()
        XCTAssert(user?.history.count == 1)
        XCTAssert(user?.history.contains(course1?.id ?? "") ?? false)
        
        CoreDataHelper.addToUserHistory(course2!)
        
        user = CoreDataHelper.getUserData()
        XCTAssert(user?.history.count == 2)
        XCTAssert(user?.history[0] == course1?.id)
        XCTAssert(user?.history[1] == course2?.id)
    }
    
    func testUserHistoryAddingDuplicates() {
        CoreDataHelper.saveUserData(name: "Test User")
        CoreDataHelper.addToUserHistory(course2!)
        CoreDataHelper.addToUserHistory(course2!)
        
        let user = CoreDataHelper.getUserData()
        XCTAssert(user?.history.count == 1)
    }
}
