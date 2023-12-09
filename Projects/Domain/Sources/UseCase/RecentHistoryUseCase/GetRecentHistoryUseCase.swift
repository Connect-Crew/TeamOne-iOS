//
//  GetRecentHistoryUseCase.swift
//  Domain
//
//  Created by Junyoung on 12/9/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

import Core

public protocol GetRecentHistoryUseCase {
    /**
     최근 검색어 리스트
     - Authors: junlight94
     - parameters:
        - param: Void
     - Argument: 최근 검색어 리스트 가져오기
     - returns: 검색어 리스트
     */
    func getRecentSearchHistory() -> [String]
}

public struct GetRecentHistory: GetRecentHistoryUseCase {
    
    private let recentSearchHistoryRepository = DIContainer.shared.resolve(RecentSearchHistoryRepository.self)
    
    public init() {}
    
    public func getRecentSearchHistory() -> [String] {
        return recentSearchHistoryRepository.getRecentSearchHistory()
    }
}
