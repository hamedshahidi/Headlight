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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //resizeImage()
        // Do any additional setup after loading the view.
    }
    
    func resizeImage() {
        logoView.image?.stretchableImage(withLeftCapWidth: 150, topCapHeight: 150)
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let skillView = segue.destination as! SignupSkillsViewController
        if nameField?.text?.count ?? 0 > 0 && nameField?.text?.count ?? 0 < 21 {
            skillView.name = nameField?.text ?? ""
        } else {
            createAlert(errorMsg: "Please enter a name between 1-20 characters.")
        }
    }
 
    func createAlert(errorMsg: String) {
        let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
