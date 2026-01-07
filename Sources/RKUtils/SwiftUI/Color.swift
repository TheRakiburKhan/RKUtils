//
//  Color.swift
//  RKiOSUtils
//
//  Created by Rakibur Khan on 26/5/25.
//

#if canImport(SwiftUI)
import SwiftUI

public extension Color {
    /**
     Creates a SwiftUI `Color` from a hex color string.

     Supports hex strings with or without the `#` prefix. Parses 6-character hex values (RRGGBB).

     - Parameters:
        - hexString: The hex color string (e.g., `"#FF5733"` or `"FF5733"`)
        - alpha: The opacity value (default: `1.0`)

     - Returns: A `Color` initialized with the hex color and alpha.

     - Example:
     ```swift
     Color(hexString: "#FF5733")
     Color(hexString: "FF5733")
     Color(hexString: "#FF5733", alpha: 0.8)
     ```

     - Note: Works on all Apple platforms: iOS, macOS, tvOS, watchOS, visionOS.
     */
    init(hexString: String, alpha: Double = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)

        if (hexString.hasPrefix("#")) {
            scanner.currentIndex = .init(utf16Offset: 1, in: hexString)
        }

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = Double(r) / 255.0
        let green = Double(g) / 255.0
        let blue  = Double(b) / 255.0

        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }

    /**
     Converts the color to a hexadecimal string representation.

     Returns a 6-character hex string with `#` prefix (e.g., `"#FF5733"`).

     - Returns: A hex string representation of the color.

     - Example:
     ```swift
     let color = Color(red: 1.0, green: 0.34, blue: 0.2)
     let hex = color.toHexString()
     // "#FF5733"
     ```

     - Note: Requires UIKit (iOS, tvOS, visionOS) or AppKit (macOS).
     */
    func toHexString() -> String {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: nil)
        let rgb = Int(r * 255) << 16 | Int(g * 255) << 8 | Int(b * 255)
        return String(format: "#%06X", rgb)
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        guard let rgbColor = nsColor.usingColorSpace(.deviceRGB) else {
            return "#000000"
        }
        let r = Int(rgbColor.redComponent * 255)
        let g = Int(rgbColor.greenComponent * 255)
        let b = Int(rgbColor.blueComponent * 255)
        let rgb = r << 16 | g << 8 | b
        return String(format: "#%06X", rgb)
        #else
        return "#000000"
        #endif
    }
}

//MARK: Color Manipulation
public extension Color {
    /**
     Returns a new color with the specified brightness.

     - Parameter brightness: The brightness value (0.0 to 1.0).

     - Returns: A new `Color` with the specified brightness.

     - Example:
     ```swift
     let color = Color.blue
     let darker = color.withBrightness(0.3)
     let brighter = color.withBrightness(0.9)
     ```

     - Note: Requires UIKit (iOS, tvOS, visionOS) or AppKit (macOS).
     */
    func withBrightness(_ brightness: Double) -> Color {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return Color(UIColor(hue: h, saturation: s, brightness: CGFloat(brightness), alpha: a))
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        nsColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return Color(NSColor(hue: h, saturation: s, brightness: CGFloat(brightness), alpha: a))
        #else
        return self
        #endif
    }

    /**
     Returns a lighter version of the color.

     - Parameter percentage: The percentage to lighten (0.0 to 1.0). For example, `0.2` means 20% lighter.

     - Returns: A lighter `Color`.

     - Example:
     ```swift
     let baseColor = Color.blue
     let lighterColor = baseColor.lighter(by: 0.2)
     ```

     - Note: Requires UIKit (iOS, tvOS, visionOS) or AppKit (macOS).
     */
    func lighter(by percentage: Double) -> Color {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return Color(UIColor(hue: h, saturation: s, brightness: min(b + CGFloat(percentage), 1.0), alpha: a))
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        nsColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return Color(NSColor(hue: h, saturation: s, brightness: min(b + CGFloat(percentage), 1.0), alpha: a))
        #else
        return self
        #endif
    }

    /**
     Returns a darker version of the color.

     - Parameter percentage: The percentage to darken (0.0 to 1.0). For example, `0.2` means 20% darker.

     - Returns: A darker `Color`.

     - Example:
     ```swift
     let baseColor = Color.blue
     let darkerColor = baseColor.darker(by: 0.2)
     ```

     - Note: Requires UIKit (iOS, tvOS, visionOS) or AppKit (macOS).
     */
    func darker(by percentage: Double) -> Color {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return Color(UIColor(hue: h, saturation: s, brightness: max(b - CGFloat(percentage), 0.0), alpha: a))
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        nsColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return Color(NSColor(hue: h, saturation: s, brightness: max(b - CGFloat(percentage), 0.0), alpha: a))
        #else
        return self
        #endif
    }
}

//MARK: Random Colors
public extension Color {
    /**
     Generates a random color with full opacity.

     - Returns: A random `Color`.

     - Example:
     ```swift
     let randomColor = Color.random
     ```
     */
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }

    /**
     Generates a random pastel color (soft, low saturation).

     Pastel colors have lower saturation and higher brightness for a softer appearance.

     - Returns: A random pastel `Color`.

     - Example:
     ```swift
     let pastelColor = Color.randomPastel
     ```
     */
    static var randomPastel: Color {
        Color(
            hue: .random(in: 0...1),
            saturation: .random(in: 0.2...0.4),
            brightness: .random(in: 0.8...1.0)
        )
    }
}

