//
//  CLLocationCoordinate2D.swift
//  RKUtils
//
//
//  Created by Rakibur Khan on 2/4/24.
//

import CoreLocation

public extension CLLocationCoordinate2D {
    func bearing(to point: CLLocationCoordinate2D) -> Double {
        let fromLatitude = latitude.toRadians
        let fromLongitude = longitude.toRadians
        
        let toLatitude = point.latitude.toRadians
        let toLongitude = point.longitude.toRadians
        
        let differenceLongitude = toLongitude - fromLongitude
        
        let y = sin(differenceLongitude) * cos(toLatitude)
        let x = cos(fromLatitude) * sin(toLatitude) - sin(fromLatitude) * cos(toLatitude) * cos(differenceLongitude)
        let radiansBearing = atan2(y, x)
        let degree = radiansBearing.toDegrees
        return (degree >= 0) ? degree : (360 + degree)
    }
}
