//
//  Double.swift
//  
//
//  Created by Rakibur Khan on 2/4/24.
//

import Foundation

public extension Double {
    private func numberFormatter(minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> NumberFormatter {
        let formatter = NumberFormatter()
        
        if let minFraction = minFraction {
            formatter.minimumFractionDigits = minFraction
            
            if let maxFraction = maxFraction {
                formatter.maximumFractionDigits = maxFraction
            }
        } else {
            if let maxFraction = maxFraction {
                formatter.maximumFractionDigits = maxFraction
            } else {
                formatter.maximumFractionDigits = isWholeNumber ? 0 : 2
            }
        }
        
        if let groupSize = groupSize {
            formatter.groupingSize = groupSize
        }
        
        return formatter
    }
    
    func toLocal(minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        let formatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)
        formatter.numberStyle = .decimal
        
        let number = NSNumber(value: self)
        return formatter.string(from: number) ?? "\(self)"
    }
    
    func percentage(minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        let value: Double = self / 100
        let formatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)
        formatter.numberStyle = .percent
        
        let number = NSNumber(value: value)
        
        return formatter.string(from: number) ?? "\(value)"
    }
    
    func currency(code: String, symbol: String? = nil, minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        let formatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)
        formatter.numberStyle = .currency
        formatter.currencyCode = code
        
        if let symbol = symbol {
            formatter.currencySymbol = symbol
        }
        
        let number = NSNumber(value: self)
        
        return formatter.string(from: number) ?? "\(self.toLocal(minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)) \(code)"
    }
    
    func distanceFromMeter(unitStyle: Formatter.UnitStyle = .medium, minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        let data = Measurement(value: self, unit: UnitLength.meters)
        
        let formatter = MeasurementFormatter()
        formatter.unitStyle = unitStyle
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)
        
        return formatter.string(from: data)
    }
    
    func distance(unitStyle: Formatter.UnitStyle = .medium, baseUnit: UnitLength = .meters, minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        let data = Measurement(value: self, unit: baseUnit)
        
        let formatter = MeasurementFormatter()
        formatter.unitStyle = unitStyle
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)
        
        return formatter.string(from: data)
    }
    
    func time(unitStyle: Formatter.UnitStyle = .medium, baseUnit: UnitDuration = .minutes, minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        let data = Measurement(value: self, unit: baseUnit)
        
        let formatter = MeasurementFormatter()
        formatter.unitStyle = unitStyle
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)
        
        return formatter.string(from: data)
    }
    
    func temperature(unitStyle: Formatter.UnitStyle = .medium, minFraction: Int? = nil, maxFraction: Int? = nil, groupSize: Int? = nil) -> String {
        let data = Measurement(value: self, unit: UnitTemperature.kelvin)
        
        let formatter = MeasurementFormatter()
        formatter.unitStyle = unitStyle
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter = numberFormatter(minFraction: minFraction, maxFraction: maxFraction, groupSize: groupSize)
        
        return formatter.string(from: data)
    }
    
    func toPositiveSuffix(interval: Int, groupSeparator: Bool = false) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = groupSeparator
        
        if let divisor = Double(exactly: interval) {
            if self >= abs(divisor) {
                let remainder = self.truncatingRemainder(dividingBy: divisor)
                let formattedNumber = self - remainder
                
                if remainder > 0 {
                    formatter.positiveSuffix = "+"
                }
                
                return formatter.string(from: NSNumber(value: formattedNumber)) ?? ""
            }
        }
        
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    var isWholeNumber: Bool { isZero ? true : !isNormal ? false : self == rounded() }
}

public extension Double {
    @inlinable
    func degreesToRadians() -> Double {
        self * .pi / 180.0
    }
    
    @inlinable
    func radiansToDegrees() -> Double {
        self * 180.0 / .pi
    }
}

//MARK: - Calender component converter
public extension Double {
    func day(units: NSCalendar.Unit = [.day], context: Formatter.Context = .listItem) -> String? {
        let component: DateComponents = .init(day: Int(self))
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = units
        formatter.formattingContext = context
        return formatter.string(from: component)
    }
    
    func month(units: NSCalendar.Unit = [.month], context: Formatter.Context = .listItem) -> String? {
        let component: DateComponents = .init(month: Int(self))
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = units
        formatter.formattingContext = context
        return formatter.string(from: component)
    }
    
    func year(units: NSCalendar.Unit = [.year], context: Formatter.Context = .listItem) -> String? {
        let component: DateComponents = .init(year: Int(self))
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = units
        formatter.formattingContext = context
        return formatter.string(from: component)
    }
}
