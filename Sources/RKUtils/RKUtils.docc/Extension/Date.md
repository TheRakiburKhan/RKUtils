# ``RKUtils/Foundation/Date``

Date formatting, arithmetic operations, and time calculations.

## Overview

Date extensions provide flexible formatting options, date arithmetic (adding/subtracting time), distance calculations between dates, and utilities for working with weeks and months. These utilities handle time zones, calendars, and localization automatically.

### Simple Date Formatting

Format dates with custom format strings:

```swift
let date = Date()

// Basic format
let simple = date.toString(format: "yyyy-MM-dd")
// "2024-01-15"

// Custom format with time
let detailed = date.toString(format: "MMM dd, yyyy 'at' h:mm a")
// "Jan 15, 2024 at 2:30 PM"

// With specific timezone
let nyTime = date.toString(
    format: "yyyy-MM-dd HH:mm:ss",
    timeZone: TimeZone(identifier: "America/New_York")
)
// "2024-01-15 09:30:00"
```

### Localized Date Formatting

Use localized templates for proper regional formatting:

```swift
let date = Date()

// Localized template (adapts to user's locale)
let localized = date.readableString(localizedDateFormatFromTemplate: "MMMdy")
// US: "Jan 15, 2024"
// Germany: "15. Jan. 2024"

// Custom format with locale
let custom = date.readableString(
    locale: Locale(identifier: "fr_FR"),
    format: "EEEE dd MMMM yyyy"
)
// "lundi 15 janvier 2024"
```

### Relative Time (Apple Platforms)

Display human-readable relative time:

```swift
#if canImport(Darwin)
let twoHoursAgo = Date().addingTimeInterval(-7200)
let relative = twoHoursAgo.relativeTime()
// "2 hours ago"

let tomorrow = Date().addingTimeInterval(86400)
let future = tomorrow.relativeTime()
// "in 1 day"

// Customized style
let named = twoHoursAgo.relativeTime(style: .named, unitStyle: .full)
// "2 hours ago"

let numeric = twoHoursAgo.relativeTime(style: .numeric, unitStyle: .abbreviated)
// "2 hr. ago"
#endif
```

### Date Arithmetic

Add or subtract time from dates:

```swift
let now = Date()

// Add time
if let tomorrow = now.dateAfter(1, .day) {
    print(tomorrow)
    // 24 hours from now
}

if let nextWeek = now.dateAfter(1, .weekOfYear) {
    print(nextWeek)
    // 7 days from now
}

if let nextMonth = now.dateAfter(1, .month) {
    print(nextMonth)
    // 1 month from now
}

// Subtract time
if let yesterday = now.dateBefore(1, .day) {
    print(yesterday)
    // 24 hours ago
}

if let lastYear = now.dateBefore(1, .year) {
    print(lastYear)
    // 1 year ago
}
```

### Distance Calculations

Calculate time between dates:

```swift
let start = Date()
let end = start.addingTimeInterval(172800) // 2 days later

// Distance from start to end
let daysTill = start.distanceOf(.day, till: end)
// 2

let hoursTill = start.distanceOf(.hour, till: end)
// 48

// Distance from end to start
let daysFrom = start.distanceOf(.day, from: end)
// -2 (negative because it's in the past)

// Check age
let birthDate = Calendar.current.date(from: DateComponents(year: 1990, month: 1, day: 1))!
let age = birthDate.distanceOf(.year, till: Date())
// 34 (years since birth)
```

### Check if Today

Determine if a date is today:

```swift
let now = Date()
let today = now.isInToday()
// true

let yesterday = now.addingTimeInterval(-86400)
let notToday = yesterday.isInToday()
// false

// With specific calendar
let gregorianToday = now.isInToday(calendar: Calendar(identifier: .gregorian))
// true
```

### Current Week Dates

Get all dates for the current week:

```swift
let today = Date()
let weekDates = today.datesOfCurrentWeek()
// Array of 7 dates starting from first day of week

// Use in calendar view
for (index, date) in weekDates.enumerated() {
    let dayName = date.toString(format: "EEE")
    let dayNumber = date.toString(format: "d")
    print("\(dayName) \(dayNumber)")
}
// Sun 14
// Mon 15
// Tue 16
// ...

// With specific calendar
let islamicCalendar = Calendar(identifier: .islamicCivil)
let islamicWeek = today.datesOfCurrentWeek(using: islamicCalendar)
// Week dates according to Islamic calendar
```

### Month Name

Get the month name from a date:

```swift
let date = Date()
let month = date.monthName()
// "January"

// Different months
let components = DateComponents(year: 2024, month: 7, day: 15)
if let julyDate = Calendar.current.date(from: components) {
    let julyName = julyDate.monthName()
    // "July"
}
```

### Scheduling Example

Combine methods for scheduling:

```swift
func scheduleWeeklyMeeting(startDate: Date) {
    // Get all dates for the week
    let weekDates = startDate.datesOfCurrentWeek()

    // Schedule meeting for Wednesday (index 3) at 2 PM
    if let wednesday = weekDates[safe: 3],
       let meetingTime = wednesday.dateAfter(14, .hour) { // Add 14 hours from midnight

        print("Meeting scheduled for: \(meetingTime.toString(format: "EEEE, MMM dd 'at' h:mm a"))")
        // "Wednesday, Jan 17 at 2:00 PM"

        // Calculate reminder (1 hour before)
        if let reminder = meetingTime.dateBefore(1, .hour) {
            scheduleReminder(at: reminder)
        }
    }
}
```

### Timeline Filtering

Filter data by date ranges:

```swift
let posts: [Post] = loadPosts()

// Today's posts
let todaysPosts = posts.filter { $0.date.isInToday() }

// Posts from this week
let weekDates = Date().datesOfCurrentWeek()
let thisWeeksPosts = posts.filter { post in
    weekDates.contains { weekDate in
        post.date.isInToday(calendar: Calendar.current) == weekDate.isInToday()
    }
}

// Posts within last 7 days
let sevenDaysAgo = Date().dateBefore(7, .day)!
let recentPosts = posts.filter { post in
    post.date.distanceOf(.day, till: Date()) <= 7
}
```

## Topics

### Date Formatting

Convert dates to formatted strings.

- ``Date/toString(format:calendar:timeZone:)``
- ``Date/readableString(calendar:timeZone:locale:localizedDateFormatFromTemplate:)``
- ``Date/readableString(calendar:timeZone:locale:format:)``

### Relative Time

Display human-readable relative time (Apple platforms).

- ``Date/relativeTime(to:context:style:unitStyle:calendar:)``

### Date Arithmetic

Add or subtract time from dates.

- ``Date/dateAfter(_:_:calendar:timeZone:)``
- ``Date/dateBefore(_:_:calendar:timeZone:)``

### Distance Calculations

Calculate time between dates.

- ``Date/distanceOf(_:till:calendar:)``
- ``Date/distanceOf(_:from:calendar:)``

### Utilities

Helper methods for common date operations.

- ``Date/isInToday(calendar:)``
- ``Date/monthName()``
- ``Date/datesOfCurrentWeek(using:)``

## See Also

- ``RKUtils/Swift/String``
- ``RKUtils/Swift/Int``
