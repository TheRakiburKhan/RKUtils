//
//  Bundle.swift
//  
//
//  Created by Rakibur Khan on 2/4/24.
//

import Foundation

public extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var releaseVersionNumberPretty: String {
        return "v\(releaseVersionNumber ?? "1.0.0")"
    }
    
    var bundleDisplayName: String {
        return infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    }
}
