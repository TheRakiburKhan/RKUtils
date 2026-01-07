//
//  ProcessInfo.swift
//  RKUtils
//
//
//  Created by Rakibur Khan on 6/1/26.
//

import Foundation

public extension ProcessInfo {
    /**
     Indicates whether the app is running in a SwiftUI preview environment.

     This property checks the `XCODE_RUNNING_FOR_PREVIEWS` environment variable which is set
     by Xcode when running SwiftUI previews. This is useful for providing mock data or
     adjusting behavior specifically for previews.

     - Returns: `true` if running in a SwiftUI preview, `false` otherwise.

     - Example:
     ```swift
     if ProcessInfo.processInfo.isPreview {
         // Use mock data for preview
         return sampleData
     } else {
         // Load real data
         return loadDataFromAPI()
     }
     ```

     - Note: This only works at runtime. For compile-time preview detection, use SwiftUI's
     built-in preview mechanisms.
     */
    var isPreview: Bool {
        return environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
