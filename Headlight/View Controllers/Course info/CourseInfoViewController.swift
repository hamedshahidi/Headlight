//
//  CourseInfoViewController.swift
//  Headlight
//
//  Created by iosdev on 24/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class CourseInfoViewController: UITableViewController {
    
    // this hardcoded data will be replaced by fetched data
    let courseData = [
        [ // 0
            "name": "Converting websites to PWA",
            "rating": 4.2,
        ],
        [ // 1
            "description": "Converting existing websites to mobile friendly PWAs.",
            "location": [ "lgn": 60.25864, "ltd": 24.845427]
        ],
        [ // 2
            "organization": "Metropolia",
            "time": [ "start": "26-1-2020", "end": "12-2-2020"]
        ],
        [ // 3
            "skills": [
                "gained": ["pwa","sass"],
                "required": ["javascript","html","css"]
            ]
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
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
        return courseData.count
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
            
            return 72
            
        } else if indexPath.row == 1 {
            
            return 120
            
        } else if indexPath.row == 2 {
            
            return 100
            
        } else if indexPath.row == 3 {
            
            return 200
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        switch indexPath.row {
        case 0:
            if let cell = cell as? courseInfoHeaderCell {
                cell.courseName?.text = courseData[0]["name"] as? String
                let rate = "\(courseData[0]["rating"] ?? "0.0")"
                cell.courseRate?.text = rate
            }
            return
        case 1:
            if let cell = cell as? courseDescAndMapCell {
                cell.courseDesc?.text = courseData[1]["description"] as? String
                // TODO location on map
            }
            return
        case 2:
            if let cell = cell as? courseProviderAndDatesCell {
                cell.courseOrganizer?.text = courseData[2]["organization"] as? String
                let time = courseData[2]["time"] as? [String: String]
                cell.startDate?.text = time?["start"]
                cell.endDate?.text = time?["end"]
            }
            return
        case 3:
            if let cell = cell as? courseSkillsCell {
                // show skills in tableview
            }
            return
        default:
            // error cell
            return
        }
    }
}
