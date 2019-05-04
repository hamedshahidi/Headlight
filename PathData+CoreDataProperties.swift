//
//  PathData+CoreDataProperties.swift
//  Headlight
//
//  Created by Tuomas Pöyry on 02/05/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//
//

import Foundation
import CoreData


extension PathData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PathData> {
        return NSFetchRequest<PathData>(entityName: "Path")
    }

    @NSManaged public var gainedSkills: NSData?
    @NSManaged public var id: UUID?
    @NSManaged public var missingSkills: NSData?
    @NSManaged public var name: String?
    @NSManaged public var requiredSkills: NSData?
    @NSManaged public var timeCreated: NSDate?
    @NSManaged public var courseList: NSOrderedSet?

}

// MARK: Generated accessors for courseList
extension PathData {

    @objc(insertObject:inCourseListAtIndex:)
    @NSManaged public func insertIntoCourseList(_ value: CourseData, at idx: Int)

    @objc(removeObjectFromCourseListAtIndex:)
    @NSManaged public func removeFromCourseList(at idx: Int)

    @objc(insertCourseList:atIndexes:)
    @NSManaged public func insertIntoCourseList(_ values: [CourseData], at indexes: NSIndexSet)

    @objc(removeCourseListAtIndexes:)
    @NSManaged public func removeFromCourseList(at indexes: NSIndexSet)

    @objc(replaceObjectInCourseListAtIndex:withObject:)
    @NSManaged public func replaceCourseList(at idx: Int, with value: CourseData)

    @objc(replaceCourseListAtIndexes:withCourseList:)
    @NSManaged public func replaceCourseList(at indexes: NSIndexSet, with values: [CourseData])

    @objc(addCourseListObject:)
    @NSManaged public func addToCourseList(_ value: CourseData)

    @objc(removeCourseListObject:)
    @NSManaged public func removeFromCourseList(_ value: CourseData)

    @objc(addCourseList:)
    @NSManaged public func addToCourseList(_ values: NSOrderedSet)

    @objc(removeCourseList:)
    @NSManaged public func removeFromCourseList(_ values: NSOrderedSet)

}
