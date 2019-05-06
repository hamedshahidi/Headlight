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
    @IBOutlet weak var skillNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.background
        nextBtn.backgroundColor = Theme.tint
        nextBtn.tintColor = Theme.background
        tableView.layer.cornerRadius = 16
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
        cell.textLabel?.textColor = Theme.dark1
        
        // Check accessory type while reusing cells
        if selectedSkills[Array(skills.keys)[indexPath.row]] != nil {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.black

        } else {
            cell.accessoryType = .none
            cell.textLabel?.textColor = Theme.dark1
        }

        return cell
    }
    
    // Append skill to selected skills
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Add/remove skill
        if selectedSkills[Array(skills.keys)[indexPath.row]] == nil {
            selectedSkills[Array(skills.keys)[indexPath.row]] = Array(skills.keys)[indexPath.row]
            self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            self.tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor.black
            self.updateSkillNumber()
        } else {
            selectedSkills.removeValue(forKey: Array(skills.keys)[indexPath.row])
            self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
            self.tableView.cellForRow(at: indexPath)?.textLabel?.textColor = Theme.dark1
            self.updateSkillNumber()
        }
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func updateSkillNumber() {
        let localizedStr: String
        if selectedSkills.count == 1 {
            localizedStr = NSLocalizedString("skill_chosen", comment: "")
        } else {
            localizedStr = NSLocalizedString("skills_chosen", comment: "")
        }
        skillNumberLabel.text = String(selectedSkills.count) + " " + localizedStr
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
        CoreDataHelper.addToUserSkills(skills: Array(selectedSkills.values))
        print(CoreDataHelper.getUserData()?.name, CoreDataHelper.getUserData()?.skills)
    }
    @IBAction func clearUserData(_ sender: Any) {
        CoreDataHelper.clearUserData()
    }
    
}
