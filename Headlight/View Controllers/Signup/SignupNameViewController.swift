//
//  SignupNameViewController.swift
//  Headlight
//
//  Created by iosdev on 21/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class SignupNameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    var keyboardPresent: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.backgroundColor = Theme.background
        contentView.backgroundColor = Theme.background
        enterButton.backgroundColor = Theme.dark3
        enterButton.tintColor = Theme.dark1
        enterButton.layer.cornerRadius = 4
        welcomeText.text = NSLocalizedString("get_started", comment: "")
        nameField.placeholder = NSLocalizedString("name_placeholder_text", comment: "")
        enterButton.setTitle(NSLocalizedString("enter_button_text", comment: ""), for: .normal)
    }
    
    @IBAction func nameFieldOnChange(_ sender: Any) {
        if nameField?.text?.count ?? 0 > 0 && nameField?.text?.count ?? 0 < 21 {
            enterButton.backgroundColor = Theme.tint
            enterButton.tintColor = Theme.background
        } else {
            enterButton.backgroundColor = Theme.dark3
            enterButton.tintColor = Theme.dark1
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as?NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + 64, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            
            if self.view.frame.origin.y == 0 {
                //self.view.frame.origin.y -= keyboardSize.height
                
            }
        }

    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        if self.view.frame.origin.y != 0{
            //self.view.frame.origin.y = 0

        }
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
