//
//  UIScreenExtensionsTests.swift
//  RKUtils
//
//  Created by Rakibur Khan on 8/12/24.
//

#if canImport(UIKit) && !os(visionOS) && !os(watchOS)
import Testing
import UIKit
@testable import RKUtils

@MainActor
@Suite("UIScreen Extensions")
struct UIScreenExtensionsTests {

    @Test("minEdge returns minimum screen dimension")
    func minEdge() {
        let screen = UIScreen.main
        let minEdge = screen.minEdge
        let expectedMinEdge = min(screen.bounds.width, screen.bounds.height)

        #expect(minEdge == expectedMinEdge)
        #expect(minEdge > 0)
    }

    @Test("minEdge is always positive")
    func minEdgePositive() {
        let minEdge = UIScreen.main.minEdge
        #expect(minEdge > 0)
    }
}
#endif
