//
//  CourseRow.swift
//  Headlight
//
//  Created by iosdev on 23/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import Foundation
import UIKit

class CourseRow : UITableViewCell {
}
    
extension CourseRow : UICollectionViewDataSource {
    
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

extension CourseRow : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 1.3
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
