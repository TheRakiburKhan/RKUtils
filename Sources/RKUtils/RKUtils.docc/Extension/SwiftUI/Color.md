# ``RKUtils/SwiftUICore/Color``

Cross-platform hex colors, brightness manipulation, random colors, component extraction, and accessibility utilities for SwiftUI.

## Overview

SwiftUI Color extensions provide the same powerful color utilities as UIColor and NSColor, but for SwiftUI's declarative framework. Work with hex codes, adjust brightness, extract components, and ensure WCAG accessibility compliance across all Apple platforms.

### Hex Colors

Work with hexadecimal color codes:

```swift
// Create from hex string
Color(hexString: "#FF5733")
Color(hexString: "FF5733")
Color(hexString: "#FF5733", alpha: 0.8)

// Convert to hex string (requires UIKit/AppKit)
let hex = Color.blue.toHexString()
// "#007AFF"
```

### Color Manipulation

Adjust brightness dynamically in SwiftUI views:

```swift
struct ThemedView: View {
    let baseColor = Color.blue

    var body: some View {
        VStack {
            // Set specific brightness
            Rectangle()
                .fill(baseColor.withBrightness(0.3))

            // Lighten or darken by percentage
            Rectangle()
                .fill(baseColor.lighter(by: 0.2))  // 20% lighter

            Rectangle()
                .fill(baseColor.darker(by: 0.3))   // 30% darker
        }
    }
}
```

### Random Colors

Generate random colors for testing and visualization:

```swift
struct RandomColorView: View {
    @State private var backgroundColor = Color.random

    var body: some View {
        Rectangle()
            .fill(backgroundColor)
            .onTapGesture {
                backgroundColor = Color.randomPastel
            }
    }
}
```

### Color Components

Extract RGBA values:

```swift
let color = Color.blue

// Get all components at once
let (r, g, b, a) = color.rgbaComponents
print("R: \(r), G: \(g), B: \(b), A: \(a)")

// Get individual components
let red = color.redComponent
let green = color.greenComponent
let blue = color.blueComponent
```

### Accessibility

Ensure WCAG compliance in SwiftUI:

```swift
struct AccessibleText: View {
    let background = Color(hexString: "#007AFF")

    var body: some View {
        Text("Hello, World!")
            .foregroundColor(background.isLight ? .black : .white)
            .padding()
            .background(background)
    }
}

// Check contrast ratio
let background = Color.white
let text = Color.black
let ratio = text.contrastRatio(with: background)
// 21.0 (maximum contrast)

if ratio >= 4.5 {
    print("Meets WCAG AA standard")
}
```

### Design System with SwiftUI

Define brand colors for SwiftUI apps:

```swift
extension Color {
    // Brand colors from design system
    static let brandPrimary = Color(hexString: "#007AFF")
    static let brandSecondary = Color(hexString: "#5856D6")
    static let brandAccent = Color(hexString: "#FF9500")

    // Semantic colors
    static let success = Color(hexString: "#34C759")
    static let warning = Color(hexString: "#FF9500")
    static let error = Color(hexString: "#FF3B30")
}

struct ContentView: View {
    var body: some View {
        Button("Submit") {
            // Action
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.brandPrimary)
        .cornerRadius(8)
    }
}
```

### Dynamic Button States

Create interactive buttons with color variations:

```swift
struct ThemedButton: View {
    let title: String
    let action: () -> Void
    @State private var isPressed = false

    var normalColor = Color.blue

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .padding()
                .background(
                    isPressed
                        ? normalColor.darker(by: 0.15)
                        : normalColor
                )
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}
```

### Adaptive Text Color

Automatically choose text color for readability:

```swift
struct AdaptiveCard: View {
    let backgroundColor: Color
    let content: String

    var textColor: Color {
        backgroundColor.isLight ? .black : .white
    }

    var body: some View {
        VStack {
            Text(content)
                .foregroundColor(textColor)
                .padding()
        }
        .background(backgroundColor)
        .cornerRadius(12)
    }
}

// Usage
AdaptiveCard(
    backgroundColor: Color(hexString: "#FF5733"),
    content: "This text is always readable!"
)
```

### Gradient Backgrounds

Create smooth gradients with color variations:

```swift
struct GradientBackground: View {
    let baseColor = Color(hexString: "#007AFF")

    var body: some View {
        LinearGradient(
            colors: [
                baseColor.lighter(by: 0.2),
                baseColor,
                baseColor.darker(by: 0.2)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}
```

### Color Palette Generator

Generate harmonious color schemes:

```swift
struct ColorPaletteView: View {
    let baseColor = Color(hexString: "#007AFF")

    var colors: [Color] {
        [
            baseColor.lighter(by: 0.4),
            baseColor.lighter(by: 0.2),
            baseColor,
            baseColor.darker(by: 0.2),
            baseColor.darker(by: 0.4)
        ]
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<colors.count, id: \.self) { index in
                Rectangle()
                    .fill(colors[index])
            }
        }
        .frame(height: 100)
    }
}
```

### Random Avatar Colors

Generate consistent colors for user avatars:

```swift
struct UserAvatar: View {
    let username: String

    var avatarColor: Color {
        let hash = abs(username.hashValue)
        let hue = Double(hash % 360) / 360.0
        return Color(hue: hue, saturation: 0.6, brightness: 0.9)
    }

    var textColor: Color {
        avatarColor.isLight ? .black : .white
    }

    var initials: String {
        username.prefix(2).uppercased()
    }

    var body: some View {
        Circle()
            .fill(avatarColor)
            .frame(width: 80, height: 80)
            .overlay(
                Text(initials)
                    .font(.title)
                    .foregroundColor(textColor)
            )
    }
}
```

### Accessibility Validator

Check color contrast for WCAG compliance:

```swift
struct AccessibilityInfo: View {
    let backgroundColor: Color
    let textColor: Color

    var contrastRatio: Double {
        textColor.contrastRatio(with: backgroundColor)
    }

    var meetsWCAG_AA: Bool {
        contrastRatio >= 4.5
    }

    var meetsWCAG_AAA: Bool {
        contrastRatio >= 7.0
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Contrast Ratio: \(String(format: "%.1f", contrastRatio)):1")

            HStack {
                Image(systemName: meetsWCAG_AA ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(meetsWCAG_AA ? .green : .red)
                Text("WCAG AA")
            }

            HStack {
                Image(systemName: meetsWCAG_AAA ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(meetsWCAG_AAA ? .green : .red)
                Text("WCAG AAA")
            }
        }
        .padding()
    }
}
```

### Theme Switcher

Create dynamic themes with color variations:

```swift
struct ThemedView: View {
    @State private var isDarkMode = false

    var backgroundColor: Color {
        let base = Color(hexString: "#007AFF")
        return isDarkMode ? base.darker(by: 0.7) : base.lighter(by: 0.8)
    }

    var textColor: Color {
        backgroundColor.isLight ? .black : .white
    }

    var body: some View {
        VStack {
            Text("Themed Content")
                .foregroundColor(textColor)
                .padding()

            Toggle("Dark Mode", isOn: $isDarkMode)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
    }
}
```

### Debug Color Visualizer

Use random colors to visualize layouts:

```swift
#if DEBUG
struct DebugColoredVStack<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            content
        }
        .background(Color.randomPastel.opacity(0.3))
    }
}
#endif
```

### Color Analysis Tool

Extract and display color information:

```swift
struct ColorAnalyzer: View {
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Color Analysis")
                .font(.headline)

            let (r, g, b, a) = color.rgbaComponents

            Text("Red: \(Int(r * 255))")
            Text("Green: \(Int(g * 255))")
            Text("Blue: \(Int(b * 255))")
            Text("Alpha: \(String(format: "%.2f", a))")
            Text("Hex: \(color.toHexString())")
            Text("Is Light: \(color.isLight ? "Yes" : "No")")

            Divider()

            let whiteRatio = color.contrastRatio(with: .white)
            let blackRatio = color.contrastRatio(with: .black)

            Text("Best text color: \(whiteRatio > blackRatio ? "White" : "Black")")
        }
        .padding()
    }
}
```

## Topics

### Hex Color Support

Create and convert colors using hexadecimal strings.

- ``Color/init(hexString:alpha:)``
- ``Color/toHexString()``

### Color Manipulation

Adjust color brightness programmatically.

- ``Color/withBrightness(_:)``
- ``Color/lighter(by:)``
- ``Color/darker(by:)``

### Random Colors

Generate random colors for testing and visualization.

- ``Color/random``
- ``Color/randomPastel``

### Color Components

Extract RGBA components from colors.

- ``Color/rgbaComponents``
- ``Color/redComponent``
- ``Color/greenComponent``
- ``Color/blueComponent``

### Color Comparison

Check color properties and calculate contrast ratios.

- ``Color/isLight``
- ``Color/isDark``
- ``Color/contrastRatio(with:)``

## See Also

- ``RKUtils/UIKitUIColor``
- ``RKUtils/AppKit/NSColor``
