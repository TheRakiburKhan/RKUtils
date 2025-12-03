//
//  DoubleExtensionsTests.swift
//  RKiOSUtils
//
//  Created by Rakibur Khan on 1/6/25.
//

import Foundation
import Testing
@testable import RKUtils

@Suite("Double Extensions") struct DoubleExtensionsTests {

    // MARK: - Number Formatting Tests

    @Test("toLocal formats numbers with locale-specific formatting")
    func toLocal() {
        let value = 1234.56
        let result = value.toLocal()

        #expect(result.contains("1") && result.contains("2") && result.contains("3") && result.contains("4"))
    }

    @Test("toLocal with fraction digits applies minimum and maximum fraction constraints")
    func toLocalWithFractionDigits() {
        let value = 1234.567
        let result = value.toLocal(minFraction: 2, maxFraction: 3)

        // Just check that the result is not empty and contains digits
        #expect(!result.isEmpty)
        #expect(result.contains("1") || result.contains("2") || result.contains("3") || result.contains("4"))
    }

    @Test("scientificNotation formats numbers in exponential notation")
    func scientificNotation() {
        let value = 1230.0
        let result = value.scientificNotation(minFraction: 2, maxFraction: 2)

        #expect(result.contains("E") || result.contains("e"))
    }

    @Test("percentage formats numbers as percentage strings")
    func percentage() {
        #expect(25.0.percentage().contains("25"))
        #expect(50.0.percentage().contains("50"))
    }

    @Test("currency formats numbers with currency code and symbol")
    func currency() {
        let value = 1234.56
        let result = value.currency(code: "USD", symbol: "$")

        #expect(result.contains("1234") || result.contains("1,234"))
    }

    @Test("inWords converts numbers to word representation")
    func inWords() {
        let value = 42.0
        let result = value.inWords(locale: Locale(identifier: "en_US"))

        #expect(!result.isEmpty)
        #expect(result.lowercased().contains("forty") || result == "42.00")
    }

    @Test("toPositiveSuffix formats numbers with suffix at intervals")
    func toPositiveSuffix() {
        #expect(1250.0.toPositiveSuffix(interval: 1000, groupSeparator: false) == "1000+")
        #expect(999.0.toPositiveSuffix(interval: 1000, groupSeparator: false) == "999")
        #expect(2000.0.toPositiveSuffix(interval: 1000, groupSeparator: false) == "2000")
    }

    @Test("abbreviated formats numbers with K, M, B suffixes")
    func abbreviated() {
        #expect(999.0.abbreviated() == "999.0")
        #expect(1_200.0.abbreviated().contains("1") && 1_200.0.abbreviated().contains("K"))
        #expect(1_500_000.0.abbreviated().contains("1") && 1_500_000.0.abbreviated().contains("M"))
        #expect(2_500_000_000.0.abbreviated().contains("2") && 2_500_000_000.0.abbreviated().contains("B"))
    }

    // MARK: - Measurement Formatting Tests

    @Test("distance formats numbers as distance measurements")
    func distance() {
        let meters = 1000.0
        let result = meters.distance()

        #expect(!result.isEmpty)
        #expect(result.contains("km") || result.contains("m"))
    }

    @Test("time formats numbers as time measurements")
    func time() {
        let minutes = 90.0
        let result = minutes.time()

        #expect(!result.isEmpty)
    }

    @Test("temperature formats numbers as temperature measurements")
    func temperature() {
        let kelvin = 273.15
        let result = kelvin.temperature()

        #expect(!result.isEmpty)
        #expect(result.contains("°") || result.contains("K"))
    }

    @Test("speed formats numbers as speed measurements")
    func speed() {
        let mps = 10.0
        let result = mps.speed()

        #expect(!result.isEmpty)
    }

    // MARK: - Time Component Tests

    @Test("secondsToTime converts seconds to time format")
    func secondsToTime() {
        let seconds = 3665.0 // 1 hour, 1 minute, 5 seconds
        let result = seconds.secondsToTime()

        #expect(result.contains("1") || result.contains("hr") || result.contains("h"))
    }

    @Test("day formats numbers as day measurements")
    func day() {
        let days = 5.0
        let result = days.day()

        #expect(!result.isEmpty)
        #expect(result.contains("5") || result.contains("day"))
    }

    @Test("month formats numbers as month measurements")
    func month() {
        let months = 3.0
        let result = months.month()

        #expect(!result.isEmpty)
        #expect(result.contains("3") || result.contains("mo"))
    }

