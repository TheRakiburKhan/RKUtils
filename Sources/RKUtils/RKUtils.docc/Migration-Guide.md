# Migration Guide: v2.x → v3.0

Upgrade your project from RKUtils v2.x to v3.0 with this comprehensive migration guide.

## Overview

RKUtils v3.0 introduces a major architectural simplification by consolidating the multi-target structure (RKUtils, RKUtilsUI, RKUtilsMacOS, RKUtilsSwiftUI) into a **single unified target**. This change dramatically improves the developer experience while maintaining full backward compatibility at the API level.

### What's New in v3.0

- ✅ **Single import statement** - No more confusion about which product to use
- ✅ **Unified documentation** - All extensions in one place with proper cross-referencing
- ✅ **Simplified Package.swift** - One target, one product
- ✅ **iOS 14+ / macOS 11+ minimum** - Dropped support for pre-2020 OS versions
- ✅ **Same APIs** - All your existing code continues to work

### Breaking Changes Summary

1. **Product names changed** - `RKUtilsUI` and `RKUtilsMacOS` products removed
2. **Import statements changed** - All imports now use `import RKUtils`
3. **Minimum OS versions increased** - iOS 14+, macOS 11+, tvOS 14+

## Migration Steps

### Step 1: Update Package Dependency

#### Xcode Projects

1. Open your project in Xcode
2. Go to your project settings > **Package Dependencies**
3. Select the RKUtils package
4. Update the version requirement to `3.0.0` or later
5. Click **Update to Latest Package Versions**

#### Package.swift Projects

Update your `Package.swift` dependency version:

```swift
// Before (v2.x)
.package(
    url: "https://github.com/TheRakiburKhan/RKUtils.git",
    from: "2.1.0"
)

// After (v3.0)
.package(
    url: "https://github.com/TheRakiburKhan/RKUtils.git",
    from: "3.0.0"
)
```

### Step 2: Update Product References

In your `Package.swift`, update target dependencies:

```swift
// Before (v2.x)
.target(
    name: "MyiOSApp",
    dependencies: [
        .product(name: "RKUtilsUI", package: "RKUtils")
    ]
)

.target(
    name: "MyMacApp",
    dependencies: [
        .product(name: "RKUtilsMacOS", package: "RKUtils")
    ]
)

// After (v3.0)
.target(
    name: "MyiOSApp",
    dependencies: [
        .product(name: "RKUtils", package: "RKUtils")
    ]
)

.target(
    name: "MyMacApp",
    dependencies: [
        .product(name: "RKUtils", package: "RKUtils")
    ]
)
```

### Step 3: Update Import Statements

Replace all import statements throughout your codebase:

```swift
// Before (v2.x)
import RKUtilsUI        // iOS/tvOS/visionOS
import RKUtilsMacOS     // macOS
import RKUtilsSwiftUI   // SwiftUI Color extensions

// After (v3.0)
import RKUtils          // All platforms
```

#### Quick Find & Replace

Use Xcode's find and replace (Cmd+Shift+F) to update all imports at once:

1. **Find:** `import RKUtilsUI`
   **Replace:** `import RKUtils`

2. **Find:** `import RKUtilsMacOS`
   **Replace:** `import RKUtils`

3. **Find:** `import RKUtilsSwiftUI`
   **Replace:** `import RKUtils`

### Step 4: Update Platform Requirements

Ensure your deployment targets meet the new minimum requirements:

#### Xcode Projects

1. Select your project in the Project Navigator
2. Select your target
3. Go to **General** tab > **Deployment Info**
4. Update minimum deployment targets:
   - iOS: **14.0** (was 13.0)
   - macOS: **11.0** (was 10.15)
   - tvOS: **14.0** (was 13.0)
   - watchOS: **7.0** (unchanged)
   - visionOS: **1.0** (unchanged)

#### Package.swift Projects

Update your platforms declaration:

```swift
// Before (v2.x)
platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6)
]

// After (v3.0)
platforms: [
    .iOS(.v14),
    .macOS(.v11),
    .tvOS(.v14),
    .watchOS(.v7),
    .visionOS(.v1)
]
```

### Step 5: Clean Build

After making changes:

