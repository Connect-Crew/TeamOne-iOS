//
//  UserDefaultWrapper.swift
//  Core
//
//  Created by 강현준 on 2023/11/16.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

@propertyWrapper struct UserDefaultWrapper<T> {

    var wrappedValue: T? {
        get {
            return UserDefaults.standard.object(forKey: self.key) as? T
        }

        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: key)
            } else { UserDefaults.standard.setValue(newValue, forKey: key) }
        }
    }

    private let key: String

    init(key: String) {
        self.key = key
    }
}
