//
//  SearchRow.swift
//  Headlight
//
//  Created by iosdev on 25/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import Foundation
import UIKit

class SearchRow : UITableViewCell {
     var all_skills = skills
}

extension SearchRow : UICollectionViewDataSource{
    
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "entryCell", for: indexPath as IndexPath) as! SingleCellContent
        let skill = Array(self.all_skills)[indexPath.item]
        cell.labelText.text = skill.value
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print((collectionView.cellForItem(at: indexPath) as! SingleCellContent).hiddenValue)
    }
}


extension SearchRow : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = 100 - (2 * hardCodedPadding)
        print(itemWidth)
        print(itemHeight)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}

class SingleCellContent : UICollectionViewCell {
    
    @IBOutlet weak var labelText: UILabel!
    open var hiddenValue = ""
}

