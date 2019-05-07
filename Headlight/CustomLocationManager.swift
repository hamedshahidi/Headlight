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
    
//    let course: CourseStruct.Course? = nil
    
//    struct Coordinates {
//        var lat: Double
//        var long: Double
//    }
    
    
    // Get coordinates of course
    static func getCoordinatesForCourse(_ course: CourseStruct.Course?) -> CLLocation {
        let coordinates = GeoData.Coordinates(lat: course?.location?.ltd ?? 0.0, long: course?.location?.lgn ?? 0.0)
        
        return CLLocation(latitude: coordinates.lat, longitude: coordinates.long)
    }
    
    
    // Find place name of location on map by converting CLLocation object
    // which containes coordinates into human readable place name
    func findLocationName(_ location: CLLocation ) -> String {
        var locationName: String = ""
        
        // Reverse Geocoding CLLocation object
        CLGeocoder().reverseGeocodeLocation(location){ ( placemarks, error ) in
            locationName = self.placemarkHandler(placemarks, error)
        }
        
        return locationName
    }
    
    
    // process reverseGeocodeLocation response and extraxt string from placemark
    func placemarkHandler(_ placemarks: [CLPlacemark]?, _ error: Error?) -> String {
        
        var result = ""
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            result = "-"
            
        } else {
        
            if let placemarks = placemarks, let placemark = placemarks.first {
                result = placemark.compactAddress
            }
        }
        
        return result
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
