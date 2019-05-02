//
//  SearchScreenViewController.swift
//  Headlight
//
//  Created by iosdev on 25/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var resultTableView: UITableView!
    
    var searchContainers = ["Skills"]
    var course_data : [CourseStruct.Course]?
    var all_skills = skills
    var searchResultData : [CourseStruct.Course?]?
    private var searchString: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.resultTableView.dataSource = self
        self.resultTableView.delegate = self
        
        self.searchResultData = []
        
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
            return (self.searchResultData?.count ?? 0)
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
            cell.cont_ref = self
            return cell
        }else{
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = self.searchResultData?[indexPath.row]?.name ?? ""
            cell.detailTextLabel?.text = self.searchResultData?[indexPath.row]?.description ?? ""
            return cell
        }
    }
    
    // the appendToSearchString function is bit of a legacy function. The original plan was to concatenate
    // the possible search strings into one long one, but the current implementation is better.
    
    func appendToSearchString(_ string: String){
        self.searchFunction(string)
    }
    
    
    // the searchfunction gets the list of all of the courses from core data helper class, and then
    // compares the search string with values inside of it.
    // it first clears the current search array (array that populates the resulting table view) and
    // then does the actual search.
    
    func searchFunction(_ searchString: String){
        do{
            self.clearSearchData()
            self.searchResultData =  CoreDataHelper.listAllCourses().filter{
            for skill in $0.skills?.gained ?? []{
                if(skill == searchString){
                    return true
                }
                
            }
            for skill in $0.skills?.required ?? []{
                if(skill == searchString){
                    return true
                }
                
            }
           return false
        }
            DispatchQueue.main.async {
                self.updateResultTableViewData()
            }
        }
    }
    
    func updateResultTableViewData(){
        self.resultTableView.reloadData()
        print("data reloaded..")
    }
    
    func clearSearchData(){
        self.searchResultData?.removeAll()
    }

}

//create some sort of controller for the second table view, which will populate the search results

