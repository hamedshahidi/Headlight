//
//  Career.swift
//  Headlight
//
//  Created by Tuomas Pöyry on 29/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import Foundation

struct Career {
    let name: String;
    let requiredSkills: [String];
}

class CareerData {
    static let frontEndDeveloper = Career(name: "Front-End Developer", requiredSkills: [
        "html", "css", "js", "tier-1-mathematics", "basic-unix", "ionic", "angular", "sass", "ux-prototyping", "color-theory", "pwa"
    ])
    static let backendDeveloper = Career(name: "Back-End Developer", requiredSkills: [
        "js", "tier-2-mathematics", "basic-unix", "basic-logism", "object-oriented-programming", "data-communications", "kotlin", "java", "sql"
        ])
    static let fullStackDeveloper = Career(name: "Full Stack Developer", requiredSkills: Array(Set(CareerData.frontEndDeveloper.requiredSkills + CareerData.backendDeveloper.requiredSkills)))
    static let computerScientist = Career(name: "Computer Scientist", requiredSkills: [
        "js", "tier-2-physics", "tier-3-mathematics", "basic-unix", "basic-logism", "object-oriented-programming", "data-communications", "java", "csharp", "c++", "sql"
        ])
    static let uiDesigner = Career(name: "UI Designer", requiredSkills: [
        "html", "css", "js", "sass", "ux-prototyping", "color-theory"
        ])
    static let androidDeveloper = Career(name: "Android Developer", requiredSkills: [
        "tier-1-mathematics", "basic-unix", "basic-logism", "angular", "ux-prototyping", "color-theory", "object-oriented-programming", "data-communications", "kotlin", "android-studio", "java", "android", "pwa"
        ])
    static let iOSDeveloper = Career(name: "iOS Developer", requiredSkills: [
        "tier-1-mathematics", "basic-unix", "basic-logism", "angular", "ux-prototyping", "color-theory", "object-oriented-programming", "data-communications", "swift", "xcode", "ios", "pwa", "sql"
        ])
    static let mobileDeveloper = Career(name: "Mobile Developer", requiredSkills: Array(Set(CareerData.androidDeveloper.requiredSkills + CareerData.iOSDeveloper.requiredSkills)))
    static let gameDeveloper = Career(name: "Game Developer", requiredSkills: [
        "tier-3-physics", "tier-3-mathematics", "basic-unix", "basic-logism", "object-oriented-programming", "data-communications", "java", "unity", "csharp", "unreal", "c++", "sql"
        ])
    
    static let careerList = [
        CareerData.frontEndDeveloper,
        CareerData.backendDeveloper,
        CareerData.fullStackDeveloper,
        CareerData.computerScientist,
        CareerData.uiDesigner,
        CareerData.androidDeveloper,
        CareerData.iOSDeveloper,
        CareerData.mobileDeveloper,
        CareerData.gameDeveloper
    ]
    
    static let careerCaregoryDictionary = [
        "Web Development": [
            CareerData.frontEndDeveloper,
            CareerData.backendDeveloper,
            CareerData.fullStackDeveloper,
            CareerData.uiDesigner,
        ],
        "Mobile Application Development": [
            CareerData.androidDeveloper,
            CareerData.iOSDeveloper,
            CareerData.mobileDeveloper,
        ],
        "Video Game Development": [
            CareerData.gameDeveloper
        ],
        "Other": [
            CareerData.computerScientist,
        ]
    ]
}
