//
//  Double.swift
//  RKUtils
//
//
//  Created by Rakibur Khan on 2/4/24.
//

import Foundation

// MARK: - Public Double Formatting Extensions
// MARK: Number Formatting
public extension Double {
    /**
    Converts the Double to a localized string using NumberFormatter.
     
     - Parameters:
        - minFraction: Minimum number of digits after the decimal point.
        - maxFraction: Maximum number of digits after the decimal point.
        - groupSize: Optional grouping size for thousands separator.
     
     - Returns: A formatted string representation of the number.
     */
    func toLocal(minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        let formatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, numberStyle: .decimal, groupSize: groupSize)
        return formatter.string(from: NSNumber(value: self)) ?? String(format: "%.2f", self)
    }
    
    /**
    Converts the Double into scientific notation format.
    
     - Parameters:
        - minFraction: Minimum digits after the decimal point.
        - maxFraction: Maximum digits after the decimal point.
     
     - Returns: A string in scientific notation (e.g., 1.23E+3).
     */
    func scientificNotation(minFraction: Int = 2, maxFraction: Int = 2) -> String {
        let formatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, numberStyle: .scientific)
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    /**
     Converts the Double to a percentage string (e.g., "25%").
     
     - Parameters:
        - minFraction: Minimum number of fraction digits.
        - maxFraction: Maximum number of fraction digits.
        - groupSize: Optional grouping size for separator.
     
     - Returns: A percentage-formatted string.
     */
     func percentage(minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
         let value = self / 100.0
        let formatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, numberStyle: .percent, groupSize: groupSize)
        return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.2f%%", value * 100)
    }
    
    /**
     Converts the Double to a localized currency string.
     
     - Parameters:
        - code: ISO 4217 currency code (e.g., "USD").
        - symbol: Optional override for currency symbol (e.g., "$").
        - minFraction: Minimum fraction digits.
        - maxFraction: Maximum fraction digits.
        - groupSize: Optional grouping size.
     
     - Returns: A formatted currency string.
     */
    func currency(code: String, symbol: String? = nil, minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        let formatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, numberStyle: .currency, groupSize: groupSize)
        formatter.currencyCode = code
        if let symbol = symbol { formatter.currencySymbol = symbol }
        return formatter.string(from: NSNumber(value: self)) ??
        "\(toLocal(minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)) \(symbol ?? code)"
    }
    
    /**
     Converts the Double to a written-out word string using `NumberFormatter.Style.spellOut`.
     
     - Parameters:
        - locale: Locale for language formatting (default is `.current`).
     
     - Returns: Written words for the number, or fallback if unsupported.
     */
    func inWords(locale: Locale = .current) -> String {
        let formatter = numberFormatter(locale: locale, numberStyle: .spellOut)
        let result = formatter.string(from: NSNumber(value: self))
        return result == "\(self)" ? String(format: "%.2f", self) : result ?? "\(self)"
    }
    
    /**
     Rounds the number down to the nearest multiple of interval, appending "+" if it had a remainder.
     
     - Parameters:
        - interval: The step size (e.g., 1000 will round 1250 to "1000+").
        - groupSeparator: Whether to use thousand separators.
     
     - Returns: A suffix-formatted string with optional "+" sign.
     */
    func toPositiveSuffix(interval: Int, groupSeparator: Bool = false) -> String {
        let formatter = numberFormatter(numberStyle: .decimal, groupSeparator: groupSeparator)
        guard self >= 0, let divisor = Double(exactly: interval) else {
            return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        }
        
        if self >= divisor {
            let remainder = self.truncatingRemainder(dividingBy: divisor)
            let roundedDown = self - remainder
            if remainder > 0 { formatter.positiveSuffix = "+" }
            return formatter.string(from: NSNumber(value: roundedDown)) ?? "\(roundedDown)"
        }
        
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    /**
     Converts the Double into abbreviated string (e.g., 1.2K, 5.6M).
     
     - Returns: A shortened string representation with suffixes.
     */
    func abbreviated() -> String {
        let absValue = abs(self)
        let sign = self < 0 ? "-" : ""
        
        switch absValue {
            case 1_000_000_000...:
                return "\(sign)\((absValue / 1_000_000_000).roundedString(toPlaces: 1))B"
            case 1_000_000...:
                return "\(sign)\((absValue / 1_000_000).roundedString(toPlaces: 1))M"
            case 1_000...:
                return "\(sign)\((absValue / 1_000).roundedString(toPlaces: 1))K"
            default:
                return "\(sign)\(roundedString(toPlaces: 1))"
        }
    }
}

