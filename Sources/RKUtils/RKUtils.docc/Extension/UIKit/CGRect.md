# ``RKUtils/CoreFoundation/CGRect``

Rectangle dimension utilities for layout calculations.

## Overview

`CGRect` extensions provide convenient access to the smaller dimension (width or height) of a rectangle. This utility is useful for determining the limiting dimension when fitting content or creating circular elements.

### Minimum Edge

Access the smaller dimension of a rectangle:

```swift
import CoreGraphics
import RKUtils

let rect = CGRect(x: 0, y: 0, width: 100, height: 150)
let smallestSide = rect.minEdge  // 100 (width is smaller)

// For circular avatars
let circleRadius = avatarRect.minEdge / 2
```

## Real-World Examples

### Circular Profile Images

Create perfectly circular images based on available space:

```swift
func setupAvatarImage(_ imageView: UIImageView, in containerRect: CGRect) {
    // Use the smaller dimension to ensure circle fits
    let size = containerRect.minEdge
    let avatarSize = size * 0.8  // 80% of available space

    imageView.frame = CGRect(
        x: (containerRect.width - avatarSize) / 2,
        y: (containerRect.height - avatarSize) / 2,
        width: avatarSize,
        height: avatarSize
    )

    // Make it circular
    imageView.layer.cornerRadius = avatarSize / 2
    imageView.clipsToBounds = true
}
```

### Square Grid Cells

Calculate grid cell sizes that fit in any orientation:

```swift
func calculateCellSize(for collectionView: UICollectionView, columns: Int) -> CGSize {
    let bounds = collectionView.bounds
    let minDimension = bounds.minEdge

    // Calculate cell size based on smaller dimension
    let spacing: CGFloat = 10
    let totalSpacing = spacing * CGFloat(columns + 1)
    let availableWidth = minDimension - totalSpacing
    let cellSize = availableWidth / CGFloat(columns)

    return CGSize(width: cellSize, height: cellSize)
}

func setupGridLayout() {
    let cellSize = calculateCellSize(for: collectionView, columns: 3)

    let layout = UICollectionViewFlowLayout()
    layout.itemSize = cellSize
    layout.minimumInteritemSpacing = 10
    layout.minimumLineSpacing = 10
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    collectionView.collectionViewLayout = layout
}
```

### Responsive Buttons

Size buttons proportionally to view bounds:

```swift
func setupActionButton(in containerView: UIView) {
    let containerBounds = containerView.bounds
    let minEdge = containerBounds.minEdge

    // Button should be 30% of smallest dimension
    let buttonSize = minEdge * 0.3

    actionButton.frame = CGRect(
        x: (containerBounds.width - buttonSize) / 2,
        y: containerBounds.height - buttonSize - 40,
        width: buttonSize,
        height: buttonSize
    )

    // Make it circular
    actionButton.layer.cornerRadius = buttonSize / 2
}
```

### Loading Spinner Sizing

Size activity indicators appropriately for available space:

```swift
func showLoadingSpinner(in view: UIView) {
    let viewBounds = view.bounds
    let containerSize = viewBounds.minEdge * 0.25

    let containerView = UIView(frame: CGRect(
        x: (viewBounds.width - containerSize) / 2,
        y: (viewBounds.height - containerSize) / 2,
        width: containerSize,
        height: containerSize
    ))

    containerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    containerView.layer.cornerRadius = 12

    let spinner = UIActivityIndicatorView(style: .large)
    spinner.color = .white
    spinner.center = CGPoint(x: containerSize / 2, y: containerSize / 2)

    containerView.addSubview(spinner)
    view.addSubview(containerView)

    spinner.startAnimating()
}
```

### Aspect Ratio Constraints

Maintain square aspect ratio within available bounds:

```swift
func fitSquareInRect(_ rect: CGRect) -> CGRect {
    let side = rect.minEdge
    let x = (rect.width - side) / 2
    let y = (rect.height - side) / 2

    return CGRect(x: rect.origin.x + x, y: rect.origin.y + y, width: side, height: side)
}

// Usage
let containerRect = CGRect(x: 0, y: 0, width: 200, height: 300)
let squareRect = fitSquareInRect(containerRect)
// Returns CGRect(x: 0, y: 50, width: 200, height: 200)

imageView.frame = squareRect
```

### Circular Progress Indicator

Create circular progress views:

