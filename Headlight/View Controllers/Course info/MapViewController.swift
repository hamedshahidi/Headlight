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

    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var mapTypeChanger: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getCoordinates()
        initializeUISettings()
        
        let locationManager = CustomLocationManager()
        
        // Get coordinates of current course
        let location = locationManager.getCoordinatesForCourse(course)
        
        // Set map region based on coordinates
        let regionRadius: CLLocationDistance = 600.0
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        map.setRegion(region, animated: true)
        
        // Initialize a pin for location
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        // Find place name by coordinates and feed to UI
        locationManager.feedLocationName(location, target: pin)
        
        // Add pin to map
        map.addAnnotation(pin)
    }
    
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            map.mapType = .standard
        default:
            map.mapType = .satellite
        }
    }
    
    func initializeUISettings() {
        self.navigationItem.title = NSLocalizedString("map_page_title", comment: "")
        mapTypeChanger.layer.cornerRadius = 8
        mapTypeChanger.borderWidth = 2
        mapTypeChanger.borderColor = Theme.accent
        mapTypeChanger.backgroundColor = Theme.background
        mapTypeChanger.tintColor = Theme.accent
        mapTypeChanger.layer.masksToBounds = true
        let font = UIFont.boldSystemFont(ofSize: 16)
        mapTypeChanger.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        mapTypeChanger.setTitle(NSLocalizedString("map_changer_normal", comment: ""), forSegmentAt: 0)
        mapTypeChanger.setTitle(NSLocalizedString("map_changer_satellite", comment: ""), forSegmentAt: 1)
    }

}
