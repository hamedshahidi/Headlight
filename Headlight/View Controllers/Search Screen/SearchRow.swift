//
//  SearchRow.swift
//  Headlight
//
//  Created by iosdev on 25/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import Foundation
import UIKit

// this is the class holding the horizontally scrolling netflix -esque search thingie.
// basically, the objects in that tableview get instantiated as this class.

// originally this class was divided into 2 different extensions of this class, but upon further thinking
// this solution is the best one.


// so this class is responsible for the actions happening inside the cells of the horizontally scrolling
// view controller and also obviously populating those said cells.

class SearchRow : UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var all_skills = skills
    open var cont_ref : SearchViewController?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "entryCell", for: indexPath as IndexPath) as! SingleCellContent
        let skill = Array(self.all_skills)[indexPath.item]
        cell.labelText.text = skill.value
        cell.hiddenValue = skill.key
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var temp_string: String = (collectionView.cellForItem(at: indexPath) as! SingleCellContent).hiddenValue
        print("sending a value to be searched : \(temp_string)")
        self.cont_ref?.appendToSearchString(temp_string)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = 100 - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}

// this small class is for the single cell inside the horizontally scrolling view.
// holds the label texts that shows the text value of the block.
// hidden value is basically the key used to search the database for the wanted course info.

class SingleCellContent : UICollectionViewCell {
    
    @IBOutlet weak var labelText: UILabel!
    open var hiddenValue = ""
}

