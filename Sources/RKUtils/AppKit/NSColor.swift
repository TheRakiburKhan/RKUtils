//
//  NSColor.swift
//  RKUtils
//
//  Created by Rakibur Khan on 3/12/25.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public extension NSColor {
    /**
     Creates an `NSColor` from a hex color string.

     Supports hex strings with or without the `#` prefix. Parses 6-character hex values (RRGGBB).

     - Parameters:
        - hexString: The hex color string (e.g., `"#FF5733"` or `"FF5733"`)
        - alpha: The opacity value (default: `1.0`)

     - Returns: An `NSColor` initialized with the hex color and alpha.

     - Example:
     ```swift
     let color1 = NSColor(hexString: "#FF5733")
     let color2 = NSColor(hexString: "FF5733")
     let color3 = NSColor(hexString: "#FF5733", alpha: 0.8)
     ```
     */
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
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
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }

    /**
     Converts the color to a hexadecimal string representation.

     Returns a 6-character hex string with `#` prefix (e.g., `"#FF5733"`).

     - Returns: A hex string representation of the color.

     - Example:
     ```swift
     let color = NSColor(red: 1.0, green: 0.34, blue: 0.2, alpha: 1.0)
     let hex = color.toHexString()
     // "#FF5733"
     ```
     */
    func toHexString() -> String {
        guard let rgbColor = usingColorSpace(.deviceRGB) else {
            return "#000000"
        }

        let r = Int(rgbColor.redComponent * 255)
        let g = Int(rgbColor.greenComponent * 255)
        let b = Int(rgbColor.blueComponent * 255)
        let rgb = r << 16 | g << 8 | b

        return String(format: "#%06X", rgb)
    }
}

//MARK: Color Manipulation
public extension NSColor {
    /**
     Returns a new color with the specified brightness.

     - Parameter brightness: The brightness value (0.0 to 1.0).

     - Returns: A new `NSColor` with the specified brightness.

     - Example:
     ```swift
     let color = NSColor.systemBlue
     let darker = color.withBrightness(0.3)
     let brighter = color.withBrightness(0.9)
     ```
     */
    func withBrightness(_ brightness: CGFloat) -> NSColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var oldBrightness: CGFloat = 0
        var alpha: CGFloat = 0

        getHue(&hue, saturation: &saturation, brightness: &oldBrightness, alpha: &alpha)
        return NSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    /**
     Returns a lighter version of the color.

     - Parameter percentage: The percentage to lighten (0.0 to 1.0). For example, `0.2` means 20% lighter.

     - Returns: A lighter `NSColor`.

     - Example:
     ```swift
     let baseColor = NSColor.systemBlue
     let lighterColor = baseColor.lighter(by: 0.2)
     ```
     */
    func lighter(by percentage: CGFloat) -> NSColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let newBrightness = min(brightness + percentage, 1.0)
        return NSColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
    }

    /**
     Returns a darker version of the color.

     - Parameter percentage: The percentage to darken (0.0 to 1.0). For example, `0.2` means 20% darker.

     - Returns: A darker `NSColor`.

     - Example:
     ```swift
     let baseColor = NSColor.systemBlue
     let darkerColor = baseColor.darker(by: 0.2)
     ```
     */
    func darker(by percentage: CGFloat) -> NSColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let newBrightness = max(brightness - percentage, 0.0)
        return NSColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
    }
}

//MARK: Random Colors
public extension NSColor {
    /**
     Generates a random color with full opacity.

     - Returns: A random `NSColor`.

     - Example:
     ```swift
     let randomColor = NSColor.random
     view.layer?.backgroundColor = randomColor.cgColor
     ```
     */
    static var random: NSColor {
        return NSColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }

    /**
     Generates a random pastel color (soft, low saturation).

     Pastel colors have lower saturation and higher brightness for a softer appearance.

     - Returns: A random pastel `NSColor`.

     - Example:
     ```swift
     let pastelColor = NSColor.randomPastel
     avatarView.layer?.backgroundColor = pastelColor.cgColor
     ```
     */
    static var randomPastel: NSColor {
        return NSColor(
            hue: .random(in: 0...1),
            saturation: .random(in: 0.2...0.4),
            brightness: .random(in: 0.8...1.0),
            alpha: 1.0
        )
    }
}

