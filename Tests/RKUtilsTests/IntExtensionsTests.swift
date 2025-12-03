//
//  IntExtensionsTests.swift
//  RKiOSUtils
//
//  Created by Rakibur Khan on 1/6/25.
//

import Foundation
import Testing
@testable import RKUtils

@Suite("Int Extensions") struct IntExtensionsTests {

    @Test("toLocal formats integers with locale-specific formatting", arguments: [
        (1234, "en_US", "1,234"),
        (1234, "fr_FR", "1 234")
    ])
    func toLocal(value: Int, localeIdentifier: String, expected: String) {
        #expect(value.toLocal(locale: Locale(identifier: localeIdentifier)) == expected)
    }

    // MARK: - Locale Tests for toLocal()

    @Test("toLocal with different locales produces localized output")
    func toLocalWithDifferentLocales() {
        let value = 1234567

        let enUS = Locale(identifier: "en_US")
        let arSA = Locale(identifier: "ar_SA")
        let hiIN = Locale(identifier: "hi_IN")
        let bnBD = Locale(identifier: "bn_BD")

        let enResult = value.toLocal(locale: enUS)
        let arResult = value.toLocal(locale: arSA)
        let hiResult = value.toLocal(locale: hiIN)
        let bnResult = value.toLocal(locale: bnBD)

        #expect(enResult == "1,234,567") // English (US)
        #expect(arResult != enResult) // Should be localized digits/separators
        #expect(hiResult != enResult) // Hindi numerals/local formatting
        #expect(bnResult != enResult) // Bengali numerals/local formatting
    }

    @Test("toPositiveSuffix formats numbers with suffix at intervals")
    func toPositiveSuffix() {
        #expect(109.intervalDescription(interval: 10, suffix: "+", groupSeparator: false) == "100+")
        #expect(120.intervalDescription(interval: 10, suffix: "+", groupSeparator: false) == "120")
        #expect(9999.intervalDescription(interval: 1000, suffix: "+", groupSeparator: true) == "9,000+")
    }

    @Test("digitNames converts digits to their word representations")
    func digitNames() {
        let digits = 123.digitNames(locale: Locale(identifier: "en_US"))
        #expect(digits == ["one", "two", "three"])
    }

    // MARK: - digitNames() Locale Tests

    @Test("digitNames with different locales produces localized digit names")
    func digitNamesWithLocales() {
        let value = 123

        let expectedEN = ["one", "two", "three"]
        let expectedHI = ["एक", "दो", "तीन"] // Hindi
        let expectedAR = ["واحد", "اثنان", "ثلاثة"] // Arabic

        let en = Locale(identifier: "en_US")
        let hi = Locale(identifier: "hi_IN")
        let ar = Locale(identifier: "ar_SA")

        #expect(value.digitNames(locale: en) == expectedEN)

        // Check if Hindi spellings match any of expected
        let hiNames = value.digitNames(locale: hi)
        #expect(hiNames.first == expectedHI.first) // Basic validation

        let arNames = value.digitNames(locale: ar)
        #expect(arNames.first == expectedAR.first)
    }

    @Test("inWords converts numbers to word representation")
    func inWords() {
        #expect(123.inWords(locale: Locale(identifier: "en_US")) == "one hundred twenty-three")
    }

    @Test("byteSizeFormatted formats byte sizes with appropriate units")
    func byteSizeFormatted() {
        #expect(1024.byteSizeFormatted().contains("KB"))
        #expect(1048576.byteSizeFormatted().contains("MB"))
    }

    @Test("times executes closure specified number of times")
    func times() {
        var counter = 0
        5.times { i in
            counter += i
        }
        #expect(counter == 0 + 1 + 2 + 3 + 4)
    }

    @Test("clamped constrains numbers within range", arguments: [
        (5, 1...10, 5),
        (0, 1...10, 1),
        (15, 1...10, 10)
    ])
    func clamped(value: Int, range: ClosedRange<Int>, expected: Int) {
        #expect(value.clamped(to: range) == expected)
    }

    @Test("pluralized formats numbers with singular or plural nouns", arguments: [
        (1, "apple", nil, "1 apple"),
        (2, "apple", nil, "2 apples"),
        (2, "child", "children", "2 children")
    ])
    func pluralized(count: Int, singular: String, plural: String?, expected: String) {
        if let plural = plural {
            #expect(count.pluralized(singular, plural) == expected)
        } else {
            #expect(count.pluralized(singular) == expected)
        }
    }

    @Test("abbreviated formats numbers with K, M, B suffixes", arguments: [
        (999, "999"),
        (1_200, "1.2K"),
        (2_500_000, "2.5M"),
        (3_200_000_000, "3.2B")
    ])
    func abbreviated(value: Int, expected: String) {
        #expect(value.abbreviated() == expected)
    }

    @Test("secondsToMinutesSeconds converts seconds to minutes and seconds")
    func secondsToMinutesSeconds() {
        let result = 125.secondsToMinutesSeconds
        #expect(result.minutes == 2)
        #expect(result.seconds == 5)
    }

    @Test("timeString formats seconds as MM:SS", arguments: [
        (125, "02:05"),
        (65, "01:05")
    ])
    func timeString(seconds: Int, expected: String) {
        #expect(seconds.timeString == expected)
    }

    @Test("inWords property uses current locale")
    func inWordsProperty() {
        #expect(42.inWords == 42.inWords(locale: .current))
    }

    @Test("isEven identifies even numbers")
    func isEven() {
        #expect(2.isEven)
        #expect(!3.isEven)
    }

    @Test("isOdd identifies odd numbers")
    func isOdd() {
        #expect(3.isOdd)
        #expect(!2.isOdd)
    }

    @Test("isPositive identifies positive numbers")
    func isPositive() {
        #expect(5.isPositive)
        #expect(!(-3).isPositive)
    }

    @Test("isNegative identifies negative numbers")
    func isNegative() {
        #expect((-5).isNegative)
        #expect(!0.isNegative)
    }
}
