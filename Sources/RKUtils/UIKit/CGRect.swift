//
//  CGRect.swift
//
//
//  Created by Rakibur Khan on 2/4/24.
//

#if canImport(CoreGraphics)
import CoreGraphics

public extension CGRect {
    /**
     Returns the smaller dimension (width or height) of the rectangle.

     Useful for determining the limiting dimension when fitting content or creating circular elements.

     - Returns: The minimum of width and height.

     - Example:
     ```swift
     let rect = CGRect(x: 0, y: 0, width: 100, height: 150)
     let smallestSide = rect.minEdge  // 100

     // Use for circular avatars
     let circleRadius = avatarRect.minEdge / 2
     ```
     */
    var minEdge: CGFloat {
        return min(self.size.width, self.size.height)
    }
}
#endif
