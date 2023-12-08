//
//  DefaultRecentSearchHistoryRepository.swift
//  Data
//
//  Created by Junyoung on 12/7/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Domain
import Core

public final class DefaultRecentSearchHistoryRepository: RecentSearchHistoryRepository {
    
    public init() {}
    
    public func saveSearchHistory(_ keywords: [String]) {
        UserDefaultKeyList.RecentSearchHistory.searchRecentHistory = keywords
    }
    
    public func getRecentSearchHistory() -> [String] {
        return UserDefaultKeyList.RecentSearchHistory.searchRecentHistory ?? []
    }
}
