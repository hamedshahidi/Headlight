//
//  CareerPathAlgorithmTests.swift
//  HeadlightTests
//
//  Created by Tuomas Pöyry on 30/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import XCTest
@testable import Headlight

class CareerPathAlgorithmTests: XCTestCase {
    var courseList: [CourseStruct.Course] = []
    var user: User = User(name: "Test", skills: ["c++"], history: [])

    override func setUp() {
        courseList = []
        
        courseList.append(CourseStruct.Course(id: "test-2", name: "Test course 2", description: "Test 2 course description", location: CourseStruct.Location(lgn: 10, ltd: 20), time: CourseStruct.Time(start: "10.10.2019", end: "10.11.2019"), organization: "Test", rating: 2.3, skills: CourseStruct.Skills(gained: ["sass", "js"], required: ["html"])))

        courseList.append(CourseStruct.Course(id: "test-1", name: "Test course 1", description: "Test 1 course description", location: CourseStruct.Location(lgn: 10, ltd: 20), time: CourseStruct.Time(start: "10.10.2019", end: "10.11.2019"), organization: "Test", rating: 2.3, skills: CourseStruct.Skills(gained: ["css", "html"], required: [])))
        
        courseList.append(CourseStruct.Course(id: "test-3", name: "Test course 3", description: "Test 3 course description", location: CourseStruct.Location(lgn: 10, ltd: 20), time: CourseStruct.Time(start: "10.10.2019", end: "10.11.2019"), organization: "Test", rating: 4.3, skills: CourseStruct.Skills(gained: ["xcode"], required: ["swift", "c++"])))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSkillInclusion() {
        XCTAssert(CareerPathAlgorithm.containsSkills(["test1", "test2"], ["test1", "test2", "test3"]))
        XCTAssert(!CareerPathAlgorithm.containsSkills(["test1", "test2", "test3"], ["test1", "test2"]))
    }
    
    func testCourseOrdering() {
        let list = CareerPathAlgorithm.orderCourseListBasedOnRequirements(courseList, user.skills, ["swift", "c++"])
        
        XCTAssert(list[0].id == "test-1")
        XCTAssert(list[1].id == "test-3")
        XCTAssert(list[2].id == "test-2")
    }
}
