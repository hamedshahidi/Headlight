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

            let colors = getPairColors()
            cell.requiredSkillLabel?.textColor = colors.0
            cell.requiredSkillLabel?.backgroundColor = colors.1
            
            return cell
            
        case "skillsGainedCV":

            cell.gainedSkillLabel?.text = skills?.gained?[indexPath.row]

            let colors = getPairColors()
            cell.gainedSkillLabel?.textColor = colors.1
            cell.gainedSkillLabel?.backgroundColor = colors.0

            return cell
            
        default:
            return cell
        }
    }
}


extension CourseInfoViewController
{
    
    // Finds two complementary colors for text and background
    // with a contrast rate suitable for reading.
    func getPairColors () -> (UIColor,UIColor) {
        
        var color: UIColor = .white
        var complementary: UIColor = .black
        
        let colors = ["#00FF00","#0000FF","#FF0000","#01FFFE","#FFA6FE","#006401","#010067","#95003A","#007DB5","#FF00F6","#774D00","#90FB92","#0076FF","#FF937E","#6A826C","#FF029D","#FE8900","#7A4782","#7E2DD2","#85A900","#FF0056","#A42400","#00AE7E","#683D3B","#BDC6FF","#263400","#BDD393","#00B917","#9E008E","#001544","#C28C9F","#FF74A3","#01D0FF","#004754","#E56FFE","#788231","#0E4CA1","#91D0CB","#BE9970","#968AE8","#BB8800","#43002C","#DEFF74","#00FFC6","#FFE502","#620E00","#008F9C","#98FF52","#7544B1","#B500FF","#00FF78","#FF6E41","#005F39","#6B6882","#5FAD4E","#A75740","#A5FFD2","#FFB167","#009BFF","#E85EBE"]
        
        // Search for colors with good contrast rate
        repeat {
            
            let colorIndex = Int.random(in: 0 ..< colors.count)
            color = UIColor(hex: colors.shuffled()[colorIndex]) ?? .cyan
            complementary = getComplementaryForColor(color: color)
            
        } while (
            usedColors.contains(color) ||
            UIColor.contrastRatio(between: color, and: complementary) < 6
            )
        
        usedColors.append(color)
        
        return (color, complementary)
    }
    
    func getComplementaryForColor(color: UIColor) -> UIColor {
        
        let ciColor = CIColor(color: color)
        
        // get the current values and make the difference from white:
        let compRed: CGFloat = 1.0 - ciColor.red
        let compGreen: CGFloat = 1.0 - ciColor.green
        let compBlue: CGFloat = 1.0 - ciColor.blue
        
        return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: 1.0)
    }
}


extension UIColor {
    
    // Calculates contrast rate of two colors (used in general)
    static func contrastRatio(between color1: UIColor, and color2: UIColor) -> CGFloat {
        
        let luminance1 = color1.luminance()
        let luminance2 = color2.luminance()
        
        let luminanceDarker = min(luminance1, luminance2)
        let luminanceLighter = max(luminance1, luminance2)
        
        return (luminanceLighter + 0.05) / (luminanceDarker + 0.05)
    }
    
    // Calculates contrast rate of a color to another (used on a color)
    func contrastRatio(with color: UIColor) -> CGFloat {
        return UIColor.contrastRatio(between: self, and: color)
    }
    
    func luminance() -> CGFloat {
        
        let ciColor = CIColor(color: self)
        
        func adjust(colorComponent: CGFloat) -> CGFloat {
            return (colorComponent < 0.03928) ? (colorComponent / 12.92) : pow((colorComponent + 0.055) / 1.055, 2.4)
        }
        
        return 0.2126 * adjust(colorComponent: ciColor.red) + 0.7152 * adjust(colorComponent: ciColor.green) + 0.0722 * adjust(colorComponent: ciColor.blue)
    }
}


