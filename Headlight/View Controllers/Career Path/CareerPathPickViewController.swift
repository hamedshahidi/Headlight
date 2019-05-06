//
//  CareerPathViewController.swift
//  Headlight
//
//  Created by Tuomas Pöyry on 29/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class CareerPathPickViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var careerName: UILabel!
    @IBOutlet weak var careerLength: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var careerPath: CareerPath? = nil
    var careerPathWithSelfStudy: CareerPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        careerPathWithSelfStudy = CareerPathAlgorithm.careerPathWithSelfStudy(careerPath!)
        
        self.navigationItem.title = careerPath?.career.name
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let pathLength = careerPathWithSelfStudy?.path.count ?? 0
        let skillCount = careerPathWithSelfStudy?.gainedSkills.count ?? 0
        careerName.text = String(pathLength) + (pathLength == 1 ? " course" : " courses")
        careerLength.text = String(skillCount) + (skillCount == 1 ? " skills" : " skills")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return careerPathWithSelfStudy?.path.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "careerPickViewCell", for: indexPath) as? CourseTableCell else {
            fatalError("Unable to find careerPickViewCell.")
        }
        
        let course = careerPathWithSelfStudy?.path[indexPath.row]
        cell.courseTitle.text = course?.name ?? "Unknown"
        cell.courseOrganization.text = course?.organization ?? "Unknown"
        cell.courseNumber.text = String(indexPath.row + 1) + "."
        
        if course?.id == "self-study" {
            cell.backgroundColor = #colorLiteral(red: 0.9050358534, green: 0.9051876664, blue: 0.9050158858, alpha: 1)
        } else {
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        return cell
    }

    @IBAction func pickPath(_ sender: Any) {
        CoreDataHelper.clearCareerPathData()
        CoreDataHelper.saveCareerPath(careerPath: careerPath!)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "courseSegue" {
            let course = careerPathWithSelfStudy?.path[tableView.indexPathForSelectedRow?.row ?? 0]
            if course?.id == "self-study" { return false }
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.destination is CoursePageViewController {
            let viewController = segue.destination as! CoursePageViewController
            let course = careerPathWithSelfStudy?.path[tableView.indexPathForSelectedRow?.row ?? 0]
            
            viewController.course = course
        }
    }

}
