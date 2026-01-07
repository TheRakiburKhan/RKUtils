# ``RKUtils/AppKit/NSSecureTextField``

Password visibility toggle for secure text fields.

## Overview

`NSSecureTextField` extensions provide a password visibility toggle button, allowing users to show or hide password text with a single click. This is a common UX pattern that improves usability while maintaining security.

### Adding Password Visibility Toggle

Use ``NSSecureTextField/setSecureTextToggleToRight(_:)`` to add an eye icon button that toggles password visibility:

```swift
import AppKit
import RKUtils

class LoginViewController: NSViewController {
    @IBOutlet weak var passwordField: NSSecureTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add show/hide password button
        passwordField.setSecureTextToggleToRight(.systemBlue)
    }
}
```

### How It Works

The toggle functionality:

1. **Hidden State**: Shows an "eye" icon (SF Symbol: `eye`)
2. **Visible State**: Shows an "eye.slash" icon (SF Symbol: `eye.slash`)
3. **Clicking**: Switches between `NSSecureTextField` and `NSTextField` to show/hide the password

The button is automatically positioned at the trailing edge of the text field with appropriate spacing.

## Real-World Examples

### Login Form

Complete login form with password visibility toggle:

```swift
class LoginViewController: NSViewController {
    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var passwordField: NSSecureTextField!
    @IBOutlet weak var loginButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPasswordField()
        setupBindings()
    }

    func setupPasswordField() {
        // Add visibility toggle
        passwordField.setSecureTextToggleToRight(.systemBlue)

        // Configure appearance
        passwordField.placeholderString = "Enter your password"
        passwordField.font = .systemFont(ofSize: 14)
        passwordField.bezelStyle = .roundedBezel
    }

    func setupBindings() {
        // Enable login when both fields have text
        NotificationCenter.default.addObserver(
            forName: NSControl.textDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateLoginButton()
        }
    }

    func updateLoginButton() {
        let hasUsername = !usernameField.stringValue.isEmpty
        let hasPassword = !passwordField.stringValue.isEmpty
        loginButton.isEnabled = hasUsername && hasPassword
    }

    @IBAction func login(_ sender: NSButton) {
        let username = usernameField.stringValue
        let password = passwordField.stringValue

        authenticate(username: username, password: password)
    }

    func authenticate(username: String, password: String) {
        // Perform authentication...
    }
}
```

### Registration Form

Registration with password confirmation:

```swift
class RegistrationViewController: NSViewController {
    @IBOutlet weak var passwordField: NSSecureTextField!
    @IBOutlet weak var confirmPasswordField: NSSecureTextField!
    @IBOutlet weak var strengthLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add visibility toggles to both fields
        passwordField.setSecureTextToggleToRight(.systemBlue)
        confirmPasswordField.setSecureTextToggleToRight(.systemBlue)

        // Configure fields
        passwordField.placeholderString = "Choose a password"
        confirmPasswordField.placeholderString = "Confirm password"

        observePasswordChanges()
    }

    func observePasswordChanges() {
        NotificationCenter.default.addObserver(
            forName: NSControl.textDidChangeNotification,
            object: passwordField,
            queue: .main
        ) { [weak self] _ in
            self?.validatePassword()
        }
    }

    func validatePassword() {
        let password = passwordField.stringValue

        // Simple password strength indicator
        let strength: String
        if password.isEmpty {
            strength = ""
        } else if password.count < 6 {
            strength = "Weak"
            strengthLabel.textColor = .systemRed
        } else if password.count < 10 {
            strength = "Medium"
            strengthLabel.textColor = .systemOrange
        } else {
            strength = "Strong"
            strengthLabel.textColor = .systemGreen
        }

        strengthLabel.stringValue = strength
    }

    @IBAction func register(_ sender: NSButton) {
        let password = passwordField.stringValue
        let confirm = confirmPasswordField.stringValue

        guard password == confirm else {
            showAlert("Passwords don't match")
            return
        }

        // Proceed with registration...
    }

    func showAlert(_ message: String) {
        let alert = NSAlert()
        alert.messageText = "Error"
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.runModal()
    }
}
```

### Settings Panel

Password change with current password verification:

```swift
class PasswordChangeViewController: NSViewController {
    @IBOutlet weak var currentPasswordField: NSSecureTextField!
    @IBOutlet weak var newPasswordField: NSSecureTextField!
    @IBOutlet weak var confirmPasswordField: NSSecureTextField!
    @IBOutlet weak var saveButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPasswordFields()
    }

    func setupPasswordFields() {
        // Add toggles to all password fields
        currentPasswordField.setSecureTextToggleToRight(.systemGray)
        newPasswordField.setSecureTextToggleToRight(.systemBlue)
        confirmPasswordField.setSecureTextToggleToRight(.systemBlue)

        // Configure placeholders
        currentPasswordField.placeholderString = "Current password"
        newPasswordField.placeholderString = "New password"
        confirmPasswordField.placeholderString = "Confirm new password"

        // Initial state
        saveButton.isEnabled = false
    }

    @IBAction func save(_ sender: NSButton) {
        let current = currentPasswordField.stringValue
        let new = newPasswordField.stringValue
        let confirm = confirmPasswordField.stringValue

        // Validate
        guard !current.isEmpty else {
            showAlert("Please enter your current password")
            return
        }

        guard !new.isEmpty, new.count >= 8 else {
            showAlert("New password must be at least 8 characters")
            return
        }

        guard new == confirm else {
            showAlert("New passwords don't match")
            return
        }

        // Update password
        updatePassword(current: current, new: new)
    }

    func updatePassword(current: String, new: String) {
        // Verify current password and update...
    }

    func showAlert(_ message: String) {
        let alert = NSAlert()
        alert.messageText = "Invalid Input"
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.runModal()
    }
}
```

