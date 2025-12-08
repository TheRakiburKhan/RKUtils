# Changelog

All notable changes to **RKUtils** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

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

**For new Linux users:** See [Linux Platform Guide](https://github.com/TheRakiburKhan/RKUtils/wiki/Linux-Platform-Guide) for platform-specific limitations and code examples.

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

**Migration:** See [Migration Guide: v1 to v2](https://github.com/TheRakiburKhan/RKUtils/wiki/Migration-Guide-v1-to-v2) for complete upgrade instructions.

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

- **[v1.0 → v2.0](https://github.com/TheRakiburKhan/RKUtils/wiki/Migration-Guide-v1-to-v2)** - Package rename, module splits, platform requirements
- **[Linux Platform Guide](https://github.com/TheRakiburKhan/RKUtils/wiki/Linux-Platform-Guide)** - Cross-platform usage examples
- **[UIKit to AppKit](https://github.com/TheRakiburKhan/RKUtils/wiki/UIKit-to-AppKit-Migration)** - Adapting iOS code for macOS
- **[Testing Migration](https://github.com/TheRakiburKhan/RKUtils/wiki/Testing-Migration-XCTest-to-Swift-Testing)** - XCTest to Swift Testing

---

## Links

- [GitHub Repository](https://github.com/TheRakiburKhan/RKUtils)
- [API Documentation](https://swiftpackageindex.com/TheRakiburKhan/RKUtils/documentation/rkutils)
- [Wiki](https://github.com/TheRakiburKhan/RKUtils/wiki)
- [Report Issues](https://github.com/TheRakiburKhan/RKUtils/issues)

[Unreleased]: https://github.com/TheRakiburKhan/RKUtils/compare/v2.1.1...HEAD
[2.1.1]: https://github.com/TheRakiburKhan/RKUtils/releases/tag/v2.1.1
[2.1.0]: https://github.com/TheRakiburKhan/RKUtils/releases/tag/v2.1.0
[2.0.0]: https://github.com/TheRakiburKhan/RKUtils/releases/tag/v2.0.0
[1.0.0]: https://github.com/TheRakiburKhan/RKUtils/releases/tag/v1.0.0
