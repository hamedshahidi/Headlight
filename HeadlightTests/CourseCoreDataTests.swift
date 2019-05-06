//
//  CourseCoreDataTests.swift
//  HeadlightTests
//
//  Created by Tuomas Pöyry on 23/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import XCTest
@testable import Headlight

class CourseCoreDataTests: XCTestCase {
    var course1: CourseStruct.Course?
    var course2: CourseStruct.Course?

    override func setUp() {
        course1 = CourseStruct.Course(id: "test-1", name: "Test course 1", description: "Test 1 course description", location: CourseStruct.Location(lgn: 10, ltd: 20), time: CourseStruct.Time(start: "10.10.2019", end: "10.11.2019"), organization: "Test", rating: 2.3, skills: CourseStruct.Skills(gained: ["css", "js"], required: ["html"]))
        
        course2 = CourseStruct.Course(id: "test-2", name: "Test course 2", description: "Test 2 course description", location: CourseStruct.Location(lgn: 10, ltd: 20), time: CourseStruct.Time(start: "10.10.2019", end: "10.11.2019"), organization: "Test", rating: 2.3, skills: CourseStruct.Skills(gained: ["css", "js"], required: ["html"]))
    }

    override func tearDown() {
        CoreDataHelper.clearCourseData()
    }

    func testSingleCourseSaving() {
        CoreDataHelper.saveCourseData(course: course1!)
        
        let list = CoreDataHelper.listAllCourses()
        XCTAssert(list.count == 1)
        XCTAssert(list[0].id == "test-1")
    }
    
    func testMultipleCourseSaving() {
        CoreDataHelper.saveCourseData(courseList: [course1!, course2!])
        
        let list = CoreDataHelper.listAllCourses()
        XCTAssert(list.count == 2)
        XCTAssert(list.filter { course in course.id == "test-1" }.count > 0)
        XCTAssert(list.filter { course in course.id == "test-2" }.count > 0)
    }
    
    func testDuplicateCourseSaving() {
        CoreDataHelper.saveCourseData(courseList: [course1!, course2!, course1!])
        
        var list = CoreDataHelper.listAllCourses()
        XCTAssert(list.count == 2)
        XCTAssert(list.filter { course in course.id == "test-1" }.count > 0)
        XCTAssert(list.filter { course in course.id == "test-2" }.count > 0)
        
        course1?.name = "Edit"
        
        CoreDataHelper.saveCourseData(course: course1!)
        
        list = CoreDataHelper.listAllCourses()
        XCTAssert(list.count == 2)
        XCTAssert(list.filter { course in course.name == "Edit" }.count > 0)
        XCTAssert(list.filter { course in course.name == "Test course 2" }.count > 0)
    }
    
    func testCourseFind() {
        CoreDataHelper.saveCourseData(courseList: [course1!, course2!])
        
        var find = CoreDataHelper.findCourseByID("test-1")
        XCTAssert(find != nil)
        XCTAssert(find?.id == "test-1")
        
        find = CoreDataHelper.findCourseByID("test-2")
        XCTAssert(find != nil)
        XCTAssert(find?.id == "test-2")
        
        find = CoreDataHelper.findCourseByID("test-3")
        XCTAssert(find == nil)
    }
    
    func testCourseCoreDataParsing() {
        CoreDataHelper.saveCourseData(course: course1!)
        
        let find = CoreDataHelper.findCourseByID("test-1")
        XCTAssert(find != nil)
        XCTAssert(find?.id == "test-1")
        XCTAssert(find?.name == "Test course 1")
        XCTAssert(find?.description == "Test 1 course description")
        //XCTAssert(find?.location.lgn == 10 && find?.location.ltd == 20)
        //XCTAssert(find?.time.start == "10.10.2019" && find?.time.end == "10.11.2019")
        XCTAssert(find?.organization == "Test")
        XCTAssert(find?.rating == 2.3)
        XCTAssert(find?.skills?.gained?.count == 2 && find?.skills?.gained?.contains("css") ?? false && find?.skills?.gained?.contains("js") ?? false)
        XCTAssert(find?.skills?.required?.count == 1 && find?.skills?.required?.contains("html") ?? false)
    }
}
