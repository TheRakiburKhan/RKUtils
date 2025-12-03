//
//  UICollectionView.swift
//  
//
//  Created by Rakibur Khan on 2/4/24.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UICollectionView {
    var visibleCurrentCellIndexPath: IndexPath? {
        for cell in self.visibleCells {
            let indexPath = self.indexPath(for: cell)
            return indexPath
        }
        
        return nil
    }
    
    /// UICollectionViewCell classname and xib name must be same
    func register<T: UICollectionViewCell>(cell: T.Type, fromNib: Bool = true, bundle: Bundle? = nil) {
        let identifier = String(describing: T.self)
        
        if fromNib  {
            self.register(UINib(nibName: identifier, bundle: bundle), forCellWithReuseIdentifier: identifier)
        } else {
            self.register(T.self, forCellWithReuseIdentifier: identifier)
        }
    }
    
    /// UITableViewHeaderFooterView classname and xib name must be same
    func registerSupplementaryView<T: UICollectionReusableView>(resuableView: T.Type, isHeader: Bool, fromNib: Bool = true, bundle: Bundle? = nil) {
        let identifier = String(describing: T.self)
        let elementKind: String = isHeader ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter
        
        if fromNib {
            self.register(UINib(nibName: identifier, bundle: bundle), forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
        } else {
            self.register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
        }
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(cell: T.Type, indexPath: IndexPath) -> T? {
        let identifier = String(describing: T.self)
        let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell as? T
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(cell: T.Type, kind: String, indexPath: IndexPath) -> T? {
        let identifier = String(describing: T.self)
        let cell = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
        return cell as? T
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(cell: T.Type, isHeader: Bool, indexPath: IndexPath) -> T? {
        let identifier = String(describing: T.self)
        let elementKind: String = isHeader ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter
        let cell = self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath)
        return cell as? T
    }
}
#endif
