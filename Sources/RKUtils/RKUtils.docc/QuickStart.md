# Quick Start Guide

Get up and running with RKUtils in minutes with this comprehensive quick start guide.

## Overview

RKUtils provides powerful extensions for Foundation, UIKit, AppKit, and SwiftUI that work seamlessly across all Apple platforms. This guide shows you how to use the most common features in real-world scenarios.

## Basic Setup

### 1. Install RKUtils

If you haven't already installed RKUtils, see the <doc:Installation> guide.

### 2. Import RKUtils

In any Swift file where you want to use RKUtils:

```swift
import RKUtils
```

That's it! All extensions are now available.

## Foundation Extensions

These work on **all platforms** including iOS, macOS, tvOS, watchOS, visionOS, and even Linux.

### String Extensions

#### Email Validation

```swift
import RKUtils

let email = "user@example.com"
if email.isValidEmail {
    print("Valid email address")
}

// Invalid examples
"@example.com".isValidEmail        // false
"user@".isValidEmail               // false
"not an email".isValidEmail        // false
```

#### Date Parsing from Strings

```swift
let dateString = "2024-01-15"
if let date = dateString.toDate(format: "yyyy-MM-dd") {
    print("Parsed date: \(date)")
}

// ISO8601 parsing
let isoString = "2024-01-15T10:30:00Z"
if let isoDate = isoString.toISO8601Date() {
    print("ISO date: \(isoDate)")
}
```

#### Base64 Encoding

```swift
let text = "Hello, World!"
let encoded = text.base64Encoded
print(encoded)  // "SGVsbG8sIFdvcmxkIQ=="

if let decoded = encoded.base64Decoded {
    print(decoded)  // "Hello, World!"
}
```

#### Digit and Word Conversion

```swift
"123".digitNames        // "one two three"
"ABC 123".digitNames    // "ABC one two three"
```

### Number Extensions

#### Integer Formatting

```swift
import RKUtils

// Abbreviations
1_000.abbreviated       // "1K"
1_234_567.abbreviated   // "1.2M"
2_500_000_000.abbreviated  // "2.5B"

// Locale-specific formatting
let number = 1234
number.toLocal()  // "1,234" (en_US) or "1 234" (fr_FR)

// Pluralization
1.pluralized(singular: "apple")           // "1 apple"
2.pluralized(singular: "apple")           // "2 apples"
2.pluralized(singular: "child", plural: "children")  // "2 children"

// Byte sizes
1024.byteSizeFormatted       // "1.0 KB"
1_048_576.byteSizeFormatted  // "1.0 MB"
```

#### Double Formatting

```swift
// Percentages
0.75.percentage()        // "75%"
0.4567.percentage()      // "45.67%"

// Currency
99.99.currency(code: "USD")  // "$99.99"
49.50.currency(code: "EUR")  // "€49.50"

// Scientific notation
123456.78.scientificNotation()  // "1.23e+05"

// Rounding
3.14159.roundedString(places: 2)  // "3.14"

// Measurements (Darwin only)
42.0.distance()      // "42 km"
100.0.speed()        // "100 km/h"
25.0.temperature()   // "25°C"
```

### Date Extensions

#### Date Formatting

```swift
import RKUtils

let date = Date()

// Simple formatting
date.toString()  // "2024-01-15 14:30:00" (default format)
date.toString(format: "MMM d, yyyy")  // "Jan 15, 2024"

// Readable strings with locale
date.readableString(localizedDateFormatFromTemplate: "MMMdy")
// "Jan 15" (localized for current locale)
```

#### Relative Time (iOS 14+, macOS 11+)

```swift
let pastDate = Date().addingTimeInterval(-3600)  // 1 hour ago
pastDate.relativeTime()  // "1 hr ago"

let futureDate = Date().addingTimeInterval(7200)  // 2 hours from now
futureDate.relativeTime()  // "in 2 hr"
```

#### Date Arithmetic

