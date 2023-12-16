//
//  RecentHistoryFacade.swift
//  Domain
//
//  Created by Junyoung on 12/16/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Core

public protocol RecentHistoryFacade {
    func saveHistroy(_ keyword: String)
    func removeHistroy(_ keyword: String)
    func getHistory() -> [String]
    func removeAllHistory()
}

public struct RecentHistory: RecentHistoryFacade {
    
    private let getRecentHistoryUsecase = DIContainer.shared.resolve(GetRecentHistoryUseCase.self)
    private let addRecentHistoryUseCase = DIContainer.shared.resolve(AddRecentHistoryUseCase.self)
    private let removeRecentHistoryUsecase = DIContainer.shared.resolve(RemoveRecentHistoryUseCase.self)
    
    public init() {}
    
    public func saveHistroy(_ keyword: String) {
        addRecentHistoryUseCase.addSearchHistory(keyword)
    }
    
    public func removeHistroy(_ keyword: String) {
        removeRecentHistoryUsecase.deleteHistory(keyword)
    }
    
    public func getHistory() -> [String] {
        getRecentHistoryUsecase.getRecentSearchHistory()
    }
    
    public func removeAllHistory() {
        removeRecentHistoryUsecase.clearAllHistory()
    }
}
