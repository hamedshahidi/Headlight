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

    static private func save() {
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failed to save core data \(error).")
        }
    }
    
    static func saveUserData(name: String) {
        let user = getUserCoreData() ?? UserData(context: managedObjectContext)

        user.name = name
        
        self.save()
    }
    
    static func addToUsersSkills(skills: [String]) {
        let user = getUserCoreData()
    
        if let coreUser = user {
            let existingSkills = parseFromCoreDataSkills(coreUser.skills)
            let combinedSkills = Array(Set(existingSkills + skills))
            coreUser.skills = convertToCoreDataSkills(combinedSkills)
        }
        
        self.save()
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
    
    // Use only for development purposes
    static func clearUserData() {
        let user = getUserCoreData()
        if let coreUser = user {
            managedObjectContext.delete(coreUser)
        }
        
        self.save()
    }
    
    static func getUserData() -> User? {
        let user = getUserCoreData()
        
        if let coreUser = user {
            return User(name: coreUser.name ?? "Unknown", skills: parseFromCoreDataSkills(coreUser.skills))
        } else {
            return nil
        }
    }
    
    static private func saveSingleCourseData(_ course: CourseStruct.Course) {
        if let courseId = course.id {
            let courseCore = findCourseCoreDataByID(courseId) ?? CourseData(context: managedObjectContext)
            
            courseCore.id = courseId
            courseCore.name = course.name ?? "Unkown"
            courseCore.desc = course.description ?? "Data for this course is missing."
            courseCore.location = convertToCoreDataLocation(course.location)
            courseCore.timeEnd = course.time?.end
            courseCore.timeStart = course.time?.start
            courseCore.organization = course.organization
            courseCore.rating = course.rating ?? 0
            courseCore.skillsGained = convertToCoreDataSkills(course.skills?.gained ?? [])
            courseCore.skillsRequired = convertToCoreDataSkills(course.skills?.required ?? [])
        }
    }
    
    // Save a single course
    static func saveCourseData(course: CourseStruct.Course) {
        saveSingleCourseData(course)
        self.save()
    }
    
    // Save multiple courses
    static func saveCourseData(courseList: [CourseStruct.Course]) {
        for course in courseList {
            saveSingleCourseData(course)
        }
        self.save()
    }
    
    static private func findCourseCoreDataByID(_ id: String) -> CourseData? {
        let courseRequest: NSFetchRequest<CourseData> = CourseData.fetchRequest()
        courseRequest.predicate = NSPredicate(format: "id = %@", id)
        
        if let list = try? managedObjectContext.fetch(courseRequest) {
            if list.count <= 0 {
                return nil
            }
            return list[0]
        }
        
        return nil
    }
    
    static func findCourseByID(_ id: String) -> CourseStruct.Course? {
        let course = findCourseCoreDataByID(id)
        
        if let coreCourse = course {
            return parseFromCoreDataCourse(coreCourse)
        } else {
            return nil
        }
    }
    
    static func listAllCourses() -> [CourseStruct.Course] {
        let courseRequest: NSFetchRequest<CourseData> = CourseData.fetchRequest()
        
        if let list = try? managedObjectContext.fetch(courseRequest) {
            return list.map { course in parseFromCoreDataCourse(course) }
        }
        
        return []
    }
    
    // Use only for development purposes
    static func clearCourseData() {
        let courseRequest: NSFetchRequest<CourseData> = CourseData.fetchRequest()
        
        if let list = try? managedObjectContext.fetch(courseRequest) {
            for course in list {
                managedObjectContext.delete(course)
            }
        }
        
        self.save()
    }
    
    static func saveCareerPath(careerPath: CareerPath) {
        let careerPathData = PathData(context: managedObjectContext)
        
        careerPathData.id = UUID()
        careerPathData.name = careerPath.career.name
        careerPathData.requiredSkills = self.convertToCoreDataSkills(careerPath.career.requiredSkills)
        careerPathData.gainedSkills = self.convertToCoreDataSkills(careerPath.gainedSkills)
        careerPathData.missingSkills = self.convertToCoreDataSkills(careerPath.missingSkills)
        careerPathData.timeCreated = Date() as NSDate
        
        var courseList: [CourseData] = []
        for course in careerPath.path {
            if let courseData = self.findCourseCoreDataByID(course.id ?? "") {
                courseList.append(courseData)
            }
        }
        
        careerPathData.courseList = NSOrderedSet(array: courseList)
        
        self.save()
    }
    
    static func listAllCareerPaths() -> [CareerPath] {
        let careerPathRequest: NSFetchRequest<PathData> = PathData.fetchRequest()
        
        if let list = try? managedObjectContext.fetch(careerPathRequest) {
            return list.map { careerPath in parseFromCoreDataCareerPath(careerPath) }
        }
        
        return []
    }
    
    static private func findCareerPathCoreDataByID(_ id: UUID) -> PathData? {
        let careerPathRequest: NSFetchRequest<PathData> = PathData.fetchRequest()
        careerPathRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        if let list = try? managedObjectContext.fetch(careerPathRequest) {
            if list.count <= 0 {
                return nil
            }
            return list[0]
        }
        
        return nil
    }
    
    static func findCareerPathByID(_ id: UUID) -> CareerPath? {
        let careerPath = findCareerPathCoreDataByID(id)
        
        if let coreCareerPath = careerPath {
            return parseFromCoreDataCareerPath(coreCareerPath)
        } else {
            return nil
        }
    }
    
    static private func removeCareerPathCoreByID(_ id: UUID) {
        let careerPath = findCareerPathCoreDataByID(id)
        
        if let coreCareerPath = careerPath {
            for course in coreCareerPath.courseList ?? [] {
                (course as! CourseData).careerPaths?.removeFromCourseList(course as! CourseData)
            }
            managedObjectContext.delete(coreCareerPath)
        }
    }
    
    static func removeCareerPathByID(_ id: UUID) {
        removeCareerPathCoreByID(id)
        self.save()
    }
    
    // Use only for development purposes
    static func clearCareerPathData() {
        let careerPathRequest: NSFetchRequest<PathData> = PathData.fetchRequest()
        
        if let list = try? managedObjectContext.fetch(careerPathRequest) {
            for careerPath in list {
                removeCareerPathCoreByID(careerPath.id!)
            }
        }
        
        self.save()
    }

    // Convert skills array from Binary Data back to [String]
    static private func parseFromCoreDataSkills(_ coreSkills: NSData?) -> [String] {
        if coreSkills == nil {
            return []
        }
        
        var skills: [String] = []
        if let skillsData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(coreSkills! as Data) {
            skills = (skillsData ?? []) as! [String]
        }
        return skills
    }
    
    // Convert skills array [String] to Binary Data
    static private func convertToCoreDataSkills(_ skills: [String]?) -> NSData? {
        if let skillsArray = skills, skillsArray.count > 0 {
            do {
                return try NSKeyedArchiver.archivedData(withRootObject: skillsArray, requiringSecureCoding: false) as NSData
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    // Convert location from Binary Data back to CourseStruct.Location
    static private func parseFromCoreDataLocation(_ coreLocation: NSData?) -> CourseStruct.Location {
        var location = CourseStruct.Location(lgn: 0, ltd: 0);
        
        if coreLocation == nil {
            return location
        }
        
        if let locationData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(coreLocation! as Data) {
            let locationDictionary = locationData as! Dictionary<String, Double>
            location.lgn = locationDictionary["lgn"]
            location.ltd = locationDictionary["ltd"]
        }
        
        return location
    }
    
    // Convert CourseStruct.Location to Binary Data
    static private func convertToCoreDataLocation(_ location: CourseStruct.Location?) -> NSData? {
        if let locationData = location {
            do {
                return try NSKeyedArchiver.archivedData(withRootObject: ["lgn": locationData.lgn, "ltd": locationData.ltd], requiringSecureCoding: false) as NSData
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    // Convert course from Core Data back to CourseStruct.Course
    static private func parseFromCoreDataCourse(_ coreCourse: CourseData) -> CourseStruct.Course {
        let course = CourseStruct.Course(id: coreCourse.id, name: coreCourse.name, description: coreCourse.desc, location: parseFromCoreDataLocation(coreCourse.location), time: CourseStruct.Time(start: coreCourse.timeStart, end: coreCourse.timeEnd), organization: coreCourse.organization, rating: coreCourse.rating, skills: CourseStruct.Skills(gained: parseFromCoreDataSkills(coreCourse.skillsGained), required: parseFromCoreDataSkills(coreCourse.skillsRequired)))
        return course
    }
    
    // Convert career path from Core Data back to CareerPath
    static private func parseFromCoreDataCareerPath(_ coreCareerPath: PathData) -> CareerPath {
        let career = Career(name: coreCareerPath.name ?? "", requiredSkills: self.parseFromCoreDataSkills(coreCareerPath.requiredSkills))

        var path: [CourseStruct.Course] = []
        for course in Array(coreCareerPath.courseList ?? []) as! [CourseData] {
            path.append(self.parseFromCoreDataCourse(course))
        }

        let gainedSkills = self.parseFromCoreDataSkills(coreCareerPath.gainedSkills)
        let missingSkills = self.parseFromCoreDataSkills(coreCareerPath.missingSkills)

        return CareerPath(id: coreCareerPath.id, career: career, path: path, missingSkills: missingSkills, gainedSkills: gainedSkills)
    }
}
