//
//  NSTableView.swift
//  RKUtils
//
//  Created by Rakibur Khan on 3/12/25.
//


#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public extension NSTableView {
    /// NSTableCellView classname and xib name must be same
    func register<T: NSView>(cell: T.Type, fromNib: Bool = true, bundle: Bundle? = nil) {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: T.self))

        if fromNib {
            self.register(NSNib(nibNamed: identifier.rawValue, bundle: bundle), forIdentifier: identifier)
        } else {
            // Note: AppKit doesn't support registering classes directly like UIKit
            // You need to use register(_:forIdentifier:) with NSNib
        }
    }

    func dequeueReusableCell<T: NSView>(cell: T.Type, owner: Any? = nil) -> T? {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: T.self))
        let view = self.makeView(withIdentifier: identifier, owner: owner)
        return view as? T
    }
}

public extension NSTableView {
    @IBInspectable
    var backgroundViewColor: NSColor? {
        set {
            self.backgroundColor = newValue ?? .clear
        }
        get {
            return self.backgroundColor
        }
    }

    func deselectAllRows() {
        self.deselectAll(nil)
    }
}
#endif
