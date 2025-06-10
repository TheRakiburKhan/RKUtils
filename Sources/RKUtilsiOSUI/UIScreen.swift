//
//  UIScreen.swift
//  
//
//  Created by Rakibur Khan on 2/4/24.
//

#if canImport(UIKit)
import UIKit

public extension UIScreen {
    var minEdge: CGFloat {
        return UIScreen.main.bounds.minEdge
    }
}
#endif
