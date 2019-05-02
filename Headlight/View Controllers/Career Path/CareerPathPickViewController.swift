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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = careerPath?.career.name
        
        tableView.dataSource = self
        tableView.delegate = self
        
        careerName.text = careerPath?.career.name ?? "Unknown"
        careerLength.text = String(careerPath?.path.count ?? 0) + " courses"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return careerPath?.path.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "careerPickViewCell", for: indexPath)
        
        cell.textLabel?.text = careerPath?.path[indexPath.row].name
        
        return cell
    }

    @IBAction func pickPath(_ sender: Any) {
        CoreDataHelper.saveCareerPath(careerPath: careerPath!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.destination is CourseInfoViewController {
            let viewController = segue.destination as! CourseInfoViewController
            let course = careerPath?.path[tableView.indexPathForSelectedRow?.row ?? 0]
            
            viewController.course = course
        }
    }

}
