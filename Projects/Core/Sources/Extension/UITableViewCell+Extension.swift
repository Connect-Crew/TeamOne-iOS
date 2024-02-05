//
//  UITableViewCell+Extension.swift
//  Core
//
//  Created by Junyoung on 12/8/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public extension UITableView {
    
    func register<T>(_ cellClass: T.Type) where T: UITableViewCell {
        self.register(cellClass.self, forCellReuseIdentifier: cellClass.defaultReuseIdentifier)
    }
    
    func dequeueCell<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T? where T: UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: cellClass.defaultReuseIdentifier, for: indexPath) as? T
    }
    
}

public extension UITableViewCell {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
