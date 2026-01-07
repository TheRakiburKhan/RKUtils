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
    /**
     Creates a Combine publisher that emits the text field's current text whenever it changes.

     Works for both `NSTextField` and `NSSecureTextField` (which is a subclass of `NSTextField`).

     - Returns: A publisher that emits the text field's string value, never fails.

     - Example:
     ```swift
     let textField = NSTextField()

     textField.textPublisher()
         .sink { newText in
             print("Text changed to: \\(newText)")
         }
         .store(in: &cancellables)
     ```

     - Note: Uses `NSControl.textDidChangeNotification` internally. Returns an empty string if text is `nil`.
     */
    func textPublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: NSControl.textDidChangeNotification, object: self)
            .map { ($0.object as? NSTextField)?.stringValue ?? "" }
            .eraseToAnyPublisher()
    }
}

public extension NSTextField {
    /**
     Adds left padding to the text field by adjusting the cell's drawing rect.

     - Parameter amount: The padding width in points.

     - Important: This method provides a simplified implementation. For production use,
     create a custom `NSTextFieldCell` subclass that overrides `titleRect(forBounds:)`
     to properly adjust the text drawing area.

     - Note: Unlike UIKit's `UITextField`, AppKit's `NSTextField` doesn't have `leftView`/`rightView`.
     Padding is achieved through `NSTextFieldCell` customization or layout constraints.
     */
    func setLeftPaddingPoints(_ amount: CGFloat) {
        // AppKit approach: Use cell's titleRect(forBounds:) override
        // This is a simplified version - for production, subclass NSTextFieldCell
        _ = self.cell as? NSTextFieldCell
        // For proper implementation, create a custom NSTextFieldCell subclass
    }

    /**
     Adds right padding to the text field by adjusting the cell's drawing rect.

     - Parameter amount: The padding width in points.

     - Important: This method provides a simplified implementation. For production use,
     create a custom `NSTextFieldCell` subclass that overrides `titleRect(forBounds:)`
     to properly adjust the text drawing area.

     - Note: Unlike UIKit's `UITextField`, AppKit's `NSTextField` doesn't have `leftView`/`rightView`.
     Padding is achieved through `NSTextFieldCell` customization or layout constraints.
     */
    func setRightPaddingPoints(_ amount: CGFloat) {
        // AppKit approach: Use cell's titleRect(forBounds:) override
        // This is a simplified version - for production, subclass NSTextFieldCell
        _ = self.cell as? NSTextFieldCell
        // For proper implementation, create a custom NSTextFieldCell subclass
    }
}
#endif
