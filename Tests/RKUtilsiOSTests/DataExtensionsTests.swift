//
//  DataExtensionsTests.swift
//  RKiOSUtils
//
//  Created by Rakibur Khan on 1/6/25.
//

import Testing
import Foundation
@testable import RKUtils

@Suite("Data Extensions")
struct DataExtensionsTests {

    @Test("Append string to data")
    func appendString() {
        var data = Data()
        let testString = "Hello, World!"

        data.append(testString)

        let resultString = String(data: data, encoding: .utf8)
        #expect(resultString == testString)
    }

    @Test("Append multiple strings")
    func appendMultipleStrings() {
        var data = Data()

        data.append("Hello, ")
        data.append("World!")

        let resultString = String(data: data, encoding: .utf8)
        #expect(resultString == "Hello, World!")
    }

    @Test("Append empty string")
    func appendEmptyString() {
        var data = Data()
        let initialCount = data.count

        data.append("")

        #expect(data.count == initialCount)
    }

    @Test("Append string with special characters")
    func appendStringWithSpecialCharacters() {
        var data = Data()
        let specialString = "Test with émojis 🎉 and special chars: \n\t"

        data.append(specialString)

        let resultString = String(data: data, encoding: .utf8)
        #expect(resultString == specialString)
    }

    @Test("Append string to existing data")
    func appendStringToExistingData() {
        var data = Data([0x48, 0x65, 0x6C, 0x6C, 0x6F]) // "Hello" in ASCII
        let appendString = ", World!"

        data.append(appendString)

        let resultString = String(data: data, encoding: .utf8)
        #expect(resultString == "Hello, World!")
    }

    @Test("Append Unicode string")
    func appendUnicodeString() {
        var data = Data()
        let unicodeString = "مرحبا العالم" // Arabic: Hello World

        data.append(unicodeString)

        let resultString = String(data: data, encoding: .utf8)
        #expect(resultString == unicodeString)
    }
}
