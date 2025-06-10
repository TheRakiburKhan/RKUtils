//
//  IntExtensionsTests.swift
//  RKiOSUtils
//
//  Created by Rakibur Khan on 1/6/25.
//


import XCTest
@testable import RKUtils

final class IntExtensionsTests: XCTestCase {

    func testToLocal() {
        XCTAssertEqual(1234.toLocal(locale: Locale(identifier: "en_US")), "1,234")
        XCTAssertEqual(1234.toLocal(locale: Locale(identifier: "fr_FR")), "1 234")
    }
    
    // MARK: - Locale Tests for toLocal()
    
    func testToLocalWithDifferentLocales() {
        let value = 1234567
        
        let enUS = Locale(identifier: "en_US")
        let arSA = Locale(identifier: "ar_SA")
        let hiIN = Locale(identifier: "hi_IN")
        let bnBD = Locale(identifier: "bn_BD")
        
        let enResult = value.toLocal(locale: enUS)
        let arResult = value.toLocal(locale: arSA)
        let hiResult = value.toLocal(locale: hiIN)
        let bnResult = value.toLocal(locale: bnBD)
        
        XCTAssertEqual(enResult, "1,234,567") // English (US)
        XCTAssertNotEqual(arResult, enResult) // Should be localized digits/separators
        XCTAssertNotEqual(hiResult, enResult) // Hindi numerals/local formatting
        XCTAssertNotEqual(bnResult, enResult) // Bengali numerals/local formatting
    }
    
    func testToPositiveSuffix() {
        XCTAssertEqual(109.toPositiveSuffix(interval: 10, suffix: "+", groupSeparator: false), "100+")
        XCTAssertEqual(120.toPositiveSuffix(interval: 10, suffix: "+", groupSeparator: false), "120")
        XCTAssertEqual(9999.toPositiveSuffix(interval: 1000, suffix: "+", groupSeparator: true), "9,000+")
    }

    func testDigitNames() {
        let digits = 123.digitNames(locale: Locale(identifier: "en_US"))
        XCTAssertEqual(digits, ["one", "two", "three"])
    }
    
    // MARK: - digitNames() Locale Tests
    
    func testDigitNamesWithLocales() {
        let value = 123
        
        let expectedEN = ["one", "two", "three"]
        let expectedHI = ["एक", "दो", "तीन"] // Hindi
        let expectedAR = ["واحد", "اثنان", "ثلاثة"] // Arabic
        
        let en = Locale(identifier: "en_US")
        let hi = Locale(identifier: "hi_IN")
        let ar = Locale(identifier: "ar_SA")
        
        XCTAssertEqual(value.digitNames(locale: en), expectedEN)
        
        // Check if Hindi spellings match any of expected
        let hiNames = value.digitNames(locale: hi)
        XCTAssertEqual(hiNames.first, expectedHI.first) // Basic validation
        
        let arNames = value.digitNames(locale: ar)
        XCTAssertEqual(arNames.first, expectedAR.first)
    }

    func testInWords() {
        XCTAssertEqual(123.inWords(locale: Locale(identifier: "en_US")), "one hundred twenty-three")
    }
    
    func testByteSizeFormatted() {
        XCTAssertTrue(1024.byteSizeFormatted().contains("KB"))
        XCTAssertTrue(1048576.byteSizeFormatted().contains("MB"))
    }
    
    func testTimes() {
        var counter = 0
        5.times { i in
            counter += i
        }
        XCTAssertEqual(counter, 0 + 1 + 2 + 3 + 4)
    }
    
    func testClamped() {
        XCTAssertEqual(5.clamped(to: 1...10), 5)
        XCTAssertEqual(0.clamped(to: 1...10), 1)
        XCTAssertEqual(15.clamped(to: 1...10), 10)
    }
    
    func testPluralized() {
        XCTAssertEqual(1.pluralized("apple"), "1 apple")
        XCTAssertEqual(2.pluralized("apple"), "2 apples")
        XCTAssertEqual(2.pluralized("child", "children"), "2 children")
    }
    
    func testAbbreviated() {
        XCTAssertEqual(999.abbreviated(), "999")
        XCTAssertEqual(1_200.abbreviated(), "1.2K")
        XCTAssertEqual(2_500_000.abbreviated(), "2.5M")
        XCTAssertEqual(3_200_000_000.abbreviated(), "3.2B")
    }
    
    func testSecondsToMinutesSeconds() {
        let result = 125.secondsToMinutesSeconds
        XCTAssertEqual(result.minutes, 2)
        XCTAssertEqual(result.seconds, 5)
    }
    
    func testTimeString() {
        XCTAssertEqual(125.timeString, "02:05")
        XCTAssertEqual(65.timeString, "01:05")
    }

    func testInWordsProperty() {
        XCTAssertEqual(42.inWords, 42.inWords(locale: .current))
    }

    func testIsEven() {
        XCTAssertTrue(2.isEven)
        XCTAssertFalse(3.isEven)
    }

    func testIsOdd() {
        XCTAssertTrue(3.isOdd)
        XCTAssertFalse(2.isOdd)
    }

    func testIsPositive() {
        XCTAssertTrue(5.isPositive)
        XCTAssertFalse((-3).isPositive)
    }

    func testIsNegative() {
        XCTAssertTrue((-5).isNegative)
        XCTAssertFalse(0.isNegative)
    }
}
