//
//  User.swift
//  Headlight
//
//  Created by Tuomas Pöyry on 22/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import Foundation

class User {
    let name: String
    let skills: [String]
    let history: [String]
    
    init(name: String, skills: [String], history: [String]) {
        self.name = name
        self.skills = skills
        self.history = history
    }
    
    func getCareerPathProgress(_ careerPath: CareerPath?) -> Int {
        var index = 0
        
        if self.history.count == 0 || careerPath == nil {
            return 0
        }
        
        for course in careerPath!.path {
            if self.history.contains(course.id ?? "") {
                return index
            }
            index += 1
        }
        
        return 0
    }
}
