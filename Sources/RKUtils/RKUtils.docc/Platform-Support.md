# Platform Support

Understand which features are available on each platform and how RKUtils handles platform differences.

## Overview

RKUtils is designed to work across all Apple platforms with a unified API. Platform-specific features are handled through Swift's conditional compilation, ensuring you only get the code relevant to your target platform.

## Supported Platforms

### Minimum Versions

| Platform | Minimum Version | Notes |
|----------|----------------|-------|
| **iOS** | 14.0 | Full UIKit support |
| **macOS** | 11.0 (Big Sur) | Full AppKit support |
| **tvOS** | 14.0 | Full UIKit support |
| **watchOS** | 7.0 | Foundation only |
| **visionOS** | 1.0 | Full UIKit support |
| **Mac Catalyst** | 14.0 | Uses UIKit APIs |
| **Linux** | N/A | Foundation only |

### Development Requirements

- **Swift** 6.0+
- **Xcode** 16.0+ (for Apple platforms)

## Feature Matrix

### Foundation Extensions

Available on **all platforms** including Linux:

| Extension | iOS | macOS | tvOS | watchOS | visionOS | Linux |
|-----------|-----|-------|------|---------|----------|-------|
| String | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Date | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Int | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Double | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Bundle | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Data | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| ProcessInfo | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ Limited |

**Linux Limitations:**
- No `CLLocationCoordinate2D` (requires CoreLocation)
- No measurement formatters (distance, speed, temperature, etc.)
- No `RelativeDateTimeFormatter` for `Date.relativeTime()`
- `ProcessInfo.isPreview` always returns `false`

### UIKit Extensions

Available on iOS, tvOS, visionOS, and Mac Catalyst:

| Extension | iOS | macOS | tvOS | watchOS | visionOS | Catalyst |
|-----------|-----|-------|------|---------|----------|----------|
| UIView | ✅ | ❌ | ✅ | ❌ | ✅ | ✅ |
| UIColor | ✅ | ❌ | ✅ | ❌ | ✅ | ✅ |
| UITextField | ✅ | ❌ | ✅ | ❌ | ✅ | ✅ |
| UITextView | ✅ | ❌ | ❌ | ❌ | ✅ | ✅ |
| UITableView | ✅ | ❌ | ✅ | ❌ | ✅ | ✅ |
| UICollectionView | ✅ | ❌ | ✅ | ❌ | ✅ | ✅ |
| UIDevice | ✅ | ❌ | ✅ | ❌ | ✅ | ✅ |
| UIScreen | ✅ | ❌ | ✅ | ❌ | ✅ | ✅ |
| UIStoryboard | ✅ | ❌ | ✅ | ❌ | ✅ | ✅ |
| CGRect | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |

**Note:** Mac Catalyst uses UIKit APIs, not AppKit.

### AppKit Extensions

Available on **macOS only** (not Mac Catalyst):

| Extension | iOS | macOS | tvOS | watchOS | visionOS | Catalyst |
|-----------|-----|-------|------|---------|----------|----------|
| NSView | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| NSColor | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| NSTextField | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| NSSecureTextField | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| NSTableView | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| NSCollectionView | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |

### SwiftUI Extensions

Available on **all Apple platforms** (requires SwiftUI framework):

| Extension | iOS | macOS | tvOS | watchOS | visionOS | Linux |
|-----------|-----|-------|------|---------|----------|-------|
| Color | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

## Platform-Specific Features

### iOS / tvOS / visionOS (UIKit)

These platforms share the same UIKit APIs:

```swift
import RKUtils

// UIView styling
view.setCornerRadius(cornerRadius: 12)
view.setBorder(width: 2, color: .systemBlue)
view.setShadow(color: .black, opacity: 0.2, radius: 8)
view.setLinearGradientBackground(colors: [.blue, .purple])
view.applyBlurEffect(style: .systemMaterial)

// UIColor utilities
let color = UIColor(hexString: "#FF5733")
let lighter = color.lighter(by: 0.2)
let darker = color.darker(by: 0.3)

// Type-safe table views
tableView.register(cell: MyCell.self)
let cell = tableView.dequeueReusableCell(MyCell.self, for: indexPath)
```

**iOS-Specific:**
- `UITextView` extensions (not available on tvOS)
- Full touch and gesture support

**tvOS-Specific:**
- Focus engine considerations
- Remote control support

**visionOS-Specific:**
- Spatial UI considerations
- Same APIs as iOS

### macOS (AppKit)

macOS uses AppKit with APIs that mirror UIKit where possible:

