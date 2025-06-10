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
        let emailRegex =
        #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return predicate.evaluate(with: self)
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
