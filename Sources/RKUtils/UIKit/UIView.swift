//
//  UIView.swift
//
//
//  Created by Rakibur Khan on 3/4/24.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

@MainActor
public extension UIView {
    /**
     Sets the corner radius of the view's layer.

     - Parameter cornerRadius: The radius to use for rounding corners.

     - Example:
     ```swift
     view.setCornerRadius(cornerRadius: 12.0)
     ```
     */
    func setCornerRadius(cornerRadius:CGFloat){
        self.layer.cornerRadius = cornerRadius
    }

    /**
     Rounds specific corners of the view with a custom radius.

     - Parameters:
        - corners: The corners to round (default: all corners)
        - cornerRadius: The radius for the corners (default: `10`)
        - clips: Whether to clip subviews to bounds (default: `false`)

     - Example:
     ```swift
     // Round top corners only
     view.roundedCorner(
         corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner],
         radius: 16.0
     )
     ```
     */
    func roundedCorner(corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner],radius cornerRadius: CGFloat = 10, clips: Bool = false) {
        layer.maskedCorners = corners
        layer.cornerRadius = cornerRadius
        clipsToBounds = clips
    }

    /**
     Makes the view fully rounded (circular or pill-shaped) based on its height.

     Uses half of the view's height as the corner radius to create a circular effect.

     - Parameter clips: Whether to clip subviews to bounds (default: `true`)

     - Example:
     ```swift
     // Make a button pill-shaped
     button.rounded()
     ```
     */
    func rounded(clips: Bool = true) {
        roundedCorner(radius: bounds.height / 2, clips: clips)
    }

    /**
     Applies a border to the view with optional background color and corner radius.

     - Parameters:
        - borderWidth: The width of the border (default: `1`)
        - borderColor: The color of the border (default: `.secondaryLabel`)
        - background: Optional background color for the layer
        - cornerRadius: Optional corner radius to apply

     - Example:
     ```swift
     view.setBorder(
         width: 2.0,
         color: .systemBlue,
         background: .white,
         radius: 8.0
     )
     ```
     */
    func setBorder(width borderWidth: CGFloat = 1, color borderColor: UIColor? = .secondaryLabel, background: UIColor? = nil, radius cornerRadius: CGFloat? = nil) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        layer.backgroundColor = background?.cgColor
        if let cornerRadius = cornerRadius {
            layer.cornerRadius = cornerRadius
        }
    }

    /**
     Applies a shadow to the view with customizable properties.

     - Parameters:
        - color: The shadow color (default: `.secondaryLabel`)
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
     let shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 8.0).cgPath
     view.setShadow(path: shadowPath, opacity: 0.3)
     ```

     - Note: Using a custom `path` improves rendering performance.
     */
    func setShadow(color: UIColor? = .secondaryLabel, background: UIColor? = nil, offset: CGSize = .zero, opacity: Float = 1, radius: CGFloat = 10, cornerRadius: CGFloat = 0, path: CGPath? = nil) {
        roundedCorner(radius: cornerRadius, clips: false)

        layer.bounds = bounds
        layer.backgroundColor = background?.cgColor
        layer.shadowColor = color?.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowPath = path
        layer.masksToBounds = false
    }

}

//MARK: Gradient Related
@MainActor
public extension UIView {
    /**
     Applies a linear gradient background to the view.

     The gradient layer is inserted at index 0, behind all other sublayers.

     - Parameters:
        - colors: Array of colors for the gradient
        - startPoint: Starting point of the gradient (default: top-left `(0, 0)`)
        - endPoint: Ending point of the gradient (default: bottom-right `(1, 1)`)
        - location: Optional array of color stop locations (0.0 to 1.0)
        - type: The gradient type (default: `.axial` for linear gradient)

     - Example:
     ```swift
     // Vertical gradient
     view.setLinearGradientBackground(
         colors: [.systemBlue, .systemPurple],
         startPoint: CGPoint(x: 0, y: 0),
         endPoint: CGPoint(x: 0, y: 1)
     )

     // Diagonal gradient with custom stops
     view.setLinearGradientBackground(
         colors: [.red, .orange, .yellow],
         startPoint: CGPoint(x: 0, y: 0),
         endPoint: CGPoint(x: 1, y: 1),
         location: [0.0, 0.5, 1.0]
     )

     // Radial gradient
     view.setLinearGradientBackground(
         colors: [.white, .black],
         type: .radial
     )
     ```
     */
    func setLinearGradientBackground(colors: [UIColor]?, startPoint: CGPoint? = nil, endPoint: CGPoint? = nil, location: [NSNumber]? = nil, type: CAGradientLayerType = .axial) {
        let gradientLayer = CAGradientLayer()

        gradientLayer.type = type

        gradientLayer.colors = colors?.map{ $0.cgColor }

        gradientLayer.locations = location

        gradientLayer.startPoint = startPoint ?? .init(x: 0, y: 0)
        gradientLayer.endPoint = endPoint ?? .init(x: 1, y: 1)

        gradientLayer.position = self.center

        gradientLayer.frame = bounds

        layer.insertSublayer(gradientLayer, at: 0)
    }
}

//MARK: UIView Animations
@MainActor
public extension UIView{
    /**
     Shows or hides the view with a cross-dissolve animation.

     Uses a 0.4 second transition with cross-dissolve effect.

     - Parameter isHidden: `true` to hide the view, `false` to show it

     - Example:
     ```swift
     view.showViewWithAnimation(isHidden: false)  // Fade in
     view.showViewWithAnimation(isHidden: true)   // Fade out
     ```
     */
    func showViewWithAnimation(isHidden: Bool) {
        UIView.transition(with: self, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
            self.isHidden = isHidden
        })
    }
}

@MainActor
public extension UIView {
    /**
     Applies a blur effect to the view.

     Adds a `UIVisualEffectView` with the specified blur style as a subview.

     - Parameter style: The blur style to apply (default: `.regular`)

     - Example:
     ```swift
     view.applyBlurEffect(style: .systemMaterial)
     view.applyBlurEffect(style: .dark)
     view.applyBlurEffect(style: .light)
     ```

     - Note: The blur view automatically resizes with the parent view.
     */
    func applyBlurEffect(style: UIBlurEffect.Style = .regular) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}

#endif
