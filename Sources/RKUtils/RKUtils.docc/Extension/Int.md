# ``RKUtils/Swift/Int``

Comprehensive number formatting, abbreviations, pluralization, and utility operations for integers.

## Overview

Int extensions provide powerful formatting capabilities including abbreviated numbers, percentage formatting, byte sizes, word spelling, time formatting, and utility operations. These utilities are essential for displaying metrics, statistics, and user-facing numbers.

### Abbreviated Numbers

Display large numbers in compact form:

```swift
let followers = 1_234_567
let abbreviated = followers.abbreviated()
// "1.2M"

let views = 42_300
let shortForm = views.abbreviated()
// "42.3K"

let billions = 2_500_000_000
let billions = billions.abbreviated()
// "2.5B"
```

### Localized Number Formatting

Format numbers with locale-specific formatting:

```swift
let value = 1234567
let usFormat = value.toLocal(locale: Locale(identifier: "en_US"))
// "1,234,567"

let deFormat = value.toLocal(locale: Locale(identifier: "de_DE"))
// "1.234.567"
```

### Percentage Formatting

Convert integers to percentage strings:

```swift
let progress = 75
let percent = progress.percentage()
// "75%"

let completion = 100
let complete = completion.percentage()
// "100%"
```

### Byte Size Formatting

Display file sizes in human-readable format:

```swift
let bytes = 1_048_576
let fileSize = bytes.byteSizeFormatted()
// "1 MB"

let largeFile = 5_368_709_120
let size = largeFile.byteSizeFormatted()
// "5 GB"

// Specific units
let kilobytes = 2048
let kb = kilobytes.byteSizeFormatted(preferredUnits: .useKB)
// "2 KB"
```

### Word Spelling

Spell out numbers in words:

```swift
let number = 123
let words = number.inWords()
// "one hundred twenty-three"

// Also available as property
let wordsProp = number.inWords
// "one hundred twenty-three"

// Get individual digit names
let digits = number.digitNames()
// ["one", "two", "three"]
```

### Pluralization

Automatically pluralize words based on count:

```swift
let items = 1
let singular = items.pluralized("item")
// "1 item"

let multiple = 5
let plural = multiple.pluralized("item")
// "5 items"

// Custom plural form
let people = 3
let custom = people.pluralized("person", "people")
// "3 people"
```

### Time Formatting

Convert seconds to time strings:

```swift
let seconds = 125
let time = seconds.timeString
// "02:05"

let longDuration = 3665
let longTime = longDuration.timeString
// "61:05"

// Get minutes and seconds separately
let components = seconds.secondsToMinutesSeconds
// (minutes: 2, seconds: 5)
```

### Time Components (Darwin/Linux)

Format time components with units:

```swift
#if canImport(Darwin)
let days = 7
let dayString = days.day()
// "7d" (abbreviated)

let months = 3
let monthString = months.month(style: .full)
// "3 months"

let years = 2
let yearString = years.year(style: .short)
// "2 yr"
#else
// Linux: basic formatting
let days = 7
let dayString = days.day()
// "7 days"
#endif
```

### Interval Description

Round to intervals with suffix:

```swift
let value = 92
let rounded = value.intervalDescription(interval: 10)
// "90+"

let large = 1250
let thousands = large.intervalDescription(interval: 1000, suffix: "+", groupSeparator: true)
// "1,000+"
```

### Loop Utilities

Execute code blocks multiple times:

```swift
5.times {
    print("Hello!")
}
// Prints "Hello!" 5 times

10.times { index in
    let cell = createCell(at: index)
    stackView.addArrangedSubview(cell)
}
// Creates 10 cells with indices 0-9
```

### Value Clamping

Constrain values to ranges:

```swift
let score = 150
let clamped = score.clamped(to: 0...100)
// 100

let negative = -5
let positive = negative.clamped(to: 0...100)
// 0
```

### Value Checking

Check number properties:

```swift
let even = 42
even.isEven  // true
even.isOdd   // false

let odd = 17
odd.isEven   // false
odd.isOdd    // true

// Check sign
let positive = 10
positive.isPositive  // true
positive.isNegative  // false

let negative = -5
negative.isPositive  // false
negative.isNegative  // true
```

### UNIX Timestamp Conversion

Convert timestamps to dates:

```swift
let timestamp = 1704470400
if let date = timestamp.toDate() {
    print(date)
    // 2024-01-05 16:00:00 +0000
}
```

## Topics

### Number Formatting

Format integers with localization and abbreviations.

- ``Int/toLocal(locale:)``
- ``Int/percentage(minFraction:maxFraction:groupSize:)``
- ``Int/abbreviated(locale:)``
- ``Int/intervalDescription(interval:suffix:groupSeparator:locale:)``

### Word Formatting

Convert numbers to spelled-out words.

- ``Int/inWords(locale:)``
- ``Int/inWords``
- ``Int/digitNames(locale:fallbackToEnglish:)``

### Byte Size Formatting

Format byte counts as human-readable file sizes.

- ``Int/byteSizeFormatted(preferredUnits:)``

### Time Formatting

Convert numbers to time strings and components.

- ``Int/timeString``
- ``Int/secondsToMinutesSeconds``
- ``Int/day(style:context:)``
- ``Int/month(style:context:)``
- ``Int/year(style:context:)``

### Utility Operations

Common operations and transformations.

- ``Int/times(_:)``
- ``Int/clamped(to:)``
- ``Int/pluralized(_:_:)``

### Conversions

Convert integers to other types.

- ``Int/toDate()``

### Value Checking

Check integer properties and states.

- ``Int/isEven``
- ``Int/isOdd``
- ``Int/isPositive``
- ``Int/isNegative``

## See Also

- ``RKUtils/Swift/Double``
- ``RKUtils/Swift/String``
