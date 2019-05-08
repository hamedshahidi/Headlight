//
//  LocationManagerUnitTests.swift
//  HeadlightTests
//
//  Created by iosdev on 08/05/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import XCTest
import MapKit
@testable import Headlight

class LocationManagerUnitTests: XCTestCase {
    
    var course: CourseStruct.Course = CourseStruct.Course(id: "test-1", name: "Test course 1", description: "Test 1 course description", location: CourseStruct.Location(lgn: 10, ltd: 20), time: CourseStruct.Time(start: "10.10.2019", end: "10.11.2019"), organization: "Test", rating: 2.3, skills: CourseStruct.Skills(gained: [], required: []))
    
    override func setUp() {
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCoordinateInclusion() {
        let clLocation = CustomLocationManager().getCoordinatesForCourse(course)
        XCTAssert(clLocation.coordinate.latitude == 20 )
        XCTAssert(clLocation.coordinate.longitude == 10 )
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
