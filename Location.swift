//
//  Locations.swift
//  Location Base
//
//  Created by Gianluca Rago on 7/8/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit
import CoreLocation

class Location {
    
    private static var locationManager:CLLocationManager?
    
    static func prepare() -> CLLocationManager {
        if let manager = locationManager {
            return manager
        } else {
            locationManager = CLLocationManager()
            locationManager!.requestAlwaysAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager!.desiredAccuracy = kCLLocationAccuracyBest
                locationManager!.startUpdatingLocation()
            }
            if CLLocationManager.headingAvailable() {
                locationManager!.headingFilter = 2
                locationManager!.startUpdatingHeading()
            }
            return locationManager!
        }
    }
    
    static func currentCoords() -> CLLocationCoordinate2D {
        if let manager = locationManager {
            return manager.location!.coordinate
        } else {
            return prepare().location!.coordinate
        }
    }
    
    static func radians(fromDegrees:Double) -> Double { return fromDegrees * .pi / 180.0 }
    static func degrees(fromRadians:Double) -> Double { return fromRadians * 180.0 / .pi }

}
