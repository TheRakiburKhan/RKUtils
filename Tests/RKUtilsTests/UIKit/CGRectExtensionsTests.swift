//
//  CGRectExtensionsTests.swift
//  RKUtils
//
//  Created by Rakibur Khan on 3/12/25.
//

import Testing
import Foundation
@testable import RKUtils
#if canImport(UIKit)
import UIKit
@testable import RKUtils

@Suite("CGRect Extensions")
struct CGRectExtensionsTests {

    @Test("minEdge returns minimum of width and height")
    func minEdgeSquare() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        #expect(rect.minEdge == 100)
    }

    @Test("minEdge returns width when width is smaller")
    func minEdgeWidthSmaller() {
        let rect = CGRect(x: 0, y: 0, width: 50, height: 100)
        #expect(rect.minEdge == 50)
    }

    @Test("minEdge returns height when height is smaller")
    func minEdgeHeightSmaller() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        #expect(rect.minEdge == 50)
    }

    @Test("minEdge with zero dimensions")
    func minEdgeZero() {
        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        #expect(rect.minEdge == 0)
    }

    @Test("minEdge with negative dimensions")
    func minEdgeNegative() {
        let rect = CGRect(x: 0, y: 0, width: -10, height: 20)
        #expect(rect.minEdge == 10.0)
    }
}
#endif
