//
//  AddRecentHistoryUseCase.swift
//  Domain
//
//  Created by Junyoung on 12/9/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

import Core

public protocol AddRecentHistoryUseCase {
    /**
     최근 검색어 저장
     - Authors: junlight94
     - parameters:
        - search: 검색어
     - Argument: 최근 검색어 저장
     - returns: Void
     */
    func addSearchHistory(_ keyword: String)
}

public struct AddRecentHistory: AddRecentHistoryUseCase {
    
    private let recentSearchHistoryRepository = DIContainer.shared.resolve(RecentSearchHistoryRepository.self)
    
    public init() {}
    
    public func addSearchHistory(_ keyword: String) {
        let historyList = filterAndAppendHisttory(keyword)
        
        recentSearchHistoryRepository.saveSearchHistory(historyList)
    }
    
    private func filterAndAppendHisttory(_ keyword: String) -> [String] {
        var searchHistory = recentSearchHistoryRepository.getRecentSearchHistory()
        
        if searchHistory.contains(keyword) {
            searchHistory.removeAll(where: {$0 == keyword})
        }
        
        searchHistory.insert(keyword, at: 0)
        return searchHistory
    }
    
}