//MARK: Color Components
public extension Color {
    /**
     Returns all RGBA components as a tuple.

     - Returns: A tuple containing red, green, blue, and alpha values (0.0 to 1.0).

     - Example:
     ```swift
     let color = Color.blue
     let (r, g, b, a) = color.rgbaComponents
     print("R: \(r), G: \(g), B: \(b), A: \(a)")
     ```

     - Note: Requires UIKit (iOS, tvOS, visionOS) or AppKit (macOS).
     */
    var rgbaComponents: (red: Double, green: Double, blue: Double, alpha: Double) {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b), Double(a))
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        guard let rgb = nsColor.usingColorSpace(.deviceRGB) else {
            return (0, 0, 0, 1)
        }
        return (Double(rgb.redComponent), Double(rgb.greenComponent), Double(rgb.blueComponent), Double(rgb.alphaComponent))
        #else
        return (0, 0, 0, 1)
        #endif
    }

    /**
     Returns the red component of the color.

     - Returns: The red value (0.0 to 1.0).

     - Example:
     ```swift
     let color = Color(red: 1.0, green: 0.5, blue: 0.2)
     let red = color.redComponent  // 1.0
     ```

     - Note: Requires UIKit (iOS, tvOS, visionOS) or AppKit (macOS).
     */
    var redComponent: Double {
        return rgbaComponents.red
    }

    /**
     Returns the green component of the color.

     - Returns: The green value (0.0 to 1.0).

     - Example:
     ```swift
     let color = Color(red: 1.0, green: 0.5, blue: 0.2)
     let green = color.greenComponent  // 0.5
     ```

     - Note: Requires UIKit (iOS, tvOS, visionOS) or AppKit (macOS).
     */
    var greenComponent: Double {
        return rgbaComponents.green
    }

    /**
     Returns the blue component of the color.

     - Returns: The blue value (0.0 to 1.0).

     - Example:
     ```swift
     let color = Color(red: 1.0, green: 0.5, blue: 0.2)
     let blue = color.blueComponent  // 0.2
     ```

     - Note: Requires UIKit (iOS, tvOS, visionOS) or AppKit (macOS).
     */
    var blueComponent: Double {
        return rgbaComponents.blue
    }
}

//MARK: Color Comparison
public extension Color {
    /**
     Indicates whether the color is perceived as light.

     Uses the relative luminance formula to determine if the color is light.
     Useful for determining if dark text should be used on this background.

     - Returns: `true` if the color is light, `false` otherwise.

     - Example:
     ```swift
     let background = Color(hexString: "#FFFFFF")
     if background.isLight {
         Text("Dark text").foregroundColor(.black)
     } else {
         Text("Light text").foregroundColor(.white)
     }
     ```

     - Note: Requires UIKit (iOS, tvOS, visionOS) or AppKit (macOS).
     */
    var isLight: Bool {
        let (r, g, b, _) = rgbaComponents
        let brightness = (r * 299 + g * 587 + b * 114) / 1000
        return brightness > 0.5
    }

    /**
     Indicates whether the color is perceived as dark.

     - Returns: `true` if the color is dark, `false` otherwise.

     - Example:
     ```swift
     let background = Color.primary
     if background.isDark {
         // Dark background, use light text
     }
     ```

     - Note: Requires UIKit (iOS, tvOS, visionOS) or AppKit (macOS).
     */
    var isDark: Bool {
        return !isLight
    }

    /**
     Calculates the WCAG contrast ratio between this color and another color.

     The contrast ratio ranges from 1:1 (no contrast) to 21:1 (maximum contrast).
     WCAG guidelines recommend:
     - 4.5:1 minimum for normal text (AA)
     - 7:1 minimum for normal text (AAA)
     - 3:1 minimum for large text (AA)

     - Parameter color: The color to compare with.

     - Returns: The contrast ratio as a `Double`.

     - Example:
     ```swift
     let background = Color.white
     let text = Color.black
     let ratio = text.contrastRatio(with: background)
     // 21.0 (maximum contrast)

     if ratio >= 4.5 {
         print("Meets WCAG AA standard for normal text")
     }
     ```

     - Note: Requires UIKit (iOS, tvOS, visionOS) or AppKit (macOS).
     */
    func contrastRatio(with color: Color) -> Double {
        let l1 = relativeLuminance
        let l2 = color.relativeLuminance

        let lighter = max(l1, l2)
        let darker = min(l1, l2)

        return (lighter + 0.05) / (darker + 0.05)
    }

    /**
     Calculates the relative luminance of the color according to WCAG standards.

     - Returns: The relative luminance value (0.0 to 1.0).
     */
    private var relativeLuminance: Double {
        let (r, g, b, _) = rgbaComponents

        func adjust(_ component: Double) -> Double {
            if component <= 0.03928 {
                return component / 12.92
            } else {
                return pow((component + 0.055) / 1.055, 2.4)
            }
        }

        let r2 = adjust(r)
        let g2 = adjust(g)
        let b2 = adjust(b)

        return 0.2126 * r2 + 0.7152 * g2 + 0.0722 * b2
    }
}
#endif
