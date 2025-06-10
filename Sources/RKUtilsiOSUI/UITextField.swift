//
//  UITextField.swift
//  
//
//  Created by Rakibur Khan on 3/4/24.
//

#if canImport(UIKit)
import UIKit
import Combine

@MainActor
fileprivate var secureTextState: Bool?
@MainActor
fileprivate var systemTint: UIColor?

public extension UITextField {
    //MARK: To set image in right corner of textfield
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
    
    func textPublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .eraseToAnyPublisher()
    }
}

//MARK- TextField Padding
public extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
#endif
