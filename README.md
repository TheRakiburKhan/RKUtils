# RKUtils

**RKUtils** is a lightweight, reusable Swift package offering a collection of productivity-focused extensions and helpers for UIKit and Foundation. Built for iOS developers who value clean code and efficiency.

---

## 🚀 Features

- ✅ Type-safe `UIStoryboard` instantiation
- ✅ Handy `UIView` extensions: corners, borders, shadows, gradients, blur, animations
- ✅ One-liner keyboard toolbars for `UITextField` / `UITextView`
- ✅ Impact and notification haptic feedback made easy
- ✅ Access app version, screen size utilities
- 🧼 Clean, focused, boilerplate-free APIs

---

## 📦 Installation

### Swift Package Manager

Using Xcode:

1. Open your project in Xcode
2. Go to **File > Add Packages...**
3. Add the following URL

```
https://github.com/TheRakiburKhan/RKUtils.git
```

4. Choose the latest version and confirm.

Or via `Package.swift`:

```swift
dependencies: [
 .package(url: "https://github.com/TheRakiburKhan/RKUtils.git", from: "1.0.0")
]
```

Then import it:

```
import RKUtils
```

## 📘 Usage Examples

### 🎯 UIView Helpers

```
myView.rounded() // Perfect circle
myView.setCornerRadious(cornerRadious: 8)
myView.setBorder(width: 1, color: .lightGray)
myView.setShadow(opacity: 0.2, radius: 4)
myView.setLinearGradientBackground(colors: [.systemBlue, .systemTeal])
myView.applyBlurEffect()
```

### 🎹 Keyboard Toolbar with Done Button

```
textField.addDoneButtonOnKeyboard()
textView.addDoneButtonOnKeyboard()
```

### 🧬 Storyboard View Controller Instantiation

```
let vc: MyViewController = storyboard.instantiate()
```

Ensure the storyboard ID matches the class name.

### 📱 Screen and Bundle Utilities

```
let minEdge = UIScreen.main.minEdge
let version = Bundle.main.appVersion
let build = Bundle.main.buildNumber
```

### 🎯 Haptic Feedback

```
UIImpactFeedbackGenerator(style: .medium).impact()
UINotificationFeedbackGenerator().success()
```

## ✅ Requirements

- iOS 11.0+

- Swift 5.7+

- Xcode 14+

## 📄 License

MIT License

See the LICENSE file for details.

## 👤 Author

Rakibur Khan

Passionate iOS Developer focused on architecture, performance, and simplicity.

- 🔗 github.com/TheRakiburKhan

**Contributions, suggestions, and PRs are welcome!**