1. Clean build folder: **Product > Clean Build Folder** (Cmd+Shift+K)
2. Reset package caches: **File > Packages > Reset Package Caches**
3. Rebuild your project

## Code Migration Examples

### iOS/UIKit Migration

No API changes - only the import statement changes:

```swift
// Before (v2.x)
import UIKit
import RKUtilsUI

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.setCornerRadius(cornerRadius: 12)
        view.setBorder(width: 2, color: .systemBlue)

        let color = UIColor(hexString: "#FF5733")
        view.backgroundColor = color
    }
}

// After (v3.0)
import UIKit
import RKUtils  // ← Only change

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.setCornerRadius(cornerRadius: 12)
        view.setBorder(width: 2, color: .systemBlue)

        let color = UIColor(hexString: "#FF5733")
        view.backgroundColor = color
    }
}
```

### macOS/AppKit Migration

No API changes - only the import statement changes:

```swift
// Before (v2.x)
import AppKit
import RKUtilsMacOS

class MyViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.setCornerRadius(cornerRadius: 12)
        view.setBorder(width: 2, color: .systemBlue)

        let color = NSColor(hexString: "#FF5733")
        view.layer?.backgroundColor = color.cgColor
    }
}

// After (v3.0)
import AppKit
import RKUtils  // ← Only change

class MyViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.setCornerRadius(cornerRadius: 12)
        view.setBorder(width: 2, color: .systemBlue)

        let color = NSColor(hexString: "#FF5733")
        view.layer?.backgroundColor = color.cgColor
    }
}
```

### SwiftUI Migration

No API changes - only the import statement changes:

```swift
// Before (v2.x)
import SwiftUI
import RKUtilsUI       // or RKUtilsMacOS
import RKUtilsSwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .foregroundColor(.white)
            .padding()
            .background(
                Color(hexString: "#007AFF")
                    .lighter(by: 0.2)
            )
    }
}

// After (v3.0)
import SwiftUI
import RKUtils  // ← Only change (single import for all platforms)

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .foregroundColor(.white)
            .padding()
            .background(
                Color(hexString: "#007AFF")
                    .lighter(by: 0.2)
            )
    }
}
```

### Cross-Platform Package Migration

For packages that support multiple platforms:

```swift
// Before (v2.x)
// Package.swift
let package = Package(
    name: "MyLibrary",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    dependencies: [
        .package(url: "https://github.com/TheRakiburKhan/RKUtils.git", from: "2.1.0")
    ],
    targets: [
        .target(
            name: "MyiOSCode",
            dependencies: [
                .product(name: "RKUtilsUI", package: "RKUtils")
            ]
        ),
        .target(
            name: "MyMacCode",
            dependencies: [
                .product(name: "RKUtilsMacOS", package: "RKUtils")
            ]
        )
    ]
)

// After (v3.0)
let package = Package(
    name: "MyLibrary",
    platforms: [.iOS(.v14), .macOS(.v11)],
    dependencies: [
        .package(url: "https://github.com/TheRakiburKhan/RKUtils.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "MyiOSCode",
            dependencies: [
                .product(name: "RKUtils", package: "RKUtils")  // ← Same product
            ]
        ),
        .target(
            name: "MyMacCode",
            dependencies: [
                .product(name: "RKUtils", package: "RKUtils")  // ← Same product
            ]
        )
    ]
)
```

## API Compatibility

### ✅ No Breaking API Changes

All public APIs remain **100% compatible**. The following code works identically in both versions:

```swift
// String extensions
"test@example.com".isValidEmail
"2024-01-15".toDate(format: "yyyy-MM-dd")

// Number extensions
1_234_567.abbreviated
42.5.percentage()

// Date extensions
Date().toString()
Date().relativeTime()

// UIColor/NSColor extensions
UIColor(hexString: "#FF5733")
UIColor.random
color.lighter(by: 0.2)
color.contrastRatio(with: .white)

// View extensions
view.setCornerRadius(cornerRadius: 12)
view.setBorder(width: 2, color: .systemBlue)
view.setShadow(color: .black, opacity: 0.2, radius: 4)

// SwiftUI Color extensions
Color(hexString: "#007AFF")
Color.randomPastel
color.isLight
```

### Removed APIs

**None.** All v2.x APIs are still available in v3.0.

