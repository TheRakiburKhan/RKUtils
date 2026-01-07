# ``RKUtils/UIKit/UIScreen``

Screen dimension utilities for responsive layouts.

## Overview

`UIScreen` extensions provide convenient access to the smaller dimension (width or height) of the main screen's bounds. This utility is useful for responsive layouts that need to adapt to the device's limiting dimension.

### Screen Minimum Edge

Access the smaller dimension of the screen:

```swift
import UIKit
import RKUtils

let smallestDimension = UIScreen.main.minEdge
// On iPhone 14 Pro in portrait: 393 (width is smaller than height)
// On iPhone 14 Pro in landscape: 852 (height is smaller than width)
// On iPad Pro 12.9" in portrait: 1024 (width is smaller than height)
```

## Real-World Examples

### Responsive Layout

Create layouts that adapt to the limiting dimension:

```swift
func setupImageView() {
    let limitingDimension = UIScreen.main.minEdge
    let imageSize = limitingDimension * 0.8  // 80% of smallest dimension

    imageView.constrainSize(width: imageSize, height: imageSize)
}
```

### Circular Avatar Sizing

Size circular elements based on screen size:

```swift
func setupProfileAvatar() {
    let screenMinEdge = UIScreen.main.minEdge

    // Calculate avatar size as percentage of smallest screen dimension
    let avatarSize: CGFloat
    if screenMinEdge < 375 {
        // Small devices (iPhone SE)
        avatarSize = screenMinEdge * 0.25
    } else if screenMinEdge < 428 {
        // Standard devices
        avatarSize = screenMinEdge * 0.30
    } else {
        // Large devices (Pro Max, iPad)
        avatarSize = screenMinEdge * 0.35
    }

    avatarImageView.frame.size = CGSize(width: avatarSize, height: avatarSize)
    avatarImageView.rounded()  // Make it circular
}
```

### Square Grid Cells

Calculate grid cell sizes that work in any orientation:

```swift
func calculateGridCellSize(columns: Int, spacing: CGFloat) -> CGFloat {
    let screenMin = UIScreen.main.minEdge
    let totalSpacing = spacing * CGFloat(columns + 1)
    let availableWidth = screenMin - totalSpacing
    let cellSize = availableWidth / CGFloat(columns)

    return cellSize
}

func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()

    // 3 columns with 12pt spacing
    let cellSize = calculateGridCellSize(columns: 3, spacing: 12)

    layout.itemSize = CGSize(width: cellSize, height: cellSize)
    layout.minimumInteritemSpacing = 12
    layout.minimumLineSpacing = 12
    layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

    collectionView.collectionViewLayout = layout
}
```

### Onboarding Page Sizing

Size onboarding illustrations appropriately:

```swift
class OnboardingViewController: UIViewController {
    @IBOutlet weak var illustrationImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let minDimension = UIScreen.main.minEdge

        // Illustration should be 60% of smallest screen dimension
        let illustrationSize = minDimension * 0.6

        illustrationImageView.constrainSize(
            width: illustrationSize,
            height: illustrationSize
        )
    }
}
```

### Modal Size Configuration

Configure modal presentation sizes:

```swift
func presentCustomModal() {
    let modalVC = CustomModalViewController()

    let screenMinEdge = UIScreen.main.minEdge

    // Modal should be slightly smaller than screen
    let modalSize = screenMinEdge * 0.9

    modalVC.preferredContentSize = CGSize(width: modalSize, height: modalSize)
    modalVC.modalPresentationStyle = .formSheet

    present(modalVC, animated: true)
}
```

### Loading Spinner Size

Size activity indicators based on screen:

```swift
func showLoadingSpinner() {
    let containerSize = UIScreen.main.minEdge * 0.25

    let containerView = UIView(frame: CGRect(
        x: (view.bounds.width - containerSize) / 2,
        y: (view.bounds.height - containerSize) / 2,
        width: containerSize,
        height: containerSize
    ))

    containerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    containerView.setCornerRadius(cornerRadius: 12)

    let spinner = UIActivityIndicatorView(style: .large)
    spinner.color = .white
    spinner.center = CGPoint(x: containerSize / 2, y: containerSize / 2)

    containerView.addSubview(spinner)
    view.addSubview(containerView)

    spinner.startAnimating()
}
```

### Button Sizing

Create consistent button sizes across devices:

```swift
func setupActionButton() {
    let minEdge = UIScreen.main.minEdge

    // Button width is 80% of smallest dimension, with max 400pt
    let buttonWidth = min(minEdge * 0.8, 400)
    let buttonHeight: CGFloat = 50

    actionButton.constrainSize(width: buttonWidth, height: buttonHeight)
    actionButton.rounded()  // Pill-shaped

    // Center horizontally
    actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
}
```

### Custom Alert Dialog

Size custom alert dialogs appropriately:

```swift
class CustomAlertView: UIView {
    func show(in parentView: UIView) {
        let minEdge = UIScreen.main.minEdge

        // Alert should be 70% of smallest dimension
        let alertSize = minEdge * 0.7

        self.frame.size = CGSize(width: alertSize, height: alertSize * 0.6)
        self.center = parentView.center

        self.setCornerRadius(cornerRadius: 16)
        self.setShadow(
            color: .black,
            offset: CGSize(width: 0, height: 4),
            opacity: 0.3,
            radius: 12
        )

        parentView.addSubview(self)

        // Fade in animation
        self.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
}
```

### Floating Action Button

Position and size floating buttons:

```swift
func setupFloatingActionButton() {
    let buttonSize: CGFloat = UIScreen.main.minEdge * 0.15

    floatingButton.frame.size = CGSize(width: buttonSize, height: buttonSize)
    floatingButton.rounded()  // Circular

    // Position in bottom-right corner
    floatingButton.frame.origin = CGPoint(
        x: view.bounds.width - buttonSize - 20,
        y: view.bounds.height - buttonSize - 100
    )

    floatingButton.setShadow(
        color: .black,
        offset: CGSize(width: 0, height: 4),
        opacity: 0.3,
        radius: 8
    )
}
```

## Implementation Details

The `minEdge` property returns the smaller of the screen's width or height by accessing `UIScreen.main.bounds` and calculating `min(width, height)`.

**Important Notes:**
- Values are in **points**, not pixels
- Uses `bounds` (not `nativeBounds`)
- Updates when device orientation changes
- Works with any screen size and orientation

## Platform Availability

| Platform | Available | Notes |
|----------|-----------|-------|
| iOS | ✅ 13.0+ | Full support |
| tvOS | ❌ | Not available |
| visionOS | ❌ | Not available |
| watchOS | ❌ | Not available |
| macOS | ❌ | Not available |

## Topics

### Screen Dimensions

- ``UIScreen/minEdge``

## See Also

- ``UIDevice``
- ``UIView``
- ``CGRect``
