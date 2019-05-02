//
//  courseInfoViewController.swift
//  Headlight
//
//  Created by iosdev on 20/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class CourseInfoViewController: UITableViewController {
    
    var course: CourseStruct.Course?
    var usedColors: [UIColor] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clear
        
        // for development only
        course = CoreDataHelper.findCourseByID("metropolia-mobile-05")
    }
}

struct Storyboard {
    static let title = "courseTitleAndRate"
    static let descAndMap = "courseDescriptionAndMap"
    static let providerAndLoc = "courseProviderAndDates"
    static let skills = "courseRequiredAndGainedSkills"
}

// MARK: - Table view data source

extension CourseInfoViewController
{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 0 - course title + rate
        // 1 - description + map
        // 2 - teacher + location name
        // 3 - skills (required + gained)
//        return courseData.count
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.title, for: indexPath) as! courseInfoHeaderCell
                
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.descAndMap, for: indexPath) as! courseDescAndMapCell
                
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.providerAndLoc, for: indexPath) as! courseProviderAndDatesCell
                
                return cell
            } else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.skills, for: indexPath) as! courseSkillsCell
                
                return cell
            }

        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            
            return 80
            
        } else if indexPath.row == 1 {
            
            return 160
            
        } else if indexPath.row == 2 {
            
            return 120
            
        } else if indexPath.row == 3 {
            
            return 240
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        switch indexPath.row {
        case 0:
            if let cell = cell as? courseInfoHeaderCell {
                
                cell.courseName?.text = course?.name ?? "-"
                cell.courseRate?.text = "\(course?.rating ?? 0)"
            }
            return
        case 1:
            if let cell = cell as? courseDescAndMapCell {
                
                cell.courseDesc?.text = course?.description
                
                // TODO location on map
            }
            return
        case 2:
            if let cell = cell as? courseProviderAndDatesCell {
                
                cell.courseOrganizer?.text = course?.organization ?? "-"
                cell.startDate?.text = course?.time.start ?? "-"
                cell.endDate?.text = course?.time.end ?? "-"
            }
            return

        default:
            // error cell
            return
        }
    }
}


// CollectionViewContoller

extension CourseInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //
        let skills = course?.skills
        
        switch collectionView.restorationIdentifier {
            
        case "skillsRequiredCV":
            
            let count = skills?.required?.count ?? 0
            return count
            
        case "skillsGainedCV":
            
            let count = skills?.gained?.count ?? 0
            return count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "skillCell", for: indexPath) as? skillCell
            else { fatalError("skillcell error")}
        
        let skills = course?.skills
        
        switch collectionView.restorationIdentifier {
            
        case "skillsRequiredCV":

            cell.requiredSkillLabel?.text = skills?.required?[indexPath.row]

            let colors = SkillColor.getPairColors()
            cell.requiredSkillLabel?.textColor = colors.0
            cell.requiredSkillLabel?.backgroundColor = colors.1
            
            return cell
            
        case "skillsGainedCV":

            cell.gainedSkillLabel?.text = skills?.gained?[indexPath.row]

            let colors = SkillColor.getPairColors()
            cell.gainedSkillLabel?.textColor = colors.1
            cell.gainedSkillLabel?.backgroundColor = colors.0

            return cell
            
        default:
            return cell
        }
    }
}
