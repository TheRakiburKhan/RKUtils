//
//  NSCollectionView.swift
//  RKUtils
//
//  Created by Rakibur Khan on 3/12/25.
//


#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public extension NSCollectionView {
    /**
     Returns the index path of the first visible item.

     Iterates through visible items and returns the index path of the first one found.

     - Returns: The index path of the first visible item, or `nil` if no items are visible.

     - Example:
     ```swift
     if let indexPath = collectionView.visibleCurrentCellIndexPath {
         print("First visible item is at section \\(indexPath.section), item \\(indexPath.item)")
     }
     ```
     */
    var visibleCurrentCellIndexPath: IndexPath? {
        for cell in self.visibleItems() {
            let indexPath = self.indexPath(for: cell)
            return indexPath
        }

        return nil
    }

    /**
     Registers a collection view item for reuse using its class name as the identifier.

     - Parameters:
        - cell: The collection view item class type to register.
        - fromNib: Whether to load the item from a NIB file (default: `true`). If `false`, registers the class directly.
        - bundle: Optional bundle containing the NIB file. Defaults to the main bundle.

     - Example:
     ```swift
     collectionView.register(cell: CustomItem.self)
     // Later dequeue:
     let item = collectionView.dequeueReusableItem(cell: CustomItem.self, indexPath: indexPath)
     ```

     - Important: When `fromNib` is `true`, the NIB filename must match the class name exactly.
     */
    func register<T: NSCollectionViewItem>(cell: T.Type, fromNib: Bool = true, bundle: Bundle? = nil) {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: T.self))

        if fromNib  {
            self.register(NSNib(nibNamed: identifier.rawValue, bundle: bundle), forItemWithIdentifier: identifier)
        } else {
            self.register(T.self, forItemWithIdentifier: identifier)
        }
    }

    /**
     Registers a supplementary view for reuse using its class name as the identifier.

     - Parameters:
        - reusableView: The supplementary view class type to register.
        - kind: The kind of supplementary view (e.g., `.sectionHeader`, `.sectionFooter`).
        - fromNib: Whether to load the view from a NIB file (default: `true`). If `false`, registers the class directly.
        - bundle: Optional bundle containing the NIB file. Defaults to the main bundle.

     - Example:
     ```swift
     collectionView.registerSupplementaryView(
         reusableView: CustomHeaderView.self,
         kind: .sectionHeader
     )
     // Later dequeue:
     let header = collectionView.dequeueReusableSupplementaryView(
         cell: CustomHeaderView.self,
         kind: .sectionHeader,
         indexPath: indexPath
     )
     ```

     - Important: When `fromNib` is `true`, the NIB filename must match the class name exactly.
     */
    func registerSupplementaryView<T: NSView>(reusableView: T.Type, kind: NSCollectionView.SupplementaryElementKind, fromNib: Bool = true, bundle: Bundle? = nil) {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: T.self))

        if fromNib {
            self.register(NSNib(nibNamed: identifier.rawValue, bundle: bundle), forSupplementaryViewOfKind: kind, withIdentifier: identifier)
        } else {
            self.register(T.self, forSupplementaryViewOfKind: kind, withIdentifier: identifier)
        }
    }

    /**
     Dequeues a reusable collection view item with type safety.

     - Parameters:
        - cell: The collection view item class type to dequeue.
        - indexPath: The index path specifying the location of the item.

     - Returns: An item of the specified type, or `nil` if the type doesn't match.

     - Example:
     ```swift
     guard let item = collectionView.dequeueReusableItem(cell: CustomItem.self, indexPath: indexPath) else {
         return NSCollectionViewItem()
     }
     item.configure(with: data)
     return item
     ```
     */
    func dequeueReusableItem<T: NSCollectionViewItem>(cell: T.Type, indexPath: IndexPath) -> T? {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: T.self))
        let item = self.makeItem(withIdentifier: identifier, for: indexPath)
        return item as? T
    }

    /**
     Dequeues a reusable supplementary view with type safety.

     - Parameters:
        - cell: The supplementary view class type to dequeue.
        - kind: The kind of supplementary view (e.g., `.sectionHeader`, `.sectionFooter`).
        - indexPath: The index path specifying the location of the supplementary view.

     - Returns: A view of the specified type, or `nil` if the type doesn't match.

     - Example:
     ```swift
     guard let header = collectionView.dequeueReusableSupplementaryView(
         cell: CustomHeaderView.self,
         kind: .sectionHeader,
         indexPath: indexPath
     ) else {
         return NSView()
     }
     header.configure(with: sectionData)
     return header
     ```
     */
    func dequeueReusableSupplementaryView<T: NSView>(cell: T.Type, kind: NSCollectionView.SupplementaryElementKind, indexPath: IndexPath) -> T? {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: T.self))
        let view = self.makeSupplementaryView(ofKind: kind, withIdentifier: identifier, for: indexPath)
        return view as? T
    }
}
#endif
