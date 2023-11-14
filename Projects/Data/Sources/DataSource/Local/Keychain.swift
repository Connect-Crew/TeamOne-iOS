//
//  Keychain.swift
//  Data
//
//  Created by 강현준 on 2023/11/07.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public protocol KeychainProtocol {
    func add(_ query: [String: Any]) -> OSStatus
    func search(_ query: [String: Any]) -> Data?
    func update(_ query: [String: Any], with attributes: [String: Any]) -> OSStatus
    func delete(_ query: [String: Any]) -> OSStatus
}

public struct Keychain: KeychainProtocol {

    public init() { }

    public func add(_ query: [String: Any]) -> OSStatus {
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    public func search(_ query: [String: Any]) -> Data? {
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        return status == noErr ? (item as? Data) : nil
    }
    
    public func update(_ query: [String: Any], with attributes: [String: Any]) -> OSStatus {
        return SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
    }
    
    public func delete(_ query: [String: Any]) -> OSStatus {
        return SecItemDelete(query as CFDictionary)
    }
}
