//
//  RecentSearchHistoryRepository.swift
//  Domain
//
//  Created by Junyoung on 12/7/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public protocol RecentSearchHistoryRepository {
    func saveSearchHistory(_ keywords: [String])
    func getRecentSearchHistory() -> [String]
}
