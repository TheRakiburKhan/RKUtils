# ``RKUtils/_LocationEssentials/CLLocationCoordinate2D``

Powerful geographic coordinate utilities for location-based calculations.

## Overview

`CLLocationCoordinate2D` extensions provide geographic calculation utilities, enabling you to compute bearings and directions between coordinates with precision.

> Important: These extensions require `CoreLocation` framework and are only available on platforms that support it (iOS, macOS, tvOS, watchOS). Not available on Linux.

### Calculating Bearing Between Coordinates

Use ``CLLocationCoordinate2D/bearing(to:)`` to determine the compass direction from one location to another:

```swift
import CoreLocation
import RKUtils

let sanFrancisco = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
let losAngeles = CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)

let bearing = sanFrancisco.bearing(to: losAngeles)
print("Direction: \(bearing)°")  // ~135° (Southeast)
```

### Understanding Bearing Values

Bearing is returned in degrees (0-360):

| Bearing | Direction | Cardinal |
|---------|-----------|----------|
| 0° | North | N |
| 45° | Northeast | NE |
| 90° | East | E |
| 135° | Southeast | SE |
| 180° | South | S |
| 225° | Southwest | SW |
| 270° | West | W |
| 315° | Northwest | NW |

### Real-World Examples

#### Navigation Arrow

Display a navigation arrow pointing toward a destination:

```swift
let currentLocation = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)  // NYC
let destination = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)       // Paris

let bearing = currentLocation.bearing(to: destination)

// Use bearing to rotate navigation arrow
let rotationAngle = bearing - deviceHeading  // Adjust for device orientation
navigationArrowView.transform = CGAffineTransform(rotationAngle: rotationAngle.toRadians)
```

#### Compass Direction Label

Show human-readable direction:

```swift
func cardinalDirection(from bearing: Double) -> String {
    switch bearing {
    case 0..<22.5, 337.5..<360: return "North"
    case 22.5..<67.5: return "Northeast"
    case 67.5..<112.5: return "East"
    case 112.5..<157.5: return "Southeast"
    case 157.5..<202.5: return "South"
    case 202.5..<247.5: return "Southwest"
    case 247.5..<292.5: return "West"
    case 292.5..<337.5: return "Northwest"
    default: return "Unknown"
    }
}

let home = CLLocationCoordinate2D(latitude: 37.3861, longitude: -122.0839)  // Cupertino
let work = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)  // San Francisco

let bearing = home.bearing(to: work)
let direction = cardinalDirection(from: bearing)
print("Work is \(direction) of home")  // "Work is North of home"
```

#### Route Planning

Calculate bearing changes for multi-waypoint routes:

```swift
let waypoints = [
    CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),  // NYC
    CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298),  // Chicago
    CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)  // LA
]

for i in 0..<waypoints.count - 1 {
    let from = waypoints[i]
    let to = waypoints[i + 1]
    let bearing = from.bearing(to: to)

    print("Leg \(i + 1): Head \(bearing)°")
}
```

### Precision and Accuracy

The bearing calculation uses the **forward azimuth** formula, which accounts for Earth's curvature. This provides accurate bearings for distances ranging from meters to thousands of kilometers.

**Note:** For very short distances (< 10 meters), minor bearing variations may occur due to GPS precision limits.

### Platform Availability

| Platform | Available | Notes |
|----------|-----------|-------|
| iOS | ✅ | Full support |
| macOS | ✅ | Full support |
| tvOS | ✅ | Full support |
| watchOS | ✅ | Full support |
| visionOS | ✅ | Full support |
| Linux | ❌ | CoreLocation not available |

## Topics

### Calculations

- ``CLLocationCoordinate2D/bearing(to:)``
