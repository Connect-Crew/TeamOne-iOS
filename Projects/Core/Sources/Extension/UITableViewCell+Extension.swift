//
//  UITableViewCell+Extension.swift
//  Core
//
//  Created by Junyoung on 12/8/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
