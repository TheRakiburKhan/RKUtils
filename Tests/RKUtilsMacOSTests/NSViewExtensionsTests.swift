//
//  NSViewExtensionsTests.swift
//  RKUtils
//
//  Created by Rakibur Khan on 3/12/25.
//

import Testing
import Foundation
@testable import RKUtils
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
@testable import RKUtilsMacOSUI

@MainActor
@Suite("NSView Extensions")
struct NSViewExtensionsTests {

    // MARK: - Corner Radius Tests

    @Test("setCornerRadius sets the correct corner radius")
    func setCornerRadius() {
        let view = NSView()
        view.setCornerRadius(cornerRadius: 10)

        #expect(view.wantsLayer == true)
        #expect(view.layer?.cornerRadius == 10)
    }

    @Test("roundedCorner sets all corners by default")
    func roundedCornerAllCorners() {
        let view = NSView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.roundedCorner(radius: 15)

        #expect(view.wantsLayer == true)
        #expect(view.layer?.cornerRadius == 15)
        #expect(view.layer?.masksToBounds == false)
    }

    @Test("roundedCorner sets specific corners")
    func roundedCornerSpecificCorners() {
        let view = NSView()
        view.roundedCorner(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 20)

        #expect(view.wantsLayer == true)
        #expect(view.layer?.maskedCorners == [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        #expect(view.layer?.cornerRadius == 20)
    }

    @Test("rounded makes view circular")
    func rounded() {
        let view = NSView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.rounded()

        #expect(view.wantsLayer == true)
        #expect(view.layer?.cornerRadius == 50)
        #expect(view.layer?.masksToBounds == true)
    }

    // MARK: - Border Tests

    @Test("setBorder sets border width")
    func setBorderWidth() {
        let view = NSView()
        view.setBorder(width: 2)

        #expect(view.wantsLayer == true)
        #expect(view.layer?.borderWidth == 2)
    }

    @Test("setBorder sets border color")
    func setBorderColor() {
        let view = NSView()
        view.setBorder(color: .red)

        #expect(view.wantsLayer == true)
        #expect(view.layer?.borderColor == NSColor.red.cgColor)
    }

    @Test("setBorder sets background color")
    func setBorderBackground() {
        let view = NSView()
        view.setBorder(background: .blue)

        #expect(view.wantsLayer == true)
        #expect(view.layer?.backgroundColor == NSColor.blue.cgColor)
    }

    @Test("setBorder sets corner radius when provided")
    func setBorderWithCornerRadius() {
        let view = NSView()
        view.setBorder(radius: 10)

        #expect(view.wantsLayer == true)
        #expect(view.layer?.cornerRadius == 10)
    }

    // MARK: - Shadow Tests

    @Test("setShadow sets shadow properties")
    func setShadowProperties() {
        let view = NSView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.setShadow(
            color: .black,
            offset: CGSize(width: 0, height: 2),
            opacity: 0.5,
            radius: 4
        )

        #expect(view.wantsLayer == true)
        #expect(view.layer?.shadowColor == NSColor.black.cgColor)
        #expect(view.layer?.shadowOffset == CGSize(width: 0, height: 2))
        #expect(view.layer?.shadowOpacity == 0.5)
        #expect(view.layer?.shadowRadius == 4)
        #expect(view.layer?.masksToBounds == false)
    }

    @Test("setShadow sets corner radius")
    func setShadowCornerRadius() {
        let view = NSView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.setShadow(cornerRadius: 12)

        #expect(view.wantsLayer == true)
        #expect(view.layer?.cornerRadius == 12)
    }

    // MARK: - Gradient Tests

    @Test("setLinearGradientBackground adds gradient layer")
    func setLinearGradientBackground() {
        let view = NSView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.setLinearGradientBackground(
            colors: [.red, .blue],
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 1, y: 1)
        )

        #expect(view.wantsLayer == true)
        #expect(view.layer?.sublayers != nil)

        if let sublayersCount = view.layer?.sublayers?.count {
            #expect(sublayersCount > 0)
        }

        // Check if it's a gradient layer
        if let gradientLayer = view.layer?.sublayers?.first as? CAGradientLayer {
            #expect(gradientLayer.colors != nil)
            if let colorsCount = gradientLayer.colors?.count {
                #expect(colorsCount == 2)
            }
        }
    }

    // MARK: - Animation Tests

    @Test("showViewWithAnimation shows view")
    func showViewWithAnimationShow() {
        let view = NSView()
        view.isHidden = true
        view.alphaValue = 0.0

        view.showViewWithAnimation(isHidden: false)

        // Note: Animation is asynchronous, but we can check the final state will be set
        #expect(view.isHidden == false)
        #expect(view.alphaValue == 1.0)
    }

    @Test("showViewWithAnimation hides view")
    func showViewWithAnimationHide() {
        let view = NSView()
        view.isHidden = false
        view.alphaValue = 1.0

        view.showViewWithAnimation(isHidden: true)

        #expect(view.isHidden == true)
        #expect(view.alphaValue == 0.0)
    }

    // MARK: - Blur Effect Tests

    @Test("applyBlurEffect adds blur effect view")
    func applyBlurEffect() {
        let view = NSView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.applyBlurEffect()

        // Check that a subview was added
        #expect(view.subviews.count == 1)

        // Check if it's a NSVisualEffectView
        if let blurView = view.subviews.first as? NSVisualEffectView {
            #expect(blurView.frame == view.bounds)
            #expect(blurView.state == .active)
        }
    }

    @Test("applyBlurEffect with custom material")
    func applyBlurEffectWithMaterial() {
        let view = NSView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.applyBlurEffect(material: .hudWindow)

        // Check if it's a NSVisualEffectView with correct material
        if let blurView = view.subviews.first as? NSVisualEffectView {
            #expect(blurView.material == .hudWindow)
        }
    }
}
#endif
