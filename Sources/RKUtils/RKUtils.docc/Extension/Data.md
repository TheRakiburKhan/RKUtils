# ``RKUtils/Foundation/Data``

Utilities for building and manipulating binary data with string content.

## Overview

Data extensions provide a convenient method for building binary data by appending UTF-8 encoded strings. This is particularly useful when constructing HTTP request bodies, building multipart form data, or assembling binary protocols that include text segments.

### Appending Strings to Data

Build binary data by appending UTF-8 encoded strings:

```swift
var data = Data()
data.append("Hello, ")
data.append("World!")

let result = String(data: data, encoding: .utf8)
// "Hello, World!"
```

### Building HTTP Request Bodies

Construct request bodies by appending formatted strings:

```swift
func createMultipartFormData(boundary: String, fields: [String: String]) -> Data {
    var data = Data()

    for (key, value) in fields {
        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        data.append("\(value)\r\n")
    }

    data.append("--\(boundary)--\r\n")

    return data
}

// Usage
let boundary = "Boundary-\(UUID().uuidString)"
let formData = createMultipartFormData(
    boundary: boundary,
    fields: ["username": "alice", "email": "alice@example.com"]
)

// Result:
// --Boundary-12345678-1234-1234-1234-123456789ABC
// Content-Disposition: form-data; name="username"
//
// alice
// --Boundary-12345678-1234-1234-1234-123456789ABC
// Content-Disposition: form-data; name="email"
//
// alice@example.com
// --Boundary-12345678-1234-1234-1234-123456789ABC--
```

### Building File Upload Requests

Combine binary file data with text headers:

```swift
func createFileUploadData(fileData: Data, filename: String, mimeType: String) -> Data {
    var data = Data()
    let boundary = "Boundary-\(UUID().uuidString)"

    // Add file field header
    data.append("--\(boundary)\r\n")
    data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
    data.append("Content-Type: \(mimeType)\r\n\r\n")

    // Add binary file data
    data.append(fileData)

    // Add closing boundary
    data.append("\r\n--\(boundary)--\r\n")

    return data
}

// Usage
let imageData = UIImage(named: "photo")!.jpegData(compressionQuality: 0.8)!
let uploadData = createFileUploadData(
    fileData: imageData,
    filename: "profile.jpg",
    mimeType: "image/jpeg"
)
```

### Building JSON-Like Text Protocols

Construct custom text-based protocols:

```swift
func createLogEntry(timestamp: Date, level: String, message: String) -> Data {
    var data = Data()

    let formatter = ISO8601DateFormatter()
    let dateString = formatter.string(from: timestamp)

    data.append("[\(dateString)] ")
    data.append("[\(level.uppercased())] ")
    data.append(message)
    data.append("\n")

    return data
}

// Usage
var logData = Data()
logData.append(createLogEntry(timestamp: Date(), level: "info", message: "Server started"))
logData.append(createLogEntry(timestamp: Date(), level: "warn", message: "High memory usage"))
logData.append(createLogEntry(timestamp: Date(), level: "error", message: "Connection failed"))

// Save to file
try? logData.write(to: logFileURL)
```

### Building CSV Data

Generate CSV files by appending formatted rows:

```swift
func createCSV(headers: [String], rows: [[String]]) -> Data {
    var data = Data()

    // Add headers
    data.append(headers.joined(separator: ","))
    data.append("\n")

    // Add rows
    for row in rows {
        data.append(row.joined(separator: ","))
        data.append("\n")
    }

    return data
}

// Usage
let csvData = createCSV(
    headers: ["Name", "Email", "Age"],
    rows: [
        ["Alice", "alice@example.com", "30"],
        ["Bob", "bob@example.com", "25"]
    ]
)

// Result:
// Name,Email,Age
// Alice,alice@example.com,30
// Bob,bob@example.com,25
```

### Building API Query Strings

Construct URL-encoded request bodies:

```swift
func createURLEncodedBody(parameters: [String: String]) -> Data {
    var data = Data()

    let encodedPairs = parameters.map { key, value in
        let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
        let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value
        return "\(encodedKey)=\(encodedValue)"
    }

    data.append(encodedPairs.joined(separator: "&"))

    return data
}

// Usage
let bodyData = createURLEncodedBody(parameters: [
    "username": "alice",
    "password": "secret123",
    "remember": "true"
])

// Result: username=alice&password=secret123&remember=true
```

## Topics

### String Appending

Append UTF-8 encoded strings to binary data.

- ``Data/append(_:)``

## See Also

- ``RKUtils/Swift/String``
- ``RKUtils/Foundation/Bundle``