```swift
class CircularProgressView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()

        // Use smaller dimension to ensure circle fits
        let diameter = bounds.minEdge
        let inset = (bounds.width - diameter) / 2

        // Position circular path in center
        let circleBounds = CGRect(
            x: inset,
            y: (bounds.height - diameter) / 2,
            width: diameter,
            height: diameter
        )

        updateCirclePath(in: circleBounds)
    }

    func updateCirclePath(in rect: CGRect) {
        let radius = rect.minEdge / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)

        let path = UIBezierPath(
            arcCenter: center,
            radius: radius - 5,  // Inset for stroke width
            startAngle: -.pi / 2,
            endAngle: .pi * 1.5,
            clockwise: true
        )

        shapeLayer.path = path.cgPath
    }
}
```

### Modal Dialog Sizing

Size modal dialogs proportionally:

```swift
func presentCustomDialog() {
    let screenBounds = UIScreen.main.bounds
    let minEdge = screenBounds.minEdge

    // Dialog should be 70% of smallest screen dimension
    let dialogSize = minEdge * 0.7

    let dialogVC = CustomDialogViewController()
    dialogVC.preferredContentSize = CGSize(width: dialogSize, height: dialogSize * 0.8)
    dialogVC.modalPresentationStyle = .formSheet

    present(dialogVC, animated: true)
}
```

### Floating Action Button

Position and size floating buttons:

```swift
func setupFloatingButton(in view: UIView) {
    let viewBounds = view.bounds
    let buttonSize: CGFloat = viewBounds.minEdge * 0.15

    floatingButton.frame = CGRect(
        x: viewBounds.width - buttonSize - 20,
        y: viewBounds.height - buttonSize - 100,
        width: buttonSize,
        height: buttonSize
    )

    // Make circular
    floatingButton.layer.cornerRadius = buttonSize / 2
    floatingButton.clipsToBounds = true

    // Add shadow
    floatingButton.layer.shadowColor = UIColor.black.cgColor
    floatingButton.layer.shadowOffset = CGSize(width: 0, height: 4)
    floatingButton.layer.shadowOpacity = 0.3
    floatingButton.layer.shadowRadius = 8
    floatingButton.layer.masksToBounds = false
}
```

### Custom Drawing

Use minEdge for centered circular drawings:

```swift
class CircleView: UIView {
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // Draw circle that fits perfectly in view
        let diameter = rect.minEdge
        let inset = (rect.width - diameter) / 2

        let circleRect = CGRect(
            x: inset,
            y: (rect.height - diameter) / 2,
            width: diameter,
            height: diameter
        )

        context.setFillColor(UIColor.systemBlue.cgColor)
        context.fillEllipse(in: circleRect)
    }
}
```

### Badge Positioning

Position badges on circular avatars:

```swift
func addBadge(to avatarView: UIView) {
    let avatarBounds = avatarView.bounds
    let avatarDiameter = avatarBounds.minEdge

    // Badge should be 25% of avatar size
    let badgeSize = avatarDiameter * 0.25

    let badgeView = UIView(frame: CGRect(
        x: avatarDiameter - badgeSize,
        y: avatarDiameter - badgeSize,
        width: badgeSize,
        height: badgeSize
    ))

    badgeView.backgroundColor = .systemGreen
    badgeView.layer.cornerRadius = badgeSize / 2
    badgeView.layer.borderWidth = 2
    badgeView.layer.borderColor = UIColor.white.cgColor

    avatarView.addSubview(badgeView)
}
```

## Implementation Details

The `minEdge` property returns the smaller of the rectangle's width or height:

```swift
var minEdge: CGFloat {
    return min(self.size.width, self.size.height)
}
```

**Use Cases:**
- Ensuring circular elements fit within rectangular bounds
- Creating square cells in grid layouts
- Responsive sizing based on limiting dimension
- Maintaining aspect ratios
- Centering circular progress indicators

## Platform Availability

| Platform | Available |
|----------|-----------|
| iOS | ✅ 13.0+ |
| tvOS | ✅ 13.0+ |
| macOS | ✅ 13.0+ |
| watchOS | ✅ 6.0+ |
| visionOS | ✅ 1.0+ |
| Linux | ✅ (CoreGraphics available) |

## Topics

### Dimensions

- ``CGRect/minEdge``

## See Also

- ``UIView``
- ``UIScreen``