```swift
let today = Date()

// Add time
let tomorrow = today.dateAfter(1, .day)
let nextWeek = today.dateAfter(1, .weekOfYear)
let nextMonth = today.dateAfter(1, .month)

// Subtract time
let yesterday = today.dateBefore(1, .day)
let lastMonth = today.dateBefore(1, .month)

// Calculate distances
let christmas = Date()  // Assume Dec 25
let daysUntil = today.distanceOf(.day, till: christmas)
print("Days until Christmas: \(daysUntil)")
```

#### Week Dates

```swift
let today = Date()
let weekDates = today.datesOfCurrentWeek()
// Returns array of 7 dates representing the current week
```

#### Date Checks

```swift
let date = Date()
if date.isInToday() {
    print("This date is today")
}

let monthName = date.monthName()  // "January"
```

### Bundle Extensions

```swift
import RKUtils

// Version information
let version = Bundle.main.releaseVersionNumber  // "1.0.0"
let build = Bundle.main.buildVersionNumber      // "42"
let pretty = Bundle.main.releaseVersionNumberPretty  // "1.0.0 (42)"

// App name
let appName = Bundle.main.bundleDisplayName  // "MyApp"

// Environment detection
#if targetEnvironment(simulator)
if Bundle.main.isSimulator {
    print("Running in simulator")
}
#endif
```

### ProcessInfo Extensions

```swift
import RKUtils

// SwiftUI Preview detection
if ProcessInfo.processInfo.isPreview {
    print("Running in SwiftUI preview")
}
```

### Data Extensions

```swift
import RKUtils

var data = Data()
data.append("Hello")
data.append(", ")
data.append("World!")

if let string = String(data: data, encoding: .utf8) {
    print(string)  // "Hello, World!"
}
```

## UIKit Extensions (iOS, tvOS, visionOS)

### UIColor - Hex Colors

```swift
import UIKit
import RKUtils

// Create from hex
let red = UIColor(hexString: "#FF0000")
let blue = UIColor(hexString: "0000FF")  // # is optional
let transparentGreen = UIColor(hexString: "#00FF00", alpha: 0.5)

// Convert to hex
let systemBlue = UIColor.systemBlue
let hex = systemBlue.toHexString()  // "#007AFF"
```

### UIColor - Manipulation

```swift
let baseColor = UIColor.systemBlue

// Adjust brightness
let darker = baseColor.darker(by: 0.2)    // 20% darker
let lighter = baseColor.lighter(by: 0.3)  // 30% lighter
let specific = baseColor.withBrightness(0.5)  // Set to 50% brightness

// Random colors
let randomColor = UIColor.random
let pastelColor = UIColor.randomPastel  // Soft, low saturation

// Extract components
let (r, g, b, a) = baseColor.rgbaComponents
print("R: \(r), G: \(g), B: \(b), A: \(a)")
```

### UIColor - Accessibility

```swift
let background = UIColor(hexString: "#007AFF")
let textColor: UIColor = background.isLight ? .black : .white

// WCAG contrast ratio
let ratio = UIColor.black.contrastRatio(with: .white)  // 21.0
if ratio >= 4.5 {
    print("Meets WCAG AA standard")
}
if ratio >= 7.0 {
    print("Meets WCAG AAA standard")
}
```

### UIView - Styling

```swift
import UIKit
import RKUtils

class MyViewController: UIViewController {
    let cardView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Corner radius
        cardView.setCornerRadius(cornerRadius: 12)

        // Borders
        cardView.setBorder(width: 2, color: .systemBlue)
        // Or with corner radius
        cardView.setBorder(width: 2, color: .systemBlue, cornerRadius: 12)

        // Shadows
        cardView.setShadow(
            color: .black,
            opacity: 0.2,
            radius: 8,
            offset: CGSize(width: 0, height: 4)
        )

        // Rounded corners (specific corners)
        cardView.roundedCorner(
            radius: 16,
            corners: [.topLeft, .topRight]
        )

        // Make circular
        cardView.rounded()  // Sets corner radius to half of bounds
    }
}
```

### UIView - Gradients

```swift
let gradientView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))

gradientView.setLinearGradientBackground(
    colors: [.systemBlue, .systemPurple],
    startPoint: CGPoint(x: 0, y: 0),
    endPoint: CGPoint(x: 1, y: 1)
)
```

