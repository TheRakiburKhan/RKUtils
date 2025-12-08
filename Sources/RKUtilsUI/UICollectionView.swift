//
//  UICollectionView.swift
//  
//
//  Created by Rakibur Khan on 2/4/24.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UICollectionView {
    /**
     Returns the index path of the first visible cell.

     Iterates through visible cells and returns the index path of the first one found.

     - Returns: The index path of the first visible cell, or `nil` if no cells are visible.

     - Example:
     ```swift
     if let indexPath = collectionView.visibleCurrentCellIndexPath {
         print("First visible cell is at section \\(indexPath.section), item \\(indexPath.item)")
     }
     ```
     */
    var visibleCurrentCellIndexPath: IndexPath? {
        for cell in self.visibleCells {
            let indexPath = self.indexPath(for: cell)
            return indexPath
        }

        return nil
    }
    
    /**
     Registers a collection view cell for reuse using its class name as the identifier.

     - Parameters:
        - cell: The cell class type to register.
        - fromNib: Whether to load the cell from a XIB file (default: `true`). If `false`, registers the class directly.
        - bundle: Optional bundle containing the XIB file. Defaults to the main bundle.

     - Example:
     ```swift
     collectionView.register(cell: CustomCell.self)
     // Later dequeue:
     let cell = collectionView.dequeueReusableCell(cell: CustomCell.self, indexPath: indexPath)
     ```

     - Important: When `fromNib` is `true`, the XIB filename must match the class name exactly.
     */
    func register<T: UICollectionViewCell>(cell: T.Type, fromNib: Bool = true, bundle: Bundle? = nil) {
        let identifier = String(describing: T.self)
        
        if fromNib  {
            self.register(UINib(nibName: identifier, bundle: bundle), forCellWithReuseIdentifier: identifier)
        } else {
            self.register(T.self, forCellWithReuseIdentifier: identifier)
        }
    }
    
    /**
     Registers a supplementary view (header or footer) for reuse using its class name as the identifier.

     - Parameters:
        - resuableView: The reusable view class type to register.
        - isHeader: `true` for section header, `false` for section footer.
        - fromNib: Whether to load the view from a XIB file (default: `true`). If `false`, registers the class directly.
        - bundle: Optional bundle containing the XIB file. Defaults to the main bundle.

     - Example:
     ```swift
     collectionView.registerSupplementaryView(resuableView: CustomHeaderView.self, isHeader: true)
     // Later dequeue:
     let header = collectionView.dequeueReusableSupplementaryView(
         cell: CustomHeaderView.self,
         isHeader: true,
         indexPath: indexPath
     )
     ```

     - Important: When `fromNib` is `true`, the XIB filename must match the class name exactly.
     */
    func registerSupplementaryView<T: UICollectionReusableView>(resuableView: T.Type, isHeader: Bool, fromNib: Bool = true, bundle: Bundle? = nil) {
        let identifier = String(describing: T.self)
        let elementKind: String = isHeader ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter
        
        if fromNib {
            self.register(UINib(nibName: identifier, bundle: bundle), forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
        } else {
            self.register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
        }
    }
    
    /**
     Dequeues a reusable collection view cell with type safety.

     - Parameters:
        - cell: The cell class type to dequeue.
        - indexPath: The index path specifying the location of the cell.

     - Returns: A cell of the specified type, or `nil` if the type doesn't match.

     - Example:
     ```swift
     guard let cell = collectionView.dequeueReusableCell(cell: CustomCell.self, indexPath: indexPath) else {
         return UICollectionViewCell()
     }
     cell.configure(with: data)
     return cell
     ```
     */
    func dequeueReusableCell<T: UICollectionViewCell>(cell: T.Type, indexPath: IndexPath) -> T? {
        let identifier = String(describing: T.self)
        let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell as? T
    }
    
    /**
     Dequeues a reusable supplementary view with type safety using a custom kind string.

     - Parameters:
        - cell: The reusable view class type to dequeue.
        - kind: The kind of supplementary view (e.g., `UICollectionView.elementKindSectionHeader`).
        - indexPath: The index path specifying the location of the supplementary view.

     - Returns: A view of the specified type, or `nil` if the type doesn't match.

     - Example:
     ```swift
     let header = collectionView.dequeueReusableSupplementaryView(
         cell: CustomHeaderView.self,
         kind: UICollectionView.elementKindSectionHeader,
         indexPath: indexPath
     )
     ```
     */
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(cell: T.Type, kind: String, indexPath: IndexPath) -> T? {
        let identifier = String(describing: T.self)
        let cell = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
        return cell as? T
    }

    /**
     Dequeues a reusable supplementary view (header or footer) with type safety.

     - Parameters:
        - cell: The reusable view class type to dequeue.
        - isHeader: `true` for section header, `false` for section footer.
        - indexPath: The index path specifying the location of the supplementary view.

     - Returns: A view of the specified type, or `nil` if the type doesn't match.

     - Example:
     ```swift
     guard let header = collectionView.dequeueReusableSupplementaryView(
         cell: CustomHeaderView.self,
         isHeader: true,
         indexPath: indexPath
     ) else {
         return UICollectionReusableView()
     }
     header.configure(with: sectionData)
     return header
     ```
     */
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(cell: T.Type, isHeader: Bool, indexPath: IndexPath) -> T? {
        let identifier = String(describing: T.self)
        let elementKind: String = isHeader ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter
        let cell = self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath)
        return cell as? T
    }
}
#endif
