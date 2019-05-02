//
//  CareerPathCoreDataTests.swift
//  HeadlightTests
//
//  Created by Tuomas Pöyry on 30/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import XCTest
@testable import Headlight

class CareerPathCoreDataTests: XCTestCase {
    var course1: CourseStruct.Course?
    var course2: CourseStruct.Course?
    var careerPath: CareerPath?

    override func setUp() {
        course1 = CourseStruct.Course(id: "test-1", name: "Test course 1", description: "Test 1 course description", location: CourseStruct.Location(lgn: 10, ltd: 20), time: CourseStruct.Time(start: "10.10.2019", end: "10.11.2019"), organization: "Test", rating: 2.3, skills: CourseStruct.Skills(gained: ["css", "js"], required: ["html"]))
        
        course2 = CourseStruct.Course(id: "test-2", name: "Test course 2", description: "Test 2 course description", location: CourseStruct.Location(lgn: 10, ltd: 20), time: CourseStruct.Time(start: "10.10.2019", end: "10.11.2019"), organization: "Test", rating: 2.3, skills: CourseStruct.Skills(gained: ["css", "js"], required: ["html"]))
        
        careerPath = CareerPath(id: nil, career: Career(name: "Test", requiredSkills: ["html", "css", "js"]), path: [course1!, course2!], missingSkills: ["html"], gainedSkills: ["css", "js"])
        
        self.tearDown()
        
        CoreDataHelper.saveCourseData(courseList: [course1!, course2!])
    }

    override func tearDown() {
        CoreDataHelper.clearCareerPathData()
        CoreDataHelper.clearCourseData()
    }
    
    func testSingleCareerPathSaving() {
        CoreDataHelper.saveCareerPath(careerPath: careerPath!)
        
        let list = CoreDataHelper.listAllCareerPaths()
        XCTAssert(list.count == 1)
        XCTAssert(list[0].career.name == careerPath?.career.name)
    }

    func testCareerPathFind() {
        CoreDataHelper.saveCareerPath(careerPath: careerPath!)
        
        let list = CoreDataHelper.listAllCareerPaths()
        
        var find = CoreDataHelper.findCareerPathByID(list[0].id!)
        XCTAssert(find != nil)
        XCTAssert(find?.id == list[0].id)
        
        find = CoreDataHelper.findCareerPathByID(UUID())
        XCTAssert(find == nil)
    }
    
    func testCareerPathCoreDataParsing() {
        CoreDataHelper.saveCareerPath(careerPath: careerPath!)
        
        let list = CoreDataHelper.listAllCareerPaths()
        
        print(list)

        let find = list[0]
        print("find")
        print(find.path)
        XCTAssert(find.career.name == careerPath!.career.name)
        XCTAssert(find.career.requiredSkills.filter { x in !careerPath!.career.requiredSkills.contains(x) }.count == 0)
        XCTAssert(find.path.count == careerPath!.path.count)
        XCTAssert(find.path[0].id == careerPath!.path[0].id)
        XCTAssert(find.gainedSkills.filter { x in !careerPath!.gainedSkills.contains(x) }.count == 0)
        XCTAssert(find.missingSkills.filter { x in !careerPath!.missingSkills.contains(x) }.count == 0)
    }
}
