//
//  Locations.swift
//  Core
//
//  Created by Gianluca Rago on 7/8/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit
import CoreLocation

class Location: NSObject {
    
    static var locationManager:CLLocationManager?
    private static var regions:[String:CLRegion] = [:]
    
    static func prepare(uuid:UUID? = nil) -> CLLocationManager? {
        if let manager = locationManager {
            return manager
        } else {
            locationManager = CLLocationManager()
            locationManager!.requestAlwaysAuthorization()
            if isEnabled() {
                locationManager!.desiredAccuracy = kCLLocationAccuracyBest
                locationManager!.pausesLocationUpdatesAutomatically = false
                locationManager!.allowsBackgroundLocationUpdates = true
                locationManager!.startUpdatingLocation()
                if uuid != nil {
                    let region = CLBeaconRegion(proximityUUID:uuid!, identifier:"beacon")
                    region.notifyOnEntry = true
                    region.notifyOnExit = true
                    locationManager!.startMonitoring(for:region)
                    locationManager!.startRangingBeacons(in:region)
                }
                if CLLocationManager.headingAvailable() {
                    locationManager!.headingFilter = 2
                    locationManager!.startUpdatingHeading()
                }
                return locationManager!
            }
            return nil
        }
    }
    
    static func isEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    static func coords() -> CLLocationCoordinate2D? {
        if let manager = locationManager {
            return manager.location!.coordinate
        } else {
            if let manager = prepare() {
                return manager.location!.coordinate
            }
            return nil
        }
    }
    
    static func monitor(id:String, location:CLLocationCoordinate2D) -> CLRegion {
        let radius:CLLocationDistance = 10.0
        let region:CLRegion = CLCircularRegion(center:location, radius:radius, identifier:id)
        locationManager!.startMonitoring(for:region)
        regions[id] = region
        return region
    }
    
    static func distance(coordA:CLLocationCoordinate2D, coordB:CLLocationCoordinate2D) -> Double {
        let a:CLLocation = CLLocation(latitude:coordA.latitude, longitude:coordA.longitude)
        let b:CLLocation = CLLocation(latitude:coordB.latitude, longitude:coordB.longitude)
        return a.distance(from:b)
    }
    
    static func toFeet(meters:Double) -> Double {
        return meters*3.28084
    }
    
    static func radians(fromDegrees:Double) -> Double { return fromDegrees * .pi / 180.0 }
    static func degrees(fromRadians:Double) -> Double { return fromRadians * 180.0 / .pi }

}
