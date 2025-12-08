//
//  UIScreen.swift
//  
//
//  Created by Rakibur Khan on 2/4/24.
//

#if canImport(UIKit) && !os(visionOS) && !os(watchOS)
import UIKit

public extension UIScreen {
    /**
     Returns the smaller dimension (width or height) of the main screen's bounds.

     Useful for responsive layouts that need to adapt to the device's smaller dimension.

     - Returns: The minimum of screen width and height in points.

     - Example:
     ```swift
     let smallestDimension = UIScreen.main.minEdge
     // On iPhone 14 Pro in portrait: 393 (width is smaller than height)
     // On iPad Pro 12.9" in portrait: 1024 (width is smaller than height)
     ```

     - Note: Uses the `bounds` of the main screen, not `nativeBounds`. Values are in points, not pixels.
     */
    var minEdge: CGFloat {
        return UIScreen.main.bounds.minEdge
    }
}
#endif
