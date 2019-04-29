//
//  ViewController.swift
//  Headlight
//
//  Created by Tuomas Pöyry on 16/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

struct CareerPath {
    let path: [[CourseStruct.Course]]
    let missingSkills: [String]
    let gainedSkills: [String]
}

class ViewController: UIViewController {
    
    var fetcher : DataFetcher = DataFetcher()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Init user here for now, TODO: needs to be moved
        fetcher.FetchInitialData()
        
        var courseList = CoreDataHelper.listAllCourses()
        
        let user = CoreDataHelper.getUserData()
        
        print("User skills")
        print(user?.skills)
        
        print("Wanted skills")
        let career = ["tier-3-physics", "tier-2-mathematics", "kotlin", "pwa", "color-theory", "csharp"]
        print(career)
        
        /*
        courseList = sortCoursesByPreferenceFactor(courseList, career, user!)
        
        // print(user?.skills)
        
        for i in courseList
        {
            print(i.name ?? "")
        }
        */
        
        let path = createCoursePathTree(courseList, career, user!, nil)
        
        for x in path.path {
            print("Stage =============")
            for y in x {
                print(y.name)
            }
            print("")
        }
        
        print("Gained skills")
        print(path.gainedSkills)
        
        print("Missing skills")
        print(path.missingSkills)
        
        print("")
        
        let finalPath = combineIntoCoursePath(path)
        for i in finalPath {
            print(i.name)
        }
    }
    
    func combineIntoCoursePath(_ coursePathTree: CareerPath) -> [CourseStruct.Course] {
        var path: [CourseStruct.Course] = []
        for x in coursePathTree.path {
            path = x + path
        }
        
        return path
    }
    
    func createCoursePathTree(_ courseList: [CourseStruct.Course], _ career: [String], _ user: User, _ path: CareerPath?) -> CareerPath {
        let list = sortCoursesByPreferenceFactor(courseList, career, user)
        
        print("")
        print("Career")
        print(career)
        
        var stepCourses: [CourseStruct.Course] = []
        var fulfilledSkills: [String] = []
        var requiredSkills: [String] = []
        for course in list {
            let skills = calculateCareerGivenSkills(course, career)
            
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
        requiredSkills = Array(Set(requiredSkills + career.filter { skill in !fulfilledSkills.contains(skill) }))
        
        stepCourses.map { course in print(course.name ?? "") }
        print(fulfilledSkills)
        print(requiredSkills)
        
        var currentPath = path?.path ?? []
        currentPath.append(stepCourses)
        
        let careerPath = CareerPath(path: currentPath, missingSkills: requiredSkills, gainedSkills: completeGainedSkills)
        
        if requiredSkills.count > 0 && stepCourses.count > 0 {
            let unusedCourseList = courseList.filter { course in !stepCourses.contains { x in x.id == course.id } }
            return createCoursePathTree(unusedCourseList, requiredSkills, user, careerPath)
        } else {
            return CareerPath(path: careerPath.path.filter { x in x.count > 0 }, missingSkills: careerPath.missingSkills, gainedSkills: careerPath.gainedSkills)
        }
    }
    
    func sortCoursesByPreferenceFactor(_ courseList: [CourseStruct.Course], _ career: [String], _ user: User) -> [CourseStruct.Course] {
        var list = courseList
        list.sort { a, b in calculateCoursePreferenceFactor(a, career, user) > calculateCoursePreferenceFactor(b, career, user) }
        list = list.filter { course in calculateCoursePreferenceFactor(course, career, user) > 0 }
        return list
    }
    
    func calculateCoursePreferenceFactor(_ course: CourseStruct.Course, _ career: [String], _ user: User) -> Double {
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
    
    func calculateCareerGivenSkills(_ course: CourseStruct.Course, _ career: [String]) -> [String] {
        return career.filter { skill in course.skills?.gained!.contains(skill) ?? false }
    }
}

