//
//  skillsgained.swift
//  Headlight
//
//  Created by iosdev on 01/05/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class skillsgained: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var courses: [CourseStruct.Course]
        courses = CoreDataHelper.listAllCourses()
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "skills", for: indexPath as IndexPath) as? SkillsCell
            else { fatalError("cell not working")}
        
        print("test")
        
        cell.skills.text  = "n"
        cell.backgroundColor = Theme.accent
        
        return cell
    }
    

    /*func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var courses: [CourseStruct.Course]
        courses = CoreDataHelper.listAllCourses()
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "skills", for: indexPath as IndexPath) as? SkillsCell
            else { fatalError("cell not working")}
        
        cell.skills.text  = "n"
        cell.backgroundColor = Theme.accent
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var courses: [CourseStruct.Course]
        courses = CoreDataHelper.listAllCourses()
        
        return courses.count
    }*/
    
}
