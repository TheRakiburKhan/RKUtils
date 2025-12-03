//
//  UITableView.swift
//  
//
//  Created by Rakibur Khan on 2/4/24.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UITableView {
    /// UITableViewCell classname and xib name must be same
    func register<T: UITableViewCell>(cell: T.Type, fromNib: Bool = true, bundle: Bundle? = nil) {
        let identifier = String(describing: T.self)
        
        if fromNib {
            self.register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: identifier)
        }
    }
    
    /// UITableViewHeaderFooterView classname and xib name must be same
    func register<T: UITableViewHeaderFooterView>(headerFooter: T.Type, fromNib: Bool = true, bundle: Bundle? = nil) {
        let identifier = String(describing: T.self)
        if fromNib {
            self.register(UINib(nibName: identifier, bundle: bundle), forHeaderFooterViewReuseIdentifier: identifier)
        } else {
            self.register(T.self, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(cell: T.Type, indexPath: IndexPath) -> T? {
        let identifier = String(describing: T.self)
        let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        return cell as? T
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(view: T.Type) -> T? {
        let identifier = String(describing: T.self)
        let cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier)
        return cell as? T
    }
}

public extension UITableView {
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
    
    func deselectAllRows(animated: Bool) {
        indexPathsForSelectedRows?.forEach{ indexPath in
            deselectRow(at: indexPath, animated: animated)
        }
    }
}
#endif