### Custom Styled Password Field

Password field with custom styling:

```swift
class StyledPasswordField: NSSecureTextField {
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()

        guard superview != nil else { return }

        setupAppearance()
        setupToggle()
    }

    func setupAppearance() {
        // Custom styling
        self.font = .systemFont(ofSize: 14, weight: .medium)
        self.alignment = .left
        self.bezelStyle = .roundedBezel
        self.drawsBackground = true
        self.backgroundColor = NSColor(calibratedWhite: 0.95, alpha: 1.0)
        self.textColor = .labelColor

        // Border
        self.wantsLayer = true
        self.layer?.borderWidth = 1
        self.layer?.borderColor = NSColor.separatorColor.cgColor
        self.layer?.cornerRadius = 8

        // Padding via cell
        if let cell = self.cell as? NSTextFieldCell {
            cell.placeholderAttributedString = NSAttributedString(
                string: "Enter password",
                attributes: [
                    .foregroundColor: NSColor.secondaryLabelColor,
                    .font: NSFont.systemFont(ofSize: 14)
                ]
            )
        }
    }

    func setupToggle() {
        setSecureTextToggleToRight(.controlAccentColor)
    }

    // Focus ring
    override func drawFocusRingMask() {
        let path = NSBezierPath(roundedRect: bounds, xRadius: 8, yRadius: 8)
        path.fill()
    }

    override var focusRingMaskBounds: NSRect {
        return bounds
    }
}
```

### SwiftUI Integration

Use password field in SwiftUI with NSViewRepresentable:

```swift
struct SecurePasswordField: NSViewRepresentable {
    @Binding var text: String
    var placeholder: String = "Password"
    var tintColor: NSColor = .controlAccentColor

    func makeNSView(context: Context) -> NSSecureTextField {
        let field = NSSecureTextField()
        field.placeholderString = placeholder
        field.delegate = context.coordinator
        field.setSecureTextToggleToRight(tintColor)
        return field
    }

    func updateNSView(_ nsView: NSSecureTextField, context: Context) {
        nsView.stringValue = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: SecurePasswordField

        init(_ parent: SecurePasswordField) {
            self.parent = parent
        }

        func controlTextDidChange(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField else { return }
            parent.text = textField.stringValue
        }
    }
}

// Usage in SwiftUI
struct LoginView: View {
    @State private var password = ""

    var body: some View {
        VStack {
            SecurePasswordField(text: $password, placeholder: "Enter password")
                .frame(height: 32)
                .padding()

            Button("Login") {
                print("Password: \(password)")
            }
        }
    }
}
```

## Implementation Details

### Button Positioning

The toggle button is automatically positioned:
- **X Position**: Trailing edge of text field minus button width and 8pt spacing
- **Y Position**: Vertically centered within the text field
- **Size**: Equal to the text field's height

### State Management

The extension uses file-private variables to track:
- `secureTextState`: Whether password is currently hidden
- `systemTintColor`: Color to use when password is visible

### Text Field Switching

When toggling visibility:
1. Current text is preserved
2. All formatting properties (font, alignment, colors) are copied
3. Delegate and other attributes are maintained
4. The appropriate field type is swapped in

## Best Practices

### Always Add to Superview First

The text field must have a superview before calling `setSecureTextToggleToRight`:

```swift
// ✅ Correct
view.addSubview(passwordField)
passwordField.setSecureTextToggleToRight(.systemBlue)

// ❌ Wrong - will silently fail
passwordField.setSecureTextToggleToRight(.systemBlue)
view.addSubview(passwordField)
```

### Choose Appropriate Colors

Use system colors that match your app's theme:

```swift
// Standard blue
passwordField.setSecureTextToggleToRight(.systemBlue)

// Matches accent color
passwordField.setSecureTextToggleToRight(.controlAccentColor)

// Subtle gray
passwordField.setSecureTextToggleToRight(.systemGray)
```

### Consider Accessibility

The toggle button includes accessibility descriptions:
- Hidden: "Show password"
- Visible: "Hide password"

These descriptions are automatically set based on the SF Symbol used.

## Platform Availability

| Platform | Available |
|----------|-----------|
| macOS | ✅ 11.0+ (requires SF Symbols) |
| iOS | ❌ Use UITextField |

## Topics

### Password Visibility

- ``RKUtils/AppKit/NSSecureTextField/setSecureTextToggleToRight(_:)``

## See Also

- ``RKUtils/AppKit/NSTextField``
- ``RKUtils/AppKit/NSView``