// MARK: Measurement Formatting
public extension Double {
    /**
     Formats a Double as a distance value (e.g., meters, kilometers).
     
     - Parameters:
        - baseUnit: Unit of measurement (default is meters).
        - unitStyle: Display style (e.g., .short, .medium).
        - minFraction: Minimum fraction digits.
        - maxFraction: Maximum fraction digits.
        - groupSize: Optional grouping size.
     
     - Returns: A localized distance string.
     */
    func distance(baseUnit: UnitLength = .meters, unitStyle: Formatter.UnitStyle = .medium, minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        return measurementString(unit: baseUnit, unitStyle: unitStyle, minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)
    }
    
    /**
     Formats the Double as a duration (e.g., minutes, hours).
     
     - Parameters:
        - baseUnit: Duration unit (default is `.minutes`).
        - unitStyle: Formatter style.
        - minFraction: Minimum fraction digits.
        - maxFraction: Maximum fraction digits.
        - groupSize: Optional grouping size.
     
     - Returns: A formatted duration string.
     */
    func time(baseUnit: UnitDuration = .minutes, unitStyle: Formatter.UnitStyle = .medium, minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        return measurementString(unit: baseUnit, unitStyle: unitStyle, minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)
    }
    
    /**
     Formats the Double as a temperature value in Kelvin.
     
     - Parameters:
        - baseUnit: Temperature Unit (default is `.kelvin`).
        - unitStyle: Display style.
        - minFraction: Minimum fraction digits.
        - maxFraction: Maximum fraction digits.
        - groupSize: Optional grouping size.
     
     - Returns: A temperature-formatted string.
     */
    func temperature(baseUnit: UnitTemperature = .kelvin, unitStyle: Formatter.UnitStyle = .medium, minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        return measurementString(unit: baseUnit, unitStyle: unitStyle, minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)
    }
    
    /**
     Formats the Double as a speed value in metersPerSecond.
     
     - Parameters:
        - baseUnit: Speed Unit (default is `.metersPerSecond`).
        - unitStyle: Display style.
        - minFraction: Minimum fraction digits.
        - maxFraction: Maximum fraction digits.
        - groupSize: Optional grouping size.
     
     - Returns: A speed-formatted string.
     */
    func speed(baseUnit: UnitSpeed = .metersPerSecond, unitStyle: Formatter.UnitStyle = .medium, minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        return measurementString(unit: baseUnit, unitStyle: unitStyle, minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)
    }
}

// MARK: Time Components
public extension Double {
    /**
     Converts seconds into a readable time format (e.g., "1h 3m").
     
     - Parameters:
        - calendar: Calendar to be used. Default is .autoupdatingCurrent
        - units: Allowed time components.
        - style: Output format style.
        - context: Formatting context.
     
     - Returns: A time-formatted string.
     */
    func secondsToTime(calendar: Calendar = .autoupdatingCurrent, units: NSCalendar.Unit = [.hour, .minute, .second], style: DateComponentsFormatter.UnitsStyle = .abbreviated, context: Formatter.Context = .listItem) -> String {
        let formatter = dateComponentsFormatter(calendar: calendar, units: units, style: style, context: context)
        
        return formatter.string(from: self) ?? "\(self)s"
    }
    
    /**
     Converts a number to a day count string.
     
     - Parameters:
        - calendar: Calendar to be used. Default is .autoupdatingCurrent
        - style: Units style.
        - context: Formatting context.
     
     - Returns: A day-formatted string.
     */
    func day(calendar: Calendar = .autoupdatingCurrent, style: DateComponentsFormatter.UnitsStyle = .abbreviated, context: Formatter.Context = .listItem) -> String {
        let components = DateComponents(day: Int(self))
        let formatter = dateComponentsFormatter(calendar: calendar, units: [.day], style: style, context: context)
        return formatter.string(from: components) ?? toLocal()
    }
    
    /**
     Converts a number to a month count string.
     
     - Parameters:
        - calendar: Calendar to be used. Default is .autoupdatingCurrent
        - style: Units style.
        - context: Formatting context.
     
     - Returns: A month-formatted string.
     */
    func month(calendar: Calendar = .autoupdatingCurrent, style: DateComponentsFormatter.UnitsStyle = .abbreviated, context: Formatter.Context = .listItem) -> String {
        let components = DateComponents(month: Int(self))
        let formatter = dateComponentsFormatter(calendar: calendar, units: [.month], style: style, context: context)
        return formatter.string(from: components) ?? toLocal()
    }
    
