//
//  NSTableView.swift
//  RKUtils
//
//  Created by Rakibur Khan on 3/12/25.
//


#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public extension NSTableView {
    /**
     Registers a table cell view for reuse using its class name as the identifier.

     - Parameters:
        - cell: The cell view class type to register.
        - fromNib: Whether to load the cell from a NIB file (default: `true`). If `false`, class registration is not supported in AppKit.
        - bundle: Optional bundle containing the NIB file. Defaults to the main bundle.

     - Example:
     ```swift
     tableView.register(cell: CustomCellView.self)
     // Later dequeue:
     let cell = tableView.dequeueReusableCell(cell: CustomCellView.self, owner: self)
     ```

     - Important: When `fromNib` is `true`, the NIB filename must match the class name exactly.
     - Note: Unlike UIKit, AppKit's NSTableView doesn't support registering classes directly without NIBs.
     */
    func register<T: NSView>(cell: T.Type, fromNib: Bool = true, bundle: Bundle? = nil) {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: T.self))

        if fromNib {
            self.register(NSNib(nibNamed: identifier.rawValue, bundle: bundle), forIdentifier: identifier)
        } else {
            // Note: AppKit doesn't support registering classes directly like UIKit
            // You need to use register(_:forIdentifier:) with NSNib
        }
    }

    /**
     Dequeues a reusable table cell view with type safety.

     - Parameters:
        - cell: The cell view class type to dequeue.
        - owner: The owner object to pass to the NIB loader (default: `nil`).

     - Returns: A view of the specified type, or `nil` if the type doesn't match.

     - Example:
     ```swift
     guard let cell = tableView.dequeueReusableCell(cell: CustomCellView.self, owner: self) else {
         return NSView()
     }
     cell.configure(with: data)
     return cell
     ```
     */
    func dequeueReusableCell<T: NSView>(cell: T.Type, owner: Any? = nil) -> T? {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: T.self))
        let view = self.makeView(withIdentifier: identifier, owner: owner)
        return view as? T
    }
}

public extension NSTableView {
    /**
     The background color of the table view.

     - Note: This property is `@IBInspectable`, allowing it to be set in Interface Builder.
     Sets `backgroundColor` directly on macOS.
     */
    @IBInspectable
    var backgroundViewColor: NSColor? {
        set {
            self.backgroundColor = newValue ?? .clear
        }
        get {
            return self.backgroundColor
        }
    }

    /**
     Deselects all currently selected rows in the table view.

     - Example:
     ```swift
     // When user clicks outside the table
     tableView.deselectAllRows()
     ```

     - Note: Internally calls `deselectAll(_:)` with `nil` sender.
     */
    func deselectAllRows() {
        self.deselectAll(nil)
    }
}
#endif
