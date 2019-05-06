//
//  MainViewController.swift
//  Headlight
//
//  Created by iosdev on 23/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Profile info
    @IBOutlet weak var profileCoursesDone: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var precentageCoursesDone: UILabel!
    @IBOutlet weak var profileCoursesLeft: UILabel!
    
    //Current course
    @IBOutlet weak var currentCourseName: UILabel!
    @IBOutlet weak var currentCourseOrganization: UILabel!
    @IBOutlet weak var currentCourseDescription: UILabel!
    @IBOutlet weak var currentCourseRating: UILabel!
    @IBOutlet weak var currentCourseSkills: UILabel!
    
    
    // Search bar
    @IBOutlet weak var searchBar: UISearchBar!
  
    // Table view
    @IBOutlet weak var tableView: UITableView!
    
    // Career path
    var careerPath: CareerPath? = nil
    var selectedCourse: CourseStruct.Course? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Overview"
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // Gets career path data
        let careerPaths = CoreDataHelper.listAllCareerPaths()
        if careerPaths.count > 0 {
            careerPath = careerPaths[0]
            tableView.reloadData()
        }
                
        // Removes lines ontop and under the search bar
        searchBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        
        let user = CoreDataHelper.getUserData()
        let currentCareerPathIndex = user?.getCareerPathProgress(careerPath) ?? 0
        
        //Sets profile info
        let coursesDone = user?.history.count ?? 0
        profileName.text = user?.name
        profileCoursesDone.text = String(coursesDone)
        profileCoursesLeft.text = String((careerPath?.path.count ?? 0) - coursesDone)
        var percentage = (Float(careerPath?.path.count ?? 0) / Float(coursesDone)) * 10
        if coursesDone == 0 {
             percentage = 0
        }
        precentageCoursesDone.text = NSString(format: "%.1f", percentage) as String + "%"
        
        //Sets current course info
        let currentCourse = careerPath?.path[currentCareerPathIndex]
        var stringOfSkills: String = ""
        for skills in currentCourse?.skills?.gained ?? [""] {
            let aSkill = NSLocalizedString(skills, comment: "")
            stringOfSkills.append(aSkill + ",  ")
        }
        
        currentCourseName.text = currentCourse?.name
        currentCourseOrganization.text = currentCourse?.organization
        currentCourseDescription.text = currentCourse?.description
        currentCourseRating.text = NSString(format: "%.1f", currentCourse?.rating ?? 0 ) as String
        currentCourseSkills.attributedText = setColoredLabel(skillString: stringOfSkills)
    }

    // Search bar click
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        performSegue(withIdentifier: "searchSegue", sender: self)
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if careerPath == nil {
            return 0
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "careerTableCell") as! CourseRow
        
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.reloadData()
        
        return cell
    }
    
    // Makes title's background color white
    /*func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
    }*/
    
    
    // Creates title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return careerPath?.career.name ?? "Career path"
    }

    // Amount of courses in career path
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if careerPath == nil {
            return 0
        } else {
            return careerPath?.path.count ?? 0
        }
    }
    
    // Gets data for each course cell (name, description and skills)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseCell", for: indexPath as IndexPath) as? CourseCell
            else { fatalError("cell not working")}
        
        let course = careerPath?.path[indexPath.row]
        let user = CoreDataHelper.getUserData()
        let userHasDoneThisCourse = user?.history.contains(course?.id ?? "") ?? false
        
        var skillString: String = ""
        
        for skill in course?.skills?.gained ?? [""] {
            let aSkill = NSLocalizedString(skill, comment: "")
            if userHasDoneThisCourse {
                skillString.append(aSkill + "  ")
            } else {
                skillString.append(aSkill + ",  ")
            }
        }
        
        // Different cell and text colors for already done courses
        if userHasDoneThisCourse {
            cell.backgroundColor = Theme.dark3
            cell.courseName.textColor = Theme.dark2
            cell.courseInfo.textColor = Theme.dark2
            cell.courseSkills.textColor = Theme.dark2
            cell.courseSkills.text = skillString
        } else {
            cell.courseName.textColor = UIColor.darkText
            cell.courseInfo.textColor = UIColor.darkText
            cell.backgroundColor = UIColor.white
            cell.courseSkills.attributedText = setColoredLabel(skillString: skillString)
        }
        
        cell.course = course
        cell.courseName.text = course?.name ?? "Unknown"
        cell.courseInfo.text = course?.description ?? ""
        
        return cell
    }

    // Displays the current course in the career path collectionview
    var scrollOnceOnly = false
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let user = CoreDataHelper.getUserData()
        let currentCareerPathIndex = user?.getCareerPathProgress(careerPath) ?? 0

        if !scrollOnceOnly {
            let indexToScrollTo = IndexPath(item: currentCareerPathIndex, section: 0)
            collectionView.scrollToItem(at: indexToScrollTo, at: .centeredHorizontally, animated: false)
            scrollOnceOnly = true
        }
    }
    
    // Sets the padding for courses in career path and defines that 1.3 courses are shown per row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 1.3
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    // Creates onclick animation for collecitionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 1, animations: {
            collectionView.cellForItem(at: indexPath)?.alpha = 0.1
        })
        selectedCourse = (collectionView.cellForItem(at: indexPath) as! CourseCell).course
        UIView.animate(withDuration: 0.5, animations: {
            collectionView.cellForItem(at: indexPath)?.alpha = 1
        })
        performSegue(withIdentifier: "courseInfoSegue", sender: self)
    }

    @IBAction func clearCareerPathData(_ sender: Any) {
        CoreDataHelper.clearCareerPathData()
        CoreDataHelper.clearUserData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.destination is CourseInfoViewController {
            let viewController = segue.destination as? CourseInfoViewController
            viewController?.course = selectedCourse
        }
    }
}

extension NSMutableAttributedString {
    func setColorForText(textToFind: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        //if range != nil {
            self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        //}
    }
    
}

// Sets color for each skill
func setColoredLabel(skillString: String) -> NSAttributedString{
    let attributedString = NSMutableAttributedString()
    let skills = skillString.split(separator: ",")
    for skill in skills {
        let skillColor = SkillColor.getColor(str: String(skill))
        attributedString.append(NSAttributedString(string: String(skill),
                                                   attributes: [.foregroundColor: skillColor ?? UIColor.black]))
    }
    return attributedString
}


