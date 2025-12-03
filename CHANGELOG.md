# Changelog

All notable changes to **RKUtils** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

---

## [2.0.0] - 2024-12-03

### 🎉 Major Update - macOS Support & Testing Framework Migration

### Added

#### 🍎 macOS Support (AppKit)
**New Library**: `RKUtilsMacOS` - Complete macOS/AppKit support with feature parity to UIKit extensions

- **NSColor Extensions**
  - `init(hexString:alpha:)` - Initialize NSColor from hex string (e.g., "#FF5733")
  - Consistent API with UIColor hex initializer
  - Full RGB support with optional alpha channel

- **NSView Extensions** - Complete parity with UIView
  - `setCornerRadius(cornerRadius:)` - Set corner radius with automatic layer-backing
  - `roundedCorner(corners:radius:clips:)` - Round specific corners using CACornerMask
  - `rounded(clips:)` - Make view circular
  - `setBorder(width:color:background:radius:)` - Configure border properties
  - `setShadow(color:background:offset:opacity:radius:cornerRadius:path:)` - Add shadow effects
  - `setLinearGradientBackground(colors:startPoint:endPoint:location:type:)` - Apply gradient backgrounds
  - `showViewWithAnimation(isHidden:)` - Animate view visibility with fade effect using NSAnimationContext
  - `applyBlurEffect(material:blendingMode:)` - Add blur effect using NSVisualEffectView

- **NSTextField Extensions**
  - `textPublisher()` - Combine publisher for text changes (works with NSSecureTextField)
  - `setLeftPaddingPoints(_:)` - Add left padding (simplified placeholder)
  - `setRightPaddingPoints(_:)` - Add right padding (simplified placeholder)

- **NSSecureTextField Extensions** - Password field with show/hide toggle
  - `setSecureTextToggleToRight(_:)` - Add show/hide password toggle button with eye icon
  - Automatic switching between NSSecureTextField and NSTextField for password visibility
  - SF Symbols support (macOS 11.0+) with emoji fallback (macOS 10.15)
  - State preservation during toggle (text, font, formatting, focus)

- **NSCollectionView Extensions**
  - `visibleCurrentCellIndexPath` - Get index path of currently visible cell
  - `register(cell:fromNib:bundle:)` - Type-safe cell registration

- **NSTableView Extensions**
  - `register(cell:fromNib:bundle:)` - Type-safe cell registration
  - `dequeueReusableCell(cell:owner:)` - Type-safe cell dequeue

#### 🧪 Testing Framework Migration
**Migrated from XCTest to Swift Testing framework**

- All 124 tests now use modern Swift Testing framework
- Replaced `XCTAssert*` with `#expect()` macros
- Changed test classes to structs with `@Suite` and `@Test` attributes
- Parameterized tests using `arguments:` parameter
- Added `@MainActor` isolation for UI tests
- Improved test readability and maintainability

#### ✅ Comprehensive Test Coverage (124 tests total)

**Cross-Platform Core Tests** (109 tests)
- String extensions tests (15 tests) - Email validation, date parsing, base64 encoding
- Date extensions tests (20 tests) - Date manipulation, formatting, relative time
- Int extensions tests (17 tests) - Number formatting, conversions, utilities
- Double extensions tests (42 tests) - Advanced formatting, measurements, conversions
- Bundle extensions tests (5 tests) - Version info, display name
- CLLocationCoordinate2D extensions tests (7 tests) - Bearing calculations
- Data extensions tests (4 tests) - String conversions

**UIKit Tests** (27 tests)
- UIColor extensions tests (7 tests) - Hex string initialization
- CGRect extensions tests (5 tests) - MinEdge calculations
- UIView extensions tests (15 tests) - Corner radius, borders, shadows, gradients, blur, animations

**AppKit Tests** (17 tests)
- NSColor extensions tests (2 tests) - Hex string initialization
- NSView extensions tests (15 tests) - Complete feature parity with UIView tests

#### 📦 Package Structure Improvements

**Platform-Specific Targets**
- `RKUtils` - Cross-platform utilities (all platforms)
- `RKUtilsUI` - UIKit-specific (iOS 13+, tvOS 13+, visionOS 1+, Catalyst 13+)
- `RKUtilsMacOS` - AppKit-specific (macOS 10.15+)

**Test Organization**
- `RKUtilsTests` - Cross-platform utility tests
- `RKUtilsUITests` - UIKit extension tests
- `RKUtilsMacOSTests` - AppKit extension tests

### Changed

#### 📁 File Organization
- **Extracted NSSecureTextField** - Moved to dedicated file (NSSecureTextField.swift) for better code organization
- **Modular Structure** - Each UI component has its own file
- **Consistent Naming** - Unified naming convention across all targets

#### 🎯 Platform Compatibility
**Minimum Platform Versions:**
- iOS 13.0
- macOS 10.15 (Catalina)
- watchOS 6.0
- tvOS 13.0
- visionOS 1.0
- macCatalyst 13.0

