//
//  UITextView.swift
//  
//
//  Created by Rakibur Khan on 3/4/24.
//

#if canImport(UIKit) && !os(visionOS) && !os(watchOS) && !os(tvOS)
import UIKit

public extension UITextView {
    /**
     Adds a "Done" button above the keyboard to dismiss it.

     Creates a toolbar with a "Done" button on the right side that dismisses the keyboard
     when tapped. Useful for multi-line text views that don't have a built-in return key
     to dismiss the keyboard.

     - Example:
     ```swift
     let textView = UITextView()
     textView.addDoneButtonOnKeyboard()
     // When user taps "Done", the keyboard dismisses
     ```

     - Note: Sets the text view's `inputAccessoryView` to a toolbar. The toolbar spans
     the full width of the screen and includes flexible space to right-align the button.
     */
    func addDoneButtonOnKeyboard() {
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 34))
        keyboardToolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self, action: #selector(resignFirstResponder))
        keyboardToolbar.items = [flexibleSpace, doneButton]
        self.inputAccessoryView = keyboardToolbar
    }
}
#endif
