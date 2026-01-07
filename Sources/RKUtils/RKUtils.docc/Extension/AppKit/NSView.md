# ``RKUtils/AppKit/NSView``

UIKit-style styling, animations, and visual effects for AppKit views.

## Overview

`NSView` extensions provide UIKit-style APIs for common styling tasks like corner radius, borders, shadows, gradients, and blur effects. These utilities eliminate boilerplate code and bring consistency between iOS and macOS development.

> Important: These extensions automatically set `wantsLayer = true` when modifying layer properties, as required by AppKit.

### Corner Radius Styling

Round view corners with simple method calls:

```swift
import AppKit
import RKUtils

// Simple corner radius
view.setCornerRadius(cornerRadius: 12)

// Round specific corners
view.roundedCorner(
    corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner],
    radius: 12
)

// Make fully rounded (circular or pill-shaped)
avatarView.rounded()
```

### Borders and Shadows

Add borders and drop shadows with customizable properties:

```swift
// Simple border
view.setBorder(width: 2, color: .systemBlue)

// Border with background and corner radius
view.setBorder(
    width: 2,
    color: .systemBlue,
    background: .white,
    radius: 8
)

// Drop shadow
view.setShadow(
    color: .black,
    offset: CGSize(width: 0, height: 2),
    opacity: 0.3,
    radius: 4,
    cornerRadius: 8
)
```

### Gradient Backgrounds

Apply linear gradient backgrounds to views:

```swift
// Vertical gradient
view.setLinearGradientBackground(
    colors: [.systemBlue, .systemPurple],
    startPoint: CGPoint(x: 0.5, y: 0),
    endPoint: CGPoint(x: 0.5, y: 1)
)

// Diagonal gradient with color stops
view.setLinearGradientBackground(
    colors: [.red, .yellow, .green],
    startPoint: CGPoint(x: 0, y: 0),
    endPoint: CGPoint(x: 1, y: 1),
    location: [0, 0.5, 1]
)
```

### Visual Effects and Animations

Apply blur effects and fade animations:

```swift
// Blur effect
view.applyBlurEffect(material: .contentBackground)

// Fade in/out animation
view.showViewWithAnimation(isHidden: false)  // Fade in
view.showViewWithAnimation(isHidden: true)   // Fade out
```

## Real-World Examples

### Card-Style View

Create a modern card design with rounded corners and shadow:

```swift
class CardView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }

    private func setupStyle() {
        // Rounded corners
        setCornerRadius(cornerRadius: 12)

        // Subtle drop shadow
        setShadow(
            color: .black,
            offset: CGSize(width: 0, height: -2),
            opacity: 0.1,
            radius: 8,
            cornerRadius: 12
        )

        // Background color
        wantsLayer = true
        layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
    }
}
```

### Circular Avatar

Create a circular profile image view:

```swift
class AvatarView: NSImageView {
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()

        guard window != nil else { return }

        // Make circular
        rounded()

        // Add border
        setBorder(width: 2, color: .systemBlue)
    }

    override func layout() {
        super.layout()

        // Update rounded corners when size changes
        rounded()
    }
}

// Usage
let avatarView = AvatarView()
avatarView.frame = NSRect(x: 0, y: 0, width: 80, height: 80)
avatarView.image = NSImage(named: "user-avatar")
```

### Gradient Background View

Welcome screen with gradient background:

```swift
class WelcomeViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Diagonal gradient
        view.setLinearGradientBackground(
            colors: [
                NSColor.systemBlue,
                NSColor.systemPurple
            ],
            startPoint: CGPoint(x: 0, y: 1),
            endPoint: CGPoint(x: 1, y: 0)
        )
    }
}
```

### Loading Overlay with Blur

Show a blurred loading overlay:

```swift
class ContentViewController: NSViewController {
    private var loadingOverlay: NSView?

    func showLoading() {
        let overlay = NSView(frame: view.bounds)
        overlay.autoresizingMask = [.width, .height]

        // Blur background
        overlay.applyBlurEffect(
            material: .hudWindow,
            blendingMode: .withinWindow
        )

        // Add spinner
        let spinner = NSProgressIndicator()
        spinner.style = .spinning
        spinner.controlSize = .large
        overlay.addSubview(spinner)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
        ])

        spinner.startAnimation(nil)

        view.addSubview(overlay)
        loadingOverlay = overlay

        // Fade in
        overlay.showViewWithAnimation(isHidden: false)
    }

    func hideLoading() {
        guard let overlay = loadingOverlay else { return }

        // Fade out and remove
        overlay.showViewWithAnimation(isHidden: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            overlay.removeFromSuperview()
            self.loadingOverlay = nil
        }
    }
}
```

