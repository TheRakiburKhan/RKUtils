//
//  NSSecureTextField.swift
//  RKUtils
//
//  Created by Rakibur Khan on 3/12/25.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

// MARK: - Secure Text Toggle for NSSecureTextField
@MainActor
fileprivate var secureTextState: Bool?
@MainActor
fileprivate var systemTintColor: NSColor?

public extension NSSecureTextField {
    /**
     Adds a toggle button to show/hide password text in the secure text field.

     Creates a button positioned to the right of the text field that toggles between
     showing and hiding the password. Switches between `NSSecureTextField` and `NSTextField`
     to achieve the show/hide functionality.

     - Parameter color: The tint color to use when the password is visible.

     - Example:
     ```swift
     let passwordField = NSSecureTextField()
     passwordField.setSecureTextToggleToRight(.systemBlue)
     // User can click the eye icon to toggle password visibility
     ```

     - Note: Similar to UIKit's `setSecureTextToggleToRight` but adapted for AppKit.
     The button shows an "eye" icon when hidden and "eye.slash" when visible.
     Requires macOS 11.0+ for SF Symbols support; uses emoji fallback on macOS 10.15.

     - Important: The text field must be added to a superview before calling this method.
     */
    func setSecureTextToggleToRight(_ color: NSColor) {
        guard let superview = self.superview else { return }

        let size = self.frame.height
        self.isHidden = false

        secureTextState = true
        systemTintColor = color

        // Create the toggle button
        let iconButton = NSButton(frame: NSRect(x: 0, y: 0, width: size, height: size))
        iconButton.bezelStyle = .texturedRounded
        iconButton.isBordered = false

        if #available(macOS 11.0, *) {
            iconButton.image = NSImage(systemSymbolName: "eye", accessibilityDescription: "Show password")
        } else {
            // Fallback for macOS 10.15: use text or a simple shape
            iconButton.title = "👁"
        }

        if #available(macOS 11.0, *) {
            iconButton.contentTintColor = .systemGray
        }

        iconButton.target = self
        iconButton.action = #selector(toggleSecureTextControl(_:))

        // Position button at the trailing edge of the text field
        let buttonX = self.frame.maxX - size - 8
        let buttonY = self.frame.minY + (self.frame.height - size) / 2
        iconButton.frame.origin = NSPoint(x: buttonX, y: buttonY)

        // Store button reference using tag
        iconButton.tag = 9999
        superview.addSubview(iconButton)

        // Adjust text field's right padding to make room for button
        _ = self.cell as? NSTextFieldCell
    }

    /// Toggles between secure and non-secure text display
    @objc private func toggleSecureTextControl(_ sender: NSButton) {
        guard var textSecured = secureTextState,
              let superview = self.superview else { return }

        let tint = systemTintColor ?? .controlAccentColor
        let currentText = self.stringValue
        let currentFrame = self.frame

        if textSecured {
            // Switch to plain text field (show password)
            let plainTextField = NSTextField(frame: currentFrame)
            plainTextField.stringValue = currentText
            plainTextField.font = self.font
            plainTextField.alignment = self.alignment
            plainTextField.placeholderString = self.placeholderString
            plainTextField.delegate = self.delegate
            plainTextField.tag = self.tag
            plainTextField.isEditable = self.isEditable
            plainTextField.isSelectable = self.isSelectable
            plainTextField.drawsBackground = self.drawsBackground
            plainTextField.backgroundColor = self.backgroundColor
            plainTextField.textColor = self.textColor
            plainTextField.isBordered = self.isBordered
            plainTextField.isBezeled = self.isBezeled
            plainTextField.bezelStyle = self.bezelStyle

            // Store reference to restore secure field later
            plainTextField.identifier = NSUserInterfaceItemIdentifier("plainTextField_\(self.tag)")

            // Replace secure field with plain field
            superview.addSubview(plainTextField, positioned: .below, relativeTo: sender)
            self.isHidden = true

            // Update button
            if #available(macOS 11.0, *) {
                sender.image = NSImage(systemSymbolName: "eye.slash", accessibilityDescription: "Hide password")
                sender.contentTintColor = tint
            } else {
                sender.title = "👁‍🗨"
            }

            textSecured = false
            secureTextState = textSecured

            // Make the plain text field first responder
            self.window?.makeFirstResponder(plainTextField)

        } else {
            // Switch back to secure text field (hide password)
            if let plainTextField = superview.subviews.first(where: {
                $0.identifier?.rawValue == "plainTextField_\(self.tag)"
            }) as? NSTextField {
                self.stringValue = plainTextField.stringValue
                plainTextField.removeFromSuperview()
            }

            self.isHidden = false

            // Update button
            if #available(macOS 11.0, *) {
                sender.image = NSImage(systemSymbolName: "eye", accessibilityDescription: "Show password")
                sender.contentTintColor = .systemGray
            } else {
                sender.title = "👁"
            }

            textSecured = true
            secureTextState = textSecured

            // Make the secure text field first responder
            self.window?.makeFirstResponder(self)
        }
    }
}
#endif
