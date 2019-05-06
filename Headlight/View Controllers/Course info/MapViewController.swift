//
//  MapViewController.swift
//  Headlight
//
//  Created by iosdev on 06/05/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var course: CourseStruct.Course? = nil
    struct cordinates {
        static var lat = 0.0
        static var long = 0.0
    }

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCourseCordinates()
//        let location = CLLocation(latitude: 37.334722, longitude: -122.008889)
        let location = CLLocation(latitude: cordinates.lat, longitude: cordinates.long)
        let regionRadius: CLLocationDistance = 1000.0
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        map.setRegion(region, animated: true)
        

    }
    
    func getCourseCordinates() {
        cordinates.lat = course?.location?.ltd ?? 0.0
        cordinates.long = course?.location?.lgn ?? 0.0
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