### Button with Hover Effect

Custom button with gradient and hover animation:

```swift
class GradientButton: NSButton {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }

    private func setupStyle() {
        isBordered = false
        wantsLayer = true

        // Gradient background
        setLinearGradientBackground(
            colors: [.systemBlue, .systemPurple],
            startPoint: CGPoint(x: 0, y: 0.5),
            endPoint: CGPoint(x: 1, y: 0.5)
        )

        // Rounded corners
        setCornerRadius(cornerRadius: 8)

        // Title style
        if let cell = cell as? NSButtonCell {
            cell.attributedTitle = NSAttributedString(
                string: title,
                attributes: [
                    .foregroundColor: NSColor.white,
                    .font: NSFont.systemFont(ofSize: 14, weight: .medium)
                ]
            )
        }
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()

        trackingAreas.forEach { removeTrackingArea($0) }

        let trackingArea = NSTrackingArea(
            rect: bounds,
            options: [.mouseEnteredAndExited, .activeAlways],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(trackingArea)
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            animator().alphaValue = 0.8
        }
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            animator().alphaValue = 1.0
        }
    }
}
```

### Sidebar with Material Effect

Modern sidebar with blur and separator:

```swift
class SidebarViewController: NSViewController {
    @IBOutlet weak var sidebarView: NSView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSidebar()
    }

    private func setupSidebar() {
        // Blur effect with sidebar material
        sidebarView.applyBlurEffect(
            material: .sidebar,
            blendingMode: .behindWindow
        )

        // Add right separator line
        let separator = NSView()
        separator.wantsLayer = true
        separator.layer?.backgroundColor = NSColor.separatorColor.cgColor

        sidebarView.addSubview(separator)

        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: sidebarView.topAnchor),
            separator.bottomAnchor.constraint(equalTo: sidebarView.bottomAnchor),
            separator.trailingAnchor.constraint(equalTo: sidebarView.trailingAnchor),
            separator.widthAnchor.constraint(equalToConstant: 1)
        ])
    }
}
```

### Notification Banner

Animated notification banner with gradient:

```swift
class NotificationBanner: NSView {
    private let messageLabel = NSTextField(labelWithString: "")

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        // Gradient background
        setLinearGradientBackground(
            colors: [
                NSColor.systemGreen,
                NSColor.systemGreen.withAlphaComponent(0.8)
            ],
            startPoint: CGPoint(x: 0, y: 0.5),
            endPoint: CGPoint(x: 1, y: 0.5)
        )

        // Rounded corners
        setCornerRadius(cornerRadius: 8)

        // Shadow
        setShadow(
            color: .black,
            offset: CGSize(width: 0, height: 2),
            opacity: 0.2,
            radius: 4,
            cornerRadius: 8
        )

        // Message label
        messageLabel.textColor = .white
        messageLabel.font = .systemFont(ofSize: 14, weight: .medium)
        addSubview(messageLabel)

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func show(message: String, in parentView: NSView) {
        messageLabel.stringValue = message

        parentView.addSubview(self)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parentView.topAnchor, constant: 20),
            centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            heightAnchor.constraint(equalToConstant: 44),
            widthAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])

        // Fade in
        alphaValue = 0
        showViewWithAnimation(isHidden: false)

        // Auto-hide after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.hide()
        }
    }

    func hide() {
        showViewWithAnimation(isHidden: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.removeFromSuperview()
        }
    }
}
```

### Rounded Corner Variations

Different corner rounding styles:

```swift
class CornerStylesViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // All corners rounded
        box1.setCornerRadius(cornerRadius: 12)

        // Top corners only
        box2.roundedCorner(
            corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner],
            radius: 12
        )

        // Bottom corners only
        box3.roundedCorner(
            corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner],
            radius: 12
        )

        // Fully rounded (pill shape)
        button.rounded()

        // Custom corners with clipping
        imageView.roundedCorner(
            corners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner],
            radius: 20,
            clips: true
        )
    }
}
```

### Multi-Color Gradient

Complex gradient with multiple color stops:

