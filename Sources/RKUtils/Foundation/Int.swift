//
//  Int.swift
//  RKUtils
//
//
//  Created by Rakibur Khan on 2/4/24.
//

import Foundation

public extension Int {
    /**
     Creates a `NumberFormatter` with customizable style, grouping, and locale.
     
     - Parameters:
        - numberStyle: The formatting style to apply (e.g., `.decimal`, `.spellOut`).
        - groupSize: The digit group size (e.g., 3 for thousands).
        - groupSeparator: Whether to use digit group separators (e.g., "1,000").
        - locale: The locale to use (default is `.current`).
     
     - Returns: A configured `NumberFormatter`.
    */
    private func numberFormatter( numberStyle: NumberFormatter.Style? = nil, groupSize: Int? = nil, groupSeparator: Bool? = nil, locale: Locale = .current) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.locale = locale
        
        if let numberStyle = numberStyle {
            formatter.numberStyle = numberStyle
        }
        
        if let groupSize = groupSize {
            formatter.groupingSize = groupSize
        }
        
        if let useGroupSeparator = groupSeparator {
            formatter.usesGroupingSeparator = useGroupSeparator
        }
        
        return formatter
    }
    
    #if canImport(Darwin)
    private func dateComponentsFormatter(units: NSCalendar.Unit, style: DateComponentsFormatter.UnitsStyle = .abbreviated, context: Formatter.Context = .listItem) -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()

        formatter.allowedUnits = units
        formatter.unitsStyle = style
        formatter.formattingContext = context

        return formatter
    }
    #endif
    
    /**
     Converts the Double to a percentage string (e.g., "25%").
     
     - Parameters:
     - minFraction: Minimum number of fraction digits.
     - maxFraction: Maximum number of fraction digits.
     - groupSize: Optional grouping size for separator.
     
     - Returns: A percentage-formatted string.
     */
    func percentage(minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        let value = Double(self) / 100.0
        let formatter = numberFormatter(numberStyle: .percent, groupSize: groupSize)
        return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.2f%%", value * 100)
    }
    
    /**
     Formats the integer using a localized decimal format.
     
     - Parameters:
        - locale: The locale to use (default is `.current`).
     
     - Returns: A localized string representation of the number.
    */
    func toLocal(locale: Locale = .current) -> String {
        let formatter = numberFormatter(numberStyle: .decimal, locale: locale)
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    /**
     Rounds the number down to a multiple of `interval` and adds a suffix if there is a remainder.
     
     For example, `92.intervalDescription(interval: 10)` results in `"90+"`.
     
     - Parameters:
        - interval: The interval to round down to.
        - suffix: The suffix to append when the number is not a perfect multiple (default is `"+"`).
        - groupSeparator: Whether to use digit group separators (e.g., "1,000").
        - locale: The locale to use for formatting.
     
     - Returns: A formatted string representing the rounded number with optional suffix.
     */
    func intervalDescription(interval: Int, suffix: String = "+", groupSeparator: Bool = false, locale: Locale = .current) -> String {
        let formatter = numberFormatter(numberStyle: .decimal, groupSeparator: groupSeparator, locale: locale)
        
        let absoluteInterval = abs(interval)
        let absSelf = abs(self)
        
        guard absoluteInterval > 0 else {
            return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        }
        
        var rounded: Int = 0
        
        if absSelf < absoluteInterval {
            rounded = self
        } else {
            let remainder = absSelf % absoluteInterval
            rounded = absSelf - remainder
            
            if remainder > 0 {
                formatter.positiveSuffix = suffix
            }
        }
        
        return formatter.string(from: NSNumber(value: rounded)) ?? "\(self)"
    }
    
    /**
     Converts each digit of the number into its spelled-out word form.
     
     For example, `123.digitNames()` results in `["one", "two", "three"]`.
     
     - Parameters:
        - locale: The locale to use for spelling out digits.
        - fallbackToEnglish: Whether to fallback to English if a localized digit fails.
     
     - Returns: An array of strings representing each digit.
    */
    func digitNames(locale: Locale = .current, fallbackToEnglish: Bool = true) -> [String] {
        let formatter = numberFormatter(numberStyle: .spellOut, locale: locale)
        
        let digits: [String] = String(self).compactMap { char -> String? in
            guard let digit = Int(String(char)) else { return nil }
            return formatter.string(from: NSNumber(value: digit))
        }
        
        return digits
    }
    
    /**
     Converts the number into its fully spelled-out word form.
     
     For example, `123.inWords()` results in `"one hundred twenty-three"`.
     
     - Parameters:
        - locale: The locale to use (default is `.current`).
     
     - Returns: A string with the number written in words.
     */
    func inWords(locale: Locale = .current) -> String {
        let formatter = numberFormatter(numberStyle: .spellOut, locale: locale)
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    /**
     Converts the number (in bytes) into a human-readable file size string.
     
     For example, `1048576.byteSizeFormatted()` results in `"1 MB"`.
     
     - Parameters:
        - preferredUnits: Optional set of preferred units to display (e.g., `.useMB`).
     
     - Returns: A formatted file size string.
    */
    func byteSizeFormatted(preferredUnits: ByteCountFormatter.Units = []) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        if !preferredUnits.isEmpty {
            formatter.allowedUnits = preferredUnits
        }
        return formatter.string(fromByteCount: Int64(self))
    }
    
    /**
     Repeats a closure a specified number of times.
    
     Example: `3.times { print($0) }` prints 0, 1, 2.
     
    - Parameters:
        - action: A closure that takes the current iteration index.
    */
    func times(_ action: (Int) -> Void) {
        guard self > 0 else { return }
        
        for i in 0..<self {
            action(i)
        }
    }
    
    /**
     Clamps the integer within a specified range.
     
     - Parameters:
        - range: The range to clamp the value within.
     
     - Returns: A value constrained to the specified range.
    */
     func clamped(to range: ClosedRange<Int>) -> Int {
        return Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
    
    /**
     Returns a pluralized string based on the value.
     
     For example: `1.pluralized("item")` → `"1 item"`
               `2.pluralized("item")` → `"2 items"`
     
     - Parameters:
        - singular: The singular form of the word.
        - plural: Optional plural form. If not provided, "s" is appended to the singular.
     
     - Returns: A grammatically correct string with pluralization.
    */
    func pluralized(_ singular: String, _ plural: String? = nil) -> String {
        return self == 1 ? "\(self) \(singular)" : "\(self) \(plural ?? singular + "s")"
    }
    
    /**
     Returns a shortened, human-readable abbreviation of large numbers.
     
     For example: `1_200` → `"1.2K"`, `1_500_000` → `"1.5M"`
     
     - Parameters:
        - locale: The locale to use for decimal formatting.
     
     - Returns: An abbreviated string with suffix (K, M, B).
    */
    func abbreviated(locale: Locale = .current) -> String {
        let num = Double(self)
        let thousand = 1_000.0
        let million = 1_000_000.0
        let billion = 1_000_000_000.0
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.locale = locale
        
        switch num {
            case 0..<thousand:
                return "\(self)"
            case thousand..<million:
                return "\(formatter.string(from: NSNumber(value: num / thousand)) ?? "")K"
            case million..<billion:
                return "\(formatter.string(from: NSNumber(value: num / million)) ?? "")M"
            default:
                return "\(formatter.string(from: NSNumber(value: num / billion)) ?? "")B"
        }
    }
}

#if canImport(Darwin)
public extension Int {
    func day(style: DateComponentsFormatter.UnitsStyle = .abbreviated, context: Formatter.Context = .listItem) -> String {
        let components = DateComponents(day: self)
        let formatter = dateComponentsFormatter(units: [.day], style: style, context: context)

        return formatter.string(from: components) ?? self.toLocal()
    }

    func month(style: DateComponentsFormatter.UnitsStyle = .abbreviated, context: Formatter.Context = .listItem) -> String {
        let components = DateComponents(month: self)
        let formatter = dateComponentsFormatter(units: [.month], style: style, context: context)

        return formatter.string(from: components) ?? self.toLocal()
    }

    func year(style: DateComponentsFormatter.UnitsStyle = .abbreviated, context: Formatter.Context = .listItem) -> String {
        let components = DateComponents(year: self)
        let formatter = dateComponentsFormatter(units: [.year], style: style, context: context)

        return formatter.string(from: components) ?? self.toLocal()
    }
}
#else
public extension Int {
    // Linux fallback - basic formatting (style/context parameters not available on Linux)
    func day() -> String {
        return "\(self) day\(self == 1 ? "" : "s")"
    }

    // Linux fallback - basic formatting (style/context parameters not available on Linux)
    func month() -> String {
        return "\(self) month\(self == 1 ? "" : "s")"
    }

    // Linux fallback - basic formatting (style/context parameters not available on Linux)
    func year() -> String {
        return "\(self) year\(self == 1 ? "" : "s")"
    }
}
#endif

public extension Int {
    /**
     Converts UNIX time to `Date`

    - Returns: `Optional<Date>` aka `Date?`
     */
    func toDate() -> Date? {
       return Date(timeIntervalSince1970: TimeInterval(self))
    }
}

public extension Int {
    /// Converts seconds into a (minutes, seconds) tuple.
    var secondsToMinutesSeconds: (minutes: Int, seconds: Int) {
        return (self / 60, self % 60)
    }
    
    /// Converts the value in seconds to a time string in mm:ss format.
    var timeString: String {
        String(format: "%02d:%02d", self / 60, self % 60)
    }
    
    /// Returns the spelled-out word form using the current locale.
    var inWords: String {
        inWords()
    }
    
    /// Returns `true` if the number is even.
    var isEven: Bool { self % 2 == 0 }
    
    /// Returns `true` if the number is odd.
    var isOdd: Bool { !isEven }
    
    /// Returns `true` if the number is less than 0.
    var isNegative: Bool { self < 0 }
    
    /// Returns `true` if the number is greater than 0.
    var isPositive: Bool { self > 0 }
}

// MARK: - Renamed and will be removed in future
public extension Int {
    /**
     Rounds the number down to a multiple of `interval` and adds a suffix if there is a remainder.
     
     For example, `92.toPositiveSuffix(interval: 10)` results in `"90+"`.
     
     - Parameters:
     - interval: The interval to round down to.
     - suffix: The suffix to append when the number is not a perfect multiple (default is `"+"`).
     - groupSeparator: Whether to use digit group separators (e.g., "1,000").
     - locale: The locale to use for formatting.
     
     - Returns: A formatted string representing the rounded number with optional suffix.
     */
    @available(*, deprecated, renamed: "intervalDescription(interval:suffix:groupSeparator:locale:)")
    func toPositiveSuffix(interval: Int, suffix: String = "+", groupSeparator: Bool = false, locale: Locale = .current) -> String {
       return intervalDescription(interval: interval, suffix: suffix, groupSeparator: groupSeparator, locale: locale)
    }
}
