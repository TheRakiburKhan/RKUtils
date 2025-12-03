//
//  NSColorExtensionsTests.swift
//  RKUtils
//
//  Created by Rakibur Khan on 3/12/25.
//

import Testing
import Foundation
@testable import RKUtils
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
@testable import RKUtilsMacOSUI

@Suite("NSColor Extensions")
struct NSColorExtensionsTests {

    @Test("Hex string initialization with hash", arguments: [
        ("#FF5733", 255, 87, 51),
        ("#00FF00", 0, 255, 0),
        ("#0000FF", 0, 0, 255),
        ("#FFFFFF", 255, 255, 255),
        ("#000000", 0, 0, 0)
    ])
    func hexStringWithHash(hex: String, expectedRed: Int, expectedGreen: Int, expectedBlue: Int) {
        let color = NSColor(hexString: hex)

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        #expect(Int(red * 255) == expectedRed)
        #expect(Int(green * 255) == expectedGreen)
        #expect(Int(blue * 255) == expectedBlue)
        #expect(alpha == 1.0)
    }

    @Test("Hex string initialization without hash")
    func hexStringWithoutHash() {
        let color = NSColor(hexString: "FF5733")

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        #expect(Int(red * 255) == 255)
        #expect(Int(green * 255) == 87)
        #expect(Int(blue * 255) == 51)
    }

    @Test("Hex string with custom alpha")
    func hexStringWithAlpha() {
        let color = NSColor(hexString: "#FF5733", alpha: 0.5)

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        #expect(alpha == 0.5)
    }

    @Test("Hex string with whitespace")
    func hexStringWithWhitespace() {
        let color = NSColor(hexString: "  #FF5733  ")

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        #expect(Int(red * 255) == 255)
        #expect(Int(green * 255) == 87)
        #expect(Int(blue * 255) == 51)
    }
}
#endif
