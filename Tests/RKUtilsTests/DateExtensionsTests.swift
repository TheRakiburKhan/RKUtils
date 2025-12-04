//
//  DateExtensionsTests.swift
//  RKiOSUtils
//
//  Created by Rakibur Khan on 1/6/25.
//

import Testing
import Foundation
@testable import RKUtils

@Suite("Date Extensions")
struct DateExtensionsTests {

    // MARK: - Readable String Tests

    @Test("Readable string with template")
    func readableStringWithTemplate() {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 15
        components.hour = 10
        components.minute = 30

        let date = calendar.date(from: components)!
        let result = date.readableString(localizedDateFormatFromTemplate: "MMMdy")

        #expect(!result.isEmpty)
        #expect(result.contains("15") || result.contains("Jan"))
    }

    @Test("Readable string with format")
    func readableStringWithFormat() {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 15

        let date = calendar.date(from: components)!
        let result = date.readableString(format: "dd/MM/yyyy")

        #expect(result == "15/01/2024")
    }

    // MARK: - toString Tests

    @Test("toString with default format")
    func toStringDefaultFormat() {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 15
        components.hour = 10
        components.minute = 30
        components.second = 45

        let date = calendar.date(from: components)!
        let result = date.toString()

        #expect(result.contains("2024-01-15"))
        #expect(result.contains("10:30:45"))
    }

    @Test("toString with custom format")
    func toStringCustomFormat() {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 3
        components.day = 25

        let date = calendar.date(from: components)!
        let result = date.toString(format: "dd-MM-yyyy")

        #expect(result == "25-03-2024")
    }

    // MARK: - Relative Time Tests
#if canImport(Darwin)
    @Test("Relative time in future")
    func relativeTimeFuture() {
        let now = Date()
        let futureDate = now.addingTimeInterval(3600) // 1 hour from now
        
        let result = futureDate.relativeTime(to: now)
        
        #expect(!result.isEmpty)
        #expect(result.contains("1") || result.lowercased().contains("hour"))
    }
    
    @Test("Relative time in past")
    func relativeTimePast() {
        let now = Date()
        let pastDate = now.addingTimeInterval(-7200) // 2 hours ago
        
        let result = pastDate.relativeTime(to: now)
        
        #expect(!result.isEmpty)
        #expect(result.contains("2") || result.lowercased().contains("hour"))
    }
#endif

    // MARK: - Distance Tests

    @Test("Distance in days")
    func distanceOfDays() {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1

        let startDate = calendar.date(from: components)!

        components.day = 15
        let endDate = calendar.date(from: components)!

        let distance = startDate.distanceOf(.day, till: endDate)

        #expect(distance == 14)
    }

    @Test("Distance from reference date")
    func distanceFromReferenceDate() {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1

        let startDate = calendar.date(from: components)!

        components.day = 15
        let endDate = calendar.date(from: components)!

        let distance = endDate.distanceOf(.day, from: startDate)

        #expect(distance == 14)
    }

    @Test("Distance in months")
    func distanceOfMonths() {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1

        let startDate = calendar.date(from: components)!

        components.month = 4
        let endDate = calendar.date(from: components)!

        let distance = startDate.distanceOf(.month, till: endDate)

        #expect(distance == 3)
    }

    // MARK: - Date After/Before Tests

    @Test("Date after adding days")
    func dateAfter() {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 15

        let date = calendar.date(from: components)!
        let futureDate = date.dateAfter(5, .day)

        #expect(futureDate != nil)

        let futureComponents = calendar.dateComponents([.day], from: futureDate!)
        #expect(futureComponents.day == 20)
    }

    @Test("Date before subtracting days")
    func dateBefore() {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 15

        let date = calendar.date(from: components)!
        let pastDate = date.dateBefore(5, .day)

        #expect(pastDate != nil)

        let pastComponents = calendar.dateComponents([.day], from: pastDate!)
        #expect(pastComponents.day == 10)
    }

    @Test("Date after adding months")
    func dateAfterMonths() {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 15

        let date = calendar.date(from: components)!
        let futureDate = date.dateAfter(3, .month)

        #expect(futureDate != nil)

        let futureComponents = calendar.dateComponents([.month], from: futureDate!)
        #expect(futureComponents.month == 4)
    }

    // MARK: - Dates of Current Week Tests

    @Test("Dates of current week")
    func datesOfCurrentWeek() {
        let date = Date()
        let calendar = Calendar.current

        let weekDates = date.datesOfCurrentWeek()

        #expect(weekDates.count == 7)

        // Verify all dates are in sequence
        for i in 1..<weekDates.count {
            let distance = calendar.dateComponents([.day], from: weekDates[i-1], to: weekDates[i])
            #expect(distance.day == 1)
        }
    }

    @Test("Dates of current week starting on Sunday")
    func datesOfCurrentWeekStartDay() {
        let date = Date()
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // Sunday

        let weekDates = date.datesOfCurrentWeek(using: calendar)

        #expect(weekDates.count == 7)

        let firstDayWeekday = calendar.component(.weekday, from: weekDates[0])
        #expect(firstDayWeekday == 1) // Sunday
    }

    // MARK: - Is In Today Tests

    @Test("Is in today check")
    func isInToday() {
        let now = Date()
        #expect(now.isInToday())

        let yesterday = now.addingTimeInterval(-86400)
        #expect(!yesterday.isInToday())

        let tomorrow = now.addingTimeInterval(86400)
        #expect(!tomorrow.isInToday())
    }

    // MARK: - Month Name Tests

    @Test("Month name extraction")
    func monthName() {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 15

        let date = calendar.date(from: components)!
        let monthName = date.monthName()

        #expect(monthName.lowercased().contains("jan") || monthName == "January")
    }

    @Test("Month names for different months", arguments: [
        (month: 1, expected: "January"),
        (month: 6, expected: "June"),
        (month: 12, expected: "December")
    ])
    func monthNameDifferentMonths(month: Int, expected: String) {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = month
        components.day = 1

        let date = calendar.date(from: components)!
        let monthName = date.monthName()

        #expect(monthName.contains(expected) || monthName.lowercased().hasPrefix(expected.lowercased().prefix(3)))
    }
}
