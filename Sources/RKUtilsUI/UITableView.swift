//
//  UITableView.swift
//  
//
//  Created by Rakibur Khan on 2/4/24.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UITableView {
    /**
     Registers a table view cell for reuse using its class name as the identifier.

     - Parameters:
        - cell: The cell class type to register.
        - fromNib: Whether to load the cell from a XIB file (default: `true`). If `false`, registers the class directly.
        - bundle: Optional bundle containing the XIB file. Defaults to the main bundle.

     - Example:
     ```swift
     tableView.register(cell: CustomCell.self)
     // Later dequeue:
     let cell = tableView.dequeueReusableCell(cell: CustomCell.self, indexPath: indexPath)
     ```

     - Important: When `fromNib` is `true`, the XIB filename must match the class name exactly.
     */
    func register<T: UITableViewCell>(cell: T.Type, fromNib: Bool = true, bundle: Bundle? = nil) {
        let identifier = String(describing: T.self)
        
        if fromNib {
            self.register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: identifier)
        }
    }
    
    /**
     Registers a table view header/footer view for reuse using its class name as the identifier.

     - Parameters:
        - headerFooter: The header/footer view class type to register.
        - fromNib: Whether to load the view from a XIB file (default: `true`). If `false`, registers the class directly.
        - bundle: Optional bundle containing the XIB file. Defaults to the main bundle.

     - Example:
     ```swift
     tableView.register(headerFooter: CustomHeaderView.self)
     // Later dequeue:
     let header = tableView.dequeueReusableHeaderFooterView(view: CustomHeaderView.self)
     ```

     - Important: When `fromNib` is `true`, the XIB filename must match the class name exactly.
     */
    func register<T: UITableViewHeaderFooterView>(headerFooter: T.Type, fromNib: Bool = true, bundle: Bundle? = nil) {
        let identifier = String(describing: T.self)
        if fromNib {
            self.register(UINib(nibName: identifier, bundle: bundle), forHeaderFooterViewReuseIdentifier: identifier)
        } else {
            self.register(T.self, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }
    
    /**
     Dequeues a reusable table view cell with type safety.

     - Parameters:
        - cell: The cell class type to dequeue.
        - indexPath: The index path specifying the location of the cell.

     - Returns: A cell of the specified type, or `nil` if the type doesn't match.

     - Example:
     ```swift
     guard let cell = tableView.dequeueReusableCell(cell: CustomCell.self, indexPath: indexPath) else {
         return UITableViewCell()
     }
     cell.configure(with: data)
     return cell
     ```
     */
    func dequeueReusableCell<T: UITableViewCell>(cell: T.Type, indexPath: IndexPath) -> T? {
        let identifier = String(describing: T.self)
        let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        return cell as? T
    }
    
    /**
     Dequeues a reusable table view header/footer view with type safety.

     - Parameter view: The header/footer view class type to dequeue.

     - Returns: A view of the specified type, or `nil` if the type doesn't match.

     - Example:
     ```swift
     guard let header = tableView.dequeueReusableHeaderFooterView(view: CustomHeaderView.self) else {
         return UIView()
     }
     header.configure(with: sectionData)
     return header
     ```
     */
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(view: T.Type) -> T? {
        let identifier = String(describing: T.self)
        let cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier)
        return cell as? T
    }
}

public extension UITableView {
    /**
     The background color of the table view's background view.

     Setting this property creates a new background view with the specified color.

     - Note: This property is `@IBInspectable`, allowing it to be set in Interface Builder.
     */
    @IBInspectable
    var backgroundViewColor: UIColor? {
        set {
            self.backgroundView = UIView()
            self.backgroundView?.backgroundColor = newValue
        }
        get {
            return self.backgroundView?.backgroundColor
        }
    }

    /**
     Deselects all currently selected rows in the table view.

     - Parameter animated: Whether to animate the deselection (default: depends on call).

     - Example:
     ```swift
     // When user taps "Done" editing
     tableView.deselectAllRows(animated: true)
     ```
     */
    func deselectAllRows(animated: Bool) {
        indexPathsForSelectedRows?.forEach{ indexPath in
            deselectRow(at: indexPath, animated: animated)
        }
    }
}
#endif