### UIView - Blur Effects

```swift
let backgroundView = UIView()
backgroundView.applyBlurEffect(style: .systemMaterial)

// Or with custom material
backgroundView.applyBlurEffect(style: .systemThinMaterial)
```

### UIView - Animations

```swift
let box = UIView()
box.isHidden = true

// Show with animation
box.showViewWithAnimation(duration: 0.3)

// Hide with animation
box.showViewWithAnimation(show: false, duration: 0.3)
```

### UITextField - Combine Publishers

```swift
import Combine
import RKUtils

class MyViewController: UIViewController {
    let textField = UITextField()
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.textPublisher
            .sink { text in
                print("Text changed: \(text)")
            }
            .store(in: &cancellables)
    }
}
```

### UITextField - Padding

```swift
let textField = UITextField()
textField.setLeftPaddingPoints(16)
textField.setRightPaddingPoints(16)
```

### UITableView - Type-Safe Cells

```swift
class MyCell: UITableViewCell {
    // Cell implementation
}

class MyViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell (identifier automatically matches class name)
        tableView.register(cell: MyCell.self)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue with type safety
        let cell = tableView.dequeueReusableCell(MyCell.self, for: indexPath)
        return cell
    }
}
```

### UICollectionView - Type-Safe Cells

```swift
class MyCell: UICollectionViewCell {
    // Cell implementation
}

class MyViewController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(cell: MyCell.self)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(MyCell.self, for: indexPath)
        return cell
    }
}
```

## AppKit Extensions (macOS)

AppKit extensions mirror the UIKit API for consistency:

### NSView - Styling

```swift
import AppKit
import RKUtils

class MyViewController: NSViewController {
    let cardView = NSView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Corner radius
        cardView.setCornerRadius(cornerRadius: 12)

        // Borders
        cardView.setBorder(width: 2, color: .systemBlue)

        // Shadows
        cardView.setShadow(
            color: .black,
            opacity: 0.2,
            radius: 8,
            offset: CGSize(width: 0, height: 4)
        )

        // Rounded corners
        cardView.roundedCorner(
            radius: 16,
            corners: [.topLeft, .topRight]
        )
    }
}
```

### NSColor - Same as UIColor

```swift
import AppKit
import RKUtils

let color = NSColor(hexString: "#FF5733")
let darker = color.darker(by: 0.2)
let lighter = color.lighter(by: 0.3)

let textColor: NSColor = color.isLight ? .black : .white
```

### NSTextField - Combine Publishers

```swift
import AppKit
import Combine
import RKUtils

class MyViewController: NSViewController {
    let textField = NSTextField()
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.textPublisher
            .sink { text in
                print("Text changed: \(text)")
            }
            .store(in: &cancellables)
    }
}
```

### NSSecureTextField - Password Toggle

```swift
import AppKit
import RKUtils

class MyViewController: NSViewController {
    let passwordField = NSSecureTextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(passwordField)
        // ... layout constraints ...

        // Add show/hide password button
        passwordField.setSecureTextToggleToRight(.systemBlue)
    }
}
```

## SwiftUI Extensions

### Color - Hex and Manipulation

```swift
import SwiftUI
import RKUtils

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Hex colors
            Text("Primary")
                .foregroundColor(.white)
                .padding()
                .background(Color(hexString: "#007AFF"))

            // Color manipulation
            Text("Lighter")
                .foregroundColor(.white)
                .padding()
                .background(
                    Color(hexString: "#007AFF")
                        .lighter(by: 0.2)
                )

            Text("Darker")
                .foregroundColor(.white)
                .padding()
                .background(
                    Color(hexString: "#007AFF")
                        .darker(by: 0.2)
                )

            // Random colors
            Rectangle()
                .fill(Color.randomPastel)
                .frame(height: 50)
        }
    }
}
```

### Adaptive Text Color

```swift
struct AdaptiveCard: View {
    let backgroundColor: Color

    var textColor: Color {
        backgroundColor.isLight ? .black : .white
    }

    var body: some View {
        Text("Adaptive Text")
            .foregroundColor(textColor)
            .padding()
            .background(backgroundColor)
            .cornerRadius(12)
    }
}

// Usage
AdaptiveCard(backgroundColor: Color(hexString: "#FF5733"))
AdaptiveCard(backgroundColor: Color(hexString: "#E0E0E0"))
```

