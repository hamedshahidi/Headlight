//
//  CoreDataHelper.swift
//  Headlight
//
//  Created by Tuomas Pöyry on 22/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper {
    static private let managedObjectContext = AppDelegate.viewContext

    static func saveUserData(name: String) {
        let user = getUserCoreData() ?? UserData(context: managedObjectContext)

        user.name = name
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    static func addToUsersSkills(skills: [String]) {
        let user = getUserCoreData()
    
        if let coreUser = user {
            do {
                let existingSkills = parseUserCoreDataSkills(coreUser.skills)
                let combinedSkills = Array(Set(existingSkills + skills))
                coreUser.skills = try NSKeyedArchiver.archivedData(withRootObject: combinedSkills, requiringSecureCoding: false) as NSData
            } catch {
                fatalError("Failed to save user skills")
            }
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    static private func getUserCoreData() -> UserData? {
        let userRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        
        if let list = try? managedObjectContext.fetch(userRequest) {
            if list.count <= 0 {
                return nil
            }
            return list[0]
        }

        return nil
    }
    
    // Convert skills array from Binary Data back to [String]
    static private func parseUserCoreDataSkills(_ coreSkills: NSData?) -> [String] {
        if coreSkills == nil {
            return []
        }

        var skills: [String] = []
        if let skillsData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(coreSkills! as Data) {
            skills = (skillsData ?? []) as! [String]
        }
        return skills
    }
    
    // Use only for development purposes
    static func clearUserData() {
        let user = getUserCoreData()
        if let coreUser = user {
            managedObjectContext.delete(coreUser)
        }
    }
    
    static func getUserData() -> User? {
        let user = getUserCoreData()
        
        if let coreUser = user {
            return User(name: coreUser.name ?? "Unknown", skills: parseUserCoreDataSkills(coreUser.skills))
        } else {
            return nil
        }
    }
}
