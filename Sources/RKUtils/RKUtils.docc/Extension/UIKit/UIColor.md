# ``RKUtils/UIKit/UIColor``

Hex color support, color manipulation, random colors, component extraction, and accessibility utilities.

## Overview

UIColor extensions make it easy to work with hex color codes, create random colors, adjust brightness, extract color components, and ensure accessibility compliance. These utilities are essential for theming, dynamic color generation, and working with design specifications.

### Hex Colors

Work with hexadecimal color codes:

```swift
// Create from hex string
let color1 = UIColor(hexString: "#FF5733")
let color2 = UIColor(hexString: "FF5733")
let color3 = UIColor(hexString: "#FF5733", alpha: 0.8)

// Convert to hex string
let hex = UIColor.systemBlue.toHexString()
// "#007AFF"
```

### Color Manipulation

Adjust brightness dynamically:

```swift
let baseColor = UIColor.systemBlue

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
let randomColor = UIColor.random
view.backgroundColor = randomColor

// Soft pastel color
let pastelColor = UIColor.randomPastel
avatarView.backgroundColor = pastelColor
```

### Color Components

Extract RGBA values:

```swift
let color = UIColor.systemBlue

// Get all components at once
let (r, g, b, a) = color.rgbaComponents
print("R: \(r), G: \(g), B: \(b), A: \(a)")

// Get individual components
let red = color.redComponent
let green = color.greenComponent
let blue = color.blueComponent
```

### Accessibility

Ensure WCAG compliance and readable text:

```swift
let background = UIColor(hexString: "#007AFF")

// Check if color is light or dark
if background.isLight {
    label.textColor = .black
} else {
    label.textColor = .white
}

// Calculate contrast ratio
let text = UIColor.white
let ratio = text.contrastRatio(with: background)
// 4.5 (meets WCAG AA for normal text)

if ratio >= 4.5 {
    print("Accessible color combination")
}
```

### Design System Implementation

Use hex codes from design specifications:

```swift
extension UIColor {
    // Brand colors from design system
    static let brandPrimary = UIColor(hexString: "#007AFF")
    static let brandSecondary = UIColor(hexString: "#5856D6")
    static let brandAccent = UIColor(hexString: "#FF9500")

    // Semantic colors
    static let success = UIColor(hexString: "#34C759")
    static let warning = UIColor(hexString: "#FF9500")
    static let error = UIColor(hexString: "#FF3B30")
}

// Usage
button.backgroundColor = .brandPrimary
errorLabel.textColor = .error
```

### Export Colors for Web

Convert UIColors to hex for sharing with web team:

```swift
func exportColorPalette() -> [String: String] {
    return [
        "primary": UIColor.systemBlue.toHexString(),
        "secondary": UIColor.systemPurple.toHexString(),
        "success": UIColor.systemGreen.toHexString(),
        "warning": UIColor.systemOrange.toHexString()
    ]
}

// Output:
// ["primary": "#007AFF", "secondary": "#5856D6", ...]
```

### Dynamic Button States

Create hover and pressed states:

```swift
class ThemedButton: UIButton {
    var normalColor: UIColor = .systemBlue {
        didSet { updateColors() }
    }

    private func updateColors() {
        backgroundColor = normalColor

        // Darker when pressed
        let highlightedColor = normalColor.darker(by: 0.15)
        setBackgroundImage(imageFrom(color: highlightedColor), for: .highlighted)

        // Lighter when disabled
        let disabledColor = normalColor.lighter(by: 0.3)
        setBackgroundImage(imageFrom(color: disabledColor), for: .disabled)
    }

    private func imageFrom(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}
```

### Accessible Text Colors

Automatically choose text color for readability:

```swift
func setupLabel(background: UIColor, text: String) {
    label.backgroundColor = background
    label.text = text

    // Automatically choose black or white text
    label.textColor = background.isLight ? .black : .white

    // Verify accessibility
    let ratio = label.textColor!.contrastRatio(with: background)
    if ratio < 4.5 {
        print("Warning: Text may not be readable (ratio: \(ratio))")
    }
}

// Usage
setupLabel(background: UIColor(hexString: "#FF5733"), text: "Hello")
```

### User Avatar Colors

Generate consistent colors from user data:

```swift
func avatarColor(for username: String) -> UIColor {
    let hash = abs(username.hashValue)
    let hue = CGFloat(hash % 360) / 360.0

    return UIColor(hue: hue, saturation: 0.6, brightness: 0.9, alpha: 1.0)
}

func setupAvatar(for user: User) {
    if let imageURL = user.avatarURL {
        avatarImageView.loadImage(from: imageURL)
    } else {
        let background = avatarColor(for: user.username)
        avatarView.backgroundColor = background

        // Use appropriate text color
        initialsLabel.text = user.initials
        initialsLabel.textColor = background.isLight ? .black : .white
    }
}
```

### Theme-Aware Gradients

Create smooth gradients with color variations:

```swift
func setupGradientBackground() {
    let baseColor = UIColor(hexString: "#007AFF")

    view.setLinearGradientBackground(
        colors: [
            baseColor.lighter(by: 0.2),
            baseColor,
            baseColor.darker(by: 0.2)
        ],
        startPoint: CGPoint(x: 0.5, y: 0),
        endPoint: CGPoint(x: 0.5, y: 1)
    )
}
```

### Debug Visualization

Use random colors to visualize layout:

```swift
#if DEBUG
func highlightViewHierarchy() {
    func applyRandomColor(to view: UIView) {
        // Use pastel colors for softer appearance
        view.backgroundColor = UIColor.randomPastel.withAlphaComponent(0.3)
        view.subviews.forEach { applyRandomColor(to: $0) }
    }

    applyRandomColor(to: self.view)
}
#endif
```

### Color Component Analysis

Extract and analyze color values:

```swift
func analyzeColor(_ color: UIColor) {
    let (r, g, b, a) = color.rgbaComponents

    print("Color Analysis:")
    print("  Red: \(Int(r * 255))")
    print("  Green: \(Int(g * 255))")
    print("  Blue: \(Int(b * 255))")
    print("  Alpha: \(a)")
    print("  Hex: \(color.toHexString())")
    print("  Is Light: \(color.isLight)")

    // Check contrast with white
    let whiteRatio = color.contrastRatio(with: .white)
    let blackRatio = color.contrastRatio(with: .black)

    print("  Best text color: \(whiteRatio > blackRatio ? "White" : "Black")")
}
```

## Topics

### Hex Color Support

Create and convert colors using hexadecimal strings.

- ``UIColor/init(hexString:alpha:)``
- ``UIColor/toHexString()``

### Color Manipulation

Adjust color brightness programmatically.

- ``UIColor/withBrightness(_:)``
- ``UIColor/lighter(by:)``
- ``UIColor/darker(by:)``

### Random Colors

Generate random colors for testing and visualization.

- ``UIColor/random``
- ``UIColor/randomPastel``

### Color Components

Extract RGBA components from colors.

- ``UIColor/rgbaComponents``
- ``UIColor/redComponent``
- ``UIColor/greenComponent``
- ``UIColor/blueComponent``

### Color Comparison

Check color properties and calculate contrast ratios.

- ``UIColor/isLight``
- ``UIColor/isDark``
- ``UIColor/contrastRatio(with:)``

## See Also

- <doc:UIKit-Guide>
- ``RKUtilsUI/UIKit/UIView``
- ``RKUtilsUI/UIKit/UITextField``
