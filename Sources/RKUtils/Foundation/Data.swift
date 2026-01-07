//
//  Data.swift
//  RKUtils
//
//
//  Created by Rakibur Khan on 2/4/24.
//

import Foundation

public extension Data {
    /**
     Appends a string to the data using UTF-8 encoding.

     If the string can be encoded as UTF-8 data, it is appended to the receiver.

     - Parameter string: The string to append.

     - Example:
     ```swift
     var data = Data()
     data.append("Hello, ")
     data.append("World!")

     let result = String(data: data, encoding: .utf8)  // "Hello, World!"
     ```
     */
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
