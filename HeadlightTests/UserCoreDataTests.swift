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

    override func setUp() {
        
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
        CoreDataHelper.addToUsersSkills(skills: ["css", "js", "html"])
        
        let user = CoreDataHelper.getUserData()
        XCTAssert(user?.skills.count == 3)
        XCTAssert(user?.skills.contains("css") ?? false)
        XCTAssert(user?.skills.contains("js") ?? false)
        XCTAssert(user?.skills.contains("html") ?? false)
    }
    func testUserSkillAddingDuplicates() {
        CoreDataHelper.saveUserData(name: "Test User")
        CoreDataHelper.addToUsersSkills(skills: ["css", "js", "html"])
        CoreDataHelper.addToUsersSkills(skills: ["js", "html", "css"])
        
        let user = CoreDataHelper.getUserData()
        XCTAssert(user?.skills.count == 3)
    }
}
