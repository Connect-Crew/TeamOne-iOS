//
//  UICollectionView+Extension.swift
//  Core
//
//  Created by Junyoung on 12/13/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public extension UICollectionView {
    
    func register<T>(_ cellClass: T.Type) where T: UICollectionViewCell {
        self.register(cellClass, forCellWithReuseIdentifier: cellClass.defaultReuseIdentifier)
    }
    
    func dequeueCell<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T? where T: UICollectionViewCell {
        return self.dequeueReusableCell(withReuseIdentifier: cellClass.defaultReuseIdentifier, for: indexPath) as? T
    }
}

public extension UICollectionViewCell {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
