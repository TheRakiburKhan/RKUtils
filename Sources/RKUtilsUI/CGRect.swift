//
//  CGRect.swift
//  
//
//  Created by Rakibur Khan on 2/4/24.
//

import CoreFoundation

public extension CGRect {
    var minEdge: CGFloat {
        return min(self.size.width, self.size.height)
    }
}
