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
     Converts ``Date`` to Human readable string format. Default format is "*01 Jan 1970 12:00 AM*"
     */
    func readableString(timeZone: TimeZone? = TimeZone.current, locale: Locale = Locale.current, localizedDateFormatFromTemplate: String)-> String {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = locale
        formatter.setLocalizedDateFormatFromTemplate(localizedDateFormatFromTemplate)
        
        let read = formatter.string(from: self)
        
        return read
    }
    
    func readableString(timeZone: TimeZone? = TimeZone.current, locale: Locale = Locale.current, format: String)-> String {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = locale
        formatter.dateFormat = format
        
        let read = formatter.string(from: self)
        
        return read
    }
    
    func toString(format: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone? = nil)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if let timeZone = timeZone {
            dateFormatter.timeZone = timeZone
        }
        
        let date = dateFormatter.string(from: self)
        
        return date
    }
    
    func relativeTime(to referanceDate: Date = Date(), context: Formatter.Context = .listItem, style: RelativeDateTimeFormatter.DateTimeStyle = .numeric, unitStyle: RelativeDateTimeFormatter.UnitsStyle = .abbreviated) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.formattingContext = context
        formatter.dateTimeStyle = style
        formatter.unitsStyle = unitStyle
        
        return formatter.localizedString(for: self, relativeTo: referanceDate)
    }
    
    func distanceOf(_ unit: Calendar.Component, till referanceDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([unit], from: self, to: referanceDate)
        
        return components.value(for: unit) ?? 0
    }
    
    func distanceOf(_ unit: Calendar.Component, from referanceDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([unit], from: referanceDate, to: self)
        
        return components.value(for: unit) ?? 0
    }
    
    func dateAfter(_ count: Int, _ unit: Calendar.Component) -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        let date = calendar.date(byAdding: unit, value: count, to: self)
        
        return date
    }
    
    func dateBefore(_ count: Int, _ unit: Calendar.Component) -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        let date = calendar.date(byAdding: unit, value: (count * (-1)), to: self)
        
        return date
    }
    
    func datesOfCurrentWeek(using calendar: Calendar = .current) -> [Date] {
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
    func isInToday() -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selfDate = calendar.startOfDay(for: self)
        
        return today == selfDate
    }
    
    func monthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
}
