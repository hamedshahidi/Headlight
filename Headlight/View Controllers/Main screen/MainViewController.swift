//
//  MainViewController.swift
//  Headlight
//
//  Created by iosdev on 23/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource {
  
    var coursePaths = ["Course path 1", "Course path 2", "Course path 3", "Course path 4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return coursePaths.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CourseRow
        return cell
    }
    
    private func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return coursePaths[section]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
