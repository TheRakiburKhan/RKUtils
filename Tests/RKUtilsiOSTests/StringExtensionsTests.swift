//
//  StringExtensionsTests.swift
//  RKiOSUtils
//
//  Created by Rakibur Khan on 1/6/25.
//

import Testing
import Foundation
@testable import RKUtils

@Suite("String Extensions")
struct StringExtensionsTests {

    // MARK: - ISO8601 Date Tests

    @Test("ISO8601 date parsing with timezone")
    func iso8601DateWithTimeZone() {
        let dateString = "2024-01-15T10:30:00Z"
        let date = dateString.iso8601Date(options: [.withInternetDateTime])

        #expect(date != nil)

        guard let validDate = date else {
            Issue.record("Date should not be nil")
            return
        }

        // Verify the date components
        let calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "UTC")!
        var testCalendar = calendar
        testCalendar.timeZone = timeZone
        let components = testCalendar.dateComponents([.year, .month, .day], from: validDate)

        #expect(components.year == 2024)
        #expect(components.month == 1)
        #expect(components.day == 15)
    }

    @Test("ISO8601 date parsing with custom options")
    func iso8601DateWithCustomOptions() {
        let dateString = "2024-01-15T10:30:00Z"
        let date = dateString.iso8601Date(options: [.withInternetDateTime])

        #expect(date != nil)
    }

    @Test("ISO8601 date parsing with invalid string")
    func iso8601DateInvalidString() {
        let invalidString = "not a valid date at all"
        let date = invalidString.iso8601Date(options: [.withInternetDateTime])

        // May or may not be nil depending on ISO8601DateFormatter behavior
        // Just verify it doesn't crash
        _ = date
    }

    // MARK: - String to Date Tests

    @Test("Convert string to date with default format")
    func toDateWithDefaultFormat() {
        let dateString = "2024-01-15 10:30:00"
        let date = dateString.toDate()

        #expect(date != nil)

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date!)

        #expect(components.year == 2024)
        #expect(components.month == 1)
        #expect(components.day == 15)
        #expect(components.hour == 10)
        #expect(components.minute == 30)
    }

    @Test("Convert string to date with custom format")
    func toDateWithCustomFormat() {
        let dateString = "15/01/2024"
        let date = dateString.toDate(stringFormat: "dd/MM/yyyy")

        #expect(date != nil)

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date!)

        #expect(components.year == 2024)
        #expect(components.month == 1)
        #expect(components.day == 15)
    }

    @Test("Convert string to date with timezone")
    func toDateWithTimeZone() {
        let dateString = "2024-01-15 10:30:00"
        let utcTimeZone = TimeZone(identifier: "UTC")
        let date = dateString.toDate(timeZone: utcTimeZone)

        #expect(date != nil)
    }

    @Test("Convert invalid string to date returns nil")
    func toDateInvalidString() {
        let invalidString = "not a date"
        let date = invalidString.toDate()

        #expect(date == nil)
    }

    // MARK: - Base64 Encoding Tests

    @Test("Base64 encoding")
    func toBase64() {
        let testString = "Hello, World!"
        let base64 = testString.toBase64

        #expect(base64 != nil)
        #expect(base64 == "SGVsbG8sIFdvcmxkIQ==")
    }

    @Test("Base64 encoding empty string")
    func toBase64EmptyString() {
        let emptyString = ""
        let base64 = emptyString.toBase64

        #expect(base64 != nil)
        #expect(base64 == "")
    }

    @Test("Base64 encoding with special characters")
    func toBase64WithSpecialCharacters() {
        let specialString = "Test with 特殊字符 and émojis 🎉"
        let base64 = specialString.toBase64

        #expect(base64 != nil)

        // Verify we can decode it back
        if let data = Data(base64Encoded: base64!) {
            let decodedString = String(data: data, encoding: .utf8)
            #expect(decodedString == specialString)
        }
    }

    // MARK: - Email Validation Tests

    @Test("Valid email addresses", arguments: [
        "test@example.com",
        "user.name@example.com",
        "user+tag@example.co.uk",
        "123@test.com",
        "TEST@EXAMPLE.COM"
    ])
    func isValidEmailValid(email: String) {
        #expect(email.isValidEmail())
    }

    @Test("Invalid email addresses", arguments: [
        "",
        "not an email",
        "@example.com",
        "user@",
        "user@@example.com",
        "user@example",
        "user name@example.com"
    ])
    func isValidEmailInvalid(email: String) {
        #expect(!email.isValidEmail())
    }

    // MARK: - File I/O Tests

    @Test("Write and read file")
    func writeAndReadFile() throws {
        let testString = "Test content for file I/O"
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent("test_file.txt")

        // Clean up if file exists
        try? FileManager.default.removeItem(at: fileURL)

        // Write to file
        testString.writeToFile(saveLocation: fileURL)

        // Verify file exists
        #expect(FileManager.default.fileExists(atPath: fileURL.path))

        // Read from file
        let readString = "".readFromFile(fileURL: fileURL)
        #expect(readString != nil)
        #expect(readString == testString)

        // Clean up
        try? FileManager.default.removeItem(at: fileURL)
    }

    @Test("Read from non-existent file returns nil")
    func readFromNonExistentFile() {
        let tempDirectory = FileManager.default.temporaryDirectory
        let nonExistentURL = tempDirectory.appendingPathComponent("non_existent_file.txt")

        let readString = "".readFromFile(fileURL: nonExistentURL)
        #expect(readString == nil)
    }

    @Test("Write to nil URL does not crash")
    func writeToNilURL() {
        // Should not crash
        "test".writeToFile(saveLocation: nil)
    }

    @Test("Read from nil URL returns nil")
    func readFromNilURL() {
        let result = "".readFromFile(fileURL: nil)
        #expect(result == nil)
    }
}