//MARK: Color Components
public extension NSColor {
    /**
     Returns all RGBA components as a tuple.

     - Returns: A tuple containing red, green, blue, and alpha values (0.0 to 1.0).

     - Example:
     ```swift
     let color = NSColor.systemBlue
     let (r, g, b, a) = color.rgbaComponents
     print("R: \(r), G: \(g), B: \(b), A: \(a)")
     ```
     */
    var rgbaComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        guard let rgbColor = usingColorSpace(.deviceRGB) else {
            return (0, 0, 0, 1)
        }
        return (rgbColor.redComponent, rgbColor.greenComponent, rgbColor.blueComponent, rgbColor.alphaComponent)
    }

    /**
     Returns the red component of the color.

     - Returns: The red value (0.0 to 1.0).

     - Example:
     ```swift
     let color = NSColor(red: 1.0, green: 0.5, blue: 0.2, alpha: 1.0)
     let red = color.redComponent  // 1.0
     ```
     */
    var redComponent: CGFloat {
        guard let rgbColor = usingColorSpace(.deviceRGB) else {
            return 0
        }
        return rgbColor.redComponent
    }

    /**
     Returns the green component of the color.

     - Returns: The green value (0.0 to 1.0).

     - Example:
     ```swift
     let color = NSColor(red: 1.0, green: 0.5, blue: 0.2, alpha: 1.0)
     let green = color.greenComponent  // 0.5
     ```
     */
    var greenComponent: CGFloat {
        guard let rgbColor = usingColorSpace(.deviceRGB) else {
            return 0
        }
        return rgbColor.greenComponent
    }

    /**
     Returns the blue component of the color.

     - Returns: The blue value (0.0 to 1.0).

     - Example:
     ```swift
     let color = NSColor(red: 1.0, green: 0.5, blue: 0.2, alpha: 1.0)
     let blue = color.blueComponent  // 0.2
     ```
     */
    var blueComponent: CGFloat {
        guard let rgbColor = usingColorSpace(.deviceRGB) else {
            return 0
        }
        return rgbColor.blueComponent
    }
}

//MARK: Color Comparison
public extension NSColor {
    /**
     Indicates whether the color is perceived as light.

     Uses the relative luminance formula to determine if the color is light.
     Useful for determining if dark text should be used on this background.

     - Returns: `true` if the color is light, `false` otherwise.

     - Example:
     ```swift
     let background = NSColor(hexString: "#FFFFFF")
     if background.isLight {
         label.textColor = .black
     } else {
         label.textColor = .white
     }
     ```
     */
    var isLight: Bool {
        guard let rgbColor = usingColorSpace(.deviceRGB) else {
            return false
        }

        let r = rgbColor.redComponent
        let g = rgbColor.greenComponent
        let b = rgbColor.blueComponent

        // Calculate perceived brightness using luminance formula
        let brightness = (r * 299 + g * 587 + b * 114) / 1000
        return brightness > 0.5
    }

    /**
     Indicates whether the color is perceived as dark.

     - Returns: `true` if the color is dark, `false` otherwise.

     - Example:
     ```swift
     let background = NSColor.windowBackgroundColor
     if background.isDark {
         // Dark background, use light text
     }
     ```
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

     - Returns: The contrast ratio as a `CGFloat`.

     - Example:
     ```swift
     let background = NSColor.white
     let text = NSColor.black
     let ratio = text.contrastRatio(with: background)
     // 21.0 (maximum contrast)

     if ratio >= 4.5 {
         print("Meets WCAG AA standard for normal text")
     }
     ```
     */
    func contrastRatio(with color: NSColor) -> CGFloat {
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
    private var relativeLuminance: CGFloat {
        guard let rgbColor = usingColorSpace(.deviceRGB) else {
            return 0
        }

        let r = rgbColor.redComponent
        let g = rgbColor.greenComponent
        let b = rgbColor.blueComponent

        func adjust(_ component: CGFloat) -> CGFloat {
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
