//
//  Image+Extension.swift
//  DSKit
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public extension UIImage {
    static var tabBar: TabBar.Type {
        return TabBar.self
    }
}

public struct TabBar {
    public static func image(for tabBarString: String) -> UIImage? {
        return UIImage(named: tabBarString)
    }
}
