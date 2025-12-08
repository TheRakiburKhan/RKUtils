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
    /**
     Sets the corner radius of the view.

     - Parameter cornerRadius: The radius to use when rounding corners.

     - Example:
     ```swift
     view.setCornerRadius(cornerRadius: 8.0)
     ```

     - Note: Automatically enables layer backing for the view.
     */
    func setCornerRadius(cornerRadius: CGFloat) {
        self.wantsLayer = true
        self.layer?.cornerRadius = cornerRadius
    }

    /**
     Rounds specific corners of the view with a custom radius.

     - Parameters:
        - corners: The corners to round (default: all corners)
        - cornerRadius: The radius to apply (default: `10`)
        - clips: Whether to clip subviews to bounds (default: `false`)

     - Example:
     ```swift
     // Round only top corners
     view.roundedCorner(
         corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner],
         radius: 12.0
     )

     // Round all corners with clipping
     view.roundedCorner(radius: 8.0, clips: true)
     ```

     - Note: Automatically enables layer backing for the view.
     */
    func roundedCorner(corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius cornerRadius: CGFloat = 10, clips: Bool = false) {
        self.wantsLayer = true
        layer?.maskedCorners = corners
        layer?.cornerRadius = cornerRadius
        layer?.masksToBounds = clips
    }

    /**
     Makes the view fully rounded (circular or pill-shaped).

     Uses half of the view's height as the corner radius to create a circular or pill shape.

     - Parameter clips: Whether to clip subviews to bounds (default: `true`)

     - Example:
     ```swift
     // Create a circular view (if width == height)
     view.rounded()

     // Create a pill-shaped button
     button.rounded()
     ```

     - Note: For best results with circular views, ensure width equals height.
     */
    func rounded(clips: Bool = true) {
        roundedCorner(radius: bounds.height / 2, clips: clips)
    }

    /**
     Applies a border to the view with optional background and corner radius.

     - Parameters:
        - borderWidth: The width of the border (default: `1`)
        - borderColor: The border color (default: `.secondaryLabelColor`)
        - background: Optional background color for the layer
        - cornerRadius: Optional corner radius to apply

     - Example:
     ```swift
     // Simple border
     view.setBorder()

     // Custom border with background
     view.setBorder(
         width: 2.0,
         color: .systemBlue,
         background: .white,
         radius: 8.0
     )
     ```

     - Note: Automatically enables layer backing for the view.
     */
    func setBorder(width borderWidth: CGFloat = 1, color borderColor: NSColor? = .secondaryLabelColor, background: NSColor? = nil, radius cornerRadius: CGFloat? = nil) {
        self.wantsLayer = true
        layer?.borderWidth = borderWidth
        layer?.borderColor = borderColor?.cgColor
        layer?.backgroundColor = background?.cgColor
        if let cornerRadius = cornerRadius {
            layer?.cornerRadius = cornerRadius
        }
    }

    /**
     Applies a shadow to the view with customizable properties.

     - Parameters:
        - color: The shadow color (default: `.secondaryLabelColor`)
        - background: Optional background color for the layer
        - offset: The shadow offset (default: `.zero`)
        - opacity: The shadow opacity (default: `1`)
        - radius: The shadow blur radius (default: `10`)
        - cornerRadius: Corner radius to apply (default: `0`)
        - path: Optional custom shadow path for better performance

     - Example:
     ```swift
     view.setShadow(
         color: .black,
         offset: CGSize(width: 0, height: 2),
         opacity: 0.3,
         radius: 4.0,
         cornerRadius: 8.0
     )

     // With custom path for better performance
     let shadowPath = NSBezierPath(roundedRect: view.bounds, xRadius: 8.0, yRadius: 8.0).cgPath
     view.setShadow(path: shadowPath, opacity: 0.3)
     ```

     - Note: Using a custom `path` improves rendering performance. Automatically enables layer backing.
     */
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
    /**
     Applies a linear gradient background to the view.

     - Parameters:
        - colors: Array of colors for the gradient
        - startPoint: Starting point in unit coordinate space (default: top-left `(0, 0)`)
        - endPoint: Ending point in unit coordinate space (default: bottom-right `(1, 1)`)
        - location: Optional array defining color stop locations (values between 0 and 1)
        - type: The gradient type (default: `.axial` for linear)

     - Example:
     ```swift
     // Vertical gradient from top to bottom
     view.setLinearGradientBackground(
         colors: [.systemBlue, .systemPurple],
         startPoint: CGPoint(x: 0.5, y: 0),
         endPoint: CGPoint(x: 0.5, y: 1)
     )

     // Diagonal gradient with color stops
     view.setLinearGradientBackground(
         colors: [.red, .yellow, .green],
         location: [0, 0.5, 1]
     )
     ```

     - Note: AppKit uses bottom-left origin, unlike UIKit's top-left. Automatically enables layer backing.
     */
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
    /**
     Shows or hides the view with a fade animation.

     Animates both the `isHidden` property and `alphaValue` over 0.4 seconds.

     - Parameter isHidden: `true` to hide the view, `false` to show it.

     - Example:
     ```swift
     // Hide with fade-out
     view.showViewWithAnimation(isHidden: true)

     // Show with fade-in
     view.showViewWithAnimation(isHidden: false)
     ```

     - Note: Uses `NSAnimationContext` for smooth AppKit animations.
     */
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
    /**
     Applies a visual blur effect to the view using `NSVisualEffectView`.

     Adds a blur effect view behind all other subviews with configurable material and blending.

     - Parameters:
        - material: The visual effect material (default: `.contentBackground`)
        - blendingMode: The blending mode (default: `.behindWindow`)

     - Example:
     ```swift
     // Standard background blur
     view.applyBlurEffect()

     // Custom material and blending
     view.applyBlurEffect(
         material: .hudWindow,
         blendingMode: .withinWindow
     )
     ```

     - Note: The blur view automatically resizes with the parent view. Available materials include `.contentBackground`, `.hudWindow`, `.sidebar`, and more.
     */
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
