//
//  String.swift
//  RKUtils
//
//
//  Created by Rakibur Khan on 2/4/24.
//

import Foundation

public extension String {
    func iso8601Date(options: ISO8601DateFormatter.Options = [.withTimeZone]) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = options
        
        return formatter.date(from: self)
    }
    
    func toDate(stringFormat format: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone? = nil) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        if let timeZone = timeZone {
            formatter.timeZone = timeZone
        }
        
        return formatter.date(from: self)
    }
    
    var toBase64: String? {
        let utf8 = self.data(using: .utf8)
        let base64 = utf8?.base64EncodedString()
        return base64
    }
    
    func isValidEmail() -> Bool {
        // More accurate email regex that:
        // - Requires at least one char before @
        // - Domain can't start/end with hyphen or dot
        // - Domain parts separated by literal dots (escaped \.)
        // - TLD must be at least 2 letters
        let emailRegex = #"^[A-Z0-9][A-Z0-9._%+-]*@[A-Z0-9]([A-Z0-9-]*[A-Z0-9])?(\.[A-Z0-9]([A-Z0-9-]*[A-Z0-9])?)*\.[A-Z]{2,}$"#

        // Use native Swift regex matching (cross-platform compatible)
        return self.range(of: emailRegex, options: [.regularExpression, .caseInsensitive]) != nil
    }
    
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
