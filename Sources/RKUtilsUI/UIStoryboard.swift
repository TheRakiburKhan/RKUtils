//
//  UIStoryboard.swift
//  
//
//  Created by Rakibur Khan on 2/4/24.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UIStoryboard {
    /**
     Instantiates a view controller using its class name as the storyboard identifier.

     Provides type-safe view controller instantiation by using Swift generics. The storyboard ID
     must match the view controller's class name for this method to work.

     - Returns: An instance of the view controller with the specified type, or `nil` if not found.

     - Example:
     ```swift
     // In Storyboard: Set the Storyboard ID of TestViewController to "TestViewController"
     let controller: TestViewController? = storyboard?.instantiate()

     // With explicit type annotation
     if let controller: SettingsViewController = storyboard?.instantiate() {
         navigationController?.pushViewController(controller, animated: true)
     }
     ```

     - Important: The storyboard identifier in Interface Builder must exactly match the class name.
     For example, if your class is `ProfileViewController`, set the storyboard ID to "ProfileViewController".

     - Note: Returns `nil` if the view controller cannot be found or the type doesn't match.
     */
    func instantiate<T: UIViewController>() -> T? {
        let identifier = String(describing: T.self)
        return self.instantiateViewController(withIdentifier: identifier) as? T
    }
}

#endif
