//
//  UITextField.swift
//  
//
//  Created by Rakibur Khan on 3/4/24.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit
import Combine

@MainActor
fileprivate var secureTextState: Bool?
@MainActor
fileprivate var systemTint: UIColor?

public extension UITextField {
    /**
     Adds a toggle button to show/hide secure text entry in the text field's right view.

     Displays an "eye" icon that toggles between showing and hiding the text field's content,
     commonly used for password fields.

     - Parameter color: The tint color to use when the text is visible.

     - Example:
     ```swift
     passwordField.setSecureTextToggleToRight(.systemBlue)
     // User can tap the eye icon to toggle password visibility
     ```

     - Note: Automatically sets `isSecureTextEntry` to `true` and manages the toggle state.
     The button shows "eye" when hidden and "eye.slash" when visible.
     */
    func setSecureTextToggleToRight(_ color: UIColor) {
        //Getting textfield height
        let size = self.frame.height
        
        self.isSecureTextEntry = true
        let secureText = self.isSecureTextEntry
        secureTextState = secureText
        systemTint = color
        
        //Adding Button Properties
        let iconButton = UIButton(frame: CGRect(x: 0, y: 0, width: size, height: size))
        iconButton.setImage(UIImage(systemName: "eye"), for: .normal)
        iconButton.tintColor = .systemGray
        
        //Adding Button action listener
        iconButton.addTarget(self, action: #selector(toggleButtonControl), for: .touchUpInside)
        
        //Adding button into a container view
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        iconContainerView.addSubview(iconButton)
        
        //Adding container to textfield
        rightView = iconContainerView
        rightViewMode = .always
    }
    
    //MARK: Method to toggle Secure Text
    @objc func toggleButtonControl(_ sender: UIButton){
        guard var textSecured = secureTextState else {return}
        let tint = systemTint
        
        if textSecured {
            self.isSecureTextEntry = false
            textSecured = self.isSecureTextEntry
            secureTextState = textSecured
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
            sender.tintColor = tint
            
        } else {
            self.isSecureTextEntry = true
            textSecured = self.isSecureTextEntry
            secureTextState = textSecured
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            sender.tintColor = .systemGray
            
        }
    }
    
    /**
     Creates a Combine publisher that emits the text field's current text whenever it changes.

     - Returns: A publisher that emits the text field's string value, never fails.

     - Example:
     ```swift
     let textField = UITextField()

     textField.textPublisher()
         .sink { newText in
             print("Text changed to: \\(newText)")
         }
         .store(in: &cancellables)
     ```

     - Note: Uses `UITextField.textDidChangeNotification` internally. Returns an empty string if text is `nil`.
     */
    func textPublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .eraseToAnyPublisher()
    }
}

//MARK- TextField Padding
public extension UITextField {
    /**
     Adds left padding to the text field by inserting an empty view.

     - Parameter amount: The padding width in points.

     - Example:
     ```swift
     textField.setLeftPaddingPoints(16)
     // Text will start 16 points from the left edge
     ```

     - Note: Sets `leftViewMode` to `.always`, so padding is always visible.
     */
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    /**
     Adds right padding to the text field by inserting an empty view.

     - Parameter amount: The padding width in points.

     - Example:
     ```swift
     textField.setRightPaddingPoints(16)
     // Text will end 16 points before the right edge
     ```

     - Note: Sets `rightViewMode` to `.always`, so padding is always visible. May override any existing right view.
     */
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
#endif
