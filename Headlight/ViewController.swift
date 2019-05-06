//
//  ViewController.swift
//  Headlight
//
//  Created by Tuomas Pöyry on 16/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var fetcher: DataFetcher?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetcher = DataFetcher()
        fetcher?.FetchInitialData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // for developments only
        // ==========================
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Hamed", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "coursePage01") as! CoursePageViewController
//        nextViewController.course = CoreDataHelper.findCourseByID("metropolia-mobile-01")
//        self.present(nextViewController, animated:true, completion:nil)
        // ==========================
        
        
        let user = CoreDataHelper.getUserData()
        if user != nil && user?.name.count ?? 0 > 0 {
            performSegue(withIdentifier: "frontPageSegue", sender: self)
        } else {
            performSegue(withIdentifier: "signUpSegue", sender: self)
        }
    }
}

