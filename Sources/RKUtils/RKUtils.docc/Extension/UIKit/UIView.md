# ``RKUtils/UIKit/UIView``

Styling utilities for corner radius, borders, shadows, gradients, blur effects, and animations.

## Overview

UIView extensions provide convenient methods for common styling tasks that would otherwise require verbose layer configuration. These utilities eliminate boilerplate code and make view styling more readable and maintainable.

### Corner Radius

Apply corner radius with simple one-line methods:

```swift
// Set uniform corner radius
view.setCornerRadius(cornerRadius: 12.0)

// Round specific corners only
view.roundedCorner(
    corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner],
    radius: 16.0
)

// Make view fully rounded (circular/pill-shaped)
button.rounded()  // Uses height/2 as radius
```

### Borders

Apply borders with optional background and corner radius:

```swift
// Simple border
view.setBorder(
    width: 2.
    color: .systemBlue
)

// Border with background and rounded corners
view.setBorder(
    width: 1.0,
    color: .separator,
    background: .systemBackground,
    radius: 8.0
)
```

### Shadows

Apply drop shadows with full customization:

```swift
// Standard shadow
view.setShadow(
    color: .black,
    offset: CGSize(width: 0, height: 2),
    opacity: 0.3,
    radius: 4.0,
    cornerRadius: 8.0
)

// High-performance shadow with custom path
let shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 8.0).cgPath
view.setShadow(
    color: .black,
    background: .white,
    offset: CGSize(width: 0, height: 4),
    opacity: 0.2,
    radius: 8.0,
    cornerRadius: 8.0,
    path: shadowPath
)
```

### Gradients

Apply linear or radial gradient backgrounds:

```swift
// Vertical gradient
view.setLinearGradientBackground(
    colors: [.systemBlue, .systemPurple],
    startPoint: CGPoint(x: 0, y: 0),
    endPoint: CGPoint(x: 0, y: 1)
)

// Diagonal gradient with color stops
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

### Blur Effects

Apply blur effects using UIVisualEffectView:

```swift
// Apply system blur
view.applyBlurEffect(style: .systemMaterial)

// Different blur styles
view.applyBlurEffect(style: .dark)
view.applyBlurEffect(style: .light)
view.applyBlurEffect(style: .prominent)
```

### Animations

Animate view visibility with fade transitions:

```swift
// Hide with animation
view.showViewWithAnimation(isHidden: true)

// Show with animation
view.showViewWithAnimation(isHidden: false)
```

### Card-Style Views

Create modern card designs with shadows and rounded corners:

```swift
class CardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    private func setupStyle() {
        backgroundColor = .systemBackground
        setCornerRadius(cornerRadius: 12)
        setShadow(
            color: .black,
            offset: CGSize(width: 0, height: 2),
            opacity: 0.1,
            radius: 8,
            cornerRadius: 12
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
```

### Profile Avatars

Create circular image views with borders:

```swift
func setupAvatarImage() {
    let avatarSize: CGFloat = 80

    avatarImageView.frame.size = CGSize(width: avatarSize, height: avatarSize)
    avatarImageView.rounded()  // Makes it circular
    avatarImageView.setBorder(
        width: 2,
        color: .systemBlue
    )
    avatarImageView.clipsToBounds = true
}
```

### Gradient Backgrounds

Apply eye-catching gradient backgrounds to view controllers:

```swift
class WelcomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Diagonal gradient
        view.setLinearGradientBackground(
            colors: [.systemBlue, .systemPurple],
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 1, y: 1)
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Update gradient frame if needed
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
}
```

### Loading Overlays

Show blur effect during loading states:

```swift
class ContentViewController: UIViewController {
    func showLoadingState() {
        contentView.applyBlurEffect(style: .regular)

        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tag = 999  // Tag for easy removal
        contentView.addSubview(spinner)

        // Center manually or using constraints
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        spinner.startAnimating()
    }

    func hideLoadingState() {
        // Remove blur view
        contentView.subviews
            .compactMap { $0 as? UIVisualEffectView }
            .forEach { $0.removeFromSuperview() }

        // Remove spinner
        contentView.viewWithTag(999)?.removeFromSuperview()
    }
}
```

### Rounded Buttons

Create pill-shaped buttons and custom corner designs:

```swift
class CustomButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()

        // Pill shape
        rounded()

        // Add border
        setBorder(
            width: 1,
            color: tintColor,
            radius: bounds.height / 2
        )
    }
}

// Top-rounded container
let container = UIView()
container.backgroundColor = .systemBackground
container.roundedCorner(
    corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner],
    radius: 20,
    clips: true
)
```

### Visibility Transitions

Smoothly show/hide views with animations:

```swift
class NotificationBanner: UIView {
    func show() {
        isHidden = false
        showViewWithAnimation(isHidden: false)

        // Auto-hide after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hide()
        }
    }

    func hide() {
        showViewWithAnimation(isHidden: true)
    }
}
```

### Elevated Cards with Shadows

Create depth with shadows and proper corner radius:

```swift
func styleProductCard(_ card: UIView) {
    let shadowPath = UIBezierPath(
        roundedRect: card.bounds,
        cornerRadius: 16
    ).cgPath

    card.setShadow(
        color: .black,
        background: .systemBackground,
        offset: CGSize(width: 0, height: 4),
        opacity: 0.15,
        radius: 12,
        cornerRadius: 16,
        path: shadowPath
    )
}
```

## Topics

### Corner Radius

Round view corners uniformly or selectively.

- ``UIView/setCornerRadius(cornerRadius:)``
- ``UIView/roundedCorner(corners:radius:clips:)``
- ``UIView/rounded(clips:)``

### Borders

Apply borders with optional styling.

- ``UIView/setBorder(width:color:background:radius:)``

### Shadows

Apply drop shadows with customization.

- ``UIView/setShadow(color:background:offset:opacity:radius:cornerRadius:path:)``

### Gradients

Apply gradient backgrounds.

- ``UIView/setLinearGradientBackground(colors:startPoint:endPoint:location:type:)``

### Blur Effects

Apply visual blur effects.

- ``UIView/applyBlurEffect(style:)``

### Animations

Animate view visibility.

- ``UIView/showViewWithAnimation(isHidden:)``

## See Also

- <doc:UIKit-Guide>
- ``RKUtilsUI/UIKit/UIColor``
- ``RKUtilsUI/UIKit/UITextField``
