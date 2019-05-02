//
//  ViewController.swift
//  Headlight
//
//  Created by Tuomas Pöyry on 16/04/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var fetcher : DataFetcher = DataFetcher()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Init user here for now, TODO: needs to be moved
        fetcher.FetchInitialData()
        for i in CoreDataHelper.listAllCourses()
        {
            print(i.location)
        }

    }
}

