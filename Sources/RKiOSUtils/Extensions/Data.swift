//
//  Data.swift
//  
//
//  Created by Rakibur Khan on 2/4/24.
//

import Foundation

public extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
