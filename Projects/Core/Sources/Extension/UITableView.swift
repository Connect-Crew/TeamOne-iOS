//
//  UITableView.swift
//  Core
//
//  Created by 강현준 on 2/1/24.
//  Copyright © 2024 TeamOne. All rights reserved.
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
