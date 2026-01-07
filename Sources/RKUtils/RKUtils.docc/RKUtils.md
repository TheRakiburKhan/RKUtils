# ``RKUtils``

Cross-platform Swift utilities and extensions for iOS, macOS, tvOS, watchOS, and visionOS.

## Overview

RKUtils provides battle-tested utilities for Foundation, UIKit, AppKit, and SwiftUI. Build beautiful, feature-rich applications across all Apple platforms with zero dependencies and consistent, well-documented APIs.

### Key Features

- **Cross-Platform Foundation** - String, Date, Number extensions that work everywhere
- **UIKit Extensions** - Simplified view styling, gradients, shadows, and animations for iOS/tvOS/visionOS
- **AppKit Extensions** - Complete macOS support with feature parity to UIKit
- **SwiftUI Support** - Color utilities and view modifiers for modern declarative UI
- **Zero Dependencies** - Lightweight and fast
- **Production Ready** - Battle-tested in real applications

### Quick Example

```swift
import RKUtils

// Foundation utilities work everywhere
"test@example.com".isValidEmail  // true
"2024-01-15".toDate(format: "yyyy-MM-dd")
1_234_567.abbreviated  // "1.2M"

// UIKit (iOS, tvOS, visionOS)
#if canImport(UIKit)
view.setCornerRadius(cornerRadius: 12)
view.setBorder(width: 2, color: .systemBlue)
let color = UIColor(hexString: "#FF5733")
#endif

// AppKit (macOS)
#if canImport(AppKit)
nsView.setCornerRadius(cornerRadius: 12)
nsView.setBorder(width: 2, color: .systemBlue)
let color = NSColor(hexString: "#FF5733")
#endif

// SwiftUI (all platforms)
Color(hexString: "#FF5733")
    .lighter(by: 0.2)
    .darker(by: 0.1)
```

## Topics

### Getting Started

Essential guides to get up and running quickly.

- <doc:Installation>
- <doc:QuickStart>
- <doc:Migration-Guide>
- <doc:Platform-Support>

### Foundation Extensions

Cross-platform utilities that work on all Apple platforms.

- ``Swift/String``
- ``Foundation/Date``
- ``Swift/Int``
- ``Swift/Double``
- ``Foundation/Bundle``
- ``Foundation/Data``
- ``Foundation/ProcessInfo``

### UIKit Extensions

Extensions for iOS, tvOS, and visionOS applications.

- ``UIKit/UIView``
- ``UIKit/UIColor``
- ``UIKit/UITextField``
- ``UIKit/UITextView``
- ``UIKit/UITableView``
- ``UIKit/UICollectionView``
- ``UIKit/UIDevice``
- ``UIKit/UIScreen``
- ``UIKit/UIStoryboard``
- ``CoreFoundation/CGRect``

### AppKit Extensions

Extensions for macOS applications.

- ``AppKit/NSView``
- ``AppKit/NSColor``
- ``AppKit/NSTextField``
- ``AppKit/NSSecureTextField``
- ``AppKit/NSTableView``
- ``AppKit/NSCollectionView``

### SwiftUI Extensions

Modern declarative UI utilities for all Apple platforms.

- ``SwiftUICore/Color``

## See Also

- [GitHub Repository](https://github.com/TheRakiburKhan/RKUtils)
- [Report Issues](https://github.com/TheRakiburKhan/RKUtils/issues)
- [Changelog](https://github.com/TheRakiburKhan/RKUtils/blob/main/CHANGELOG.md)
- [Contributing](https://github.com/TheRakiburKhan/RKUtils/blob/main/CONTRIBUTING.md)