```swift
import RKUtils

// NSView styling (same API as UIView)
view.setCornerRadius(cornerRadius: 12)
view.setBorder(width: 2, color: .systemBlue)
view.setShadow(color: .black, opacity: 0.2, radius: 8)
view.setLinearGradientBackground(colors: [.blue, .purple])
view.applyBlurEffect(style: .behindWindow)

// NSColor utilities (same API as UIColor)
let color = NSColor(hexString: "#FF5733")
let lighter = color.lighter(by: 0.2)
let darker = color.darker(by: 0.3)

// Password visibility toggle (AppKit-specific)
secureTextField.setSecureTextToggleToRight(.systemBlue)
```

**Important:** NSView extensions require `wantsLayer = true` to be set. The extensions handle this automatically.

### Mac Catalyst

Mac Catalyst apps use **UIKit APIs**, not AppKit:

```swift
import RKUtils

// Use UIKit extensions, not AppKit
#if targetEnvironment(macCatalyst)
view.setCornerRadius(cornerRadius: 12)  // UIView method
let color = UIColor(hexString: "#FF5733")  // UIColor, not NSColor
#endif
```

### watchOS

watchOS only has Foundation and SwiftUI support:

```swift
import RKUtils

// Foundation extensions work
let formatted = 1234.abbreviated  // "1.2K"
let valid = "test@example.com".isValidEmail  // true

// SwiftUI Color works
Color(hexString: "#FF5733")

// UIKit/AppKit extensions not available
// No UIView, NSView, etc.
```

### Linux

Linux support is limited to Foundation types:

```swift
import RKUtils

// ✅ Available
"test@example.com".isValidEmail
1234.abbreviated
Date().toString()

// ❌ Not available
// - UIKit/AppKit extensions
// - SwiftUI extensions
// - CoreLocation types
// - Measurement formatters
// - RelativeDateTimeFormatter
```

## Conditional Compilation

RKUtils uses Swift's conditional compilation to ensure platform safety. You can write platform-specific code when needed:

### Basic Conditionals

```swift
import RKUtils

#if canImport(UIKit)
// iOS, tvOS, visionOS, Catalyst
let color = UIColor(hexString: "#FF5733")
#elseif canImport(AppKit)
// macOS (but not Catalyst)
let color = NSColor(hexString: "#FF5733")
#endif
```

### Excluding Specific Platforms

```swift
// UIKit but NOT watchOS
#if canImport(UIKit) && !os(watchOS)
view.setCornerRadius(cornerRadius: 12)
#endif

// AppKit but NOT Catalyst
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
view.setCornerRadius(cornerRadius: 12)
#endif
```

### Platform-Specific Features

```swift
// iOS-specific (not tvOS or Catalyst)
#if os(iOS) && !targetEnvironment(macCatalyst)
// iPhone/iPad specific code
#endif

// macOS-specific
#if os(macOS)
// macOS only code
#endif

// Catalyst-specific
#if targetEnvironment(macCatalyst)
// Catalyst only code
#endif
```

## Cross-Platform Development

### Shared Protocols

Create platform-agnostic interfaces:

```swift
protocol ColorConvertible {
    var hex: String { get }
}

#if canImport(UIKit)
import UIKit
extension UIColor: ColorConvertible {
    var hex: String { toHexString() }
}
#elseif canImport(AppKit)
import AppKit
extension NSColor: ColorConvertible {
    var hex: String { toHexString() }
}
#endif
```

### Type Aliases

Use type aliases for cross-platform code:

```swift
#if canImport(UIKit)
typealias PlatformColor = UIColor
typealias PlatformView = UIView
#elseif canImport(AppKit)
typealias PlatformColor = NSColor
typealias PlatformView = NSView
#endif

func styleView(_ view: PlatformView, color: PlatformColor) {
    view.setCornerRadius(cornerRadius: 12)
    // Works on both iOS and macOS!
}
```

### SwiftUI Unified Approach

For SwiftUI apps, use SwiftUI's native types:

```swift
import SwiftUI
import RKUtils

struct CrossPlatformView: View {
    var body: some View {
        Text("Hello")
            .foregroundColor(.white)
            .padding()
            .background(Color(hexString: "#007AFF"))
            .cornerRadius(12)
    }
}

// Works identically on iOS, macOS, tvOS, watchOS, visionOS!
```

## Feature Availability by Use Case

### Mobile Apps (iOS, visionOS)

**Recommended:** Use UIKit or SwiftUI

```swift
import SwiftUI
import RKUtils

// Full access to all features
// - Foundation extensions ✅
// - UIKit extensions ✅
// - SwiftUI extensions ✅
```

### Desktop Apps (macOS)

**Recommended:** Use AppKit or SwiftUI

```swift
import SwiftUI
import RKUtils

// Full access to all features
// - Foundation extensions ✅
// - AppKit extensions ✅
// - SwiftUI extensions ✅
```

### TV Apps (tvOS)

**Recommended:** Use UIKit or SwiftUI

