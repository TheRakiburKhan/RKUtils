# ``RKUtils/AppKit/NSColor``

Hex color support, color manipulation, random colors, component extraction, and accessibility utilities for macOS.

## Overview

NSColor extensions provide the same powerful color utilities as UIColor, bringing consistency between iOS and macOS development. Work with hex codes, adjust brightness, extract components, and ensure WCAG accessibility compliance.

### Hex Colors

Work with hexadecimal color codes:

```swift
// Create from hex string
let color1 = NSColor(hexString: "#FF5733")
let color2 = NSColor(hexString: "FF5733")
let color3 = NSColor(hexString: "#FF5733", alpha: 0.8)

// Convert to hex string
let hex = NSColor.systemBlue.toHexString()
// "#007AFF"
```

### Color Manipulation

Adjust brightness dynamically:

```swift
let baseColor = NSColor.systemBlue

// Set specific brightness
let darker = baseColor.withBrightness(0.3)
let brighter = baseColor.withBrightness(0.9)

// Lighten or darken by percentage
let lighter = baseColor.lighter(by: 0.2)  // 20% lighter
let darker = baseColor.darker(by: 0.3)    // 30% darker
```

### Random Colors

Generate random colors for testing and visualization:

```swift
// Full random color
let randomColor = NSColor.random
view.layer?.backgroundColor = randomColor.cgColor

// Soft pastel color
let pastelColor = NSColor.randomPastel
avatarView.layer?.backgroundColor = pastelColor.cgColor
```

### Color Components

Extract RGBA values:

```swift
let color = NSColor.systemBlue

// Get all components at once
let (r, g, b, a) = color.rgbaComponents
print("R: \(r), G: \(g), B: \(b), A: \(a)")

// Get individual components
let red = color.redComponent
let green = color.greenComponent
let blue = color.blueComponent
```

### Accessibility

Ensure WCAG compliance for macOS apps:

```swift
let background = NSColor(hexString: "#007AFF")

// Check if color is light or dark
if background.isLight {
    textField.textColor = .black
} else {
    textField.textColor = .white
}

// Calculate contrast ratio
let text = NSColor.white
let ratio = text.contrastRatio(with: background)
// 4.5 (meets WCAG AA for normal text)

if ratio >= 4.5 {
    print("Accessible color combination")
}
```

### Design System Implementation

Define brand colors for macOS apps:

```swift
extension NSColor {
    // Brand colors from design system
    static let brandPrimary = NSColor(hexString: "#007AFF")
    static let brandSecondary = NSColor(hexString: "#5856D6")
    static let brandAccent = NSColor(hexString: "#FF9500")

    // Semantic colors
    static let success = NSColor(hexString: "#34C759")
    static let warning = NSColor(hexString: "#FF9500")
    static let error = NSColor(hexString: "#FF3B30")
}

// Usage
button.bezelColor = .brandPrimary
errorLabel.textColor = .error
```

### Export Colors for Web

Convert NSColors to hex for cross-platform design systems:

```swift
func exportColorPalette() -> [String: String] {
    return [
        "primary": NSColor.systemBlue.toHexString(),
        "secondary": NSColor.systemPurple.toHexString(),
        "success": NSColor.systemGreen.toHexString(),
        "warning": NSColor.systemOrange.toHexString()
    ]
}

// Output:
// ["primary": "#007AFF", "secondary": "#5856D6", ...]
```

### Dynamic Button States

Create hover and pressed states for NSButton:

```swift
class ThemedButton: NSButton {
    var normalColor: NSColor = .systemBlue {
        didSet { updateColors() }
    }

    private func updateColors() {
        bezelColor = normalColor

        // Darker when pressed
        let highlightedColor = normalColor.darker(by: 0.15)

        // Lighter when disabled
        let disabledColor = normalColor.lighter(by: 0.3)

        // Apply colors based on state
        if !isEnabled {
            bezelColor = disabledColor
        }
    }

    override var isEnabled: Bool {
        didSet {
            updateColors()
        }
    }
}
```

### Accessible Text Colors

Automatically choose text color for readability:

```swift
func setupTextField(background: NSColor, text: String) {
    textField.backgroundColor = background
    textField.stringValue = text

    // Automatically choose black or white text
    textField.textColor = background.isLight ? .black : .white

    // Verify accessibility
    if let textColor = textField.textColor {
        let ratio = textColor.contrastRatio(with: background)
        if ratio < 4.5 {
            print("Warning: Text may not be readable (ratio: \(ratio))")
        }
    }
}

// Usage
setupTextField(background: NSColor(hexString: "#FF5733"), text: "Hello")
```

### Window Title Bar Colors

Customize window appearance with theme colors:

```swift
class ColoredWindow: NSWindow {
    func setupTitleBarColor() {
        let titleBarColor = NSColor(hexString: "#007AFF")

        titlebarAppearsTransparent = true
        backgroundColor = titleBarColor

        // Choose appropriate text color
        if titleBarColor.isLight {
            appearance = NSAppearance(named: .aqua)
        } else {
            appearance = NSAppearance(named: .darkAqua)
        }
    }
}
```

### Gradient Layer Backgrounds

Create smooth gradients for macOS views:

```swift
func setupGradientBackground(for view: NSView) {
    let baseColor = NSColor(hexString: "#007AFF")

    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [
        baseColor.lighter(by: 0.2).cgColor,
        baseColor.cgColor,
        baseColor.darker(by: 0.2).cgColor
    ]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

    view.wantsLayer = true
    view.layer?.insertSublayer(gradientLayer, at: 0)
}
```

### Debug Visualization

Use random colors to visualize view hierarchy:

```swift
#if DEBUG
func highlightViewHierarchy(in view: NSView) {
    func applyRandomColor(to view: NSView) {
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.randomPastel.withAlphaComponent(0.3).cgColor
        view.subviews.forEach { applyRandomColor(to: $0) }
    }

    applyRandomColor(to: view)
}
#endif
```

### Color Component Analysis

Extract and analyze color values for macOS:

```swift
func analyzeColor(_ color: NSColor) {
    let (r, g, b, a) = color.rgbaComponents

    print("Color Analysis:")
    print("  Red: \(Int(r * 255))")
    print("  Green: \(Int(g * 255))")
    print("  Blue: \(Int(b * 255))")
    print("  Alpha: \(a)")
    print("  Hex: \(color.toHexString())")
    print("  Is Light: \(color.isLight)")

    // Check contrast with white and black
    let whiteRatio = color.contrastRatio(with: .white)
    let blackRatio = color.contrastRatio(with: .black)

    print("  Best text color: \(whiteRatio > blackRatio ? "White" : "Black")")
}
```

## Topics

### Hex Color Support

Create and convert colors using hexadecimal strings.

- ``NSColor/init(hexString:alpha:)``
- ``NSColor/toHexString()``

### Color Manipulation

Adjust color brightness programmatically.

- ``NSColor/withBrightness(_:)``
- ``NSColor/lighter(by:)``
- ``NSColor/darker(by:)``

### Random Colors

Generate random colors for testing and visualization.

- ``NSColor/random``
- ``NSColor/randomPastel``

### Color Components

Extract RGBA components from colors.

- ``NSColor/rgbaComponents``
- ``NSColor/redComponent``
- ``NSColor/greenComponent``
- ``NSColor/blueComponent``

### Color Comparison

Check color properties and calculate contrast ratios.

- ``NSColor/isLight``
- ``NSColor/isDark``
- ``NSColor/contrastRatio(with:)``

## See Also

- ``RKUtils/AppKit/NSView``
- ``RKUtils/AppKit/NSTextField``
