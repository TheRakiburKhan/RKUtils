//
//  CGRect.swift
//  
//
//  Created by Rakibur Khan on 2/4/24.
//

import UIKit

public extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }
}
