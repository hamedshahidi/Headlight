//
//  CourseCollectionViewController.swift
//  Headlight
//
//  Created by Tuomas Pöyry on 02/05/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class CourseCollectionViewController: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    var careerPath: CareerPath? = nil

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var courses: [CourseStruct.Course]
        courses = CoreDataHelper.listAllCourses()
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseCell", for: indexPath as IndexPath) as? CourseCell
        else { fatalError("cell not working")}
        
        
        cell.courseName.text = courses[indexPath.row].name
        cell.courseInfo.text = courses[indexPath.row].description
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var courses: [CourseStruct.Course]
        courses = CoreDataHelper.listAllCourses()
        
        return courses.count
    }
}
