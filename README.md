# RKUtils

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20visionOS-blue.svg" alt="Platform">
  <img src="https://img.shields.io/badge/Swift-6.0+-orange.svg" alt="Swift">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
  <img src="https://img.shields.io/badge/SPM-Compatible-brightgreen.svg" alt="SPM">
</p>

**RKUtils** is a comprehensive, cross-platform Swift package offering a rich collection of extensions and utilities for UIKit, AppKit, and Foundation. Built for developers who value clean code, type safety, and productivity across all Apple platforms.

## ✨ Highlights

- 🍎 **Full Cross-Platform Support** - iOS, macOS, tvOS, watchOS, visionOS
- 🎨 **UIKit & AppKit Parity** - Consistent APIs across platforms
- 🧪 **124 Tests** - Comprehensive test coverage with Swift Testing
- 📦 **Zero Dependencies** - Lightweight and efficient
- 🔧 **Type-Safe** - Leverage Swift's type system for safer code
- 🚀 **Production Ready** - Battle-tested extensions

---

## 📦 Installation

### Swift Package Manager

#### Using Xcode:

1. Open your project in Xcode
2. Go to **File > Add Package Dependencies...**
3. Enter the repository URL:

```
https://github.com/TheRakiburKhan/RKUtils.git
```

4. Select the version and add to your target

#### Using Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/TheRakiburKhan/RKUtils.git", from: "2.0.0")
]
```

Then add the appropriate target to your dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "RKUtils", package: "RKUtils"),          // Cross-platform utilities
        .product(name: "RKUtilsUI", package: "RKUtils"),        // UIKit (iOS/tvOS/visionOS)
        .product(name: "RKUtilsMacOS", package: "RKUtils"),     // AppKit (macOS)
    ]
)
```

---

## 🎯 Features

### 🍎 iOS/tvOS/visionOS (UIKit)

#### UIView Extensions

```swift
import RKUtilsUI

// Corner radius & rounding
view.setCornerRadius(cornerRadius: 10)
view.roundedCorner(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 15)
view.rounded()  // Perfect circle

// Borders
view.setBorder(width: 2, color: .red, background: .white, radius: 8)

// Shadows
view.setShadow(color: .black, offset: CGSize(width: 0, height: 2), opacity: 0.3, radius: 4)

// Gradients
view.setLinearGradientBackground(
    colors: [.systemBlue, .systemPurple],
    startPoint: CGPoint(x: 0, y: 0),
    endPoint: CGPoint(x: 1, y: 1)
)

// Blur effects
view.applyBlurEffect(style: .regular)

// Animations
view.showViewWithAnimation(isHidden: false)
```

#### UIColor Extensions

```swift
// Hex color initialization
let color = UIColor(hexString: "#FF5733")
let colorWithAlpha = UIColor(hexString: "#FF5733", alpha: 0.8)
```

#### UITextField Extensions

```swift
// Secure text toggle with eye icon
textField.setSecureTextToggleToRight(.systemBlue)

// Text change publisher (Combine)
textField.textPublisher()
    .sink { text in
        print("Text changed: \(text)")
    }

// Padding
textField.setLeftPaddingPoints(16)
textField.setRightPaddingPoints(16)
```

#### CGRect Extensions

```swift
let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
let minSide = rect.minEdge  // Returns 50
```

---

### 🖥️ macOS (AppKit)

#### NSView Extensions

```swift
import RKUtilsMacOS

// Identical API to UIView!
view.setCornerRadius(cornerRadius: 10)
view.roundedCorner(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 15)
view.rounded()

// Borders
view.setBorder(width: 2, color: .red, background: .white, radius: 8)

// Shadows
view.setShadow(color: .black, offset: CGSize(width: 0, height: 2), opacity: 0.3, radius: 4)

// Gradients
view.setLinearGradientBackground(
    colors: [.systemBlue, .systemPurple],
    startPoint: CGPoint(x: 0, y: 0),
    endPoint: CGPoint(x: 1, y: 1)
)

// Blur effects with AppKit materials
view.applyBlurEffect(material: .contentBackground, blendingMode: .behindWindow)

// Animations
view.showViewWithAnimation(isHidden: false)
```

#### NSColor Extensions

```swift
// Hex color initialization (same as UIColor)
let color = NSColor(hexString: "#FF5733")
let colorWithAlpha = NSColor(hexString: "#FF5733", alpha: 0.8)
```

#### NSSecureTextField Extensions

```swift
// Password field with show/hide toggle
secureTextField.setSecureTextToggleToRight(.systemBlue)
// Adds eye icon button, uses SF Symbols on macOS 11.0+
```

#### NSTextField Extensions

```swift
// Text change publisher (Combine)
textField.textPublisher()
    .sink { text in
        print("Text changed: \(text)")
    }
```

#### NSCollectionView & NSTableView

```swift
// Type-safe cell registration
collectionView.register(cell: MyCell.self)
tableView.register(cell: MyTableCell.self)

// Type-safe dequeue
let cell = tableView.dequeueReusableCell(cell: MyTableCell.self, owner: self)
```

---

### 🌐 Cross-Platform (All Platforms)

#### String Extensions

```swift
// Email validation
"test@example.com".isValidEmail  // true

// Date parsing
let date = "2024-12-03".toDate(format: "yyyy-MM-dd")

// Base64 encoding
let encoded = "Hello World".base64Encoded
```

