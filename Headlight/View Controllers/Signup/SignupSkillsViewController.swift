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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var guideText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.background
        nextBtn.backgroundColor = Theme.tint
        nextBtn.tintColor = Theme.background
        nextBtn.layer.cornerRadius = 4
        tableView.dataSource = self
        tableView.delegate = self
        guideText.text = NSLocalizedString("skill_pick", comment: "")
        nextBtn.setTitle(NSLocalizedString("next_button", comment: ""), for: .normal)
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
        cell.textLabel?.text = NSLocalizedString(Array(skills.keys)[indexPath.row], comment: "skill name")
        
        // Check accessory type while reusing cells
        if selectedSkills[Array(skills.keys)[indexPath.row]] != nil {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

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