```swift
func setupRainbowGradient() {
    rainbowView.setLinearGradientBackground(
        colors: [
            .systemRed,
            .systemOrange,
            .systemYellow,
            .systemGreen,
            .systemBlue,
            .systemPurple
        ],
        startPoint: CGPoint(x: 0, y: 0.5),
        endPoint: CGPoint(x: 1, y: 0.5),
        location: [0, 0.2, 0.4, 0.6, 0.8, 1.0]
    )
}
```

### Popover Content View

Styled popover content with blur:

```swift
class PopoverContentViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Blur with popover material
        view.applyBlurEffect(
            material: .popover,
            blendingMode: .withinWindow
        )

        // Rounded corners
        view.setCornerRadius(cornerRadius: 8)

        preferredContentSize = NSSize(width: 300, height: 200)
    }
}
```

## Implementation Details

### Layer Backing

All styling methods automatically enable layer backing by setting `wantsLayer = true`. This is required in AppKit before modifying layer properties.

### Coordinate System Differences

AppKit uses a bottom-left origin coordinate system, unlike UIKit's top-left origin. The gradient implementation accounts for this:

```swift
// AppKit coordinate system (bottom-left origin)
gradientLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
```

### Shadow Performance

For better shadow rendering performance, provide a custom `CGPath`:

```swift
let shadowPath = NSBezierPath(roundedRect: view.bounds, xRadius: 8, yRadius: 8).cgPath
view.setShadow(path: shadowPath, opacity: 0.3)
```

### Visual Effect View Materials

The `applyBlurEffect` method supports various materials:

| Material | Use Case |
|----------|----------|
| `.contentBackground` | General content areas |
| `.hudWindow` | HUD windows and overlays |
| `.sidebar` | Sidebar backgrounds |
| `.popover` | Popover content |
| `.menu` | Menu backgrounds |
| `.sheet` | Sheet backgrounds |

### Animation Context

The `showViewWithAnimation` method uses `NSAnimationContext` for smooth 0.4-second fade animations:

```swift
NSAnimationContext.runAnimationGroup { context in
    context.duration = 0.4
    context.allowsImplicitAnimation = true
    self.isHidden = isHidden
    self.alphaValue = isHidden ? 0.0 : 1.0
}
```

## Best Practices

### Always Enable Layer Backing

The extensions handle this automatically, but if you modify layers directly:

```swift
view.wantsLayer = true  // Required before layer modifications
view.layer?.backgroundColor = NSColor.red.cgColor
```

### Maintain Corner Radius on Resize

Update corner radius in `layout()` for views that change size:

```swift
override func layout() {
    super.layout()

    // Update circular shape
    avatarView.rounded()
}
```

### Use Autoresizing Masks for Effects

When adding blur effects or gradients, ensure they resize with the parent:

```swift
blurEffectView.autoresizingMask = [.width, .height]
```

### Shadow Path for Performance

Always use shadow paths for better performance:

```swift
// ✅ Good - uses path
let path = NSBezierPath(roundedRect: bounds, xRadius: 8, yRadius: 8).cgPath
view.setShadow(path: path, opacity: 0.3)

// ❌ Less efficient - no path
view.setShadow(opacity: 0.3, radius: 8)
```

### Gradient Layer Management

Gradients are inserted at layer index 0 (behind other sublayers):

```swift
layer?.insertSublayer(gradientLayer, at: 0)
```

If you need to update the gradient, remove the existing one first or manage gradient layers manually.

## Platform Availability

| Platform | Available |
|----------|-----------|
| macOS | ✅ 11.0+ |
| iOS | ❌ Use UIView extensions |

## Topics

### Corner Radius

- ``NSView/setCornerRadius(cornerRadius:)``
- ``NSView/roundedCorner(corners:radius:clips:)``
- ``NSView/rounded(clips:)``

### Borders

- ``NSView/setBorder(width:color:background:radius:)``

### Shadows

- ``NSView/setShadow(color:background:offset:opacity:radius:cornerRadius:path:)``

### Gradients

- ``NSView/setLinearGradientBackground(colors:startPoint:endPoint:location:type:)``

### Visual Effects

- ``NSView/applyBlurEffect(material:blendingMode:)``

### Animations

- ``NSView/showViewWithAnimation(isHidden:)``

## See Also

- ``NSColor``
- ``NSTextField``
- ``NSTableView``
