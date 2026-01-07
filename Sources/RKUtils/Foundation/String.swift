//
//  String.swift
//  RKUtils
//
//
//  Created by Rakibur Khan on 2/4/24.
//

import Foundation

public extension String {
    /**
     Parses the string as an ISO8601 date.

     - Parameter options: The ISO8601 format options to use (default: `.withTimeZone`)

     - Returns: A `Date` object if parsing succeeds, `nil` otherwise.

     - Example:
     ```swift
     let isoString = "2025-01-15T10:30:00Z"
     let date = isoString.iso8601Date()
     ```
     */
    func iso8601Date(options: ISO8601DateFormatter.Options = [.withTimeZone]) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = options

        return formatter.date(from: self)
    }

    /**
     Converts the string to a `Date` using a custom date format.

     - Parameters:
        - format: The date format string (default: `"yyyy-MM-dd HH:mm:ss"`)
        - timeZone: Optional timezone for date parsing. If `nil`, uses the formatter's default.

     - Returns: A `Date` object if parsing succeeds, `nil` otherwise.

     - Example:
     ```swift
     let dateString = "2025-01-15 10:30:00"
     let date = dateString.toDate(stringFormat: "yyyy-MM-dd HH:mm:ss")

     // With timezone
     let nyDate = dateString.toDate(
         stringFormat: "yyyy-MM-dd HH:mm:ss",
         timeZone: TimeZone(identifier: "America/New_York")
     )
     ```
     */
    func toDate(stringFormat format: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone? = nil) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        if let timeZone = timeZone {
            formatter.timeZone = timeZone
        }

        return formatter.date(from: self)
    }

    /**
     Encodes the string to a Base64 string.

     - Returns: A Base64-encoded string, or `nil` if encoding fails.

     - Example:
     ```swift
     let text = "Hello, World!"
     let base64 = text.toBase64  // "SGVsbG8sIFdvcmxkIQ=="
     ```
     */
    var toBase64: String? {
        let utf8 = self.data(using: .utf8)
        let base64 = utf8?.base64EncodedString()
        return base64
    }

    /**
     Validates whether the string is a valid email address.

     Uses a comprehensive regex pattern that ensures:
     - At least one character before the `@` symbol
     - Domain cannot start or end with a hyphen or dot
     - Top-level domain (TLD) must be at least 2 letters
     - Supports modern regex on iOS 16+/macOS 13+ with fallback for older versions

     - Returns: `true` if the string is a valid email address, `false` otherwise.

     - Example:
     ```swift
     "user@example.com".isValidEmail()  // true
     "invalid-email".isValidEmail()     // false
     ```

     - Note: Uses native Swift regex on newer OS versions for better performance.
     */
    func isValidEmail() -> Bool {
        // More accurate email regex that:
        // - Requires at least one char before @
        // - Domain can't start/end with hyphen or dot
        // - Domain parts separated by literal dots (escaped \.)
        // - TLD must be at least 2 letters
        let emailRegex = #"^[A-Z0-9][A-Z0-9._%+-]*@[A-Z0-9]([A-Z0-9-]*[A-Z0-9])?(\.[A-Z0-9]([A-Z0-9-]*[A-Z0-9])?)*\.[A-Z]{2,}$"#

        #if canImport(Darwin)
        // Use modern Regex on newer OS versions (macOS 13+, iOS 16+)
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            let regex = /^[A-Z0-9][A-Z0-9._%+-]*@[A-Z0-9]([A-Z0-9-]*[A-Z0-9])?(\.[A-Z0-9]([A-Z0-9-]*[A-Z0-9])?)*\.[A-Z]{2,}$/
            return (try? regex.ignoresCase().wholeMatch(in: self)) != nil
        }
        #endif

        // Fallback: Use NSString range method (works on all platforms and OS versions)
        return self.range(of: emailRegex, options: [.regularExpression, .caseInsensitive]) != nil
    }

    /**
     Reads the contents of a text file into a string.

     - Parameter fileURL: The URL of the file to read. If `nil`, returns `nil`.

     - Returns: The file contents as a UTF-8 encoded string, or `nil` if reading fails.

     - Example:
     ```swift
     let fileURL = URL(fileURLWithPath: "/path/to/file.txt")
     let content = "".readFromFile(fileURL: fileURL)
     ```

     - Note: Errors are printed to console with `debugPrint`.
     */
    func readFromFile(fileURL: URL?) -> String? {
        if let url = fileURL {
            //reading
            do {
                let text = try String(contentsOf: url, encoding: .utf8)
                return text
            } catch {
                print("Error:: Cant read file \(String(describing: fileURL))")
                debugPrint(error)
            }
        }

        return nil
    }

    /**
     Writes the string to a file at the specified URL.

     - Parameter fileURL: The destination URL for the file. If `nil`, does nothing.

     - Example:
     ```swift
     let text = "Hello, World!"
     let fileURL = URL(fileURLWithPath: "/path/to/output.txt")
     text.writeToFile(saveLocation: fileURL)
     ```

     - Note: Errors are printed to console with `debugPrint`. The write is not atomic.
     */
    func writeToFile(saveLocation fileURL: URL?){
        if let url = fileURL {
            do {
                try self.write(to: url, atomically: false, encoding: .utf8)
            }
            catch {
                print("Error:: Cant write file \(String(describing: fileURL))")
                debugPrint(error)
            }
        }
    }
}
