//
//  courseSkillsCell.swift
//  Headlight
//
//  Created by iosdev on 24/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class courseSkillsCell: UITableViewCell {

    @IBOutlet weak var requiredSkillsCollectionView: UICollectionView!
    
    @IBOutlet weak var gainedSkillsCollectionView: UICollectionView!
}

extension courseSkillsCell {
    
    func setCollectionviewDataSourceDelegate
         <D: UICollectionViewDelegate & UICollectionViewDataSource>
        (_ dataSourceDelegate: D, forRow row: Int) {
        
        requiredSkillsCollectionView.delegate = dataSourceDelegate
        requiredSkillsCollectionView.dataSource = dataSourceDelegate
        
        requiredSkillsCollectionView.reloadData()
    }
}
