//
//  SignupSkillsViewController.swift
//  Headlight
//
//  Created by iosdev on 23/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class SignupSkillsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedSkills: [String: String] = [:]
    var name = ""
    let maxHeight = UIScreen.main.bounds.size.height
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(skills.values).count
    }
    
    // Load skill names to cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath)
        cell.textLabel?.text = Array(skills.values)[indexPath.row]

        return cell
    }
    
    // Append skill to selected skills
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Add/remove skill
        if selectedSkills[Array(skills.keys)[indexPath.row]] == nil {
            selectedSkills[Array(skills.keys)[indexPath.row]] = Array(skills.keys)[indexPath.row]
            self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            selectedSkills.removeValue(forKey: Array(skills.keys)[indexPath.row])
            self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        tableView.deselectRow(at: indexPath, animated: true)

        print(selectedSkills.values)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func nextButton(_ sender: Any) {
        CoreDataHelper.saveUserData(name: name)
        CoreDataHelper.addToUsersSkills(skills: Array(selectedSkills.values))
        print(CoreDataHelper.getUserData()?.name, CoreDataHelper.getUserData()?.skills)
    }
    @IBAction func clearUserData(_ sender: Any) {
        CoreDataHelper.clearUserData()
    }
    
}
