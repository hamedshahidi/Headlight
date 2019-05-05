//
//  CourseCell.swift
//  Headlight
//
//  Created by iosdev on 30/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class CourseCell: UICollectionViewCell {
    var course: CourseStruct.Course? = nil

    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseInfo: UILabel!
    @IBOutlet weak var courseSkills: UILabel!
    
    override func prepareForReuse() {
        
    }
}
