//
//  CoursePageViewController.swift
//  Headlight
//
//  Created by iosdev on 03/05/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class CoursePageViewController: UIViewController {
    
    var course: CourseStruct.Course?
    var usedColors: [UIColor] = []
    
    struct tableViews {
        static let gained = "TableViewGainedSkills"
        static let required = "TableViewRequiredSkills"
    }
    struct headers {
        static let gained = "You will learn these skills:"
        static let required = "Required skills:"
    }
    struct placeholders {
        static let noSkillRequired = "Requires no previous skills"
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var orginizerLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    @IBOutlet weak var tableViewGainedSkills: UITableView!
    @IBOutlet weak var tableViewRequiredSkills: UITableView!
    
    @IBOutlet weak var heightConstraintGainedSkills: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintsRequiredSkills: NSLayoutConstraint!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableViewSettings()
        populateUIElements()
    }
    
    // Observer to autosize UITableView height based on its content size
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tableViewGainedSkills.layer.removeAllAnimations()
        tableViewRequiredSkills.layer.removeAllAnimations()
        heightConstraintGainedSkills.constant = tableViewGainedSkills.contentSize.height
        heightConstraintsRequiredSkills.constant = tableViewRequiredSkills.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
            self.loadViewIfNeeded()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initializeTableViewSettings() {
        
        tableViewGainedSkills.tableFooterView = UIView()
        tableViewRequiredSkills.tableFooterView = UIView()
        
        tableViewGainedSkills.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        tableViewRequiredSkills.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        tableViewGainedSkills.separatorColor = UIColor.clear
        tableViewRequiredSkills.separatorColor = UIColor.clear
    }
    
    func populateUIElements() {
        
        titleLabel?.text = course?.name ?? "-"
        rateLabel?.text = "\(course?.rating ?? 0)"
        descLabel?.text = course?.description ?? "-"
        orginizerLabel?.text = course?.organization ?? "-"
        startLabel?.text = course?.time?.start ?? "-"
        endLabel?.text = course?.time?.end ?? "-"
    }

}

// TableViewController
extension CoursePageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        // set table rows based on their related content
        switch tableView.restorationIdentifier {
        case tableViews.gained:
            return (course?.skills?.gained?.count ?? 0) + 1
            
        case tableViews.required:
            return (course?.skills?.required?.count ?? 0) + 1
            
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "skill", for: indexPath) as! SkillListCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // set row height
        switch indexPath.row {
        case 0:
            return 60

        default:
            return 50
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        var header = ""
        var skills: [String]?
        var labels: ( UILabel?, UILabel?)
        var label: UILabel?
        
        let colors = SkillColor.getPairColors()
        
        guard let cell = cell as? SkillListCell else {
            print("Cell does not exist")
            return
        }
        
        labels = (cell.gainedSkillLabel, cell.requiredSkillLabel)
        
        // Find current available label
        if labels.0 == nil { label = labels.1}
        else { label = labels.0 }
        
        // Indentify table and update UI with related data
        switch tableView.restorationIdentifier {
        case tableViews.gained:
            header = headers.gained
            skills = course?.skills?.gained ?? []
            
        case tableViews.required:
            if (course?.skills?.required?.count ?? 0) == 0 {
                header = placeholders.noSkillRequired
            } else {
                header = headers.required
            }
            skills = course?.skills?.required ?? []
            
        default:
            break
        }
        
        // Populate table with data
        switch indexPath.row {
        case 0:
            label?.text = header
            cell.backgroundColor = Theme.background
            
        default:
            label?.borderWidth = 2
            label?.borderColor = colors.0
            label?.layer.cornerRadius = 8
            label?.font = UIFont.boldSystemFont(ofSize: 16)
            label?.text = "  " + (skills?[indexPath.row - 1] ?? "") + "  "
            label?.sizeToFit()
        }
    }
}
