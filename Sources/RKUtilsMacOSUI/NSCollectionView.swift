//
//  NSCollectionView.swift
//  RKUtils
//
//  Created by Rakibur Khan on 3/12/25.
//


#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public extension NSCollectionView {
    var visibleCurrentCellIndexPath: IndexPath? {
        for cell in self.visibleItems() {
            let indexPath = self.indexPath(for: cell)
            return indexPath
        }

        return nil
    }

    /// NSCollectionViewItem classname and xib name must be same
    func register<T: NSCollectionViewItem>(cell: T.Type, fromNib: Bool = true, bundle: Bundle? = nil) {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: T.self))

        if fromNib  {
            self.register(NSNib(nibNamed: identifier.rawValue, bundle: bundle), forItemWithIdentifier: identifier)
        } else {
            self.register(T.self, forItemWithIdentifier: identifier)
        }
    }

    /// NSCollectionViewItem classname and xib name must be same
    func registerSupplementaryView<T: NSView>(reusableView: T.Type, kind: NSCollectionView.SupplementaryElementKind, fromNib: Bool = true, bundle: Bundle? = nil) {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: T.self))

        if fromNib {
            self.register(NSNib(nibNamed: identifier.rawValue, bundle: bundle), forSupplementaryViewOfKind: kind, withIdentifier: identifier)
        } else {
            self.register(T.self, forSupplementaryViewOfKind: kind, withIdentifier: identifier)
        }
    }

    func dequeueReusableItem<T: NSCollectionViewItem>(cell: T.Type, indexPath: IndexPath) -> T? {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: T.self))
        let item = self.makeItem(withIdentifier: identifier, for: indexPath)
        return item as? T
    }

    func dequeueReusableSupplementaryView<T: NSView>(cell: T.Type, kind: NSCollectionView.SupplementaryElementKind, indexPath: IndexPath) -> T? {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: T.self))
        let view = self.makeSupplementaryView(ofKind: kind, withIdentifier: identifier, for: indexPath)
        return view as? T
    }
}
#endif