    /**
     Converts a number to a year count string.
     
     - Parameters:
        - calendar: Calendar to be used. Default is .autoupdatingCurrent
        - style: Units style.
        - context: Formatting context.
     
     - Returns: A year-formatted string.
     */
    func year(calendar: Calendar = .autoupdatingCurrent, style: DateComponentsFormatter.UnitsStyle = .abbreviated, context: Formatter.Context = .listItem) -> String {
        let components = DateComponents(year: Int(self))
        let formatter = dateComponentsFormatter(calendar: calendar, units: [.year], style: style, context: context)
        return formatter.string(from: components) ?? toLocal()
    }
}

// MARK: Math / Logic
public extension Double {
    /**
     Returns a string representation of the number rounded to a specified number of decimal places.
     
     - Parameters:
        - places: Number of decimal places.
     
     - Returns: A rounded string.
     */
    func roundedString(toPlaces places: Int = 2) -> String {
        String(format: "%.\(places)f", self)
    }
    
    /**
     Clamps the number within the specified range.
     
     - Parameters:
        - lower: Lower bound.
        - upper: Upper bound.
     
     - Returns: The clamped value.
     */
    func clamped(min lower: Double, max upper: Double) -> Double {
        Swift.max(lower, Swift.min(self, upper))
    }
    
    /**
     Linearly interpolates between self and a target value.
     
     - Parameters:
        - to: Target value.
        - t: Interpolation amount (0–1).
     
     - Returns: Interpolated value.
     */
    func lerp(to: Double, by t: Double) -> Double {
        self + (to - self) * t
    }
    
    /**
     Scales the number from one range to another.
     
     - Parameters:
        - oldRange: Original value range.
        - newRange: Target range.
     
     - Returns: Value mapped to the new range.
     */
    func scaled(from oldRange: ClosedRange<Double>, to newRange: ClosedRange<Double>) -> Double {
        guard oldRange.lowerBound != oldRange.upperBound else { return newRange.lowerBound }
        let ratio = (self - oldRange.lowerBound) / (oldRange.upperBound - oldRange.lowerBound)
        
        return newRange.lowerBound + ratio * (newRange.upperBound - newRange.lowerBound)
    }
    
    /**
     Converts UNIX time to `Date`
     
     - Returns: `Optional<Date>` aka `Date?`
     */
    func toDate() -> Date? {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}

// MARK: Computed Properties
public extension Double {
    /// Checks whether the number is a whole number.
    var isWholeNumber: Bool { isZero ? true : !isNormal ? false : self == rounded() }
    
    /// Converts degrees to radians.
    var toRadians: Double { self * .pi / 180 }
    
    /// Converts radians to degrees.
    var toDegrees: Double { self * 180 / .pi }
    
    /// Checks if the value is positive.
    var isPositive: Bool { self > 0 }
    
    /// Checks if the value is negative.
    var isNegative: Bool { self < 0 }
    
    /// Returns 0 if the value is NaN.
    var zeroIfNaN: Double { isNaN ? 0 : self }
    
    /// Returns the value itself or 0 if negative.
    var nonNegativeOrZero: Double { self < 0 ? 0 : self }
    
    /// Returns a sign symbol for the number: "+", "−", or "".
    var signString: String {
        switch self {
            case _ where self > 0: return "+"
            case _ where self < 0: return "−"
            default: return ""
        }
    }
}

// MARK: - Private Helpers
private extension Double {
    func numberFormatter(locale: Locale = .current, minFraction: Int? = nil, maxFraction: Int? = nil, numberStyle: NumberFormatter.Style? = nil, groupSize: Int? = nil, groupSeparator: Bool? = nil) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = locale
        
        if let style = numberStyle {
            formatter.numberStyle = style
        }
        
        if let min = minFraction {
            formatter.minimumFractionDigits = min
        }
        
        if let max = maxFraction {
            formatter.maximumFractionDigits = max
        } else if minFraction == nil {
            formatter.maximumFractionDigits = isWholeNumber ? 0 : 2
        }
        
        if let group = groupSeparator {
            formatter.usesGroupingSeparator = group
        }
        
        if let size = groupSize {
            formatter.groupingSize = size
        }
        
        return formatter
    }
    
    func dateComponentsFormatter(calendar: Calendar, units: NSCalendar.Unit, style: DateComponentsFormatter.UnitsStyle, context: Formatter.Context) -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.calendar = calendar
        formatter.allowedUnits = units
        formatter.unitsStyle = style
        formatter.formattingContext = context
        return formatter
    }
    
    func measurementString<T: Dimension>(unit: T, unitStyle: Formatter.UnitStyle, minFraction: Int?, maxFraction: Int?, groupSize: Int?) -> String {
        let measurement = Measurement(value: self, unit: unit)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = unitStyle
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)
        
        return formatter.string(from: measurement)
    }
}
