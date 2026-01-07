# Changelog

All notable changes to **RKUtils** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

---

## [3.0.0] - 2025-01-08

### 🎉 Major Release - Single Target Architecture & Comprehensive Documentation

### Added

#### 📚 Comprehensive Documentation Overhaul

**New Dedicated Documentation Website:**

- **Platform Selector:** [https://docs.therakiburkhan.dev/RKUtils/](https://docs.therakiburkhan.dev/RKUtils/)
- **iOS/UIKit Docs:** [https://docs.therakiburkhan.dev/RKUtils/ios/documentation/rkutils/](https://docs.therakiburkhan.dev/RKUtils/ios/documentation/rkutils/)
- **macOS/AppKit Docs:** [https://docs.therakiburkhan.dev/RKUtils/macos/documentation/rkutils/](https://docs.therakiburkhan.dev/RKUtils/macos/documentation/rkutils/)

**Why Separate Builds?**
- iOS build documents UIKit symbols (UIView, UIColor, UICollectionView, etc.)
- macOS build documents AppKit symbols (NSView, NSColor, NSCollectionView, etc.)
- Foundation and SwiftUI extensions available in both

**Documentation Quality Improvements:**

- ✅ **100% Accuracy** - All 12 extension docs verified against source code
- ✅ **Real-World Examples** - Login forms, settings screens, photo galleries, navigation patterns
- ✅ **Complete API Coverage** - Every public method documented with code samples
- ✅ **Platform Availability** - Clear indicators for iOS/macOS/Linux-specific features
- ✅ **Dark Mode Support** - Beautiful, accessible documentation interface

**Comprehensive Guides:**
- **Installation Guide** - Swift Package Manager, Xcode, Package.swift integration
- **Quick Start** - Platform-specific usage examples
- **Migration Guide v2→v3** - Step-by-step upgrade instructions ([iOS](https://docs.therakiburkhan.dev/RKUtils/ios/documentation/rkutils/migration-guide) | [macOS](https://docs.therakiburkhan.dev/RKUtils/macos/documentation/rkutils/migration-guide))
- **Platform Support Matrix** - Feature availability across iOS, macOS, Linux, watchOS, tvOS, visionOS

### Changed

#### 🏗️ Architecture Refactoring - Single Target (BREAKING)

**Major Simplification:**

RKUtils has been refactored from a multi-target architecture (RKUtils, RKUtilsUI, RKUtilsMacOSUI, RKUtilsSwiftUI) to a **single unified target**. This dramatically simplifies the package structure, improves documentation, and enhances the developer experience.

**What Changed:**

- **Single Product:** Only `RKUtils` product exists now (removed `RKUtilsUI` and `RKUtilsMacOS` products)
- **Single Target:** All code consolidated into one `RKUtils` target with organized subdirectories
- **Single Import:** Users now `import RKUtils` everywhere (no more confusion about which product to use)
- **Unified Documentation:** All extension documentation in one place with proper cross-referencing
- **Organized Source Structure:**
  ```
  Sources/RKUtils/
  ├── Foundation/    # Cross-platform (String, Date, Int, Double, etc.)
  ├── UIKit/         # iOS/tvOS/visionOS extensions
  ├── AppKit/        # macOS extensions
  └── SwiftUI/       # SwiftUI Color extensions
  ```

**Migration Guide:**

See the comprehensive migration guide: [iOS](https://docs.therakiburkhan.dev/RKUtils/ios/documentation/rkutils/migration-guide) | [macOS](https://docs.therakiburkhan.dev/RKUtils/macos/documentation/rkutils/migration-guide)

```swift
// Before (v2.x)
import RKUtilsUI      // iOS
import RKUtilsMacOS   // macOS

// After (v3.0)
import RKUtils        // All platforms
```

**Why This Change:**

- ✅ **Simpler Mental Model** - One library, one import
- ✅ **Better Documentation** - All extensions in one place, proper cross-referencing works
- ✅ **Less Maintenance** - Single target, single test suite
- ✅ **Same Safety** - Platform-specific code still uses `#if canImport(UIKit)` guards
- ✅ **Zero Impact** - Conditional compilation ensures Linux/iOS/macOS only get relevant code

**Technical Details:**

- Platform separation now handled entirely by conditional compilation (`#if canImport`)
- Package.swift reduced from 4 targets to 1 target
- Test suite consolidated from 3 test targets to 1 organized test target
- All 145 tests passing with the new structure

#### 📱 Platform Requirements Update

**Minimum Platform Versions Updated:**

- iOS 13.0+ → **iOS 14.0+**
- macOS 10.15+ → **macOS 11.0+**
- tvOS 13.0+ → **tvOS 14.0+**
- Mac Catalyst 13.0+ → **Mac Catalyst 14.0+**

**Rationale:** Dropping support for pre-2020 OS versions to enable modern API usage and reduce maintenance overhead.

**Code Cleanup:**
- Removed unnecessary `@available` checks for iOS 14/macOS 11 APIs (SF Symbols, RelativeDateTimeFormatter)
- NSSecureTextField now unconditionally uses SF Symbols for password visibility toggle
- Date extensions no longer gate `relativeTime()` method with availability checks

---

## [2.1.1] - 2025-12-08

### ✅ Test Coverage Improvements

### Added

#### 🧪 Comprehensive Test Suite Expansion

**New Test Files** (8 modules, 70 new tests):

- **Color.swift (SwiftUI)** - 6 tests for hex string initialization
- **UIScreen.swift** - 2 tests for minEdge property
- **UITextField.swift** - 4 tests for text publisher and padding
- **UITableView.swift** - 11 tests for type-safe registration and helpers
- **UICollectionView.swift** - 9 tests for type-safe registration
- **UIStoryboard.swift** - 3 tests for type-safe instantiation
- **NSTextField.swift (macOS)** - 5 tests for text publisher and padding
- **NSTableView.swift (macOS)** - 9 tests for type-safe registration

**Test Coverage Statistics:**

- Previous: 124 tests (50% file coverage)
- New: **194 tests** (71% file coverage)
- Added: 70 new tests (+56% increase)

**Platform Breakdown:**

- **macOS**: 145 tests (107 core + 6 SwiftUI + 32 AppKit)
- **iOS/tvOS/visionOS**: Full UIKit suite (62 tests) + core
- **Linux**: 113 tests (core utilities, SwiftUI excluded)

### Changed

- **Type-safe APIs**: All registration/dequeue methods now have comprehensive test coverage
- **Combine publishers**: Both UITextField and NSTextField text publishers validated
- **Cross-platform consistency**: Parallel test coverage for UIKit and AppKit equivalents

---

## [2.1.0] - 2025-12-04

### 🌐 Linux & Android Platform Support

### Added

#### 🐧 Linux/Android Compatibility

**Cross-Platform Foundation Support**

- Full Linux compilation support via swift-corelibs-foundation
- Android ARM64 platform compatibility (verified via Swift Package Index)
- Cross-platform email validation using Swift Regex with fallback
- Platform guards for Apple-only frameworks (CoreLocation, CoreGraphics, SwiftUI)

**Linux Fallback Functions** (simplified implementations):

- `Double.secondsToTime(format:)` - Custom format string support with placeholders
- `Double.day()`, `Double.month()`, `Double.year()` - Simple English formatting
- `Int.day()`, `Int.month()`, `Int.year()` - Plural/singular handling

#### 🤖 CI/CD Enhancements

- Added dedicated Linux build job to GitHub Actions workflow
- Swift 6.0 on Ubuntu latest
- Parallel test execution across platforms

### Changed

#### 🔄 Cross-Platform API Design

**Email Validation**

- Replaced NSPredicate-based validation (Apple-only) with cross-platform Swift Regex
- Enhanced regex pattern to properly validate domain structure
- Runtime availability checks with fallback

**Import Changes**

- CGRect extensions: Changed from `CoreFoundation` to `CoreGraphics`
- Explicit framework checks for all platform-specific functionality

### Fixed

- **Email Regex Validation**: Enhanced pattern for consecutive dots in domain names
- **CoreGraphics Import**: Corrected import statement for CGRect extensions
- **Test Suite**: Updated 124 tests to handle platform-specific behavior
- **Locale Support**: Made locale-dependent tests Darwin-only

### Migration Notes

**For existing users (Apple platforms):** No changes required.

**For new Linux users:** See Platform Support documentation ([iOS](https://docs.therakiburkhan.dev/RKUtils/ios/documentation/rkutils/platform-support) | [macOS](https://docs.therakiburkhan.dev/RKUtils/macos/documentation/rkutils/platform-support)) for platform-specific limitations and code examples.

---

## [2.0.0] - 2025-12-04

### 🎉 Major Update - macOS Support & Testing Framework Migration

### Added

#### 🍎 macOS Support (AppKit)

**New Library**: `RKUtilsMacOS` - Complete macOS/AppKit support with feature parity to UIKit

**Added Extensions:**

- **NSColor** - Hex string initialization
- **NSView** - Complete parity with UIView (corner radius, borders, shadows, gradients, blur, animations)
- **NSTextField** - Combine text publisher, padding methods
- **NSSecureTextField** - Password toggle with show/hide button
- **NSCollectionView** - Type-safe registration and dequeue
- **NSTableView** - Type-safe registration and dequeue

#### 🧪 Testing Framework Migration

- Migrated from XCTest to Swift Testing framework
- All 124 tests now use modern `@Test` and `#expect()` macros
- Parameterized tests using `arguments:` parameter
- Added `@MainActor` isolation for UI tests

#### ✅ Comprehensive Test Coverage (124 tests total)

- **Cross-Platform Core**: 109 tests
- **UIKit**: 27 tests
- **AppKit**: 17 tests

### Changed

#### 📦 Package Rename (BREAKING)

**⚠️ Major Breaking Change:**

- **Package renamed**: `RKiOSUtils` → `RKUtils`
- **Repository URL changed**: Update your Package.swift dependencies
- **Module split**: Single module split into three targets:
  - `RKUtils` (cross-platform Foundation utilities)
  - `RKUtilsUI` (UIKit extensions for iOS/tvOS/visionOS)
  - `RKUtilsMacOS` (AppKit extensions for macOS)

**Migration:** See the [v2.0.0 release notes](https://github.com/TheRakiburKhan/RKUtils/releases/tag/v2.0.0) for upgrade instructions.

**Quick Summary:**

- Update package URL in Package.swift
- Change imports: `RKiOSUtils` → `RKUtils` or `RKUtilsUI`
- Minimum iOS version: 11.0+ → 13.0+
- Swift version required: 5.0+ → 6.0+

#### 🎯 Platform Compatibility

**Minimum Platform Versions:**

- iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, visionOS 1.0
- Swift 6.0+, Xcode 16.0+

---

## [1.0.0] - 2025-06-02

### 🎉 First Official Release

- Initial release of **RKUtils** as a Swift Package
- UIKit & Foundation extensions for iOS 11+
- Swift 5+ compatible, modular and production-ready

---

## Migration Guides

- **v2.x → v3.0** - Single target architecture ([iOS](https://docs.therakiburkhan.dev/RKUtils/ios/documentation/rkutils/migration-guide) | [macOS](https://docs.therakiburkhan.dev/RKUtils/macos/documentation/rkutils/migration-guide))
- **v1.0 → v2.0** - See [v2.0.0 release notes](https://github.com/TheRakiburKhan/RKUtils/releases/tag/v2.0.0)
- **Platform Support** - Cross-platform features and limitations ([iOS](https://docs.therakiburkhan.dev/RKUtils/ios/documentation/rkutils/platform-support) | [macOS](https://docs.therakiburkhan.dev/RKUtils/macos/documentation/rkutils/platform-support))

---

## Links

- [GitHub Repository](https://github.com/TheRakiburKhan/RKUtils)
- [Documentation](https://docs.therakiburkhan.dev/RKUtils/)
  - [iOS/UIKit Documentation](https://docs.therakiburkhan.dev/RKUtils/ios/documentation/rkutils/)
  - [macOS/AppKit Documentation](https://docs.therakiburkhan.dev/RKUtils/macos/documentation/rkutils/)
- [Swift Package Index](https://swiftpackageindex.com/TheRakiburKhan/RKUtils)
- [Report Issues](https://github.com/TheRakiburKhan/RKUtils/issues)

[Unreleased]: https://github.com/TheRakiburKhan/RKUtils/compare/v3.0.0...HEAD
[3.0.0]: https://github.com/TheRakiburKhan/RKUtils/releases/tag/v3.0.0
[2.1.1]: https://github.com/TheRakiburKhan/RKUtils/releases/tag/v2.1.1
[2.1.0]: https://github.com/TheRakiburKhan/RKUtils/releases/tag/v2.1.0
[2.0.0]: https://github.com/TheRakiburKhan/RKUtils/releases/tag/v2.0.0
[1.0.0]: https://github.com/TheRakiburKhan/RKUtils/releases/tag/v1.0.0