```swift
import SwiftUI
import RKUtils

// Most features available
// - Foundation extensions ✅
// - UIKit extensions ✅ (except UITextView)
// - SwiftUI extensions ✅
```

### Watch Apps (watchOS)

**Recommended:** Use SwiftUI

```swift
import SwiftUI
import RKUtils

// Limited to Foundation and SwiftUI
// - Foundation extensions ✅
// - SwiftUI Color extensions ✅
// - UIKit/AppKit ❌
```

### Cross-Platform Packages

**Recommended:** Use Foundation and conditional compilation

```swift
import Foundation
import RKUtils

// Use Foundation everywhere
let formatted = 1234.abbreviated

// Platform-specific when needed
#if canImport(UIKit)
let view = UIView()
view.setCornerRadius(cornerRadius: 12)
#elseif canImport(AppKit)
let view = NSView()
view.setCornerRadius(cornerRadius: 12)
#endif
```

## Testing Platform Support

### Runtime Platform Detection

```swift
import RKUtils

#if os(iOS)
print("Running on iOS")
#elseif os(macOS)
print("Running on macOS")
#elseif os(tvOS)
print("Running on tvOS")
#elseif os(watchOS)
print("Running on watchOS")
#elseif os(visionOS)
print("Running on visionOS")
#endif

// Simulator detection
if Bundle.main.isSimulator {
    print("Running in simulator")
}

// Preview detection
if ProcessInfo.processInfo.isPreview {
    print("Running in SwiftUI preview")
}
```

### Framework Availability

```swift
#if canImport(UIKit)
print("UIKit available")
#endif

#if canImport(AppKit)
print("AppKit available")
#endif

#if canImport(SwiftUI)
print("SwiftUI available")
#endif
```

## Migration Between Platforms

### iOS to macOS

When porting iOS code to macOS, most RKUtils APIs remain the same:

```swift
// iOS (UIKit)
view.setCornerRadius(cornerRadius: 12)
let color = UIColor(hexString: "#FF5733")

// macOS (AppKit) - same API!
view.setCornerRadius(cornerRadius: 12)
let color = NSColor(hexString: "#FF5733")
```

**Differences:**
- `UIColor` → `NSColor`
- `UIView` → `NSView`
- `UITextField` → `NSTextField`
- AppKit requires `wantsLayer = true` (handled automatically)

### UIKit/AppKit to SwiftUI

```swift
// UIKit/AppKit
let color = UIColor(hexString: "#FF5733")
let lighter = color.lighter(by: 0.2)

// SwiftUI - same API!
let color = Color(hexString: "#FF5733")
let lighter = color.lighter(by: 0.2)
```

## Platform-Specific Considerations

### iOS

- **UITextView** requires iOS 14+
- **Blur effects** use UIKit's native visual effect views
- **Combine publishers** available on UITextField

### macOS

- **NSView** extensions automatically set `wantsLayer = true`
- **NSSecureTextField** includes password visibility toggle
- **Blur effects** use AppKit's native visual effect views
- **CALayer** operations require explicit layer creation

### tvOS

- **Focus engine** - Views can gain focus
- **UITextView** not available
- **Limited input methods** - Remote control only

### watchOS

- **Limited to Foundation** - No UIKit/AppKit
- **SwiftUI recommended** - Best experience on watchOS
- **Small screen** - Consider simplified UIs

### visionOS

- **Spatial design** - Consider depth and immersion
- **Same UIKit APIs** - Full compatibility with iOS code
- **New interactions** - Spatial gestures available

## Troubleshooting

### "No such member" Errors

If you see errors like "UIView has no member 'setCornerRadius'":

1. Verify you've imported RKUtils: `import RKUtils`
2. Check your platform supports UIKit
3. Verify deployment target meets minimum (iOS 14+)

### Platform Mismatch

If you try to use UIKit on macOS:

```swift
#if canImport(AppKit)
// ERROR: UIView is not available on macOS
let view = UIView()  // Won't compile
#endif
```

**Solution:** Use the correct platform type:

```swift
#if canImport(UIKit)
let view = UIView()
#elseif canImport(AppKit)
let view = NSView()
#endif
```

## Best Practices

1. **Use SwiftUI when possible** - Works across all platforms
2. **Abstract platform differences** - Use protocols and type aliases
3. **Test on all target platforms** - Ensure compatibility
4. **Use conditional compilation sparingly** - Prefer unified APIs
5. **Document platform requirements** - Be clear about limitations

## Next Steps

- <doc:QuickStart> - Learn how to use RKUtils features
- <doc:Migration-Guide> - Migrate from v2.x to v3.0
- [GitHub Examples](https://github.com/TheRakiburKhan/RKUtils/tree/main/Examples) - Platform-specific examples
