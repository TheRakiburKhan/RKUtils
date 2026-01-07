# Installation

Add RKUtils to your iOS, macOS, tvOS, watchOS, or visionOS project.

## Overview

RKUtils is distributed as a Swift Package and can be easily integrated into your Xcode projects or Swift Package Manager-based projects. The single unified library works across all Apple platforms with zero external dependencies.

## Swift Package Manager

### Xcode Integration

The easiest way to add RKUtils to your project is through Xcode's built-in Swift Package Manager support.

1. Open your project in Xcode
2. Go to **File > Add Package Dependencies...**
3. Enter the repository URL:
   ```
   https://github.com/TheRakiburKhan/RKUtils.git
   ```
4. Select version rule:
   - **Recommended:** "Up to Next Major Version" with `3.0.0` as the minimum
   - This ensures you get bug fixes and new features while avoiding breaking changes
5. Click **Add Package**
6. Select **RKUtils** as the product for your target
7. Click **Add Package** again

Your project will now have access to all RKUtils extensions and utilities.

### Package.swift Integration

For Swift Package Manager projects, add RKUtils as a dependency in your `Package.swift` file.

#### Step 1: Add to Dependencies

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "YourProject",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7),
        .visionOS(.v1)
    ],
    dependencies: [
        .package(
            url: "https://github.com/TheRakiburKhan/RKUtils.git",
            from: "3.0.0"
        )
    ],
    targets: [
        .target(
            name: "YourTarget",
            dependencies: [
                .product(name: "RKUtils", package: "RKUtils")
            ]
        )
    ]
)
```

#### Step 2: Import in Your Code

```swift
import RKUtils

// All extensions are now available
let isValid = "test@example.com".isValidEmail
```

## Platform Requirements

### Minimum Versions

- **iOS** 14.0+
- **macOS** 11.0+
- **tvOS** 14.0+
- **watchOS** 7.0+
- **visionOS** 1.0+
- **Mac Catalyst** 14.0+

### Development Requirements

- **Xcode** 16.0+
- **Swift** 6.0+

## What's Included

When you import RKUtils, you get access to:

### Cross-Platform Foundation Extensions

Available on **all platforms** including Linux:

- **String** - Email validation, date parsing, Base64 encoding, digit/word conversion
- **Date** - Formatting, relative time, date arithmetic, distance calculations
- **Int** - Locale formatting, abbreviations, pluralization, byte sizes
- **Double** - Number formatting, scientific notation, measurements, conversions
- **Bundle** - Version info, display name, environment detection
- **Data** - String appending utilities
- **ProcessInfo** - Preview detection for SwiftUI

### UIKit Extensions (iOS, tvOS, visionOS)

Available when you `import RKUtils` on UIKit platforms:

- **UIView** - Corner radius, borders, shadows, gradients, blur effects, animations
- **UIColor** - Hex colors, brightness manipulation, random colors, WCAG accessibility
- **UITextField** - Combine publishers, padding utilities
- **UITableView** - Type-safe cell registration and dequeuing
- **UICollectionView** - Type-safe cell registration and dequeuing
- **UIDevice** - Device detection utilities
- **UIScreen** - Screen dimension helpers
- **UIStoryboard** - Type-safe view controller instantiation
- **CGRect** - Geometry utilities

### AppKit Extensions (macOS)

Available when you `import RKUtils` on macOS:

- **NSView** - Corner radius, borders, shadows, gradients, blur effects (mirrors UIView API)
- **NSColor** - Hex colors, brightness manipulation, random colors, WCAG accessibility
- **NSTextField** - Combine publishers, padding utilities
- **NSSecureTextField** - Password visibility toggle
- **NSTableView** - Type-safe cell registration and dequeuing
- **NSCollectionView** - Type-safe cell registration and dequeuing

### SwiftUI Extensions (Apple Platforms)

Available on all Apple platforms:

- **Color** - Hex colors, brightness manipulation, random colors, component extraction, WCAG accessibility

## Platform-Specific Usage

RKUtils uses conditional compilation to provide platform-specific APIs. You don't need to do anything special - just import RKUtils and use the extensions appropriate for your platform.

### iOS Example

```swift
import SwiftUI
import RKUtils

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .foregroundColor(.white)
            .padding()
            .background(Color(hexString: "#007AFF"))
    }
}

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.setCornerRadius(cornerRadius: 12)
        view.backgroundColor = UIColor(hexString: "#FF5733")
    }
}
```

### macOS Example

```swift
import SwiftUI
import RKUtils

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .foregroundColor(.white)
            .padding()
            .background(Color(hexString: "#007AFF"))
    }
}

class MyViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.setCornerRadius(cornerRadius: 12)
        view.layer?.backgroundColor = NSColor(hexString: "#FF5733").cgColor
    }
}
```

### Cross-Platform Example

```swift
import Foundation
import RKUtils

// Works on ALL platforms including Linux
func formatUserData() {
    let email = "user@example.com"
    if email.isValidEmail {
        print("Valid email!")
    }

    let count = 1_234_567
    print(count.abbreviated)  // "1.2M"

    let date = Date()
    print(date.toString(format: "yyyy-MM-dd"))
}
```

## Verifying Installation

After adding RKUtils, verify it's working correctly:

```swift
import RKUtils

// Test Foundation extensions
print("test@example.com".isValidEmail)  // true
print(1000.abbreviated)  // "1K"

// Test platform-specific extensions
#if canImport(UIKit)
let color = UIColor(hexString: "#FF5733")
print("UIKit available")
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
let color = NSColor(hexString: "#FF5733")
print("AppKit available")
#endif
```

## Troubleshooting

### Package Resolution Fails

If Xcode fails to resolve the package:

1. Go to **File > Packages > Reset Package Caches**
2. Try resolving packages again
3. If issues persist, delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`

### Import Errors

If you see "No such module 'RKUtils'":

1. Ensure the package is added to your target's dependencies
2. Clean build folder: **Product > Clean Build Folder** (Cmd+Shift+K)
3. Rebuild your project

### Platform Availability Errors

If you get errors about unavailable APIs:

1. Check your deployment target meets the minimum requirements (iOS 14+, macOS 11+, etc.)
2. Update your deployment target in Xcode project settings or Package.swift

## Next Steps

- <doc:QuickStart> - Learn how to use RKUtils in your project
- <doc:Migration-Guide> - Migrating from v2.x to v3.0
- <doc:Platform-Support> - Platform-specific features and limitations

## Additional Resources

- [GitHub Repository](https://github.com/TheRakiburKhan/RKUtils)
- [API Documentation](https://swiftpackageindex.com/TheRakiburKhan/RKUtils/documentation)
- [Report Issues](https://github.com/TheRakiburKhan/RKUtils/issues)
- [Changelog](https://github.com/TheRakiburKhan/RKUtils/blob/main/CHANGELOG.md)
