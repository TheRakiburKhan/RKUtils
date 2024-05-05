//
//  String.swift
//  
//
//  Created by Rakibur Khan on 2/4/24.
//

import UIKit

public extension String {
    func iso8601Date(options: ISO8601DateFormatter.Options = [.withTimeZone]) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = options
        
        return formatter.date(from: self)
    }
    
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.date(from: self)
    }
}
