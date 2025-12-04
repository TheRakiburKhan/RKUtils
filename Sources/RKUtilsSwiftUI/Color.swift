//
//  Color.swift
//  RKiOSUtils
//
//  Created by Rakibur Khan on 26/5/25.
//

#if canImport(SwiftUI)
import SwiftUI

public extension Color {
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