#### Date Extensions

```swift
let date = Date()

// Formatting
date.toString(format: "yyyy-MM-dd")  // "2024-12-03"
date.readable(dateStyle: .medium, timeStyle: .short)  // "Dec 3, 2024 at 2:30 PM"

// Manipulation
date.addingDays(7)
date.subtractingMonths(2)

// Relative time
date.relativeTime()  // "2 hours ago"

// Week dates
Date.currentWeekDates()  // Array of dates for current week
```

#### Int Extensions

```swift
let number = 42

// Formatting
number.abbreviated  // "42"
1200.abbreviated  // "1.2K"
2500000.abbreviated  // "2.5M"

// Localization
1234.toLocal(locale: Locale(identifier: "en_US"))  // "1,234"

// Word conversion
5.inWords  // "five"

// Utilities
10.times { print("Hello") }  // Prints "Hello" 10 times
```

#### Double Extensions

```swift
let value = 3.14159

// Formatting
value.roundedString(toPlaces: 2)  // "3.14"
value.percentage()  // "314.16%"
value.currency(code: "USD")  // "$3.14"

// Measurements
25.5.temperature(unit: .celsius)  // "25.5°C"
100.0.distance(unit: .kilometers)  // "100.0 km"
60.0.speed(unit: .kilometersPerHour)  // "60.0 km/h"

// Math utilities
value.clamped(to: 0.0...10.0)  // Clamps value to range
value.lerp(to: 10.0, by: 0.5)  // Linear interpolation
```

#### Bundle Extensions

```swift
// App information
Bundle.main.appVersion  // "1.0.0"
Bundle.main.buildNumber  // "42"
Bundle.main.displayName  // "MyApp"
```

#### CLLocationCoordinate2D Extensions

```swift
let london = CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)
let paris = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)

// Calculate bearing
let bearing = london.bearing(to: paris)  // Direction in degrees
```

#### Data Extensions

```swift
let data = Data()

// String conversion
data.appendString("Hello")
data.appendStrings(["Hello", "World"])
```

---

## 📱 Platform Requirements

| Platform    | Minimum Version   |
| ----------- | ----------------- |
| iOS         | 13.0+             |
| macOS       | 10.15+ (Catalina) |
| tvOS        | 13.0+             |
| watchOS     | 6.0+              |
| visionOS    | 1.0+              |
| macCatalyst | 13.0+             |

**Swift Version:** 6.0+
**Xcode Version:** 16.0+

---

## 🎨 Architecture

RKUtils is organized into three main targets:

### `RKUtils` (Cross-Platform)

Core utilities that work on all Apple platforms:

- String, Date, Int, Double extensions
- Bundle helpers
- CLLocationCoordinate2D utilities
- Data extensions

### `RKUtilsUI` (UIKit Platforms)

UIKit-specific extensions for iOS, tvOS, visionOS, and macCatalyst:

- UIView, UIColor, UITextField
- CGRect utilities

### `RKUtilsMacOS` (AppKit Platform)

AppKit-specific extensions for macOS:

- NSView, NSColor, NSTextField, NSSecureTextField
- NSCollectionView, NSTableView helpers

**Philosophy:** Maximum code reuse with platform-specific adaptations where needed. Consistent APIs across platforms for easier cross-platform development.

---

## 🧪 Testing

RKUtils includes **124 comprehensive tests** using the modern **Swift Testing** framework:

```bash
swift test
```

**Test Coverage:**

- ✅ 109 cross-platform core tests
- ✅ 27 UIKit tests
- ✅ 17 AppKit tests
- ✅ All tests passing on all platforms

---

## 📖 Documentation

### Code Examples

All extensions are thoroughly documented with inline documentation. Use Xcode's Quick Help (⌥ + Click) to view documentation for any method.

### Migration Guides

See [CHANGELOG.md](CHANGELOG.md) for:

- Migration from UIKit to AppKit
- Migration from XCTest to Swift Testing
- Complete feature list and version history

---

## 🤝 Contributing

Contributions are welcome! We love your input and appreciate any contributions, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

Please read our [Contributing Guidelines](CONTRIBUTING.md) for details on our code of conduct, development process, and how to submit pull requests.

---

## 📄 License

RKUtils is released under the MIT License. See [LICENSE](LICENSE) for full details.

Copyright (c) 2024 Rakibur Khan

---

## 👤 Author

**Rakibur Khan**

Passionate iOS & macOS developer focused on clean architecture, performance, and developer productivity.

- 🔗 GitHub: [@TheRakiburKhan](https://github.com/TheRakiburKhan)
- 📧 Email: [therakiburkhan@gmail.com](mailto:therakiburkhan@gmail.com)
- 💼 LinkedIn: [LinkedIn](https://linkedin.com/in/TheRakiburKhan)

---

## 🌟 Acknowledgments

Special thanks to:

- The Swift community for inspiration
- All contributors who help improve this package
- Apple for providing excellent platform APIs

---

## 📊 Stats

![GitHub stars](https://img.shields.io/github/stars/TheRakiburKhan/RKUtils?style=social)
![GitHub forks](https://img.shields.io/github/forks/TheRakiburKhan/RKUtils?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/TheRakiburKhan/RKUtils?style=social)

---

<p align="center">Made with ❤️ by Rakibur Khan</p>
<p align="center">If you find this package useful, please consider giving it a ⭐️</p>
