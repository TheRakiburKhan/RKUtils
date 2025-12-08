//
//  CLLocationCoordinate2D.swift
//  RKUtils
//
//
//  Created by Rakibur Khan on 2/4/24.
//

#if canImport(CoreLocation)
import CoreLocation

public extension CLLocationCoordinate2D {
    /**
     Calculates the bearing (direction angle) from this coordinate to another coordinate.

     Returns the bearing in degrees, where:
     - 0° = North
     - 90° = East
     - 180° = South
     - 270° = West

     - Parameter point: The destination coordinate.

     - Returns: The bearing in degrees (0-360).

     - Example:
     ```swift
     let from = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)  // San Francisco
     let to = CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)    // Los Angeles
     let bearing = from.bearing(to: to)  // ~135° (Southeast)
     ```
     */
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
#endif
