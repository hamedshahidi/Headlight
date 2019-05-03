//
//  CareerPickerTableViewController.swift
//  Headlight
//
//  Created by iosdev on 21/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class CareerPickerTableViewController: UITableViewController {
    // Dictionary keys are stored here to maintain ordering
    var indexList: [String] = [
        "Web Development",
        "Mobile Application Development",
        "Video Game Development",
        "Other"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Select Career"
        
        /*
        for key in CareerData.careerCaregoryDictionary.keys {
            indexList.append(key)
        }
        */
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return indexList[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return indexList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CareerData.careerCaregoryDictionary[indexList[section]]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "careerListViewCell", for: indexPath)

        cell.textLabel?.text = CareerData.careerCaregoryDictionary[indexList[indexPath.section]]?[indexPath.row].name ?? "Unknown"

        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let viewController = segue.destination as! CareerPathPickViewController
        let indexPath = tableView.indexPathForSelectedRow!
        let career = CareerData.careerCaregoryDictionary[indexList[indexPath.section]]?[indexPath.row]
        
        let careerPath = CareerPathAlgorithm.createCareerPath(career!)
        
        viewController.careerPath = careerPath
    }
}
