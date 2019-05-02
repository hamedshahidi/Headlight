//
//  SignupNameViewController.swift
//  Headlight
//
//  Created by iosdev on 21/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class SignupNameViewController: UIViewController {

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var welcomeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.background
        enterButton.backgroundColor = Theme.tint
        enterButton.tintColor = Theme.background
        enterButton.layer.cornerRadius = 4
        welcomeText.text = NSLocalizedString("get_started", comment: "")
        nameField.placeholder = NSLocalizedString("name_placeholder_text", comment: "")
        enterButton.setTitle(NSLocalizedString("enter_button_text", comment: ""), for: .normal)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let skillView = segue.destination as! SignupSkillsViewController
        if nameField?.text?.count ?? 0 > 0 && nameField?.text?.count ?? 0 < 21 {
            skillView.name = nameField?.text ?? ""
        } else {
            createAlert(errorMsg: NSLocalizedString("err_name_creation", comment: ""))
        }
    }
 
    func createAlert(errorMsg: String) {
        let alert = UIAlertController(title: NSLocalizedString("err_name_creation_title", comment: ""), message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
