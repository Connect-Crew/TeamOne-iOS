//
//  RecentSearchHistoryUseCase.swift
//  Domain
//
//  Created by Junyoung on 12/7/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

import Core

public protocol RecentSearchHistoryUseCase {
    /**
     최근 검색어 저장
     - Authors: junlight94
     - parameters:
        - search: 검색어
     - Argument: 최근 검색어 저장
     - returns: Void
     */
    func saveSearchHistory(_ keyword: String)
    
    /**
     최근 검색어 리스트
     - Authors: junlight94
     - parameters:
        - param: Void
     - Argument: 최근 검색어 리스트 가져오기
     - returns: 검색어 리스트
     */
    func getRecentSearchHistory() -> [String]
    
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

public final class RecentSearchHistory: RecentSearchHistoryUseCase {
    
    private let recentSearchHistoryRepository = DIContainer.shared.resolve(RecentSearchHistoryRepository.self)
    
    public init() {}
    
    public func saveSearchHistory(_ keyword: String) {
        let historyList = filterAndAppendHisttory(keyword)
        
        recentSearchHistoryRepository.saveSearchHistory(historyList)
    }
    
    public func getRecentSearchHistory() -> [String] {
        return recentSearchHistoryRepository.getRecentSearchHistory()
    }
    
    private func filterAndAppendHisttory(_ keyword: String) -> [String] {
        var searchHistory = recentSearchHistoryRepository.getRecentSearchHistory()
        
        if searchHistory.contains(keyword) {
            searchHistory.removeAll(where: {$0 == keyword})
        }
        
        searchHistory.insert(keyword, at: 0)
        return searchHistory
    }
    
    private func deleteKeyword(_ keyword: String) -> [String] {
        var searchHistory = recentSearchHistoryRepository.getRecentSearchHistory()
        searchHistory.removeAll(where: { $0 == keyword })
        return searchHistory
    }
    
    public func deleteHistory(_ keyword: String) {
        recentSearchHistoryRepository.saveSearchHistory(deleteKeyword(keyword))
    }
    
    public func clearAllHistory() {
        recentSearchHistoryRepository.saveSearchHistory([])
    }
    
}
