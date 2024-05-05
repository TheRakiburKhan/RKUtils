//
//  Date.swift
//  
//
//  Created by Rakibur Khan on 2/4/24.
//

import Foundation

public extension Date {
    func convertDateTimeToHumanString(timeZone: TimeZone? = TimeZone.current, timeZoneForRemoteDate: TimeZone? = TimeZone(abbreviation: "GMT"), locale: Locale = Locale.current, localizedDateFormatFromTemplate: String = "MMMddyyyyhhmma")-> String {
        
        let formatter = DateFormatter()
        
        formatter.timeZone = timeZone
        formatter.locale = locale
        formatter.setLocalizedDateFormatFromTemplate(localizedDateFormatFromTemplate)
        
        let read = formatter.string(from: self)
        
        return read
    }
    
    func convertDateToHumanString(timeZone: TimeZone? = TimeZone.current, timeZoneForRemoteDate: TimeZone? = TimeZone(abbreviation: "GMT"), locale: Locale = Locale.current, localizedDateFormatFromTemplate: String = "MMMMddyyyy")-> String {
        
        let formatter = DateFormatter()
        
        formatter.timeZone = timeZone
        formatter.locale = locale
        formatter.setLocalizedDateFormatFromTemplate(localizedDateFormatFromTemplate)
        
        let read = formatter.string(from: self)
        
        return read
    }
    
    @inlinable func convertToJSONStyle(format: String = "yyyy-MM-dd")-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let date = dateFormatter.string(from: self)
        
        return date
    }
    
    func relativeDateTimeString(context: Formatter.Context = .listItem, style: RelativeDateTimeFormatter.DateTimeStyle = .numeric, unitStyle: RelativeDateTimeFormatter.UnitsStyle = .abbreviated, relativeDate: Date = Date()) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.formattingContext = context
        formatter.dateTimeStyle = style
        formatter.unitsStyle = unitStyle
        
        return formatter.localizedString(for: self, relativeTo: relativeDate)
    }
}

public extension Date {
    var previousMonth: Date? {
        Calendar(identifier: .iso8601).date(byAdding: .month, value: -1, to: self)
    }
    
    var currentMonth: Date? {
        Calendar(identifier: .iso8601).date(byAdding: .month, value: 0, to: self)
    }
    
    var monthNumber: Int? {
        Calendar(identifier: .iso8601).component(.month, from: self)
    }
    
    var yearNumber: Int? {
        Calendar(identifier: .iso8601).component(.year, from: self)
    }
}
