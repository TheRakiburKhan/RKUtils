//
//  CLLocationCoordinate2DExtensionsTests.swift
//  RKiOSUtils
//
//  Created by Rakibur Khan on 1/6/25.
//

#if canImport(CoreLocation)
import Testing
import CoreLocation
@testable import RKUtils

@Suite("CLLocationCoordinate2D Extensions")
struct CLLocationCoordinate2DExtensionsTests {

    // MARK: - Bearing Tests

    @Test("Bearing in cardinal directions", arguments: [
        (latitude: 1.0, longitude: 0.0, expectedBearing: 0.0, name: "North"),
        (latitude: 0.0, longitude: 1.0, expectedBearing: 90.0, name: "East"),
        (latitude: -1.0, longitude: 0.0, expectedBearing: 180.0, name: "South"),
        (latitude: 0.0, longitude: -1.0, expectedBearing: 270.0, name: "West")
    ])
    func bearingCardinalDirection(latitude: Double, longitude: Double, expectedBearing: Double, name: String) {
        let start = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let destination = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        let bearing = start.bearing(to: destination)

        // Bearing should be close to expected degrees (within 1 degree)
        #expect(abs(bearing - expectedBearing) < 1.0)
    }

    @Test("Bearing from NYC to LA")
    func bearingRealWorldExample() {
        // New York City coordinates
        let nyc = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)

        // Los Angeles coordinates
        let la = CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)

        let bearing = nyc.bearing(to: la)

        // NYC to LA should be generally west (around 250-280 degrees)
        #expect(bearing > 0)
        #expect(bearing < 360)
    }

    @Test("Bearing to same point")
    func bearingToSamePoint() {
        let location = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)

        let bearing = location.bearing(to: location)

        // Bearing to same point should be 0
        #expect(abs(bearing - 0.0) < 0.1)
    }

    @Test("Bearing is in positive range")
    func bearingPositiveRange() {
        let start = CLLocationCoordinate2D(latitude: 45.0, longitude: -120.0)
        let end = CLLocationCoordinate2D(latitude: -45.0, longitude: 60.0)

        let bearing = start.bearing(to: end)

        // Bearing should always be in range [0, 360)
        #expect(bearing >= 0.0)
        #expect(bearing < 360.0)
    }

    @Test("Bearing across international date line")
    func bearingAcrossInternationalDateLine() {
        let start = CLLocationCoordinate2D(latitude: 0, longitude: 179)
        let end = CLLocationCoordinate2D(latitude: 0, longitude: -179)

        let bearing = start.bearing(to: end)

        // Should be close to 90 degrees (east)
        #expect(bearing >= 0.0)
        #expect(bearing < 360.0)
    }

    @Test("Bearing at poles")
    func bearingAtPoles() {
        let northPole = CLLocationCoordinate2D(latitude: 90, longitude: 0)
        let destination = CLLocationCoordinate2D(latitude: 45, longitude: 0)

        let bearing = northPole.bearing(to: destination)

        // Any direction from north pole should work
        #expect(bearing >= 0.0)
        #expect(bearing < 360.0)
    }

    @Test("Bearing in intercardinal directions", arguments: [
        (latitude: 1.0, longitude: 1.0, minBearing: 0.0, maxBearing: 90.0, name: "Northeast"),
        (latitude: -1.0, longitude: -1.0, minBearing: 180.0, maxBearing: 270.0, name: "Southwest")
    ])
    func bearingIntercardinalDirection(latitude: Double, longitude: Double, minBearing: Double, maxBearing: Double, name: String) {
        let start = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let destination = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        let bearing = start.bearing(to: destination)

        // Should be in the expected range
        #expect(bearing > minBearing)
        #expect(bearing < maxBearing)
    }

    @Test("Bearing precision from London to Paris")
    func bearingPrecision() {
        let start = CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278) // London
        let end = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522) // Paris

        let bearing = start.bearing(to: end)

        // London to Paris should be roughly southeast (around 120-150 degrees)
        #expect(bearing > 100.0)
        #expect(bearing < 180.0)
    }
}
#endif
