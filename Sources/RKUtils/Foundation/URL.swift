//
//  URL.swift
//  RKUtils
//
//
//  Created by Rakibur Khan on 2/4/24.
//

import Foundation

public extension URL {
    /**
     Reads the contents of this file URL as a UTF-8 encoded string.

     - Returns: The file contents as a string, or `nil` if reading fails.

     - Example:
     ```swift
     let fileURL = URL(fileURLWithPath: "/path/to/file.txt")
     let content = fileURL.readFromFile()
     ```

     - Note: Errors are printed to console with `debugPrint`.
     */
    func readFromFile() -> String? {
        do {
            return try String(contentsOf: self, encoding: .utf8)
        } catch {
            print("Error:: Cant read file \(self)")
            debugPrint(error)
            return nil
        }
    }
}
