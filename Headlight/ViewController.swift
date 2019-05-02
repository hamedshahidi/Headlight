//
//  ViewController.swift
//  Headlight
//
//  Created by Tuomas Pöyry on 16/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

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
        
        print("Career path list")
        let careerPathList = CoreDataHelper.listAllCareerPaths()
        for careerPath in careerPathList {
            print(careerPath.career.name)
        }
        
        /*
        courseList = sortCoursesByPreferenceFactor(courseList, career, user!)
        
        // print(user?.skills)
        
        for i in courseList
        {
            print(i.location)
        }
        */
        
        // let careerPath = CareerPathAlgorithm.createCareerPath(CareerStruct.Career(name: "Test", skills: career));
    }
}

