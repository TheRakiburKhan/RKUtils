# RKUtils

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FTheRakiburKhan%2FRKUtils%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/TheRakiburKhan/RKUtils)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FTheRakiburKhan%2FRKUtils%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/TheRakiburKhan/RKUtils)
![SPM](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)
[![wakatime](https://wakatime.com/badge/github/TheRakiburKhan/RKUtils.svg)](https://wakatime.com/badge/github/TheRakiburKhan/RKUtils)
[![CI](https://github.com/TheRakiburKhan/RKUtils/actions/workflows/ci.yml/badge.svg)](https://github.com/TheRakiburKhan/RKUtils/actions/workflows/ci.yml)

A comprehensive, cross-platform Swift package with extensions and utilities for UIKit, AppKit, and Foundation.

## Features

- 🌐 **Cross-Platform** - Works on iOS, macOS, tvOS, watchOS, visionOS, and Linux
- 🎨 **UIKit & AppKit** - Consistent APIs with platform parity
- 📦 **Zero Dependencies** - Lightweight and efficient
- 🧪 **Well Tested** - Comprehensive test coverage (194 tests)
- 🚀 **Production Ready** - Battle-tested in production apps

---

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/TheRakiburKhan/RKUtils.git", from: "3.0.0")
]
```

### Xcode

1. **File > Add Package Dependencies...**
2. Enter: `https://github.com/TheRakiburKhan/RKUtils.git`
3. Select version **3.0.0+** and add to your target

### Target Configuration

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "RKUtils", package: "RKUtils")
    ]
)
```

---

## Quick Examples

### Foundation Extensions

```swift
import RKUtils

// String
"test@example.com".isValidEmail  // true
"2024-12-08".toDate(stringFormat: "yyyy-MM-dd")

// Date
Date().toString(format: "yyyy-MM-dd")
Date().relativeTime()  // "2 hours ago" (Apple platforms only)

// Numbers
1234.abbreviated  // "1.2K"
3.14159.roundedString(toPlaces: 2)  // "3.14"
10.times { print("Hello") }

// Bundle
Bundle.main.releaseVersionNumber  // "1.0.0"
Bundle.main.bundleDisplayName  // "My App"
Bundle.main.isSimulator  // true/false
```

### UIKit (iOS/tvOS/visionOS)

```swift
import RKUtils  // Single import for all platforms

// UIView styling
view.setCornerRadius(cornerRadius: 10)
view.setBorder(width: 2, color: .red)
view.setShadow(color: .black, opacity: 0.3, radius: 4)
view.setLinearGradientBackground(colors: [.blue, .purple])
view.applyBlurEffect(style: .regular)

// UIColor
let color = UIColor(hexString: "#FF5733")
let lighter = color.lighter(by: 0.2)
let darker = color.darker(by: 0.3)

// UITextField
textField.setSecureTextToggleToRight(.systemBlue)
textField.textPublisher().sink { text in print(text) }
textField.setLeftPaddingPoints(16)

// Type-safe table views
tableView.register(cell: MyCell.self)
let cell = tableView.dequeueReusableCell(MyCell.self, for: indexPath)
```

### AppKit (macOS)

```swift
import RKUtils  // Same import!

// NSView - Same API as UIView!
view.setCornerRadius(cornerRadius: 10)
view.setBorder(width: 2, color: .red)
view.setShadow(color: .black, opacity: 0.3, radius: 4)
view.setLinearGradientBackground(colors: [.blue, .purple])
view.applyBlurEffect(material: .contentBackground)

// NSColor - Same API as UIColor!
let color = NSColor(hexString: "#FF5733")
let lighter = color.lighter(by: 0.2)

// NSSecureTextField
secureTextField.setSecureTextToggleToRight(.systemBlue)

// Type-safe registration
tableView.register(cell: MyCell.self)
let cell = tableView.dequeueReusableCell(cell: MyCell.self, owner: self)
```

### SwiftUI

```swift
import SwiftUI
import RKUtils

struct ContentView: View {
    var body: some View {
        Text("Hello")
            .foregroundColor(.white)
            .padding()
            .background(
                Color(hexString: "#007AFF")
                    .lighter(by: 0.2)
            )
    }
}
```

---

## Platform Requirements

| Platform | Version | Features           |
| -------- | ------- | ------------------ |
| iOS      | 14.0+   | Full               |
| macOS    | 11.0+   | Full               |
| tvOS     | 14.0+   | Full               |
| watchOS  | 7.0+    | Foundation + SwiftUI |
| visionOS | 1.0+    | Full               |
| Linux    | Any     | Core utilities\*   |

**Swift:** 6.0+ | **Xcode:** 16.0+

<details>
<summary><b>*Linux Limitations</b></summary>

Unavailable on Linux (Apple frameworks only):

- CoreLocation (CLLocationCoordinate2D)
- CoreGraphics (CGRect)
- SwiftUI (Color)
- Advanced formatters (measurements, relative dates)

Linux gets simplified fallbacks for time formatting. See [Platform Support](https://docs.therakiburkhan.dev/RKUtils/ios/documentation/rkutils/platform-support) for details.

</details>

---

## Documentation

- 📚 **[Official Documentation](https://docs.therakiburkhan.dev/RKUtils/)** - Multi-platform documentation
  - [iOS/UIKit Documentation](https://docs.therakiburkhan.dev/RKUtils/ios/documentation/rkutils/)
  - [macOS/AppKit Documentation](https://docs.therakiburkhan.dev/RKUtils/macos/documentation/rkutils/)
- 📖 **[CHANGELOG](CHANGELOG.md)** - Version history and migration guides
- 🔄 **[Migration Guide](https://docs.therakiburkhan.dev/RKUtils/ios/documentation/rkutils/migration-guide)** - Upgrade from v2.x to v3.0
- 🐛 **[Issues](https://github.com/TheRakiburKhan/RKUtils/issues)** - Report bugs or request features

All extensions include inline documentation. Use Xcode's Quick Help (⌥ + Click) for details.

---

## What's New in v3.0

### Single Target Architecture

v3.0 simplifies everything with a **single unified target**:

```swift
// Before (v2.x)
import RKUtilsUI      // iOS
import RKUtilsMacOS   // macOS

// After (v3.0)
import RKUtils        // All platforms!
```

**Benefits:**
- ✅ One library, one import
- ✅ Unified documentation
- ✅ Simpler Package.swift
- ✅ Same APIs, better experience

See the [Migration Guide](https://docs.therakiburkhan.dev/RKUtils/ios/documentation/rkutils/migration-guide) for upgrade instructions.

---

## Contributing

Contributions welcome! Please read [Contributing Guidelines](CONTRIBUTING.md) before submitting PRs.

---

## License

MIT License - see [LICENSE](LICENSE) for details.

Copyright © 2025 [Rakibur Khan](https://github.com/TheRakiburKhan)

---

<p align="center">
  <a href="https://github.com/TheRakiburKhan/RKUtils/stargazers">⭐️ Star</a> •
  <a href="https://github.com/TheRakiburKhan/RKUtils/issues">🐛 Issues</a> •
  <a href="https://github.com/TheRakiburKhan/RKUtils/pulls">🔀 Pull Requests</a>
</p>

<p align="center">Made with ❤️ by <a href="https://github.com/TheRakiburKhan">Rakibur Khan</a></p>
