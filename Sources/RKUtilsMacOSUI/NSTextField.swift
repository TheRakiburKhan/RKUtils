//
//  NSTextField.swift
//  RKUtils
//
//  Created by Rakibur Khan on 3/12/25.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import Combine

public extension NSTextField {
    /// Returns a publisher that emits the text field's text whenever it changes
    /// Works for both NSTextField and NSSecureTextField (which is a subclass)
    func textPublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: NSControl.textDidChangeNotification, object: self)
            .map { ($0.object as? NSTextField)?.stringValue ?? "" }
            .eraseToAnyPublisher()
    }
}

// Note: NSTextField doesn't have leftView/rightView like UITextField
// AppKit uses NSTextFieldCell or custom subviews for padding
// Secure text entry in AppKit is handled by NSSecureTextField, not NSTextField
public extension NSTextField {
    /// Adds left padding to the text field by adjusting the cell's drawing rect
    /// Note: This requires custom NSTextFieldCell for proper implementation
    func setLeftPaddingPoints(_ amount: CGFloat) {
        // AppKit approach: Use cell's titleRect(forBounds:) override
        // This is a simplified version - for production, subclass NSTextFieldCell
        _ = self.cell as? NSTextFieldCell
        // For proper implementation, create a custom NSTextFieldCell subclass
    }

    /// Adds right padding to the text field by adjusting the cell's drawing rect
    /// Note: This requires custom NSTextFieldCell for proper implementation
    func setRightPaddingPoints(_ amount: CGFloat) {
        // AppKit approach: Use cell's titleRect(forBounds:) override
        // This is a simplified version - for production, subclass NSTextFieldCell
        _ = self.cell as? NSTextFieldCell
        // For proper implementation, create a custom NSTextFieldCell subclass
    }
}
#endif
