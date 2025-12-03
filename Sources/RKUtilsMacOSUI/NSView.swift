//
//  NSView.swift
//  RKUtils
//
//  Created by Rakibur Khan on 3/12/25.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

@MainActor
public extension NSView {
    func setCornerRadius(cornerRadius: CGFloat) {
        self.wantsLayer = true
        self.layer?.cornerRadius = cornerRadius
    }

    func roundedCorner(corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius cornerRadius: CGFloat = 10, clips: Bool = false) {
        self.wantsLayer = true
        layer?.maskedCorners = corners
        layer?.cornerRadius = cornerRadius
        layer?.masksToBounds = clips
    }

    func rounded(clips: Bool = true) {
        roundedCorner(radius: bounds.height / 2, clips: clips)
    }

    func setBorder(width borderWidth: CGFloat = 1, color borderColor: NSColor? = .secondaryLabelColor, background: NSColor? = nil, radius cornerRadius: CGFloat? = nil) {
        self.wantsLayer = true
        layer?.borderWidth = borderWidth
        layer?.borderColor = borderColor?.cgColor
        layer?.backgroundColor = background?.cgColor
        if let cornerRadius = cornerRadius {
            layer?.cornerRadius = cornerRadius
        }
    }

    func setShadow(color: NSColor? = .secondaryLabelColor, background: NSColor? = nil, offset: CGSize = .zero, opacity: Float = 1, radius: CGFloat = 10, cornerRadius: CGFloat = 0, path: CGPath? = nil) {
        self.wantsLayer = true
        roundedCorner(radius: cornerRadius, clips: false)

        layer?.bounds = bounds
        layer?.backgroundColor = background?.cgColor
        layer?.shadowColor = color?.cgColor
        layer?.shadowOffset = offset
        layer?.shadowOpacity = opacity
        layer?.shadowRadius = radius
        layer?.shadowPath = path
        layer?.masksToBounds = false
    }
}

//MARK: Gradient Related
@MainActor
public extension NSView {
    func setLinearGradientBackground(colors: [NSColor]?, startPoint: CGPoint? = nil, endPoint: CGPoint? = nil, location: [NSNumber]? = nil, type: CAGradientLayerType = .axial) {
        self.wantsLayer = true

        let gradientLayer = CAGradientLayer()

        gradientLayer.type = type

        gradientLayer.colors = colors?.map { $0.cgColor }

        gradientLayer.locations = location

        gradientLayer.startPoint = startPoint ?? .init(x: 0, y: 0)
        gradientLayer.endPoint = endPoint ?? .init(x: 1, y: 1)

        // Note: NSView coordinate system is different from UIView
        // AppKit uses bottom-left origin, UIKit uses top-left
        gradientLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)

        gradientLayer.frame = bounds

        layer?.insertSublayer(gradientLayer, at: 0)
    }
}

//MARK: NSView Animations
@MainActor
public extension NSView {
    func showViewWithAnimation(isHidden: Bool) {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.4
            context.allowsImplicitAnimation = true
            self.isHidden = isHidden
            self.alphaValue = isHidden ? 0.0 : 1.0
        }
    }
}

@MainActor
public extension NSView {
    func applyBlurEffect(material: NSVisualEffectView.Material = .contentBackground, blendingMode: NSVisualEffectView.BlendingMode = .behindWindow) {
        let blurEffectView = NSVisualEffectView(frame: bounds)
        blurEffectView.material = material
        blurEffectView.blendingMode = blendingMode
        blurEffectView.state = .active
        blurEffectView.autoresizingMask = [.width, .height]

        // Insert at the back
        addSubview(blurEffectView, positioned: .below, relativeTo: nil)
    }
}

#endif