**Swift Version:** 6.0+

### Technical Details

#### AppKit vs UIKit Adaptations

**Layer-backing**
- All NSView layer operations automatically enable `wantsLayer = true`
- Consistent API despite different underlying implementations

**Color Types**
- NSColor instead of UIColor
- System colors adapted (`.secondaryLabelColor` vs `.secondaryLabel`)

**Coordinate System**
- Handled AppKit's bottom-left origin vs UIKit's top-left origin
- Gradient positioning adjusted for coordinate system differences

**Animations**
- NSAnimationContext with implicit animation instead of UIView.animate
- Smooth transitions with alpha value support

**Blur Effects**
- NSVisualEffectView with `material` and `blendingMode` parameters
- AppKit materials (`.contentBackground`, `.hudWindow`, etc.) instead of UIKit blur styles

**Autoresizing Masks**
- `.width` and `.height` instead of `.flexibleWidth` and `.flexibleHeight`

#### Secure Text Implementation

**UIKit Approach**
- Toggle `isSecureTextEntry` property on same UITextField instance
- Simple property change

**AppKit Approach**
- Swap between NSSecureTextField and NSTextField instances
- Required due to separate class hierarchy in AppKit
- Full state preservation during swap

---

## [1.0.0] - 2025-06-02

### 🎉 First Official Release

- Initial release of **RKUtils** as a Swift Package
- Includes helpful UIKit & Foundation extensions:
  - `UIView` (corner radius, shadows, gradients, blur, animations)
  - `UITextField` and `UITextView` (keyboard Done button, secure text toggle)
  - `UIStoryboard` (type-safe instantiation)
  - `UIScreen` (min/max edge helpers)
  - `Bundle` (version, build, name, ID)
  - `UIFeedbackGenerator` helpers
- iOS 11+ compatible, Swift 5+, modular and production-ready

---

## Migration Guide

### 🔄 From UIKit to AppKit

If you're adapting code from UIKit to AppKit using this library:

#### View Styling
```swift
// UIKit
let view = UIView()
view.setCornerRadius(cornerRadius: 10)
view.setBorder(width: 2, color: .red)
view.setShadow(color: .black, opacity: 0.5, radius: 4)
view.applyBlurEffect(style: .regular)

// AppKit - Identical API!
let view = NSView()
view.setCornerRadius(cornerRadius: 10)
view.setBorder(width: 2, color: .red)
view.setShadow(color: .black, opacity: 0.5, radius: 4)
view.applyBlurEffect(material: .contentBackground)
```

#### Color Initialization
```swift
// UIKit
let color = UIColor(hexString: "#FF5733")
let colorWithAlpha = UIColor(hexString: "#FF5733", alpha: 0.5)

// AppKit - Identical API!
let color = NSColor(hexString: "#FF5733")
let colorWithAlpha = NSColor(hexString: "#FF5733", alpha: 0.5)
```

#### Secure Text Fields
```swift
// UIKit
let textField = UITextField()
textField.setSecureTextToggleToRight(.systemBlue)

// AppKit
let secureTextField = NSSecureTextField()
secureTextField.setSecureTextToggleToRight(.systemBlue)
```

### 🧪 Test Migration from XCTest to Swift Testing

#### Basic Test Structure
```swift
// Old (XCTest)
import XCTest

class MyTests: XCTestCase {
    func testExample() {
        XCTAssertEqual(value, expected)
        XCTAssertTrue(condition)
        XCTAssertNotNil(object)
    }
}

// New (Swift Testing)
import Testing

@Suite("My Tests")
struct MyTests {
    @Test("Example test")
    func example() {
        #expect(value == expected)
        #expect(condition)
        #expect(object != nil)
    }
}
```

#### Parameterized Tests
```swift
// Old (XCTest) - Required multiple test methods
func testRed() { /* test with red */ }
func testBlue() { /* test with blue */ }
func testGreen() { /* test with green */ }

// New (Swift Testing) - Single parameterized test
@Test("Color tests", arguments: ["red", "blue", "green"])
func colorTest(color: String) {
    #expect(Color(color).isValid)
}
```

#### UI Tests with MainActor
```swift
// Swift Testing with UI components
@MainActor
@Suite("NSView Extensions")
struct NSViewTests {
    @Test("Corner radius")
    func cornerRadius() {
        let view = NSView()
        view.setCornerRadius(cornerRadius: 10)
        #expect(view.layer?.cornerRadius == 10)
    }
}
```

---

## Links

- [GitHub Repository](https://github.com/TheRakiburKhan/RKUtils)
- [Documentation](https://github.com/TheRakiburKhan/RKUtils/wiki)
- [Report Issues](https://github.com/TheRakiburKhan/RKUtils/issues)

[Unreleased]: https://github.com/TheRakiburKhan/RKUtils/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/TheRakiburKhan/RKUtils/releases/tag/v2.0.0
[1.0.0]: https://github.com/TheRakiburKhan/RKUtils/releases/tag/v1.0.0
