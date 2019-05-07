//
//  MainViewController.swift
//  Headlight
//
//  Created by iosdev on 23/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Profile info
    @IBOutlet weak var profileCoursesDone: UILabel!
    @IBOutlet weak var profileCoursesDoneText: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var precentageCoursesDone: UILabel!
    @IBOutlet weak var profileCoursesLeft: UILabel!
    @IBOutlet weak var profileCoursesLeftText: UILabel!
    
    // Current course
    @IBOutlet weak var currentCourseView: UIView!
    @IBOutlet weak var currentCourseHeader: UILabel!
    @IBOutlet weak var currentCourseName: UILabel!
    @IBOutlet weak var currentCourseOrganization: UILabel!
    @IBOutlet weak var currentCourseDescription: UILabel!
    @IBOutlet weak var currentCourseRating: UILabel!
    @IBOutlet weak var currentCourseSkills: UILabel!
    
    // Button - Pick career path
    @IBOutlet weak var pickCareerButton: UIButton!
    
    // Search bar
    @IBOutlet weak var searchBar: UISearchBar!
  
    // Table view
    @IBOutlet weak var tableView: UITableView!
    
    // Career path
    var careerPath: CareerPath? = nil
    var selectedCourse: CourseStruct.Course? = nil
    
    // Current course
    var currentCourse: CourseStruct.Course? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("overview", comment: "")
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
        searchBar.placeholder = NSLocalizedString("search", comment: "")
        
        // Adds onclick effect for current course view
        let gesture = UITapGestureRecognizer(target: self , action:  #selector(self.checkAction))
        currentCourseView.addGestureRecognizer(gesture)

    }
    
    // When you re-enter main view, collectionview will scroll to the ongoing course
    override func viewDidDisappear(_ animated: Bool) {
        scrollOnceOnly = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let user = CoreDataHelper.getUserData()
        let currentCareerPathIndex = user?.getCareerPathProgress(careerPath) ?? 0

        // If there is no career path, hides the tableView which also contains the collectionView
        if(careerPath == nil){
            tableView.isHidden = true
        }
        
        // Calculates how many courses have been completed from the current career path
        var coursesDone: Int = 0
        for course in careerPath?.path ?? []{
            if(user?.history.contains(course.id ?? "") ?? false){
                coursesDone += 1
            }
        }
        let coursesLeft = (careerPath?.path.count ?? 0) - coursesDone
        
        // Calculates how many precentage of courses has the user done regarding to the career path
        var percentage = (Float(coursesDone) / Float(careerPath?.path.count ?? 0)) * 100
        if coursesDone == 0 {
            percentage = 0
        }
        
        // Sets profile info
        profileName.text = user?.name
        profileCoursesDone.text = String(coursesDone)
        profileCoursesDoneText.text = NSLocalizedString("courses_completed", comment: "")
        profileCoursesLeft.text = String(coursesLeft)
        profileCoursesLeftText.text = NSLocalizedString("courses_left", comment: "")
        precentageCoursesDone.text = NSString(format: "%.1f", percentage) as String + "%"
        
        // Current course info is hidden if there is no career path or if the career path is done
        if(careerPath == nil || coursesLeft <= 0 ){
            currentCourseView.isHidden = true
            pickCareerButton.isHidden = false
        } else {
            currentCourseView.isHidden = false
            pickCareerButton.isHidden = true
        }
        
         currentCourse = (careerPath?.path.count ?? 0 > 0) ? careerPath?.path[currentCareerPathIndex] : nil
        
        // Gets the gained skills of current course and builds a string of them
        var stringOfSkills: String = ""
        for skills in currentCourse?.skills?.gained ?? [""] {
            let aSkill = NSLocalizedString(skills, comment: "")
            stringOfSkills.append(aSkill + ",  ")
        }
        
        // Sets current course info
        currentCourseHeader.text = NSLocalizedString("ongoing_course", comment: "")
        if let courseId = currentCourse?.id {
            currentCourseName.text = NSLocalizedString(courseId + "_name", comment: "")
            currentCourseDescription.text = NSLocalizedString(courseId + "_description", comment: "")
        } 
        currentCourseOrganization.text = currentCourse?.organization
        currentCourseRating.text = NSString(format: "%.1f", currentCourse?.rating ?? 0 ) as String
        currentCourseSkills.attributedText = setColoredLabel(skillString: stringOfSkills)
        tableView.reloadData()
    }

    // Open search page when search bar is clicked
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
    
    // Creates title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString(careerPath?.career.name ?? "Career path", comment: "")
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
        guard var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseCell", for: indexPath as IndexPath) as? CourseCell
            else { fatalError("cell not working")}
        
        let course = careerPath?.path[indexPath.row]
        let user = CoreDataHelper.getUserData()
        let userHasDoneThisCourse = user?.history.contains(course?.id ?? "") ?? false
        
        // Builds a string of skills gained per course
        var skillString: String = ""
        for skill in course?.skills?.gained ?? [""] {
            let aSkill = NSLocalizedString(skill, comment: "")
            if userHasDoneThisCourse {
                skillString.append(aSkill + "  ")
            } else {
                skillString.append(aSkill + ",  ")
            }
        }

        cell = changeCellColors(cell: cell, indexPath: indexPath, skillString: skillString, userHasDoneThisCourse: userHasDoneThisCourse)
        cell.course = course
        if let courseId = course?.id {
            cell.courseName.text = NSLocalizedString(courseId + "_name", comment: "")
            cell.courseInfo.text = NSLocalizedString(courseId + "_description", comment: "")
        }

        return cell
    }
    
    // Different cell and text colors for already done courses
    func changeCellColors(cell: CourseCell, indexPath: IndexPath, skillString: String, userHasDoneThisCourse: Bool) -> CourseCell{
        if userHasDoneThisCourse {
            cell.backgroundColor = Theme.gray
            cell.courseName.textColor = Theme.dark2
            cell.courseInfo.textColor = Theme.dark2
            cell.courseSkills.textColor = Theme.dark2
            cell.courseSkills.text = skillString
            return cell
        } else {
            cell.courseName.textColor = UIColor.darkText
            cell.courseInfo.textColor = UIColor.darkText
            cell.backgroundColor = UIColor.white
            cell.courseSkills.attributedText = setColoredLabel(skillString: skillString)
            return cell
        }
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
        UIView.animate(withDuration: 1.5, animations: {
            collectionView.cellForItem(at: indexPath)?.alpha = 0.1
        })
        selectedCourse = (collectionView.cellForItem(at: indexPath) as! CourseCell).course
        UIView.animate(withDuration: 0.5, animations: {
            collectionView.cellForItem(at: indexPath)?.alpha = 1
        })
        performSegue(withIdentifier: "courseInfoSegue", sender: self)
    }

    // DEV ONLY --- Clears career path data and user data
    @IBAction func clearCareerPathData(_ sender: Any) {
        CoreDataHelper.clearCareerPathData()
        CoreDataHelper.clearUserData()
    }
    
    // Prepares for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.destination is CoursePageViewController){
            if(segue.identifier == "courseInfoSegue"){
            let viewController = segue.destination as? CoursePageViewController
            viewController?.course = selectedCourse
            }
            else if(segue.identifier == "currentCourseSegue"){
                let viewController = segue.destination as? CoursePageViewController
                viewController?.course = currentCourse
            }
        }
    }
    
    // If current course view is clicked -> performs segue
    @objc func checkAction(sender : UITapGestureRecognizer) {
        performSegue(withIdentifier: "currentCourseSegue", sender: self)
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


