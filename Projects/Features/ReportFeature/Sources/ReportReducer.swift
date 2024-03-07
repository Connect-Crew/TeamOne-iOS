//
//  ReportReducer.swift
//  ReportFeature
//
//  Created by Junyoung on 2/25/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Domain
import Data

@Reducer
struct ReportReducer {
    
    @Dependency(\.liveValue) var numbersAPIClient
    
    var body: some Reducer<ReportState, ReportAction> {
        
        Reduce { state, action in
            switch action {
            case .reportButtonTapped(let type):
                if let index = state.reportModel.firstIndex(where: {$0.type == type}) {
                    state.reportModel[index].isSelected.toggle()
                }
                return .none
            }
        }
    }
}

private enum ReportReducertKey: DependencyKey {
    static var liveValue: MyProfileUseCaseProtocol = MyProfileUseCase(userRepository: UserRepository(userDataSource: UserDataSource()))
}

extension DependencyValues {
    var liveValue: MyProfileUseCaseProtocol {
        get { self[ReportReducertKey.self] }
        set { self[ReportReducertKey.self] = newValue }
    }
}
