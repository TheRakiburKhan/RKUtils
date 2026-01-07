# ``RKUtils/Swift/String``

Powerful string utilities for validation, parsing, formatting, and encoding.

## Overview

String extensions in RKUtils provide commonly needed functionality for form validation, date parsing, Base64 encoding, and more. These utilities work across all platforms and help reduce boilerplate code in your applications.

### Form Validation

Validate user input in registration or login forms:

```swift
let email = emailTextField.text ?? ""
if email.isValidEmail() {
    // Proceed with registration
    submitForm(email: email)
} else {
    // Show validation error
    showError("Please enter a valid email address")
}
```

### API Date Parsing

Parse date strings from API responses:

```swift
// Parse custom format
let dateString = "2024-01-15 14:30:00"
if let date = dateString.toDate(stringFormat: "yyyy-MM-dd HH:mm:ss") {
    print("Parsed date: \(date)")
}

// Parse ISO 8601 format
let isoString = "2024-01-15T14:30:00Z"
if let date = isoString.iso8601Date() {
    print("Parsed ISO date: \(date)")
}
```

### Secure Data Transmission

Encode sensitive data before transmission:

```swift
let secretMessage = "Confidential Information"
let encoded = secretMessage.toBase64
// Send encoded string to server
sendToServer(data: encoded)
```

## Topics

### Email Validation

Validate email addresses with a simple method call.

- ``String/isValidEmail()``

### Date Parsing

Convert strings to Date objects with flexible formatting options.

- ``String/toDate(stringFormat:timeZone:)``
- ``String/iso8601Date(options:)``

### Encoding

Encode strings to Base64 format for secure transmission or storage.

- ``String/toBase64``

### File Operations

Read from and write to files on disk.

- ``String/readFromFile(fileURL:)``
- ``String/writeToFile(saveLocation:)``

## See Also

- ``RKUtils/Foundation/Date``
- ``RKUtils/Swift/Int``
- ``RKUtils/Swift/Double``
