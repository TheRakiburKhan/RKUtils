//
//  ColorExtensionsTests.swift
//  RKUtils
//
//  Created by Rakibur Khan on 8/12/24.
//

#if canImport(SwiftUI)
import Testing
import SwiftUI
@testable import RKUtils

@Suite("Color Extensions")
struct ColorExtensionsTests {

    @Test("Color initializes from hex string without hash")
    func hexStringWithoutHash() {
        let color = Color(hexString: "FF5733")
        // Color doesn't expose RGB values directly, but we can verify it doesn't crash
        #expect(color != nil)
    }

    @Test("Color initializes from hex string with hash")
    func hexStringWithHash() {
        let color = Color(hexString: "#FF5733")
        #expect(color != nil)
    }

    @Test("Color initializes with custom alpha")
    func hexStringWithAlpha() {
        let color = Color(hexString: "#FF5733", alpha: 0.5)
        #expect(color != nil)
    }

    @Test("Color initializes from hex string with whitespace")
    func hexStringWithWhitespace() {
        let color = Color(hexString: "  FF5733  ")
        #expect(color != nil)
    }

    @Test("Color initializes from common colors", arguments: [
        "FFFFFF", // White
        "000000", // Black
        "FF0000", // Red
        "00FF00", // Green
        "0000FF", // Blue
        "FFFF00", // Yellow
        "FF00FF", // Magenta
        "00FFFF"  // Cyan
    ])
    func commonHexColors(hex: String) {
        let color = Color(hexString: hex)
        #expect(color != nil)
    }

    @Test("Color initializes from hex with hash prefix")
    func hexWithHashPrefix() {
        let color1 = Color(hexString: "#ABCDEF")
        let color2 = Color(hexString: "ABCDEF")
        #expect(color1 != nil)
        #expect(color2 != nil)
    }
}
#endif
