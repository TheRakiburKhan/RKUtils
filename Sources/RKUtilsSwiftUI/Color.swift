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
}
#endif
