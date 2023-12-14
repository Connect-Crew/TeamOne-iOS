//
//  UICollectionView+Extension.swift
//  Core
//
//  Created by Junyoung on 12/13/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public extension UICollectionViewCell {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
