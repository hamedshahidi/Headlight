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
    struct coordinates {
        static var lat = 0.0
        static var long = 0.0
    }

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCoordinates()
        
        // Set map region based on location
        let location = CLLocation(latitude: coordinates.lat, longitude: coordinates.long)
        let regionRadius: CLLocationDistance = 1000.0
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        map.setRegion(region, animated: true)
        
        // Add a pin on location
        let pin = MKPointAnnotation()
        pin.title = course?.organization ?? ""
        pin.coordinate = CLLocationCoordinate2D(latitude: coordinates.lat, longitude: coordinates.long)
        map.addAnnotation(pin)
    }
    
    func getCoordinates() {
        coordinates.lat = course?.location?.ltd ?? 0.0
        coordinates.long = course?.location?.lgn ?? 0.0
    }
}