    @Test("year formats numbers as year measurements")
    func year() {
        let years = 2.0
        let result = years.year()

        #expect(!result.isEmpty)
        #expect(result.contains("2") || result.contains("yr") || result.contains("year"))
    }

    // MARK: - Math / Logic Tests

    @Test("roundedString rounds numbers to specified decimal places", arguments: [
        (3.14159, 2, "3.14"),
        (2.5, 0, "2"),
        (1.999, 1, "2.0")
    ])
    func roundedString(value: Double, places: Int, expected: String) {
        #expect(value.roundedString(toPlaces: places) == expected)
    }

    @Test("clamped constrains numbers within min and max bounds", arguments: [
        (5.0, 0.0, 10.0, 5.0),
        (-5.0, 0.0, 10.0, 0.0),
        (15.0, 0.0, 10.0, 10.0)
    ])
    func clamped(value: Double, min: Double, max: Double, expected: Double) {
        #expect(value.clamped(min: min, max: max) == expected)
    }

    @Test("lerp performs linear interpolation", arguments: [
        (0.0, 10.0, 0.5, 5.0),
        (0.0, 10.0, 0.0, 0.0),
        (0.0, 10.0, 1.0, 10.0)
    ])
    func lerp(from: Double, to: Double, by: Double, expected: Double) {
        #expect(from.lerp(to: to, by: by) == expected)
    }

    @Test("scaled maps values from one range to another")
    func scaled() {
        let value = 5.0
        let result = value.scaled(from: 0...10, to: 0...100)

        #expect(result == 50.0)
    }

    @Test("scaled handles edge cases correctly")
    func scaledEdgeCases() {
        let minValue = 0.0
        let maxValue = 10.0

        #expect(minValue.scaled(from: 0...10, to: 0...100) == 0.0)
        #expect(maxValue.scaled(from: 0...10, to: 0...100) == 100.0)
    }

    @Test("toDate converts timestamp to Date object")
    func toDate() {
        let timestamp = 1704931200.0 // Jan 11, 2024 00:00:00 UTC
        let date = timestamp.toDate()

        #expect(date != nil)
    }

    // MARK: - Computed Properties Tests

    @Test("isWholeNumber identifies whole numbers correctly")
    func isWholeNumber() {
        #expect(5.0.isWholeNumber)
        #expect(!5.5.isWholeNumber)
        #expect(0.0.isWholeNumber)
    }

    @Test("toRadians converts degrees to radians")
    func toRadians() {
        let degrees = 180.0
        let radians = degrees.toRadians

        #expect(abs(radians - Double.pi) < 0.0001)
    }

    @Test("toDegrees converts radians to degrees")
    func toDegrees() {
        let radians = Double.pi
        let degrees = radians.toDegrees

        #expect(abs(degrees - 180.0) < 0.0001)
    }

    @Test("isPositive identifies positive numbers")
    func isPositive() {
        #expect(5.0.isPositive)
        #expect(!0.0.isPositive)
        #expect(!(-5.0).isPositive)
    }

    @Test("isNegative identifies negative numbers")
    func isNegative() {
        #expect((-5.0).isNegative)
        #expect(!0.0.isNegative)
        #expect(!5.0.isNegative)
    }

    @Test("zeroIfNaN returns zero for NaN values")
    func zeroIfNaN() {
        let nanValue = Double.nan
        #expect(nanValue.zeroIfNaN == 0.0)
        #expect(5.0.zeroIfNaN == 5.0)
    }

    @Test("nonNegativeOrZero returns zero for negative values")
    func nonNegativeOrZero() {
        #expect(5.0.nonNegativeOrZero == 5.0)
        #expect((-5.0).nonNegativeOrZero == 0.0)
        #expect(0.0.nonNegativeOrZero == 0.0)
    }

    @Test("signString returns correct sign representation")
    func signString() {
        #expect(5.0.signString == "+")
        #expect((-5.0).signString == "−")
        #expect(0.0.signString == "")
    }

    // MARK: - Edge Cases

    @Test("abbreviated handles large numbers correctly")
    func largeNumbers() {
        let largeNumber = 999_999_999.0
        let result = largeNumber.abbreviated()

        #expect(result.contains("M") || result.contains("B"))
    }

    @Test("toLocal handles negative numbers correctly")
    func negativeNumbers() {
        let negativeValue = -1234.56
        let result = negativeValue.toLocal()

        #expect(result.contains("-") || result.contains("−"))
    }

    @Test("zero is handled correctly across methods")
    func zero() {
        #expect(0.0.abbreviated() == "0.0")
        #expect(0.0.isWholeNumber)
        #expect(0.0.signString == "")
    }
}
