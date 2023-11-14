//
//  KeychainManager.swift
//  Data
//
//  Created by 강현준 on 2023/11/07.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public enum KeychainKey: String {
    case userToken = "com.connectCrew.TeamOne.userToken"
}

public protocol KeychainManagerProtocol {
    func save(key: KeychainKey, data: Data) -> Bool
    func load(key: KeychainKey) -> Data?
    func delete(key: KeychainKey) -> Bool
    func update(key: KeychainKey, data: Data) -> Bool
}

public struct KeychainManager:  KeychainManagerProtocol {
    
    public var keychain: KeychainProtocol

    public init (keychain: KeychainProtocol) {
        self.keychain = keychain
    }
    
    public func save(key: KeychainKey, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]
        
        let status = keychain.add(query)
        return status == errSecSuccess ? true : false
    }
    
    public func load(key: KeychainKey) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        return keychain.search(query)
    }
    
    public func delete(key: KeychainKey) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]
        
        let status = keychain.delete(query)
        return status == errSecSuccess ? true : false
    }
    
    public func update(key: KeychainKey, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]
        
        let attributes: [String: Any] = [
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]

        let status = keychain.update(query, with: attributes)
        return status == errSecSuccess ? true : false
    }
}
