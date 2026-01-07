# ``RKUtils/Swift/Double``

Comprehensive number formatting, measurement utilities, and mathematical operations for floating-point numbers.

## Overview

Double extensions provide powerful formatting capabilities for numbers, percentages, currencies, measurements, and time durations. These utilities handle localization, scientific notation, abbreviations, and mathematical operations essential for professional applications.

### Number Formatting

Format numbers with full localization support:

```swift
let value = 1234.567

// Localized number with custom fraction digits
let localized = value.toLocal(minFraction: 1, maxFraction: 2)
// "1,234.57" (US locale) or "1.234,57" (German locale)

// Scientific notation
let scientific = value.scientificNotation(minFraction: 2, maxFraction: 3)
// "1.23E+3"

// Spell out number in words
let words = value.inWords()
// "one thousand two hundred thirty-four point five seven"
```

### Currency Formatting

Display prices and monetary values:

```swift
let price = 1299.99

// USD currency
let usd = price.currency(code: "USD")
// "$1,299.99"

// Euro with custom symbol
let euro = price.currency(code: "EUR", symbol: "€", maxFraction: 2)
// "€1.299,99"

// Custom fraction digits
let precise = price.currency(code: "USD", minFraction: 3, maxFraction: 3)
// "$1,299.990"
```

### Percentage Display

Show progress, discounts, and statistics:

```swift
let progress = 65.47

// Basic percentage
let percent = progress.percentage()
// "65.47%"

// Custom precision
let rounded = 25.5.percentage(minFraction: 0, maxFraction: 0)
// "26%"

let precise = 33.33333.percentage(minFraction: 2, maxFraction: 2)
// "33.33%"
```

### Abbreviated Numbers

Display large numbers in compact form:

```swift
let followers = 1_234_567.0
let abbreviated = followers.abbreviated()
// "1.2M"

let views = 42_300.0
let shortForm = views.abbreviated()
// "42.3K"

let billions = 2_500_000_000.0
let billions = billions.abbreviated()
// "2.5B"
```

### Measurements (Apple Platforms)

Format physical measurements with units:

```swift
#if canImport(Darwin)
// Distance
let meters = 1500.0
let distance = meters.distance(baseUnit: .meters, unitStyle: .short)
// "1.5 km"

// Temperature
let kelvin = 293.15
let temp = kelvin.temperature(baseUnit: .kelvin, unitStyle: .medium)
// "20°C" (auto-converts to user's preferred unit)

// Speed
let mps = 25.0
let speed = mps.speed(baseUnit: .metersPerSecond, unitStyle: .long)
// "25 meters per second"

// Time duration
let minutes = 125.0
let duration = minutes.time(baseUnit: .minutes, unitStyle: .abbreviated)
// "2 hr"
#endif
```

### Time Components

Convert numbers to time formats:

```swift
let seconds = 3665.0
let timeString = seconds.secondsToTime()
// "1:01:05"

let days = 7.0
let dayString = days.day()
// "7 days"

let months = 3.0
let monthString = months.month()
// "3 months"
```

### Mathematical Operations

Perform common math operations:

```swift
// Round to string with decimal places
let pi = 3.14159265
let rounded = pi.roundedString(toPlaces: 2)
// "3.14"

// Clamp value to range
let value = 150.0
let clamped = value.clamped(min: 0, max: 100)
// 100.0

// Linear interpolation
let start = 0.0
let interpolated = start.lerp(to: 100, by: 0.5)
// 50.0

// Scale from one range to another
let oldValue = 50.0
let scaled = oldValue.scaled(from: 0...100, to: 0...1)
// 0.5

// Convert UNIX timestamp to Date
let timestamp = 1704470400.0
let date = timestamp.toDate()
// Date object for Jan 5, 2024
```

### Value Checking

Check number properties:

```swift
let whole = 42.0
let fraction = 42.5

// Check if whole number
whole.isWholeNumber  // true
fraction.isWholeNumber  // false

// Check sign
let positive = 10.0
positive.isPositive  // true
positive.isNegative  // false

// Convert NaN to zero safely
let invalid = Double.nan
let safe = invalid.zeroIfNaN  // 0.0

// Ensure non-negative
let negative = -5.0
let nonNeg = negative.nonNegativeOrZero  // 0.0
```

### Unit Conversions

Convert between angle units:

```swift
let degrees = 180.0
let radians = degrees.toRadians
// 3.14159... (π)

let rad = Double.pi
let deg = rad.toDegrees
// 180.0
```

## Topics

### Number Formatting

Format numbers with localization and styling.

- ``Double/toLocal(minFraction:maxFraction:groupSize:)``
- ``Double/scientificNotation(minFraction:maxFraction:)``
- ``Double/percentage(minFraction:maxFraction:groupSize:)``
- ``Double/currency(code:symbol:minFraction:maxFraction:groupSize:)``
- ``Double/inWords(locale:)``
- ``Double/abbreviated()``
- ``Double/toPositiveSuffix(interval:groupSeparator:)``

### Measurement Formatting

Format physical measurements with units (Apple platforms only).

- ``Double/distance(baseUnit:unitStyle:minFraction:maxFraction:groupSize:)``
- ``Double/time(baseUnit:unitStyle:minFraction:maxFraction:groupSize:)``
- ``Double/temperature(baseUnit:unitStyle:minFraction:maxFraction:groupSize:)``
- ``Double/speed(baseUnit:unitStyle:minFraction:maxFraction:groupSize:)``

### Time Components

Convert numbers to time and date component strings.

- ``Double/secondsToTime(calendar:units:style:context:)``
- ``Double/day(calendar:style:context:)``
- ``Double/month(calendar:style:context:)``
- ``Double/year(calendar:style:context:)``

### Mathematical Operations

Perform rounding, clamping, interpolation, and scaling.

- ``Double/roundedString(toPlaces:)``
- ``Double/clamped(min:max:)``
- ``Double/lerp(to:by:)``
- ``Double/scaled(from:to:)``

### Conversions

Convert between types and units.

- ``Double/toDate()``
- ``Double/toRadians``
- ``Double/toDegrees``

### Value Checking

Check number properties and states.

- ``Double/isWholeNumber``
- ``Double/isPositive``
- ``Double/isNegative``
- ``Double/zeroIfNaN``
- ``Double/nonNegativeOrZero``
- ``Double/signString``

## See Also

- ``RKUtils/Swift/Int``
- ``RKUtils/Swift/String``
