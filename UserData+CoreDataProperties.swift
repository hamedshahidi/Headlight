//
//  UserData+CoreDataProperties.swift
//  Headlight
//
//  Created by Tuomas Pöyry on 02/05/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var skills: NSData?

}
