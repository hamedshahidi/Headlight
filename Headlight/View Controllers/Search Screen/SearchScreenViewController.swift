//
//  SearchScreenViewController.swift
//  Headlight
//
//  Created by iosdev on 25/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var resultTableView: UITableView!
    
    var searchContainers = ["Skills"]
    var course_data : [CourseStruct.Course]?
    var all_skills = skills
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        resultTableView.dataSource = self
        resultTableView.delegate = self
        
        course_data = CoreDataHelper.listAllCourses()
        guard let usable_course_data = course_data else{ print("parsing course data failed in search");return}
        
        
        
        for var skill in skills {
            print(skill)
        }
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.tableView{
            return searchContainers[section]
        }else{
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return 1
        }else{
            return 5
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView{
             return searchContainers.count
        }else {
            return 1
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SearchRow
            return cell
        }else{
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = "testi"
             cell.detailTextLabel?.text = "extra information bla bla bla"
            return cell
        }
    }

}

//create some sort of controller for the second table view, which will populate the search results

