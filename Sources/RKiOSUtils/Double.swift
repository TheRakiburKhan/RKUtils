//
//  Double.swift
//  
//
//  Created by Rakibur Khan on 2/4/24.
//

import Foundation

public extension Double {
    private func numberFormatter(locale: Locale = .current, minFraction: Int? = nil, maxFraction: Int? = nil, numberStyle: NumberFormatter.Style? = nil, groupSize: Int? = nil, groupSeparator: Bool? = nil) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = locale
        
        if let numberStyle = numberStyle {
            formatter.numberStyle = numberStyle
        }
        
        // Fraction digits
        if let minFraction = minFraction {
            formatter.minimumFractionDigits = minFraction
        }
        
        if let maxFraction = maxFraction {
            formatter.maximumFractionDigits = maxFraction
        } else if minFraction == nil {
            formatter.maximumFractionDigits = isWholeNumber ? 0 : 2
        }
        
        // Grouping behavior
        if let useGroupSeparator = groupSeparator {
            formatter.usesGroupingSeparator = useGroupSeparator
        }
        
        if let groupSize = groupSize {
            // Note: groupingSize is locale-sensitive and often ineffective outside custom locales
            formatter.groupingSize = groupSize
        }
        
        return formatter
    }
    
    private func dateComponentsFormatter(units: NSCalendar.Unit, style: DateComponentsFormatter.UnitsStyle = .abbreviated, context: Formatter.Context = .listItem) -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = units
        formatter.unitsStyle = style
        formatter.formattingContext = context
        
        return formatter
    }
    
    func toLocal(minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        let formatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, numberStyle: .decimal, groupSize: groupSize)
        
        return formatter.string(from: NSNumber(value: self)) ?? String(format: "%.2f", self)
    }
    
    func scientificNotation(minFraction: Int = 2, maxFraction: Int = 2) -> String {
        let formatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, numberStyle: .scientific)
        
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    func percentage(minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        let value: Double = self / 100
        let formatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, numberStyle: .percent, groupSize: groupSize)
        
        return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.2f%%", value * 100)
    }
    
    func currency(code: String, symbol: String? = nil, minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        let formatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, numberStyle: .currency, groupSize: groupSize)
        formatter.currencyCode = code
        
        if let symbol = symbol {
            formatter.currencySymbol = symbol
        }
        
        return formatter.string(from: NSNumber(value: self))
        ?? "\(self.toLocal(minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)) \(symbol ?? code)"
    }
    
    func distance(unitStyle: Formatter.UnitStyle = .medium, baseUnit: UnitLength = .meters, minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        let measurement = Measurement(value: self, unit: baseUnit)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = unitStyle
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)
        
        return formatter.string(from: measurement)
    }
    
    func time(unitStyle: Formatter.UnitStyle = .medium, baseUnit: UnitDuration = .minutes, minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        let measurement = Measurement(value: self, unit: baseUnit)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = unitStyle
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)
        
        return formatter.string(from: measurement)
    }
    
    func temperature(unitStyle: Formatter.UnitStyle = .medium, minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        let measurement = Measurement(value: self, unit: UnitTemperature.kelvin)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = unitStyle
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)
        
        return formatter.string(from: measurement)
    }
    
    /// Formats a value with a "+" suffix if it's greater than or equal to the interval and has remainder
    func toPositiveSuffix(interval: Int, groupSeparator: Bool = false) -> String {
        let formatter = numberFormatter(numberStyle: .decimal, groupSeparator: groupSeparator)
        
        guard self >= 0, let divisor = Double(exactly: interval) else {
            return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        }
        
        if self >= divisor {
            let remainder = self.truncatingRemainder(dividingBy: divisor)
            let roundedDown = self - remainder
            if remainder > 0 {
                formatter.positiveSuffix = "+"
            }
            return formatter.string(from: NSNumber(value: roundedDown)) ?? "\(roundedDown)"
        }
        
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    func secondsToTime(units: NSCalendar.Unit = [.hour, .minute, .second], style: DateComponentsFormatter.UnitsStyle = .abbreviated, context: Formatter.Context = .listItem) -> String {
        let formatter = dateComponentsFormatter(units: units, style: style, context: context)
        
        return formatter.string(from: self) ?? "\(self)s"
    }

    
    /// Returns the number spelled out in words (e.g., "twenty-three")
    func inWords(locale: Locale = .current) -> String {
        let formatter = numberFormatter(locale: locale, numberStyle: .spellOut)
        
        let result = formatter.string(from: NSNumber(value: self))
        
        if result == "\(self)" {
            // Possibly unsupported locale or formatting issue
            return String(format: "%.2f", self)
        }
        return result ?? "\(self)"
    }
    
    func roundedString(toPlaces places: Int = 2) -> String {
        String(format: "%.\(places)f", self)
    }
    
    func clamped(min lower: Double, max upper: Double) -> Double {
        return Swift.max(lower, Swift.min(self, upper))
    }
    
    func lerp(to: Double, by t: Double) -> Double {
        return self + (to - self) * t
    }
    
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
                return "\(sign)\(self.roundedString(toPlaces: 1))"
        }
    }
    
    func scaled(from oldRange: ClosedRange<Double>, to newRange: ClosedRange<Double>) -> Double {
        guard oldRange.lowerBound != oldRange.upperBound else { return newRange.lowerBound }
        let ratio = (self - oldRange.lowerBound) / (oldRange.upperBound - oldRange.lowerBound)
        return newRange.lowerBound + ratio * (newRange.upperBound - newRange.lowerBound)
    }

}

// MARK: - Computed properties

public extension Double {
    var isWholeNumber: Bool { isZero ? true : !isNormal ? false : self == rounded() }
    
    var toRadians: Double {
        self * .pi / 180.0
    }
    
    var toDegrees: Double {
        self * 180.0 / .pi
    }
    
    var isPositive: Bool { self > 0 }
    var isNegative: Bool { self < 0 }
    
    var signString: String {
        switch self {
            case _ where self > 0: return "+"
            case _ where self < 0: return "−"
            default: return ""
        }
    }
    
    var zeroIfNaN: Double {
        self.isNaN ? 0 : self
    }
    
    var nonNegativeOrZero: Double {
        return self < 0 ? 0 : self
    }
    
    
}

// MARK: - Calendar component converter

public extension Double {
    func day(style: DateComponentsFormatter.UnitsStyle = .abbreviated, context: Formatter.Context = .listItem) -> String {
        let components = DateComponents(day: Int(self))
        let formatter = dateComponentsFormatter(units: [.day], style: style, context: context)
        
        return formatter.string(from: components) ?? self.toLocal()
    }
    
    func month(style: DateComponentsFormatter.UnitsStyle = .abbreviated, context: Formatter.Context = .listItem) -> String {
        let components = DateComponents(month: Int(self))
        let formatter = dateComponentsFormatter(units: [.month], style: style, context: context)
        
        return formatter.string(from: components) ?? self.toLocal()
    }
    
    func year(style: DateComponentsFormatter.UnitsStyle = .abbreviated, context: Formatter.Context = .listItem) -> String {
        let components = DateComponents(year: Int(self))
        let formatter = dateComponentsFormatter(units: [.year], style: style, context: context)
        
        return formatter.string(from: components) ?? self.toLocal()
    }
}
