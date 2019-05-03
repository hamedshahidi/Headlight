//
//  MainViewController.swift
//  Headlight
//
//  Created by iosdev on 23/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Profile info
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var precentageCoursesDone: UILabel!
    @IBOutlet weak var profileCoursesLeft: UILabel!
    
    // Search bar
    @IBOutlet weak var searchBar: UISearchBar!
  
    // Table view
    @IBOutlet weak var tableView: UITableView!
    
    var careerPath: CareerPath? = nil
    var selectedCourse: CourseStruct.Course? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Cool title"

        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        profileName.text = CoreDataHelper.getUserData()?.name
        
        let careerPaths = CoreDataHelper.listAllCareerPaths()
        if careerPaths.count > 0 {
            careerPath = careerPaths[0]
            tableView.reloadData()
        }
    }

    // Search bar click
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
        
        print("cellForRowAt")
        
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.reloadData()
        
        return cell
    }
    
    // Makes title's background color white
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
    }
    
    // Creates titles
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Career path"
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if careerPath == nil {
            return 0
        } else {
            return careerPath?.path.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseCell", for: indexPath as IndexPath) as? CourseCell
            else { fatalError("cell not working")}
        
        print("Collection cell")
        
        let course = careerPath?.path[indexPath.row]
        
        cell.course = course
        cell.courseName.text = course?.name ?? "Unknown"
        cell.courseInfo.text = course?.description ?? ""
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 1.3
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCourse = (collectionView.cellForItem(at: indexPath) as! CourseCell).course
        performSegue(withIdentifier: "courseInfoSegue", sender: self)
    }

    @IBAction func clearCareerPathData(_ sender: Any) {
        CoreDataHelper.clearCareerPathData()
        CoreDataHelper.clearUserData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.destination is CourseInfoViewController {
            let viewController = segue.destination as? CourseInfoViewController
            viewController?.course = selectedCourse
        }
    }
}
