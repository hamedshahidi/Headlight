//
//  CareerPathAlgorithm.swift
//  Headlight
//
//  Created by Tuomas Pöyry on 29/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import Foundation

struct CareerPath {
    let id: UUID?
    let career: Career
    let path: [CourseStruct.Course]
    let missingSkills: [String]
    let gainedSkills: [String]
}

class CareerPathAlgorithm {
    static internal func containsSkills(_ a: [String]?, _ b: [String]?) -> Bool {
        return (a ?? []).filter { x in !(b ?? []).contains(x) }.count == 0
    }
    
    // Sort the courses in the order they need to be done
    static internal func orderCourseListBasedOnRequirements(_ list: [CourseStruct.Course], _ missingSkills: [String]) -> [CourseStruct.Course] {
        var sortedPath: [CourseStruct.Course] = []
        var gainedSkills: [String] = missingSkills
        repeat {
            for course in list {
                if sortedPath.contains(where: { x in x.id == course.id }) { continue }
                if containsSkills(course.skills?.required, gainedSkills) {
                    sortedPath.append(course)
                    gainedSkills = Array(Set(gainedSkills + (course.skills?.gained ?? [])))
                }
            }
        } while(sortedPath.count != list.count)
        
        return sortedPath
    }
    
    static private func combineIntoCoursePath(_ coursePathTree: CareerPath) -> CareerPath {
        let sortedPath = orderCourseListBasedOnRequirements(coursePathTree.path, coursePathTree.missingSkills)
        
        return CareerPath(id: coursePathTree.id, career: coursePathTree.career, path: sortedPath, missingSkills: coursePathTree.missingSkills, gainedSkills: coursePathTree.missingSkills)
    }
    
    static private func createCoursePathTree(_ career: Career, _ courseList: [CourseStruct.Course], _ skillList: [String], _ user: User, _ path: CareerPath?) -> CareerPath {
        let list = sortCoursesByPreferenceFactor(courseList, skillList, user)
        
        var stepCourses: [CourseStruct.Course] = []
        var fulfilledSkills: [String] = []
        var requiredSkills: [String] = []
        for course in list {
            let skills = calculateCareerGivenSkills(course, skillList)
            
            let usefullSkills = skills.filter { skill in !fulfilledSkills.contains(skill) }
            if usefullSkills.count > 0 {
                fulfilledSkills = Array(Set(fulfilledSkills + usefullSkills))
                requiredSkills = Array(Set(requiredSkills + course.skills!.required!))
                stepCourses.append(course)
            }
        }
        
        let completeGainedSkills = Array(Set((path?.gainedSkills ?? []) + fulfilledSkills))
        
        // Take out the skills the user already knows
        requiredSkills = requiredSkills.filter { skill in !user.skills.contains(skill) }
        
        // Take out the skills that have already been learned
        requiredSkills = requiredSkills.filter { skill in !completeGainedSkills.contains(skill) }
        
        // Add missing career skills
        requiredSkills = Array(Set(requiredSkills + skillList.filter { skill in !fulfilledSkills.contains(skill) }))
        
        var currentPath = path?.path ?? []
        for course in stepCourses {
            currentPath.append(course)
        }
        
        let careerPath = CareerPath(id: nil, career: career, path: currentPath, missingSkills: requiredSkills, gainedSkills: completeGainedSkills)
        
        if requiredSkills.count > 0 && stepCourses.count > 0 {
            let unusedCourseList = courseList.filter { course in !stepCourses.contains { x in x.id == course.id } }
            return createCoursePathTree(career, unusedCourseList, requiredSkills, user, careerPath)
        } else {
            return CareerPath(id: nil, career: career, path: careerPath.path, missingSkills: careerPath.missingSkills, gainedSkills: careerPath.gainedSkills)
        }
    }
    
    static private func sortCoursesByPreferenceFactor(_ courseList: [CourseStruct.Course], _ career: [String], _ user: User) -> [CourseStruct.Course] {
        var list = courseList
        list.sort { a, b in calculateCoursePreferenceFactor(a, career, user) > calculateCoursePreferenceFactor(b, career, user) }
        list = list.filter { course in calculateCoursePreferenceFactor(course, career, user) > 0 }
        return list
    }
    
    static private func calculateCoursePreferenceFactor(_ course: CourseStruct.Course, _ career: [String], _ user: User) -> Double {
        let givenSkills = calculateCareerGivenSkills(course, career)
        var requiredSkills = course.skills!.required!.filter { skill in !user.skills.contains(skill) }
        requiredSkills = requiredSkills.filter { skill in !career.contains(skill) }
        
        if givenSkills.count == 0 {
            return 0
        }
        
        // print(course.name)
        // print(givenSkills)
        // print(requiredSkills)
        
        let givenSkillFactor = min(5.0, Double(givenSkills.count)) / 5.0
        let requiredSkillFactor = (3.0 - min(3.0, Double(requiredSkills.count))) / 3.0
        let ratingFactor = course.rating ?? 0.0 / 5.0
        
        // print(givenSkillFactor)
        // print(requiredSkillFactor)
        // print((givenSkillFactor + requiredSkillFactor) / 2)
        
        return (ratingFactor + givenSkillFactor + requiredSkillFactor) / 3
    }
    
    static private func calculateCareerGivenSkills(_ course: CourseStruct.Course, _ career: [String]) -> [String] {
        return career.filter { skill in course.skills?.gained!.contains(skill) ?? false }
    }
    
    static func createCareerPath(_ career: Career) -> CareerPath {
        let courseList = CoreDataHelper.listAllCourses();
        let userData = CoreDataHelper.getUserData();
        
        guard let user = userData else {
            fatalError("User must be created before career path")
        }
        
        let path = createCoursePathTree(career, courseList, career.requiredSkills, user, nil)
    
        let finalPath = combineIntoCoursePath(path)
        for i in finalPath.path {
            print(i.name)
        }
        
        return finalPath;
    }
}
