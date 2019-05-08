//
//  LocationManager.swift
//  Headlight
//
//  Created by iosdev on 07/05/2019.
//  Copyright © 2019 iSchoolMusical. All rights reserved.
//

import Foundation
import MapKit

class CustomLocationManager {
    
    init() {}
    
    // Get coordinates of course
    func getCoordinatesForCourse(_ course: CourseStruct.Course?) -> CLLocation {
        let coordinates = GeoData.Coordinates(lat: course?.location?.ltd ?? 0.0, long: course?.location?.lgn ?? 0.0)
        
        return CLLocation(latitude: coordinates.lat, longitude: coordinates.long)
    }
    
    // Find place name of given location by converting CLLocation object coordinates into human readable place name
    // and feed it to provided target
    func feedLocationName(_ location: CLLocation, target: Any ) {
        
        // Reverse Geocoding CLLocation object to find placemark
        CLGeocoder().reverseGeocodeLocation(location){ ( placemarks, error ) in
            self.placemarkHandler(placemarks, error, target)
        }
    }
    
    // process reverseGeocodeLocation response and extraxt string from placemark
    func placemarkHandler(_ placemarks: [CLPlacemark]?, _ error: Error?, _ target: Any) {
        var result = ""
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                result = placemark.compactAddress
            }
        }
        
        if let label = target as? UILabel {
            label.text = result
        }
        
        if let annotationPoint = target as? MKPointAnnotation {
            annotationPoint.title = result
        }
    }
}

extension CLPlacemark {

    var compactAddress: String {
        var result = ""
        
        if let street = thoroughfare {
            result += "\(street) "
        }
        
        if let subStreet = subThoroughfare {
            result += "\(subStreet) "
        }
        
        if let postalCode = postalCode {
            result += "\n\(postalCode) "
        }
        
        if let city = locality {
            result += "\(city)"
        }
        
        return result
    }
}

class GeoData {

    struct Coordinates {
        var lat: Double
        var long: Double
    }
}
