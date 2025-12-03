//
//  UIViewExtensionsTests.swift
//  RKUtils
//
//  Created by Rakibur Khan on 3/12/25.
//

import Testing
import Foundation
@testable import RKUtils
#if canImport(UIKit) && !os(watchOS)
import UIKit
@testable import RKUtilsUI

@MainActor
@Suite("UIView Extensions")
struct UIViewExtensionsTests {

    // MARK: - Corner Radius Tests

    @Test("setCornerRadius sets the correct corner radius")
    func setCornerRadius() {
        let view = UIView()
        view.setCornerRadius(cornerRadius: 10)

        #expect(view.layer.cornerRadius == 10)
    }

    @Test("roundedCorner sets all corners by default")
    func roundedCornerAllCorners() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.roundedCorner(radius: 15)

        #expect(view.layer.cornerRadius == 15)
        #expect(view.clipsToBounds == false)
    }

    @Test("roundedCorner sets specific corners")
    func roundedCornerSpecificCorners() {
        let view = UIView()
        view.roundedCorner(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 20)

        #expect(view.layer.maskedCorners == [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        #expect(view.layer.cornerRadius == 20)
    }

    @Test("rounded makes view circular")
    func rounded() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.rounded()

        #expect(view.layer.cornerRadius == 50)
        #expect(view.clipsToBounds == true)
    }

    // MARK: - Border Tests

    @Test("setBorder sets border width")
    func setBorderWidth() {
        let view = UIView()
        view.setBorder(width: 2)

        #expect(view.layer.borderWidth == 2)
    }

    @Test("setBorder sets border color")
    func setBorderColor() {
        let view = UIView()
        view.setBorder(color: .red)

        #expect(view.layer.borderColor == UIColor.red.cgColor)
    }

    @Test("setBorder sets background color")
    func setBorderBackground() {
        let view = UIView()
        view.setBorder(background: .blue)

        #expect(view.layer.backgroundColor == UIColor.blue.cgColor)
    }

    @Test("setBorder sets corner radius when provided")
    func setBorderWithCornerRadius() {
        let view = UIView()
        view.setBorder(radius: 10)

        #expect(view.layer.cornerRadius == 10)
    }

    // MARK: - Shadow Tests

    @Test("setShadow sets shadow properties")
    func setShadowProperties() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.setShadow(
            color: .black,
            offset: CGSize(width: 0, height: 2),
            opacity: 0.5,
            radius: 4
        )

        #expect(view.layer.shadowColor == UIColor.black.cgColor)
        #expect(view.layer.shadowOffset == CGSize(width: 0, height: 2))
        #expect(view.layer.shadowOpacity == 0.5)
        #expect(view.layer.shadowRadius == 4)
        #expect(view.layer.masksToBounds == false)
    }

    @Test("setShadow sets corner radius")
    func setShadowCornerRadius() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.setShadow(cornerRadius: 12)

        #expect(view.layer.cornerRadius == 12)
    }

    // MARK: - Gradient Tests

    @Test("setLinearGradientBackground adds gradient layer")
    func setLinearGradientBackground() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.setLinearGradientBackground(
            colors: [.red, .blue],
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 1, y: 1)
        )

        // Check that a sublayer was added
        #expect(view.layer.sublayers != nil)
        #expect(view.layer.sublayers!.count > 0)

        // Check if it's a gradient layer
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            #expect(gradientLayer.colors != nil)
            #expect(gradientLayer.colors!.count == 2)
        }
    }

    // MARK: - Animation Tests

    @Test("showViewWithAnimation shows view")
    func showViewWithAnimationShow() {
        let view = UIView()
        view.isHidden = true

        view.showViewWithAnimation(isHidden: false)

        // Note: Animation is asynchronous, but we can check the final state will be set
        // In a real test, you'd use XCTestExpectation for async testing
        #expect(view.isHidden == false)
    }

    @Test("showViewWithAnimation hides view")
    func showViewWithAnimationHide() {
        let view = UIView()
        view.isHidden = false

        view.showViewWithAnimation(isHidden: true)

        #expect(view.isHidden == true)
    }

    // MARK: - Blur Effect Tests

    @Test("applyBlurEffect adds blur effect view")
    func applyBlurEffect() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.applyBlurEffect(style: .light)

        // Check that a subview was added
        #expect(view.subviews.count == 1)

        // Check if it's a UIVisualEffectView
        if let blurView = view.subviews.first as? UIVisualEffectView {
            #expect(blurView.frame == view.bounds)
        }
    }
}
#endif
