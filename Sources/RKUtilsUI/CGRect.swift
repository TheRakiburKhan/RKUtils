//
//  CGRect.swift
//
//
//  Created by Rakibur Khan on 2/4/24.
//

#if canImport(CoreGraphics)
import CoreGraphics

public extension CGRect {
    var minEdge: CGFloat {
        return min(self.size.width, self.size.height)
    }
}
#endif
