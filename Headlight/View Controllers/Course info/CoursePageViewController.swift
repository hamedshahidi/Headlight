//
//  CoursePageViewController.swift
//  Headlight
//
//  Created by iosdev on 03/05/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit
import MapKit

class CoursePageViewController: UIViewController {
    
    var course: CourseStruct.Course?
    var user = CoreDataHelper.getUserData()
    var courseIsDone: Bool = false
    
    struct tableViews {
        static let gained = "TableViewGainedSkills"
        static let required = "TableViewRequiredSkills"
    }
    struct headers {
        static let gained = NSLocalizedString("header_gained", comment: "")
        static let required = NSLocalizedString("header_required", comment: "")
    }
    struct placeholders {
        static let noSkillRequired = NSLocalizedString("header_no_skill_required", comment: "")
    }
    struct coordinates {
        static var lat = 0.0
        static var long = 0.0
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
    
    @IBOutlet weak var locationMap: MKMapView!
    
    @IBOutlet weak var btnDone: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUISettings()
        initializeTableViewSettings()
        checkIfCourseIsDone()
        getCourseLocation()
        populateUIElements()
    }
    
    // Set initial UI properties programatically
    func initializeUISettings() {
        self.navigationItem.title = NSLocalizedString("course_page_title", comment: "")
        btnDone.layer.cornerRadius = 8
        btnDone.borderWidth = 2
    }
    
    // Observer to autosize UITableView height based on its content size
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tableViewGainedSkills.layer.removeAllAnimations()
        tableViewRequiredSkills.layer.removeAllAnimations()
        heightConstraintGainedSkills.constant = tableViewGainedSkills.contentSize.height
        heightConstraintsRequiredSkills.constant = tableViewRequiredSkills.contentSize.height
        UIView.animate(withDuration: 0.3) {
            self.updateViewConstraints()
            self.loadViewIfNeeded()
        }
    }
    
    // Handle click on course state button
    @IBAction func clickDoneBtn(_ sender: UIButton) {
        if let course = self.course {
            courseIsDone = !courseIsDone
            
            switch courseIsDone {
            case true:
                CoreDataHelper.addToUserHistory(course)
                updateButtonUI(courseIsDone)
                return
            
            default:
                CoreDataHelper.removeFromUserHistory(course)
                updateButtonUI(courseIsDone)
                return
            }
        }
    }
    
    // Check if user has done this course already and update UI accordingly
    func checkIfCourseIsDone() {
        var state: Bool = false
        if let history = user?.history,
            let course = course?.id
        {
            // 1.Check user course history
            if history.contains(course) { state = true }
            else { state = false }
        }
        courseIsDone = state
        
        // 2.Update UI
        switch courseIsDone {
        case true:
            updateButtonUI(courseIsDone)
        default:
            updateButtonUI(courseIsDone)
        }
    }
    
    // Update course state button UI based on course state
    func updateButtonUI(_ courseIsDone: Bool) {
        switch courseIsDone {
        case true:
            btnDone.backgroundColor = Theme.tint
            btnDone.borderColor = Theme.tint
            btnDone.tintColor = .white
            btnDone.borderWidth = 2
            btnDone.setTitle(NSLocalizedString("btn_already_done", comment: ""), for: UIControl.State.normal)
            btnDone.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        default:
            btnDone.backgroundColor = .clear
            btnDone.borderColor = Theme.accent
            btnDone.tintColor = Theme.accent
            btnDone.borderWidth = 2
            btnDone.setTitle(NSLocalizedString("btn_mark_done", comment: ""), for: UIControl.State.normal)
            btnDone.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    
    
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
    
    // MARK: - Navigation
    
    // Navigate to map page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.destination is MapViewController {
            let viewController = segue.destination as! MapViewController
            
            viewController.course = self.course
        }
    }
}

// TableViewController
extension CoursePageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        // Set table rows based on their related content
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
        
        // Set row height
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
        
        guard let cell = cell as? SkillListCell else {
            fatalError("Skill cell does not exist!")
        }
        
        labels = (cell.gainedSkillLabel, cell.requiredSkillLabel)
        
        // Find current available label
        if labels.0 == nil { label = labels.1}
        else { label = labels.0 }
        
        // Indentify table and update UI accordingly
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
                label?.borderColor = SkillColor.getColor(str: skills?[indexPath.row - 1] ?? "")
                label?.layer.cornerRadius = 8
                label?.font = UIFont.boldSystemFont(ofSize: 16)
                label?.text = "  " + (skills?[indexPath.row - 1] ?? "") + "  "
                label?.sizeToFit()
        }
    }
}

extension CoursePageViewController: MKMapViewDelegate {
    
    func getCourseLocation () {
        
        getCoordinates()
        
        // Set map region based on location
        let courseLocation = CLLocation(latitude: coordinates.lat, longitude: coordinates.long)
        let regionRadius: CLLocationDistance = 100.0
        let region = MKCoordinateRegion(center: courseLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        locationMap.setRegion(region, animated: false)

        
        // Add a pin on location
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: coordinates.lat, longitude: coordinates.long)
        locationMap.addAnnotation(pin)
    }
    
    func getCoordinates() {
        coordinates.lat = course?.location?.ltd ?? 0.0
        coordinates.long = course?.location?.lgn ?? 0.0
    }
}