### Accessibility-Compliant Colors

```swift
struct AccessibleButton: View {
    let backgroundColor = Color(hexString: "#007AFF")

    var body: some View {
        let textColor: Color = backgroundColor.contrastRatio(with: .white) >= 4.5
            ? .white
            : .black

        Button("Submit") {
            // Action
        }
        .foregroundColor(textColor)
        .padding()
        .background(backgroundColor)
        .cornerRadius(8)
    }
}
```

## Real-World Examples

### User Profile Card (iOS)

```swift
import SwiftUI
import RKUtils

struct UserProfileCard: View {
    let username: String
    let email: String
    let joinDate: Date

    var avatarColor: Color {
        // Generate consistent color from username
        let hash = abs(username.hashValue)
        let hue = Double(hash % 360) / 360.0
        return Color(hue: hue, saturation: 0.6, brightness: 0.9)
    }

    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            Circle()
                .fill(avatarColor)
                .frame(width: 60, height: 60)
                .overlay(
                    Text(username.prefix(2).uppercased())
                        .font(.title2)
                        .foregroundColor(avatarColor.isLight ? .black : .white)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(username)
                    .font(.headline)

                Text(email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("Joined \(joinDate.relativeTime())")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, y: 4)
    }
}
```

### Stats Dashboard (macOS)

```swift
import AppKit
import RKUtils

class StatsViewController: NSViewController {
    let statsView = NSView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStatsCard(
            title: "Total Users",
            value: 1_234_567.abbreviated,  // "1.2M"
            color: NSColor(hexString: "#007AFF")
        )
    }

    func setupStatsCard(title: String, value: String, color: NSColor) {
        let card = NSView()
        card.setCornerRadius(cornerRadius: 12)
        card.setBorder(width: 2, color: color)
        card.setShadow(color: .black, opacity: 0.1, radius: 8)

        // Add labels, constraints, etc.
        view.addSubview(card)
    }
}
```

## Platform-Specific Code

Use conditional compilation when needed:

```swift
import RKUtils

func setupView() {
    #if canImport(UIKit)
    // iOS/tvOS/visionOS
    let view = UIView()
    view.setCornerRadius(cornerRadius: 12)
    view.backgroundColor = UIColor(hexString: "#FF5733")
    #elseif canImport(AppKit)
    // macOS
    let view = NSView()
    view.setCornerRadius(cornerRadius: 12)
    view.layer?.backgroundColor = NSColor(hexString: "#FF5733").cgColor
    #endif
}
```

## Next Steps

- Explore individual extension documentation for complete API reference
- Check out <doc:Platform-Support> for platform-specific features
- See <doc:Migration-Guide> if upgrading from v2.x

## Common Patterns

### Design System with RKUtils

```swift
// Define your brand colors
extension Color {
    static let brandPrimary = Color(hexString: "#007AFF")
    static let brandSecondary = Color(hexString: "#5856D6")
    static let brandAccent = Color(hexString: "#FF9500")

    static let success = Color(hexString: "#34C759")
    static let warning = Color(hexString: "#FF9500")
    static let error = Color(hexString: "#FF3B30")
}

// Use throughout your app
Text("Success!")
    .foregroundColor(.white)
    .padding()
    .background(Color.success)
```

### Form Validation

```swift
struct LoginForm: View {
    @State private var email = ""
    @State private var isValid = false

    var body: some View {
        TextField("Email", text: $email)
            .onChange(of: email) { newValue in
                isValid = newValue.isValidEmail
            }

        if !isValid && !email.isEmpty {
            Text("Invalid email address")
                .foregroundColor(.error)
        }
    }
}
```

## Additional Resources

- [GitHub Repository](https://github.com/TheRakiburKhan/RKUtils)
- [API Documentation](https://swiftpackageindex.com/TheRakiburKhan/RKUtils/documentation)
- [Report Issues](https://github.com/TheRakiburKhan/RKUtils/issues)
