//
//  RemoveRecentHistoryUseCase.swift
//  Domain
//
//  Created by Junyoung on 12/9/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

import Core

public protocol RemoveRecentHistoryUseCase {
    /**
     최근 검색어 삭제
     - Authors: junlight94
     - parameters:
        - keyword: 삭제 할 키워드
     - Argument: 최근 검색어 1개 삭제
     - returns: Void
     */
    func deleteHistory(_ keyword: String)
    
    /**
     최근 검색어 전부 삭제
     - Authors: junlight94
     - parameters:
        - param: Void
     - Argument: 최근 검색어 전부 삭제
     - returns: Void
     */
    func clearAllHistory()
}

public struct RemoveRecentHistory: RemoveRecentHistoryUseCase {
    private let recentSearchHistoryRepository = DIContainer.shared.resolve(RecentSearchHistoryRepository.self)
    
    public init() {}
    
    public func deleteHistory(_ keyword: String) {
        recentSearchHistoryRepository.saveSearchHistory(deleteKeyword(keyword))
    }
    
    public func clearAllHistory() {
        recentSearchHistoryRepository.saveSearchHistory([])
    }
    
    private func deleteKeyword(_ keyword: String) -> [String] {
        var searchHistory = recentSearchHistoryRepository.getRecentSearchHistory()
        searchHistory.removeAll(where: { $0 == keyword })
        return searchHistory
    }
    
}
