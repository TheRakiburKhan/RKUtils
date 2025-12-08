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
- 🧪 **Well Tested** - Comprehensive test coverage
- 🚀 **Production Ready** - Battle-tested in production apps

---

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/TheRakiburKhan/RKUtils.git", from: "2.1.0")
]
```

### Xcode

1. **File > Add Package Dependencies...**
2. Enter: `https://github.com/TheRakiburKhan/RKUtils.git`
3. Select version and add to your target

### Targets

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "RKUtils", package: "RKUtils"),       // Cross-platform
        .product(name: "RKUtilsUI", package: "RKUtils"),     // UIKit (iOS/tvOS)
        .product(name: "RKUtilsMacOS", package: "RKUtils"),  // AppKit (macOS)
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
"2024-12-08".toDate(format: "yyyy-MM-dd")

// Date
Date().toString(format: "yyyy-MM-dd")
Date().addingDays(7)
Date().relativeTime()  // "2 hours ago" (Apple only)

// Numbers
1234.abbreviated  // "1.2K"
3.14159.roundedString(toPlaces: 2)  // "3.14"
10.times { print("Hello") }

// Bundle
Bundle.main.appVersion  // "1.0.0"
Bundle.main.displayName
```

### UIKit (iOS/tvOS/visionOS)

```swift
import RKUtilsUI

// UIView styling
view.setCornerRadius(cornerRadius: 10)
view.setBorder(width: 2, color: .red)
view.setShadow(color: .black, opacity: 0.3, radius: 4)
view.setLinearGradientBackground(colors: [.blue, .purple])
view.applyBlurEffect(style: .regular)

// UIColor
let color = UIColor(hexString: "#FF5733")

// UITextField
textField.setSecureTextToggleToRight(.systemBlue)
textField.textPublisher().sink { text in print(text) }
textField.setLeftPaddingPoints(16)
```

### AppKit (macOS)

```swift
import RKUtilsMacOS

// NSView - Same API as UIView!
view.setCornerRadius(cornerRadius: 10)
view.setBorder(width: 2, color: .red)
view.setShadow(color: .black, opacity: 0.3, radius: 4)
view.applyBlurEffect(material: .contentBackground)

// NSColor
let color = NSColor(hexString: "#FF5733")

// NSSecureTextField
secureTextField.setSecureTextToggleToRight(.systemBlue)

// Type-safe registration
tableView.register(cell: MyCell.self)
let cell = tableView.dequeueReusableCell(cell: MyCell.self, owner: self)
```

---

## Platform Requirements

| Platform | Version | Features         |
| -------- | ------- | ---------------- |
| iOS      | 13.0+   | Full             |
| macOS    | 10.15+  | Full             |
| tvOS     | 13.0+   | Full             |
| watchOS  | 6.0+    | Full             |
| visionOS | 1.0+    | Full             |
| Linux    | Any     | Core utilities\* |

**Swift:** 6.0+ | **Xcode:** 16.0+

<details>
<summary><b>*Linux Limitations</b></summary>

Unavailable on Linux (Apple frameworks only):

- CoreLocation (CLLocationCoordinate2D)
- CoreGraphics (CGRect)
- SwiftUI (Color)
- Advanced formatters (measurements, relative dates)

Linux gets simplified fallbacks for time formatting. See [CHANGELOG](CHANGELOG.md) for details.

</details>

---

## Documentation

- 📖 **[CHANGELOG](CHANGELOG.md)** - Version history and migration guides
- 🐛 **[Issues](https://github.com/TheRakiburKhan/RKUtils/issues)** - Report bugs or request features

All extensions include inline documentation. Use Xcode's Quick Help (⌥ + Click) for details.

---

## Contributing

Contributions welcome! Please read [Contributing Guidelines](CONTRIBUTING.md) before submitting PRs.

---

## License

MIT License - see [LICENSE](LICENSE) for details.

Copyright © 2024 [Rakibur Khan](https://github.com/TheRakiburKhan)

---

<p align="center">
  <a href="https://github.com/TheRakiburKhan/RKUtils/stargazers">⭐️ Star</a> •
  <a href="https://github.com/TheRakiburKhan/RKUtils/issues">🐛 Issues</a> •
  <a href="https://github.com/TheRakiburKhan/RKUtils/pulls">🔀 Pull Requests</a>
</p>

<p align="center">Made with ❤️ by <a href="https://github.com/TheRakiburKhan">Rakibur Khan</a></p>