### New Features in v3.0

In addition to the architectural improvements, v3.0 includes:

- **Color utilities** - Comprehensive color manipulation on UIColor, NSColor, and SwiftUI Color (added in late v2.x, now part of unified v3.0)
- **ProcessInfo.isPreview** - Detect SwiftUI previews
- **Bundle.isSimulator** - Detect simulator environment

## Testing Your Migration

After migrating, verify everything works correctly:

### 1. Compile Check

```bash
swift build
```

All files should compile without errors.

### 2. Test Suite

```bash
swift test
```

Run your existing tests to ensure no regressions.

### 3. Runtime Verification

Add this test code to verify RKUtils is working:

```swift
import RKUtils

func verifyRKUtils() {
    // Foundation
    assert("test@example.com".isValidEmail == true)
    assert(1000.abbreviated == "1K")

    // Platform-specific
    #if canImport(UIKit)
    let uiColor = UIColor(hexString: "#FF5733")
    assert(uiColor != nil)
    print("✅ UIKit extensions working")
    #endif

    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
    let nsColor = NSColor(hexString: "#FF5733")
    assert(nsColor != NSColor.clear)
    print("✅ AppKit extensions working")
    #endif

    print("✅ RKUtils v3.0 migration successful!")
}
```

## Troubleshooting

### "No such module 'RKUtils'" Error

**Solution:** Clean build and reset package caches:

```bash
rm -rf .build
swift package clean
swift package resolve
swift build
```

### Xcode Can't Find Package

**Solution:**

1. Remove the package from your project
2. **File > Packages > Reset Package Caches**
3. Add the package again with version 3.0.0+

### Deployment Target Errors

**Error:** "MyApp requires a minimum deployment target of iOS 14.0"

**Solution:** Update your deployment target:
- Xcode: Project Settings > General > Deployment Info
- Package.swift: Update `.iOS(.v14)`, `.macOS(.v11)`, etc.

### Import Conflicts

If you have both old and new imports:

```swift
import RKUtilsUI   // Old
import RKUtils     // New
```

**Solution:** Remove all old imports (`RKUtilsUI`, `RKUtilsMacOS`, `RKUtilsSwiftUI`), keep only `import RKUtils`.

## Migration Checklist

Use this checklist to ensure a complete migration:

- [ ] Updated package dependency to v3.0.0+
- [ ] Changed all `RKUtilsUI` imports to `RKUtils`
- [ ] Changed all `RKUtilsMacOS` imports to `RKUtils`
- [ ] Changed all `RKUtilsSwiftUI` imports to `RKUtils`
- [ ] Updated minimum deployment targets (iOS 14+, macOS 11+, tvOS 14+)
- [ ] Updated Package.swift platforms if applicable
- [ ] Updated Package.swift product dependencies if applicable
- [ ] Cleaned build folder
- [ ] Reset package caches
- [ ] Successfully compiled project
- [ ] Ran tests successfully
- [ ] Verified runtime functionality

## Getting Help

If you encounter issues during migration:

- **Documentation:** <doc:Installation>
- **GitHub Issues:** [Report a problem](https://github.com/TheRakiburKhan/RKUtils/issues)
- **Changelog:** [View all changes](https://github.com/TheRakiburKhan/RKUtils/blob/main/CHANGELOG.md)

## Why This Change?

The single-target architecture provides several benefits:

### Better Developer Experience

- **Simpler mental model** - One library, one import
- **No confusion** - Don't need to remember which product to use
- **Unified docs** - All extensions in one place

### Better Documentation

- **Cross-referencing works** - Can link between Foundation/UIKit/AppKit docs
- **Single source of truth** - One Installation guide, one API reference
- **Easier to navigate** - All String extensions together, not split across modules

### Better Maintenance

- **Single target** - Easier to maintain and test
- **Single product** - Simpler Package.swift
- **Same safety** - Conditional compilation still ensures platform safety

The migration effort is minimal (usually just changing import statements), but the long-term benefits are substantial.

## Next Steps

- <doc:QuickStart> - Learn how to use RKUtils v3.0
- <doc:Platform-Support> - Understand platform-specific features
- [View Full Changelog](https://github.com/TheRakiburKhan/RKUtils/blob/main/CHANGELOG.md)
