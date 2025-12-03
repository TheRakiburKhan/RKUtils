//
//  Date.swift
//  RKUtils
//
//
//  Created by Rakibur Khan on 2/4/24.
//

import Foundation

public extension Date {
    /**
    Converts the date to a human-readable string using a localized template.
     
     - Parameters:
        - calendar: The calendar to be used. Defaults to be .autoupdatingCurrent
        - timeZone: The time zone to use. Defaults to the current time zone.
        - locale: The locale to use. Defaults to the current locale.
        - localizedDateFormatFromTemplate: The localized template to use (e.g. "MMMdy").
     
     - Returns: A formatted date string.
     */
    func readableString(calendar: Calendar? = .autoupdatingCurrent, timeZone: TimeZone = .autoupdatingCurrent, locale: Locale = .autoupdatingCurrent, localizedDateFormatFromTemplate: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = locale
        formatter.calendar = calendar
        formatter.setLocalizedDateFormatFromTemplate(localizedDateFormatFromTemplate)
        
        return formatter.string(from: self)
    }
    
    /**
    Converts the date to a human-readable string using a custom date format.
     
     - Parameters:
        - timeZone: The time zone to use. Defaults to the current time zone.
        - locale: The locale to use. Defaults to the current locale.
        - format: The custom format string (e.g. "dd-MM-yyyy HH:mm").
     
     - Returns: A formatted date string.
     */
    func readableString(calendar: Calendar = .autoupdatingCurrent, timeZone: TimeZone = .autoupdatingCurrent, locale: Locale = .autoupdatingCurrent, format: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = locale
        formatter.calendar = calendar
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    /**
    Formats the date to a string using a default or custom format.
     
     - Parameters:
        - format: The format string. Defaults to `"yyyy-MM-dd HH:mm:ss"`.
        - timeZone: Optional time zone to apply.
     
     - Returns: The formatted date string.
     */
    func toString(format: String = "yyyy-MM-dd HH:mm:ss", calendar: Calendar? = nil, timeZone: TimeZone? = nil) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        if let timeZone = timeZone {
            formatter.timeZone = timeZone
        }
        
        if let calendar = calendar {
            formatter.calendar = calendar
        }
        
        return formatter.string(from: self)
    }
    
    /**
     Returns a human-readable relative time string (e.g. "2d ago", "in 3h").
     
     - Parameters:
        - referanceDate: The reference date to compare to. Defaults to now.
        - context: The formatting context (e.g. `.listItem`, `.standalone`).
        - style: The date-time style (e.g. `.numeric`, `.named`).
        - unitStyle: The style of the units (e.g. `.abbreviated`, `.full`).
     
     - Returns: A localized relative time string.
     */
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func relativeTime(to referanceDate: Date = Date(), context: Formatter.Context = .listItem, style: RelativeDateTimeFormatter.DateTimeStyle = .numeric, unitStyle: RelativeDateTimeFormatter.UnitsStyle = .abbreviated, calendar: Calendar? = nil) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.formattingContext = context
        formatter.dateTimeStyle = style
        formatter.unitsStyle = unitStyle
        
        if let calendar = calendar {
            formatter.calendar = calendar
        }
        
        return formatter.localizedString(for: self, relativeTo: referanceDate)
    }
    
    /**
     Returns the distance between `self` and `referanceDate` in the specified calendar component.
     
     - Parameters:
        - unit: The calendar component to measure.
        - referanceDate: The date to count toward.
     
     - Returns: The difference in the specified unit.
     */
    func distanceOf(_ unit: Calendar.Component, till referanceDate: Date, calendar: Calendar = .autoupdatingCurrent) -> Int {
        let components = calendar.dateComponents([unit], from: self, to: referanceDate)
        
        return components.value(for: unit) ?? 0
    }
    
    /**
     Returns the distance between `referanceDate` and `self` in the specified calendar component.
     
     - Parameters:
        - unit: The calendar component to measure.
        - referanceDate: The date to count from.
     
     - Returns: The difference in the specified unit.
     */
     func distanceOf(_ unit: Calendar.Component, from referanceDate: Date, calendar: Calendar = .autoupdatingCurrent) -> Int {
        let components = calendar.dateComponents([unit], from: referanceDate, to: self)
        
        return components.value(for: unit) ?? 0
    }
    
    /**
     Returns a date after adding a specified value and calendar component to `self`.
     
     - Parameters:
        - count: The amount to add.
        - unit: The calendar component to add.
     
     - Returns: The resulting future date.
     */
    func dateAfter(_ count: Int, _ unit: Calendar.Component, calendar: Calendar = .autoupdatingCurrent, timeZone: TimeZone = .autoupdatingCurrent) -> Date? {
        var calendar = calendar
        calendar.timeZone = timeZone
        
        return calendar.date(byAdding: unit, value: count, to: self)
    }
    
    /**
     Returns a date before subtracting a specified value and calendar component from `self`.
     
     - Parameters:
        - count: The amount to subtract.
        - unit: The calendar component to subtract.
     
     - Returns: The resulting past date.
     */
    func dateBefore(_ count: Int, _ unit: Calendar.Component, calendar: Calendar = .autoupdatingCurrent, timeZone: TimeZone = .autoupdatingCurrent) -> Date? {
        var calendar = calendar
        calendar.timeZone = timeZone
        
        return calendar.date(byAdding: unit, value: -count, to: self)
    }
    
    /**
     Returns an array of dates for the current week starting from the first day of the week.
     
     - Parameters:
        - calendar: The calendar to use. Defaults to `.current`.
     
     - Returns: An array of 7 dates representing the current week.
     */
    func datesOfCurrentWeek(using calendar: Calendar = .autoupdatingCurrent) -> [Date] {
        let currentWeekday = calendar.component(.weekday, from: self)
        let firstWeekdayIndex = calendar.firstWeekday
        
        // Calculate how many days to subtract to reach the start of the week
        let daysToSubtract = (7 + currentWeekday - firstWeekdayIndex) % 7
        
        guard let weekStartDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: self) else {
            return []
        }
        
        let dates = (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: weekStartDate)
        }
        
        return dates
    }
}

extension Date {
    /**
     Returns true if the date is today (ignores time).
     
     - Returns: `true` if the date is today.
    */
    func isInToday(calendar: Calendar = .autoupdatingCurrent) -> Bool {
         return calendar.isDateInToday(self)
    }
    
    /**
     Returns the full name of the month of the date.
     
     - Returns: A string representing the month (e.g. **January**).
     */
     func monthName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        
         return formatter.string(from: self)
    }
}
