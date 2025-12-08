//
//  Bundle.swift
//  RKUtils
//
//
//  Created by Rakibur Khan on 2/4/24.
//

import Foundation

public extension Bundle {
    /**
     The release version number of the bundle (e.g., "2.1.1").

     Retrieves the value of `CFBundleShortVersionString` from the bundle's `Info.plist`.

     - Returns: The release version string, or `nil` if not found.

     - Example:
     ```swift
     let version = Bundle.main.releaseVersionNumber  // "2.1.1"
     ```
     */
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }

    /**
     The build number of the bundle (e.g., "42").

     Retrieves the value of `CFBundleVersion` from the bundle's `Info.plist`.

     - Returns: The build version string, or `nil` if not found.

     - Example:
     ```swift
     let build = Bundle.main.buildVersionNumber  // "42"
     ```
     */
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }

    /**
     A pretty-formatted version string with a "v" prefix (e.g., "v2.1.1").

     Uses ``releaseVersionNumber`` with a "v" prefix, or "v0.0.0" if version is not available.

     - Returns: A formatted version string.

     - Example:
     ```swift
     let prettyVersion = Bundle.main.releaseVersionNumberPretty  // "v2.1.1"
     ```
     */
    var releaseVersionNumberPretty: String {
        return "v\(releaseVersionNumber ?? "0.0.0")"
    }

    /**
     The display name of the bundle as shown to users.

     Retrieves the value of `CFBundleDisplayName` from the bundle's `Info.plist`.

     - Returns: The display name string, or an empty string if not found.

     - Example:
     ```swift
     let appName = Bundle.main.bundleDisplayName  // "My App"
     ```
     */
    var bundleDisplayName: String {
        return infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    }
}
