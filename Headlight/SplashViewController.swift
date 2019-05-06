//
//  SplashViewController.swift
//  Headlight
//
//  Created by Tuomas Pöyry on 06/05/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // This logic will do
    func decideWhichScreenToShow(){
        if !UserDefaults.standard.bool(forKey: "your_key"){
            // This will execute first time, in that controller's viewDidLoad() make this true
        }else{
            
        }
    }
}
