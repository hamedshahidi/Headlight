//
//  CourseData+CoreDataProperties.swift
//  Headlight
//
//  Created by Tuomas Pöyry on 23/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//
//

import Foundation
import CoreData


extension CourseData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CourseData> {
        return NSFetchRequest<CourseData>(entityName: "Course")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var location: NSData?
    @NSManaged public var timeStart: String?
    @NSManaged public var timeEnd: String?
    @NSManaged public var skillsGained: NSData?
    @NSManaged public var skillsRequired: NSData?
    @NSManaged public var organization: String?
    @NSManaged public var rating: Double

}
